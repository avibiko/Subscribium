const MyToken = artifacts.require("MyToken");
const Subscribium = artifacts.require("Subscribium");

module.exports = function (deployer) {
  deployer.deploy(MyToken, 10000).then(function() {
    return deployer.deploy(Subscribium, "0x9fc43f48dD0838cd4B6FCDA717DF1fa249EC2444", MyToken.address)
  });
};
