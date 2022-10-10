import { ethers, network } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import chai, { expect } from "chai";
import {ContributionPoint, Giveaway, TestToken, TestToken__factory, UsePointCallee} from "../types";
import { FakeContract, smock } from "@defi-wonderland/smock";
chai.use(smock.matchers);

describe("Giveaway", function () {

  let _snapshotId: string;
  let snapshotId: string;
  let ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MANAGER"));

  let deployer: SignerWithAddress;
  let manager: SignerWithAddress;
  let contributor0: SignerWithAddress;
  let contributor1: SignerWithAddress;

  let contributionPoint: ContributionPoint;
  let giveawayContract: Giveaway;
  let testToken: TestToken;

  before(async () => {
    _snapshotId = await ethers.provider.send("evm_snapshot", []);

    // ======== SIGNER ==========
    [deployer, manager, contributor0, contributor1] = await ethers.getSigners();

    // ======== CONTRACTS ==========
    const background = await (await ethers.getContractFactory("Background")).deploy();
    const font = await (await ethers.getContractFactory("Font")).deploy();
    const logo = await (await ethers.getContractFactory("Logo")).deploy();
    const SVGGenerator = await (await ethers.getContractFactory('SVGGenerator', {libraries:{
        Background:background.address,
        Font:font.address,
        Logo:logo.address
      }})).deploy();
    const ContributionPoint = await ethers.getContractFactory("ContributionPoint",{libraries: {
        SVGGenerator:SVGGenerator.address
      }});
    contributionPoint = await ContributionPoint.deploy() as ContributionPoint;

    testToken = await (await ethers.getContractFactory("TestToken")).deploy() as TestToken;

    giveawayContract = await (await ethers.getContractFactory("Giveaway")).deploy() as Giveaway;

    snapshotId = await ethers.provider.send("evm_snapshot", []);
  });

  afterEach(async () => {
    await network.provider.send("evm_revert", [snapshotId]);
    snapshotId = await ethers.provider.send("evm_snapshot", []);
  });

  after(async () => {
    await network.provider.send("evm_revert", [_snapshotId]);
    _snapshotId = await ethers.provider.send("evm_snapshot", []);
  });

  describe("# USE POINT", async () => {
    beforeEach("init contributionPoint", async () => {
      await contributionPoint.connect(deployer).initialize("HI", "HI");
      await contributionPoint.connect(deployer).grantRole(
          ROLE,
          manager.address
      );

      await contributionPoint.connect(manager).createTag("HI");
      await contributionPoint.connect(manager).createTag("HELLO");
      await contributionPoint.connect(manager).createTag("HIHI");

      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );

      await giveawayContract.initialize(contributionPoint.address, testToken.address, ethers.utils.parseEther('1'));
      await testToken.connect(deployer).transfer(giveawayContract.address, ethers.utils.parseEther('1000'));
    })

    it("revert case : no balance", async () => {
      await expect(contributionPoint.connect(contributor1).usePoint(
          1000, giveawayContract.address, ethers.utils.toUtf8Bytes("")
      )).to.be.revertedWith("INSUFFICIENT");
    })

    it("revert case : insufficient balance", async () => {
      await expect(contributionPoint.connect(contributor0).usePoint(
          1200, giveawayContract.address, ethers.utils.toUtf8Bytes("")
      )).to.be.revertedWith("INSUFFICIENT");
    })

    it("use point", async () => {
      await contributionPoint.connect(contributor0).usePoint(
          800, giveawayContract.address, ethers.utils.defaultAbiCoder.encode(['address'],[contributor0.address])
      );

      expect(await testToken.balanceOf(contributor0.address)).to.be.eq(ethers.utils.parseEther('800'))
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(200);
    })

    it("use point for other contracts", async () => {
      await contributionPoint.connect(contributor0).usePoint(
          800, giveawayContract.address, ethers.utils.defaultAbiCoder.encode(['address'],[contributor1.address])
      );

      expect(await testToken.balanceOf(contributor1.address)).to.be.eq(ethers.utils.parseEther('800'))
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(200);
    })

    it("use point twice", async () => {
      await contributionPoint.connect(contributor0).usePoint(
          800, giveawayContract.address, ethers.utils.defaultAbiCoder.encode(['address'],[contributor0.address])
      );
      await contributionPoint.connect(contributor0).usePoint(
          200, giveawayContract.address, ethers.utils.defaultAbiCoder.encode(['address'],[contributor0.address])
      );


      expect(await testToken.balanceOf(contributor0.address)).to.be.eq(ethers.utils.parseEther('1000'))
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(0);
    })
  })
});
