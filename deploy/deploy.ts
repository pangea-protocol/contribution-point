import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import {ContractTransaction} from "ethers";
import {ContributionPoint, ContributionPoint__factory} from "../types";
import {ethers} from "hardhat";

export async function doTransaction(transaction: Promise<ContractTransaction>) {
  const tx = await transaction;
  const hre = require("hardhat")
  const chainId = await hre.getChainId();
  if (chainId === '31337' || chainId === '203') {
    return;
  }

  const receipt = await tx.wait()
  console.log(`tx : ${receipt.transactionHash} | gasUsed : ${receipt.gasUsed}`)
}

const deployFunction: DeployFunction = async function ({
                                                         deployments,
                                                         getNamedAccounts,
                                                         ethers,
                                                       }: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer, dev } = await getNamedAccounts();


  const deployResult  = await deploy("ContributionPoint", {
    from: deployer,
    proxy: {
      owner: dev,
      proxyContract: "OpenZeppelinTransparentProxy",
      execute: {
        init: {
          methodName: "initialize",
          args: ["PANGEA CONTRIBUTION", "PANGEA-CONTRIBUTOR"]
        }
      }
    },
    log:true,
    waitConfirmations: 1,
  });
  const contributionPoint = ContributionPoint__factory.connect(deployResult.address, ethers.provider) as ContributionPoint;
  console.log(await contributionPoint.owner())

  if (deployResult.newlyDeployed) {
    let ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MANAGER"));
    await doTransaction(contributionPoint.connect(await ethers.getNamedSigner("deployer")).grantRole(ROLE, deployer));
  }
};

export default deployFunction;

deployFunction.tags = ["deploy"];
