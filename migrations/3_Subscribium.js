const Subscribium = artifacts.require("Subscribium");

module.exports = function (deployer) {
  deployer.deploy(Subscribium, "0x9fc43f48dd0838cd4b6fcda717df1fa249ec2444");
};
