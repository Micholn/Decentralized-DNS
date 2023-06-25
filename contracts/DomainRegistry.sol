contract DomainRegistry {
    struct Domain {
      address owner;
      string domainName;
      string ipfsHash;
    }
  
    mapping(string => Domain) private domains;
  
    event DomainRegistered(address indexed owner, string domainName, string ipfsHash);
    event DomainTransferred(address indexed from, address indexed to, string domainName);
    event DisputeStarted(string domainName, address indexed resolver);
    event DisputeResolved(string domainName, address indexed resolver, address indexed newOwner);
  
    mapping(string => address) private disputeResolvers;
  
    modifier onlyResolver(string memory domainName) {
      require(disputeResolvers[domainName] == msg.sender, "Only the assigned resolver can resolve the dispute");
      _;
    }
  
    function registerDomain(string memory domainName, string memory ipfsHash) external {
      require(domains[domainName].owner == address(0), "Domain already registered");
      domains[domainName] = Domain(msg.sender, domainName, ipfsHash);
      emit DomainRegistered(msg.sender, domainName, ipfsHash);
    }
  
    function getDomain(string memory domainName) external view returns (address owner, string memory ipfsHash) {
      Domain memory domain = domains[domainName];
      require(domain.owner != address(0), "Domain not found");
      return (domain.owner, domain.ipfsHash);
    }
  
    function transferDomain(string memory domainName, address to) external {
      Domain storage domain = domains[domainName];
      require(domain.owner == msg.sender, "Only the owner can transfer the domain");
      require(to != address(0), "Invalid recipient");
  
      domain.owner = to;
      emit DomainTransferred(msg.sender, to, domainName);
    }
  
    function startDispute(string memory domainName) external {
      require(domains[domainName].owner != address(0), "Domain not found");
      require(disputeResolvers[domainName] == address(0), "Dispute already in progress");
  
      disputeResolvers[domainName] = msg.sender;
      emit DisputeStarted(domainName, msg.sender);
    }
  
    function resolveDispute(string memory domainName, address newOwner) external onlyResolver(domainName) {
      Domain storage domain = domains[domainName];
      require(newOwner != address(0), "Invalid new owner");
  
      address previousOwner = domain.owner;
      domain.owner = newOwner;
      delete disputeResolvers[domainName];
  
      emit DisputeResolved(domainName, msg.sender, newOwner);
      emit DomainTransferred(previousOwner, newOwner, domainName);
    }
  }