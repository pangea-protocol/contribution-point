import {task} from "hardhat/config";
import Table from "cli-table3";
import {ContributionPoint} from "../types";
import {BigNumber, ethers} from "ethers";
import {doTransaction} from "../deploy/deploy";

//
// task("grant", "Prints the list of accounts")
//     .setAction(async ({},{ethers}) => {
//       const deployer = await ethers.getNamedSigner("deployer")
//
//       const cp = await ethers.getContract("ContributionPoint") as ContributionPoint;
//
//
//         let ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MANAGER"));
//         await doTransaction(cp.connect(deployer).grantRole(ROLE, "0x2A2F23ff33671361010D357529BDF0adca9416Fc", {
//           gasPrice: BigNumber.from("250000000000")
//         }));
//         await doTransaction(cp.connect(deployer).grantRole(ROLE, "0xFFf27E60c51f86b6A1B1279fe625F0461f344634", {
//           gasPrice: BigNumber.from("250000000000")
//         }));
//
//
//     });

let ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MANAGER"))
console.log(ROLE);
