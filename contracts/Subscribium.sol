pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Subscribium {
    address public publisher;
    address public usdc = 0xFda95Ce44E948206AaF38CBe0af115FF9B8cD2e8;

    mapping(address => SubscriptionTerms) private subscribers;
    mapping(address => uint256) nextValidTime;

    struct SubscriptionTerms {
        uint256 interval;
        uint256 value;
    }

    constructor(address _publisher) {
        publisher = _publisher;
    }

    function Subscribe(uint256 _interval, uint256 _value) public {
        address subscriber = msg.sender;

        uint256 allowance = ERC20(usdc).allowance(subscriber, address(this));
        require(allowance >= _value, "Allowance is to small to subscribe");

        SubscriptionTerms memory terms = SubscriptionTerms(_interval, _value);
        subscribers[subscriber] = terms;
        nextValidTime[subscriber] = 0;
    }

    function ExecuteSubscription(address _subscriber) public returns (bool) {
        require(block.timestamp >= nextValidTime[_subscriber]);
        bool result = ERC20(usdc).transferFrom(
            _subscriber,
            address(this),
            subscribers[_subscriber].value
        );

        if (result == true) {
            nextValidTime[_subscriber] =
                block.timestamp +
                subscribers[_subscriber].interval;
        } else {
            nextValidTime[_subscriber] = 2**255;
        }

        return result;
    }

    
}