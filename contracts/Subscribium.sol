pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Subscribium is Ownable {
    using SafeMath for uint256;

    address public publisher;
    address public stablecoin;

    mapping(address => SubscriptionTerms) public subscribers;
    mapping(address => uint256) nextValidTime;

    struct SubscriptionTerms {
        uint256 interval;
        uint256 value;
    }

    constructor(address _publisher, address _stablecoin) {
        publisher = _publisher;
        stablecoin = _stablecoin;
    }

    function Subscribe(uint256 _interval, uint256 _value) public {
        address subscriber = msg.sender;

        uint256 allowance = ERC20(stablecoin).allowance(subscriber, address(this));
        require(allowance >= _value, "Allowance is to small to subscribe");

        SubscriptionTerms memory terms = SubscriptionTerms(_interval, _value);
        subscribers[subscriber] = terms;
        nextValidTime[subscriber] = 0;
    }

    function Unsubscribe() public {
        address subscriber = msg.sender;
        nextValidTime[subscriber] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function ExecuteSubscription(address _subscriber) public returns (bool) {
        require(block.timestamp >= nextValidTime[_subscriber]);
        
        bool result = ERC20(stablecoin).transferFrom(
            _subscriber,
            address(this),
            subscribers[_subscriber].value
        );

        if (result == true) {
            nextValidTime[_subscriber] =
                subscribers[_subscriber].interval.add(block.timestamp);
        }

        return result;
    }

    
}