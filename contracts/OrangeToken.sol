//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract OrangeToken {
    address public owner;
    string private _name = "Orange Token";
    string private _symbol = "ORT";
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 1000000000 * 10**_decimals;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Mint(
        address indexed sender,
        uint256 amountBefore,
        uint256 amountAfter
    );
    event Burn(
        address indexed sender,
        uint256 amountBefore,
        uint256 amountAfter,
        address indexed to
    );

    constructor() {
        owner = msg.sender;
        _balances[msg.sender] = _totalSupply;
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
