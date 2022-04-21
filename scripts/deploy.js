const main = async () => {
    const piracyContractFactory = await hre.ethers.getContractFactory("Piracy");
    const piracyContract = await piracyContractFactory.deploy();
    await piracyContract.deployed();

    console.log("Contract deployed to: ", piracyContract.address);

    let txn = await piracyContract.addFile("https://github.com/Shiv10/polygon-ens-contracts/blob/main/scripts/deploy.js");
    txn = await piracyContract.addAdmin("0x7824f80A8a69DebaAB28fAcC395694bB700955d0");
    txn = await piracyContract.checkIsAdmin("0x7824f80A8a69DebaAB28fAcC395694bB700955d0");
    console.log(txn);

}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (e) {
        console.log(e);
        process.exit(1);
    }
}

runMain();