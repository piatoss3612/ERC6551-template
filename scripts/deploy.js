const { ethers, run } = require('hardhat');

// Deploy a contract
const deploy = async (contractName, signer, args = []) => {
  const factory = await ethers.getContractFactory(contractName, signer);
  const contract = await factory.deploy(...args);

  await contract.deploymentTransaction().wait();

  return contract;
}

// Verify a contract
const verify = async (address, args = []) => {
  await run('verify:verify', {
    address: address,
    constructorArguments: args,
  }).catch((error) => { console.log(error); });
}

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const ERC6551Registry = await deploy('ERC6551Registry', deployer);

  console.log("ERC6551Registry deployed to:", ERC6551Registry.target);

  await verify(ERC6551Registry.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
