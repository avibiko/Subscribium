pragma solidity ^0.8.13;

import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract Payments is PaymentSplitter {
    address owner;
    address publisher;
    modifier OwnerOrPublisher() {
        require(_msgSender() == owner || _msgSender() == publisher);
        _;
    }
    constructor(address[] memory _payees, uint256[] memory _shares) PaymentSplitter(_payees, _shares) payable {
        owner = _payees[0];
        publisher = _payees[1];
    }
}