
const DomainRegistry = artifacts.require("DomainRegistry");

contract("DomainRegistry", (accounts) => {
  let domainRegistry;

  beforeEach(async () => {
    domainRegistry = await DomainRegistry.new();
  });

  it("should register a domain", async () => {
    const domainName = "example.com";
    const ipfsHash = "QmVp1iRa5fZwEgkD8sC7w8bMgcv32LmErP94WRu1LFD7G9";
    const owner = accounts[0];

    const receipt = await domainRegistry.registerDomain(domainName, ipfsHash, { from: owner });
    assert.equal(receipt.logs.length, 1);
    assert.equal(receipt.logs[0].event, "DomainRegistered");
    assert.equal(receipt.logs[0].args.owner, owner);
    assert.equal(receipt.logs[0].args.domainName, domainName);
    assert.equal(receipt.logs[0].args.ipfsHash, ipfsHash);

    const retrievedOwner = await domainRegistry.getDomain(domainName);
    assert.equal(retrievedOwner, owner);
  });

});