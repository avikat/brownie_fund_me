// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping (address => uint256) public addresstoAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public pricefeed;

    constructor(address _priceFeed) public {
        pricefeed=AggregatorV3Interface (_priceFeed);
        owner = msg.sender;

    }
    


    
    function fund() public payable {
        uint256 minimumUSD = 5*10**18;
        require(getConversionRate(msg.value) >= minimumUSD,"you need to spend more money"); 
        addresstoAmountFunded[msg.sender] += msg.value; 
        funders.push(msg.sender);
        
    }
    function getEntranceFee() public view returns (uint256) {
        // minimumUSD
        uint256 minimumUSD = 5 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    function getVersion() public view returns(uint256)
    {
        
        return pricefeed.version();
    
    }

    function getPrice() public view returns(uint256)
    {
        
        (
            ,int price,,,
        ) = pricefeed.latestRoundData();
        return uint256(price*10000000000);
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256)
    { 
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethAmount*ethPrice)/1000000000000000000;
        return ethAmountInUSD;
    }
    

   

    function withdraw () payable public {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++)
        {
            address funder = funders[funderIndex];
            addresstoAmountFunded[funder] = 0;
        }
         funders = new address[](0);
    }
 

}