
pragma solidity ^0.5.4;


interface IBEP20 {
    
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }

}

contract Ownable   {
    address public _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**

     * @dev Initializes the contract setting the deployer as the initial owner.

     */

    constructor() internal {
        _owner = msg.sender;

        emit OwnershipTransferred(address(0), _owner);
    }

    /**

     * @dev Returns the address of the current owner.

     */

    function owner() public view returns (address) {
        return _owner;
    }

    /**

     * @dev Throws if called by any account other than the owner.

     */

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");

        _;
    }

    /**

     * @dev Transfers ownership of the contract to a new account (`newOwner`).

     * Can only be called by the current owner.

     */

    function transferOwnership(address newOwner) public onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );

        emit OwnershipTransferred(_owner, newOwner);

        _owner = newOwner;
    }
}




contract Pool is Ownable{
    using SafeMath for uint256;
    IBEP20 public token;

    constructor(IBEP20 _token) public {
        token = _token;
   
    }
    
    
    uint public totalusercount;
    address public LastPoolWinner;
    mapping(address => uint256) depositeAmount;
    mapping(address =>uint256) winningAmount;
    address [] users;
 

    
    
    function stake (uint256 _amount) public 
     {
       require(_amount == 100E18, "Enter 100");
       require(token.balanceOf(msg.sender) >= 100E18,"balance not found");
       
          uint256 fee = _amount*100/3;
          users.push(msg.sender);
          token.transfer(_owner, fee);
          token.transferFrom(msg.sender, address(this), _amount - fee);
          depositeAmount[msg.sender]+=_amount-fee;
          uint256 currentDeposit = _amount-fee;
          totalusercount++;
          
          if(users.length>4 && token.balanceOf(address(this))> 485E18)
           {
            LastPoolWinner = users[0];
            uint256 reward=currentDeposit.mul(5);
            token.transfer(LastPoolWinner,reward);
            winningAmount[LastPoolWinner]+=reward;
         
             for(uint i = 0; i <  users.length - 1; i++)
              {
                users[i] = users[i + 1];
              }
                users.pop();
                totalusercount--;
         }
    }
    
    function approve(address spender, uint tokens)public returns (bool success) {    
         token.ApprovalFrom(msg.sender, address(this), _amount, 
         Approval(address(this), tokens),    
         return true;  
          
    }
 

    function totaluser() public view returns (address[] memory _users)
    {
       return users;    
    }
    
    
}
