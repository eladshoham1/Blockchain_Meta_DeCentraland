pragma solidity ^0.5.0;

contract Token {
    string public name;
    string public symbol;
    uint256 public decimal;
    uint256 public totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping (address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint256 _decimal, uint256 _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimal = _decimal;
        totalSupply = _totalSupply * (10 ** decimal);
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Not enough tokens to transfer");
        
        _transfer(msg.sender, _to, _value);

        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0));

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0));

        allowance[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(allowance[_from][msg.sender] >= _value, "Not approved to spend");
        require(balanceOf[_from] >= _value, "Not enough tokens to transfer");
        
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);

        return true;
    }
}