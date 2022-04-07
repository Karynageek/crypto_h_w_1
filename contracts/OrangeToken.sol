//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract OrangeToken {
    address public owner;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor(
        string memory nameToken,
        string memory symbolToken,
        uint8 decimalsToken,
        uint256 totalSupplyToken
    ) {
        _name = nameToken;
        _symbol = symbolToken;
        _decimals = decimalsToken;
        _totalSupply = totalSupplyToken * 10**_decimals;
        _balances[msg.sender] = _totalSupply;
        owner = msg.sender;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256)
    {
        return _allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(_to != address(0), "Transfer to the zero address");
        require(_balances[msg.sender] >= _value, "Insufficient balance");
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) internal {
        _balances[_from] -= _value;
        _balances[_to] += _value;
        emit Transfer(_from, _to, _value);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_to != address(0), "Transfer to the zero address");
        require(_value <= _balances[_from], "Insufficient balance");
        require(_value <= _allowances[_from][_to], "Not allowed amount");
        _allowances[_from][_to] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function mint(address _account, uint256 _amount) public {
        require(_account != address(0), "Mint to the zero address");
        _totalSupply += _amount;
        _balances[_account] += _amount;
        emit Transfer(address(0), _account, _amount);
    }

    function burn(address _account, uint256 _amount) public {
        require(_account != address(0), "Burn to the zero address");
        require(_balances[_account] >= _amount, "Amount exceeds balance");
        _balances[_account] -= _amount;
        _totalSupply -= _amount;
        emit Transfer(_account, address(0), _amount);
    }
}
