module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy("SuperDepositToken", {
        from: deployer,
        log: true,
      });

    const SuperDepositToken = await ethers.getContract("SuperDepositToken", deployer);
    await SuperDepositToken.initialize(
        "Super Deposit Token",
        "SDT",
        "5000000000000000000000"
    )

    console.log(SuperDepositToken)
}

module.exports.tags = ["SuperDepositToken"];
