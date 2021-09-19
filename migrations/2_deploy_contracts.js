const Token = artifacts.require("Token");

module.exports = async function (deployer) {
  await deployer.deploy(
    Token,
    "VeFi Protocol",
    "VEF",
    "200000000000000000000000000"
  );
};
