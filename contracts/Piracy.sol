//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;


contract Piracy {
    string private greeting;
    address private owner;
    mapping (address => bool) public admins;
    mapping (address => string) public requests;
    address[] public pendingRequests;
    mapping (string => address) public approvedRequests;
    string[] public approved;

    event newFile(address from, string file);

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;
    }

    modifier onlyOwner {
        require(msg.sender==owner);
        _;
    }

    modifier onlyAdmin {
        require(admins[msg.sender], "Not an admin");
        _;
    }

    function deleteAddressFromArrya(address addr) internal {
        uint index;
        for(uint i=0;i<pendingRequests.length;i++) {
            if(pendingRequests[i]==addr){
                index = i;
                break;
            }
        }

        pendingRequests[index] = pendingRequests[pendingRequests.length-1];
        pendingRequests.pop();
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function addAdmin(address addr) public onlyOwner {
        require(!admins[addr], "Admin already added");
        admins[addr] = true;
    }

    function addFile(string memory file) public {
        require(compareStrings(requests[msg.sender], ""), "Request already pending");
        requests[msg.sender] = file;
        pendingRequests.push(msg.sender);
    }

    function getPendingAddresses() public view onlyAdmin returns (address[] memory) {
        return pendingRequests;
    }

    function getPendingFileFromAddress(address addr) public view returns(string memory) {
        return requests[addr];
    }

    function approve(address addr) public onlyAdmin {
        require(!compareStrings(requests[addr], ""), "No pending requests for this address");
        approved.push(requests[addr]);
        approvedRequests[requests[addr]] = addr;
        emit newFile(addr, requests[addr]);
        requests[addr] = "";
        deleteAddressFromArrya(addr);
    }

    function deleteFile(address addr) public onlyAdmin {
        require(!compareStrings(requests[addr], ""), "No pending requests for this address");
        requests[addr] = "";
        deleteAddressFromArrya(addr);
    }

    function getPendingRequest(address addr) public view returns (string memory) {
        require(!compareStrings(requests[addr], ""), "No pending requests for this address");
        return requests[addr];
    }

    function checkIsAdmin(address addr) public view returns(bool) {
        return admins[addr];
    }

    function getAllFiles() public view returns (string[] memory) {
        return approved;
    }

    function getFileOwner(string memory file) public view returns (address) {
        require(approvedRequests[file]!=address(0), "No such file");
        return approvedRequests[file];
    }

}
