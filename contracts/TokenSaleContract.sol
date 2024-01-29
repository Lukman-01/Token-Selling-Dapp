//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20Token.sol";

contract TokenSale{
    address admin;
    ERC20Token public tokencontract;
    uint256 public tokenPrice;
    uint256 public tokenSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(ERC20Token _tokenContract, uint256 _tokenPrice){
        admin = msg.sender;
        tokencontract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    function multiply(uint256 x, uint256 y) internal pure returns(uint256 z){
        require(y==0 || (z = x*y)/y == x);
    }

    function buyToken(uint256 _numberOfTokens) public payable{
        require(msg.sender == multiply(_numberOfTokens, tokenPrice));
        require(tokencontract.balanceOf(address(this))>= _numberOfTokens);
        require(tokencontract.transfer(msg.sender, _numberOfTokens*1000000000000000000));

        tokenSold += _numberOfTokens;
        emit Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public{
        require(msg.sender == admin);
        require(tokencontract.transfer(admin,tokencontract.balanceOf(address(this))));

        payable(admin).transfer(address(this).balance);
    }
}