const MyToken = artifacts.require("MyToken");
const Subscribium = artifacts.require("Subscribium");
const Payments = artifacts.require("Payments");

module.exports = function (deployer) {
  let publisher = "0x6b67d934c4cef8f4bce9b81d05cb2a9bbcba3697"
  let owner = "0xc094b40284653f178e89e003d00b85ead8fcc086"
  deployer.deploy(MyToken, 100000).then(function() {
    return deployer.deploy(Payments, [owner, publisher], [10, 90]).then(function() {
      return deployer.deploy(Subscribium, publisher, MyToken.address, Payments.address)
    })
  });
};
