//SPDX-License-Identifier:GPL-3.0

pragma solidity ^0.8.2;

contract ERC20
{
    string public symbol;
    string public name;
    uint256 public totalSupply;
    uint8 public decimals;
    address  payable owner;
    mapping(address=>uint256) private balances; //collection of balances of each address
    mapping(address=>mapping(address=>uint256)) allowances; // allowances set by each address for a particular address
    event Transfer(address indexed _from, address indexed _to,uint amount); //Transfer event
    event Approval(address indexed _owner,address indexed _spender,uint256 _value);//Approval event

    
    constructor(string memory _symbol,string memory _name,uint256 _totalSupply,uint8 _decimals)
    {
        symbol=_symbol;
        name=_name;
        totalSupply=_totalSupply;
        decimals=_decimals;
        owner=payable(msg.sender);
        balances[owner]=totalSupply;

    }

    //to check token balanceof each address
    function balanceOf(address addr) public view returns(uint256 )
    {
        return(balances[addr]);

    }

    //the main transfer function
    function transfer(address _spender,uint  value) public returns(bool success)
    {

       
        require(balances[msg.sender] >=value,"Insufficient balance");
        balances[msg.sender]-=value;
        balances[_spender]+=value;
        emit Transfer(msg.sender,_spender,value);
        return true;





    }

    //function to approve delegation of token transaction
    function approve(address _spender , uint _value) public returns(bool success)
    {
        allowances[msg.sender][_spender]+=_value;
        emit Approval(msg.sender, _spender, _value);
        return true;

    }


    //to display allowance set by each address for each spender
    function allowance(address _owner,address _spender) public view returns(uint256 remaining)
    {

        return allowances[_owner][_spender];


    }

    
    //delegated transfer function
    function transferFrom(address _owner, address _to,uint _value) public returns(bool success)
    {
        
        require(allowances[_owner][msg.sender]>=_value,"Insufficient allowance");
        balances[_owner]-=_value;
        balances[_to]+=_value;
        allowances[_owner][msg.sender]-=_value;
        emit Transfer(_owner, _to, _value);
        return true;




    }

    


}
