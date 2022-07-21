import { ethers, network } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import chai, { expect } from "chai";
import {ContributionPoint, UsePointCallee} from "../types";
import { FakeContract, smock } from "@defi-wonderland/smock";
chai.use(smock.matchers);

describe("Contribution Point", function () {

  let _snapshotId: string;
  let snapshotId: string;
  let ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MANAGER"));

  let deployer: SignerWithAddress;
  let manager: SignerWithAddress;
  let contributor0: SignerWithAddress;
  let contributor1: SignerWithAddress;

  let contributionPoint: ContributionPoint;
  let pointCallee: FakeContract<UsePointCallee>;

  before(async () => {
    _snapshotId = await ethers.provider.send("evm_snapshot", []);

    // ======== SIGNER ==========
    [deployer, manager, contributor0, contributor1] = await ethers.getSigners();

    // ======== CONTRACTS ==========
    const ContributionPoint = await ethers.getContractFactory("ContributionPoint");
    contributionPoint = await ContributionPoint.deploy() as ContributionPoint;

    pointCallee = await smock.fake<UsePointCallee>("UsePointCallee");

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

  describe("# GRANT ROLE", async () => {
    it("Grant Role: Manager", async () => {
      // given
      await contributionPoint.connect(deployer).initialize("HI", "HI");
      expect(await contributionPoint.hasRole(ROLE, manager.address)).to.be.false;

      // when
      await contributionPoint.connect(deployer).grantRole(
          ROLE,
          manager.address
      );

      // then
      expect(await contributionPoint.hasRole(ROLE, manager.address)).to.be.true;
    })
  });

  describe("# TAG MANAGEMENT", async () => {
    beforeEach("init contributionPoint", async () => {
      await contributionPoint.connect(deployer).initialize("HI", "HI");
      await contributionPoint.connect(deployer).grantRole(
          ROLE,
          manager.address
      );
    })

    it("revert case : not manager call createTag ", async () => {
      await expect(contributionPoint.connect(contributor0).createTag("hihihi")).to.be.reverted;
    })

    it("create Tag", async () => {
      // given
      const givenText = 'bug bounty - open program';

      // when
      await contributionPoint.connect(manager).createTag(givenText);

      // then
      expect(await contributionPoint.connect(manager).tagDescription(0)).to.be.eq(givenText);
      expect(await contributionPoint.connect(manager).totalTags()).to.be.eq(1);
    })

    it("create tag twice", async () => {
      // given
      const givenText0 = 'bug bounty - open program';
      const givenText1 = 'gleem event';

      // when
      await contributionPoint.connect(manager).createTag(givenText0);
      await contributionPoint.connect(manager).createTag(givenText1);

      // then
      expect(await contributionPoint.connect(manager).tagDescription(0)).to.be.eq(givenText0);
      expect(await contributionPoint.connect(manager).tagDescription(1)).to.be.eq(givenText1);
      expect(await contributionPoint.connect(manager).totalTags()).to.be.eq(2);
    })

    it("update tag Description", async () => {
      // given
      const givenText0 = 'bug bounty - open program';
      await contributionPoint.connect(manager).createTag(givenText0);
      const givenText1 = 'gleem event';

      // when
      await contributionPoint.connect(manager).updateTagDescription(0, givenText1);

      // then
      expect(await contributionPoint.connect(manager).tagDescription(0)).to.be.eq(givenText1);
    })

    it("revert case: update invalid tag id", async () => {
      // given
      const givenText0 = 'bug bounty - open program';
      await contributionPoint.connect(manager).createTag(givenText0);
      const givenText1 = 'gleem event';

      // then
      await expect(contributionPoint.connect(manager).updateTagDescription(1, givenText1))
          .to.be.reverted;
    })

    it("revert case: not manager call updateTagDescription", async () => {
      // given
      const givenText0 = 'bug bounty - open program';
      await contributionPoint.connect(manager).createTag(givenText0);
      const givenText1 = 'gleem event';

      // then
      await expect(contributionPoint.connect(contributor0).updateTagDescription(0, givenText1))
          .to.be.reverted;
    })
  })

  describe("# CONTRIBUTION RECORD MANAGEMENT", async () => {
    beforeEach("init contributionPoint", async () => {
      await contributionPoint.connect(deployer).initialize("HI", "HI");
      await contributionPoint.connect(deployer).grantRole(
          ROLE,
          manager.address
      );

      await contributionPoint.connect(manager).createTag("HI");
      await contributionPoint.connect(manager).createTag("HELLO");
      await contributionPoint.connect(manager).createTag("HIHI");
    })

    it("revert case: not manager call create record", async () => {
      await expect(contributionPoint.connect(contributor0).createRecord(
          contributor0.address, 0, 1000
      )).to.be.reverted;
    })

    it("revert case: manager call create record with invalid tagId", async () => {
      await expect(contributionPoint.connect(manager).createRecord(
          contributor0.address, 10, 1000
      )).to.be.reverted;
    })

    it("revert case: manager call create record with zero point", async () => {
      await expect(contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, 0
      )).to.be.reverted;
    })

    it("create contribution record one", async () => {
      const givenPoint = 1000;
      const givenTagId = 0;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, givenTagId, givenPoint
      );

      expect(await contributionPoint.balanceOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(givenPoint);

      const record = await contributionPoint.contributionRecordByIndex(contributor0.address, 0);
      expect(record.point).to.be.eq(givenPoint);
      expect(record.tagId).to.be.eq(givenTagId);
    })

    it("create contribution record twice", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 1, givenPoint * 2
      );

      expect(await contributionPoint.balanceOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(givenPoint * 3);

      const record0 = await contributionPoint.contributionRecordByIndex(contributor0.address, 0);
      expect(record0.point).to.be.eq(givenPoint);
      expect(record0.tagId).to.be.eq(0);

      const record1 = await contributionPoint.contributionRecordByIndex(contributor0.address, 1);
      expect(record1.point).to.be.eq(givenPoint * 2);
      expect(record1.tagId).to.be.eq(1);

      expect(await contributionPoint.contributionRecordCounts(contributor0.address)).to.be.eq(2);
    })

    it("delete contribution record", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 1, givenPoint * 2
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 2, givenPoint * 3
      );


      await contributionPoint.connect(manager).deleteRecord(contributor0.address, 1);

      expect(await contributionPoint.balanceOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(givenPoint * 4);

      const record0 = await contributionPoint.contributionRecordByIndex(contributor0.address, 0);
      expect(record0.tagId).to.be.eq(0);
      expect(record0.point).to.be.eq(givenPoint);

      const record1 = await contributionPoint.contributionRecordByIndex(contributor0.address, 1);
      expect(record1.tagId).to.be.eq(2);
      expect(record1.point).to.be.eq(givenPoint * 3);

      expect(await contributionPoint.contributionRecordCounts(contributor0.address)).to.be.eq(2);
    })

    it("update contribution record (Increase)", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      const givenPoint2 = 1200;

      await contributionPoint.connect(manager).updateRecord(contributor0.address, 0, givenPoint2);

      expect(await contributionPoint.balanceOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(givenPoint2);

      const record0 = await contributionPoint.contributionRecordByIndex(contributor0.address, 0);
      expect(record0.tagId).to.be.eq(0);
      expect(record0.point).to.be.eq(givenPoint2);
    })

    it("update contribution record (Decrease)", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      const givenPoint2 = 800;

      await contributionPoint.connect(manager).updateRecord(contributor0.address, 0, givenPoint2);

      expect(await contributionPoint.balanceOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(givenPoint2);

      const record0 = await contributionPoint.contributionRecordByIndex(contributor0.address, 0);
      expect(record0.tagId).to.be.eq(0);
      expect(record0.point).to.be.eq(givenPoint2);
    })

    it("update contribution record (Decrease)", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      const givenPoint2 = 800;

      await contributionPoint.connect(manager).updateRecord(contributor0.address, 0, givenPoint2);

      expect(await contributionPoint.balanceOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(givenPoint2);

      const record0 = await contributionPoint.contributionRecordByIndex(contributor0.address, 0);
      expect(record0.tagId).to.be.eq(0);
      expect(record0.point).to.be.eq(givenPoint2);
    })

    it("revert case : call with point = 0", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      const givenPoint2 = 0;

      await expect(
          contributionPoint.connect(manager).updateRecord(contributor0.address, 0, givenPoint2)
      ).to.be.reverted;
    })

    it("revert case : call with invalid orderId", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      const givenPoint2 = 2;

      await expect(
          contributionPoint.connect(manager).updateRecord(contributor0.address, 1, givenPoint2)
      ).to.be.reverted;
    })

    it("revert case : try to transfer", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );

      await expect(
          contributionPoint.connect(contributor0).transferFrom(contributor0.address, contributor1.address, 1)
      ).to.be.reverted;
    })

    it("create records multiple users", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor1.address, 0, givenPoint
      );

      expect(await contributionPoint.totalSupply()).to.be.eq(3);
      expect(await contributionPoint.contributorIdOf(deployer.address)).to.be.eq(0);
      expect(await contributionPoint.contributorIdOf(contributor0.address)).to.be.eq(1);
      expect(await contributionPoint.contributorIdOf(contributor1.address)).to.be.eq(2);
    })

    it("bulk read: case1", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 1, givenPoint * 2
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint * 3
      );

      const records = await contributionPoint.contributionRecords(contributor0.address, 0, 2);
      expect(records.length).to.be.eq(2);
      expect(records[0].point).to.be.eq(givenPoint);
      expect(records[0].tagId).to.be.eq(0);

      expect(records[1].point).to.be.eq(givenPoint * 2);
      expect(records[1].tagId).to.be.eq(1);
    })

    it("bulk read: case2", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 1, givenPoint * 2
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint * 3
      );

      const records = await contributionPoint.contributionRecords(contributor0.address, 0, 3);
      expect(records.length).to.be.eq(3);
      expect(records[0].point).to.be.eq(givenPoint);
      expect(records[0].tagId).to.be.eq(0);

      expect(records[1].point).to.be.eq(givenPoint * 2);
      expect(records[1].tagId).to.be.eq(1);

      expect(records[2].point).to.be.eq(givenPoint * 3);
      expect(records[2].tagId).to.be.eq(0);
    })

    it("bulk read: case3", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 1, givenPoint * 2
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint * 3
      );

      const records = await contributionPoint.contributionRecords(contributor0.address, 1, 10);
      expect(records.length).to.be.eq(2);
      expect(records[0].point).to.be.eq(givenPoint * 2);
      expect(records[0].tagId).to.be.eq(1);

      expect(records[1].point).to.be.eq(givenPoint * 3);
      expect(records[1].tagId).to.be.eq(0);
    })

    it("bulk read: case3", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 1, givenPoint * 2
      );
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint * 3
      );

      await expect(contributionPoint.contributionRecords(contributor0.address, 3, 2))
          .to.be.reverted;
    })

    it("revert case: not exists contributor", async () => {
      const givenPoint = 1000;
      await contributionPoint.connect(manager).createRecord(
          contributor0.address, 0, givenPoint
      );

      await expect(contributionPoint.contributorIdOf(contributor1.address)).to.be.reverted;
    })
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
    })

    it("revert case : no balance", async () => {
      await expect(contributionPoint.connect(contributor1).usePoint(
          1000, pointCallee.address, ethers.utils.toUtf8Bytes("")
      )).to.be.revertedWith("INSUFFICIENT");
    })

    it("revert case : insufficient balance", async () => {
      await expect(contributionPoint.connect(contributor0).usePoint(
          1200, pointCallee.address, ethers.utils.toUtf8Bytes("")
      )).to.be.revertedWith("INSUFFICIENT");
    })

    it("use point", async () => {
      await contributionPoint.connect(contributor0).usePoint(
          800, pointCallee.address, ethers.utils.toUtf8Bytes("")
      );

      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(
          200
      )
    })

    it("use point multiple", async () => {
      await contributionPoint.connect(contributor0).usePoint(
          800, pointCallee.address, ethers.utils.toUtf8Bytes("")
      );
      await contributionPoint.connect(contributor0).usePoint(
          200, pointCallee.address, ethers.utils.toUtf8Bytes("")
      );

      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(0)
    })

    it("update record after use point(minus point case, edge case)", async () => {
      await contributionPoint.connect(contributor0).usePoint(
          800, pointCallee.address, ethers.utils.toUtf8Bytes("")
      );

      await contributionPoint.connect(manager).updateRecord(
          contributor0.address, 0, 100
      );

      expect(await contributionPoint.contributionPointOf(contributor0.address)).to.be.eq(-700);
    })
  })
});
