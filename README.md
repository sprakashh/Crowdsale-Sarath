CROWDSALE 

This repo contains a crowdsale contract that sells erc20 tokens in exchange of ether. It can be called as a contract which promotes investment of ether for a certain amount of time (vesting period) till which the investors have to keep the money deposited and  withdraw  gradually once the vesting period is completed.

Following are the functionalities in detail :
  1. Stores key parameters for the crowdsale:
        Token address: Address of the ERC20 token contract being sold.
        Wallet address: Address where the collected funds are sent.
        Token price: Price of one token in units of the accepted cryptocurrency .
        Sale start and end timestamps: Defines the duration of the crowdsale event.
        Cliff and vesting durations :  defines vesting conditions for purchased tokens.
  2. Accepts investor contributions during the active sale period.
  3. Validates contributions based on the token price and minimum contribution limit.
  4. Mints new tokens and transfers them to the investor's wallet address.
  5. Tracks the total amount of funds raised and tokens sold.


Steps for Deployment :

1. Go to https://remix.ethereum.org/
2. Create a new file and name it as "ERC20"
3. Go to contracts folder in this repo and copy the code from ERC20.sol
4. Paste the code from step 3 into the file created in step 2.
5. Deploy the code after entering the required details such as token name, symbol, total supply inn remix after selecting "Injected Provider-Metamask"
6. Wait for deployment to take place, note the address once deployment is complete
7. Create a new file and name it as "Crowdsale"
8. Go to contracts folder in this repo and copy the code from Crowdsale.sol
9. Paste the code from step 8 into the file created in step 7.
10. Deploy the code after entering the required details, like the address , sale start , end time (get timestamp from epoch converter website) noted in step 6.
11. Once sale starts, click on the "Buy token" function and pay the min contribution that was mentioned while deployment.
12. Approve Transaction on Metamask and wait for confirmation, once confirmed, tokens will get credited.
13. Wait for the cliff time to get over .
14. Run "Withdraw token" function , if cliff time is not yet over, it will say "no vested tokens" , else if cliff period is over and tokens available for withdrawal, it will transfer the vested amount to the caller.
15. To Halt the sale at any time, "Halt" function can be used.



Steps for  Testing :

1. Pre- requisites :  - Node JS, npm
2. Clone the repo in local machine
3. cd to the folder of repo and Install Hardhat  :  npm install --save-dev hardhat             
4. Test contract : npx hardhat test
5. Compile contract : npx hardhat compile


Additional Information

1. Here , we have used  a general implementation of ERC20 smart contract as per the specification given in https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
2. Care has been taken to ensure that no vulnerabilities like Reentrancy, integer overflow/underflow are prevalent in both contracts
3. Gas Optimization also has been taken care of.


   
   
  
