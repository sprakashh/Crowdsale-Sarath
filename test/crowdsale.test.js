const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crowdsale Contract", function () {
  let Crowdsale;
  let crowdsale;
  let token; // Mock ERC20 token

  beforeEach(async function () {
    // Deploy ERC20 mock (replace with actual token deployment if needed)
    const Token = await ethers.getContractFactory("ERC20");
    
    token = await Token.deploy(1000000); // Set initial token supply

    // Deploy Crowdsale contract
    Crowdsale = await ethers.getContractFactory("Crowdsale");
    crowdsale = await Crowdsale.deploy(
      token.address,
      0x33Bbc2b26552fb596fECF6BC55278358bfD7f857,
      ethers.utils.parseEther("0.1"), // Token price
      1714370726, // Sale starts -take from epoch converter.com
      1714370900, // Sale ends - take from epoch converter.com
      86400, // Cliff duration: 1 day
      864000 // Total vesting time: 10 days
    );
  });

  // Helper function to get signers (accounts)
  async function getSigners() {
    const signers = await ethers.getSigners();
    return signers;
  }

  it("Should deploy Crowdsale contract with correct initial values", async function () {
    expect(await crowdsale.token()).to.equal(token.address);
    expect(await crowdsale.tokenPriceInWei()).to.equal(ethers.utils.parseEther("0.1"));
    /
  });

  // *** Testing buyTokens function ***

  it("Should allow buying tokens during sale period and update vesting schedule", async function () => {
    const [buyer] = await getSigners();
    const value = ethers.utils.parseEther("1");

    await expect(crowdsale.connect(buyer).buyTokens({ value })).to.not.be.reverted;

    const schedule = await crowdsale.vestingSchedules(buyer.address);
    expect(schedule.totalContribution).to.equal(value * crowdsale.tokenPriceInWei());
  });

  it("Should revert if buying tokens before sale starts", async function () {
    const [buyer] = await getSigners();
    const value = ethers.utils.parseEther("1");

    // Move time before sale starts 
    await ethers.provider.send("evm_increaseTime", [1577836800 - block.timestamp]);

    await expect(crowdsale.connect(buyer).buyTokens({ value })).to.be.revertedWith("Sale hasn't started yet!");
  });

  it("Should revert if buying tokens after sale ends", async function () {
    const [buyer] = await getSigners();
    const value = ethers.utils.parseEther("1");

    // Move time after sale ends 
    await ethers.provider.send("evm_increaseTime", [86401]);

    await expect(crowdsale.connect(buyer).buyTokens({ value })).to.be.revertedWith("Sale is over, sorry!");
  });

  it("Should revert if buying tokens during sale on hold", async function () {
    const [buyer] = await getSigners();
    const value = ethers.utils.parseEther("1");

    // Halt the sale
    await crowdsale.haltSale();

    await expect(crowdsale.connect(buyer).buyTokens({ value })).to.be.revertedWith("Hold on tight, sale is on hold!");
  })

})