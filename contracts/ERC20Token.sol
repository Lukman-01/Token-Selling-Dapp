//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ERC20Token{
    string public name = "IbukunOla";
    string public sysmbol = "IBK";
    uint public standard = 18;
    uint public totalSupply;
    address public ownerOfContract;
    uint public  _userId;

    address[] public holderToken;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping (address => TokenHolderInfo) public tokenHolderInfos;

    struct TokenHolderInfo{
        uint256 _tokenId;
        address _from;
        address _to;
        uint256 _totalToken;
        bool _tokenHolder;
    }

    mapping(address=> uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;
    constructor(uint256 _initialSupply) {
        ownerOfContract = msg.sender;
        balanceOf[msg.sender] = _initialSupply;
        _totalSupply = _initialSupply;
    }

    function _inc() internal {
        _userId += 1;   
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        _inc();

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        TokenHolderInfo storage tokenHolderInfo = tokenHolderInfos[_to];

        tokenHolderInfo._from = msg.sender;
        tokenHolderInfo._to = _to;
        tokenHolderInfo._tokenHolder = true;
        tokenHolderInfo._tokenId = _userId;
        tokenHolderInfo._totalToken = _value;

        holderToken.push(_to);

        emit Transfer(msg.sender,_to,_value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;
        return true;
    }

    function getTokenHolderData(address _add) public view returns(uint256, address, address, uint256, bool){
        tokenHolderInfo[_add]._tokenId,
        tokenHolderInfo[_add]._from,
        tokenHolderInfo[_add]._to,
        tokenHolderInfo[_add]._totalToken,
        tokenHolderInfo[_add]._tokenHolder 
    }

    function getTokenHolders() public view returns(address[] memory){
        return holderToken;
    }
} 
