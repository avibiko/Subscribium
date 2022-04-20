const MyToken = artifacts.require("MyToken");
const Subscribium = artifacts.require("Subscribium");

module.exports = function (deployer) {
  deployer.deploy(MyToken, 100).then(function() {
    return deployer.deploy(Subscribium, "0x6b67d934c4cef8f4bce9b81d05cb2a9bbcba3697", MyToken.address)
  });
};
