pragma solidity ^0.4.22;

contract ProjectManager {
    /*
     * A factory contract to create new SharesVoteProject
     * and manager users / project summary for display
     */
    
    struct ProjectSummary {
        address deployedAddress;
        string title;
        string description;
    }
    
    address[] public userAccounts;
    string[] public userIds;
    
    mapping(string=>address)  userAccountMap;
    mapping(string=>bool)  userIdMap; // for exist logic
    
    mapping(address=>string) addressUserMap;
    mapping(address=>bool)  addressMap; // for exist logic
    
    ProjectSummary[] public deployedProjects;
    
    function register(string _userId) public {
        require(!addressMap[msg.sender], 'ETH account already registered!');
        require(!userIdMap[_userId], 'Username already exist!');
        // add to username  and account arrays
        userAccounts.push(msg.sender);
        userIds.push(_userId);
        // set userId -> account map
        userAccountMap[_userId] = msg.sender;
        // set userId exist
        userIdMap[_userId] = true;
        // set account -> userId map
        addressUserMap[msg.sender] = _userId;
        // set account address exist
        addressMap[msg.sender] = true;
    }
    
    function addressForUserId(string _userId) public view returns(address) {
        return userAccountMap[_userId];
    }
    
    function userIdForAccount(address _address) public view returns (string) {
        return addressUserMap[_address];
    }
    
    // args for remix testing 
    // "test","test desc", ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"]
    
    function newProject (string _title, string _description, 
        address[] holderAddresses) public {
        
        // make sure holder addresses are valid 
        for (uint i=0; i<holderAddresses.length; i++) {
            require(addressMap[holderAddresses[i]], 'user invalid');
        }
        // end validations
        
        // deploy ShareVoteProject contract
        address newDeployedProject = new SharesVoteProject(_title, _description, 
            address(this), holderAddresses);
        
        // create and store project summary    
        ProjectSummary memory projectSummary = ProjectSummary({
            deployedAddress: newDeployedProject,
            title: _title,
            description: _description
        });
            
        deployedProjects.push(projectSummary);
        
    }

}

contract SharesVoteProject {
    
    struct ShareHolder {
        string userId;
        address account;
        uint share;
    }
    
    struct Vote {
        address voter;
        address holder;
        uint share;
    }
    
    string public title;
    string public description;
    bool public shareDetermined;
    uint public timeCreated;
    uint public timeShareDetermined;
    
    ShareHolder[] public shareHolders;
    mapping(address=>bool) uniqueHolderAddressMap;
    Vote[] private votes;
    
    constructor (string _title, string _description, 
        address managerContract,
        address[] _holderAddresses
        ) public {
        title = _title;
        description = _description;
        
        // create list of ShareHolder structs by looking up userId
        ProjectManager manager = ProjectManager(managerContract);
        for (uint i=0; i<_holderAddresses.length; i++) {
            address _address = _holderAddresses[i];
            
            require(!uniqueHolderAddressMap[_address], 'duplicated user account found');
            uniqueHolderAddressMap[_address] = true;
            
            // look up userId to create holder struct
            string memory _userId = manager.userIdForAccount(_address);
            ShareHolder memory holder = ShareHolder({
                userId: _userId,
                account: _address,
                share: 0
            });
            shareHolders.push(holder);
        }
        
        shareDetermined = false;
        timeCreated = now;
    }
    
    // vote
    // and finalize shares when everyone voted
    
    // Payment and split (fallback function)

    function () public payable {
        
        uint balance = msg.value;
        uint spentAmt = 0;
        uint l = shareHolders.length;
        
        // TODO: use share pct istead of even split :D
        for(uint i=0; i<l-1; i++){
            uint amt = balance/l;
            shareHolders[i].account.transfer(amt);
            spentAmt += amt;
        }
    
        // send the rest to the last address
        shareHolders[l-1].account.transfer(balance - spentAmt);

    }
    
    
    //////
    // future features
    
    // - update own vote
    
    // - vote add new shareholder
    
    // -  kick shareholder
}