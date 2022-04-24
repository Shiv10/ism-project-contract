async function main() {
  const [owner, randomPerson] = await hre.ethers.getSigners()
  const Piracy = await hre.ethers.getContractFactory("Piracy");
  const piracy = await Piracy.deploy();
  await piracy.deployed();

  console.log("Contract deployed to:", piracy.address);

  let txn = await piracy.addFile("https://www.google.com");

  txn = await piracy.checkIsAdmin(owner.address);
  console.log(txn);

  txn = await piracy.getPendingAddresses();
  console.log(txn);

  txn = await piracy.getPendingFileFromAddress(txn[0]);
  console.log(txn);
  
  txn = await piracy.approve(owner.address);

  txn = await piracy.getPendingAddresses();
  console.log(txn);

  txn = await piracy.getAllFiles();
  console.log(txn);

  txn = await piracy.getFileOwner(txn[0]);
  console.log(txn)
}
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch(e) {
    console.log(e);
    process.exit(1);
  }
}

runMain();