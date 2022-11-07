import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { BigNumber } from "ethers";
import { ethers } from "hardhat";


const deployFunction: DeployFunction = async function ({
                                                         deployments,
                                                         getNamedAccounts,
                                                         ethers,
                                                       }: HardhatRuntimeEnvironment) {
  const { deploy } = deployments;
  const { deployer, dev } = await getNamedAccounts();

  const deployResult = await deploy("Giveaway", {
    from: deployer,
    proxy: {
      owner: dev,
      proxyContract: "OpenZeppelinTransparentProxy",
      execute: {
        init: {
          methodName: "initialize",
          args: [
              "0xAad62610C04Bd8Ba99a3429f90385bc4Df1CE144",
              "0x816BE2E0594D7cFF6a745591E72BB7397F272385",
              BigNumber.from(10).pow(18)
          ]
        }
      }
    },
    log:true,
    waitConfirmations: 1,
    gasPrice: BigNumber.from("250000000000")
  });
};

export default deployFunction;

deployFunction.tags = ["giveaway", "deploy"];
