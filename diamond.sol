pragma solidity ^0.6.7;

import "https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";


contract DiamondHands {

    AggregatorV3Interface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
     */
     
     //Stored amount of ETH - This is the same amount to be returned later
     uint public storedTokens;
     
     //Address of investor, tokens will be returned to this address when price condition is met
     address payable public investor;
     
     //Value of token which acts as unlock condition
     uint public moonValue;
     
     //State of contract 
    enum State { Created, Locked, Inactive }
    State public state;
     
    constructor() public {
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() private view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
    
    function deposit(uint256 amount) payable public {
        require(msg.value == amount);
        investor = msg.sender;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function withdraw() public {
        investor.transfer(address(this).balance);
    }
    
    function onTheMoon() public returns (bool) {
        if (getLatestPrice() > 1){
            withdraw();
            return true;
        }
        else{
            return false;
        }
    }
    
}
