const Token = artifacts.require('Token');

module.exports = async function (deployer) {
  await deployer.deploy(Token, 'VeFi Protocol', 'VEF', web3.utils.toWei('200000000'));
};
