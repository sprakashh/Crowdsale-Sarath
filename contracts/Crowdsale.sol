//SPDX-License-Identifier:GPL 3.0


pragma solidity ^0.8.2;
import "./ERC20.sol";

contract Crowdsale

{

    ERC20 public token;
    address payable public wallet; 
  uint256 public tokenPriceInWei; // Price per token 
  uint256 public saleStartsAt;     
  uint256 public saleEndsAt;       
  bool public saleOnHold;          // To Halt

  // Vesting parameters
  uint256 public cliffDuration;     //cliff time
  uint256 public totalVestingTime;  // Total vesting duration 

  // Mapping to track contributions and vesting schedules for each participant
  mapping(address => VestingSchedule) public vestingSchedules;

  struct VestingSchedule {
    uint256 totalContribution;  // Total tokens contributed
    uint256 vestedAmount;       // Amount of tokens already vested
    uint256 lastVestingTime;     // Timestamp of the last vested tokens withdrawal
  }

  constructor(
    ERC20 _token,
    address payable _wallet,
    uint256 _tokenPriceInWei,
    uint256 _saleStartsAt,
    uint256 _saleEndsAt,
    uint256 _cliffDuration,
    uint256 _totalVestingTime
  ) {
    token = _token;
    wallet = _wallet;
    tokenPriceInWei = _tokenPriceInWei;
    saleStartsAt = _saleStartsAt;
    saleEndsAt = _saleEndsAt;
    cliffDuration = _cliffDuration;
    totalVestingTime = _totalVestingTime;
    saleOnHold = false;
  }

  // code to buy some tokens in exchange of eth
  function buyTokens() public payable {
    require(block.timestamp >= saleStartsAt, "Sale hasn't started yet!");
    require(block.timestamp <= saleEndsAt, "Sale is over, sorry!");
    require(!saleOnHold, "Hold on tight, sale is on hold!");

    uint256 tokensToGive = msg.value * tokenPriceInWei;

    // Update contributor's vesting schedule
    VestingSchedule storage schedule = vestingSchedules[msg.sender];
    schedule.totalContribution += tokensToGive;
  }

  // function to claim  vested tokens after the cliff period
  function withdrawVestedTokens() public {
    require(hasVestedTokens(msg.sender), "No vested tokens available yet!");

    uint256 claimableAmount = calculateVestedAmount(msg.sender);
    vestingSchedules[msg.sender].vestedAmount += claimableAmount;
    vestingSchedules[msg.sender].lastVestingTime = block.timestamp;

    token.transfer(msg.sender, claimableAmount);
  }

  // function to check if a contributor has any vested tokens
  function hasVestedTokens(address contributor) public view returns (bool) {
    VestingSchedule storage schedule = vestingSchedules[contributor];
  uint256 elapsedTime = block.timestamp - schedule.lastVestingTime;

  if (elapsedTime < cliffDuration) {
    return false; // Cliff period not passed yet
  }

  uint256 totalVested = schedule.totalContribution * elapsedTime / totalVestingTime;
  return totalVested > schedule.vestedAmount; 
  }

  // Calculate how many tokens are ready to be claimed based on vesting schedule
  function calculateVestedAmount(address contributor) public view returns (uint256) {
    VestingSchedule storage schedule = vestingSchedules[contributor];
    uint256 elapsedTime = block.timestamp - schedule.lastVestingTime;

    if (elapsedTime < cliffDuration) {
      return 0; // Cliff period not passed yet
    }

    uint256 totalVested = schedule.totalContribution * elapsedTime / totalVestingTime;
    return totalVested - schedule.vestedAmount; // Claimable amount after vestedAmount deduction
  }

  // Function to halt the sale 
  function haltSale() public onlyOwner {
    saleOnHold = true;
  }

  // Modifier to restrict functions to contract owner 
  modifier onlyOwner() {
    require(msg.sender == 0x33Bbc2b26552fb596fECF6BC55278358bfD7f857, "Only the owner can do this!");
    _;
  }





}