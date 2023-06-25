const DomainRegistry = artifacts.require("DomainRegistry");

module.exports = function (deployer) {
  deployer.deploy(DomainRegistry);
};