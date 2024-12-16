var MyContract = artifacts.require("Travel");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(MyContract);
};

