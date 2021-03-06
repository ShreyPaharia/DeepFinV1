<p align="center"><img src="/tempsnip.png" align="center" width="400"></p>

<p  align="center">New way to tokenize post dated payments and unlock huge amount of money locked in large supply chains! 🚀</p>

## Motivation
  SMEs all around the world are facing cashflow/financing problems due to lack of credit history, small loan sizes. But any company works with companies who are willing to accept payments after 60-120 days from the date of supply. So these SMEs have to work with loan sharks for their financing needs. Invoice discounting is a way to solve this problem for SMEs working directly with large, well-known companies whose invoices banks accept, but not for companies who are deep in the supply chain (i.e. supplying to the company which is working with large company). Because of this large amount of money is locked in such supply chains due to which them SMEs have to face issues. More than millions of dollars are locked in these supply chain which can be used to generate higher yield for depositors and helping MSMEs all around the world. 

## Solution
  We are building a decentralized pool-based structure leveraging AAVE for deep tier financing. Lenders provide liquidity by depositing stable coins in a pool contract. Borrowers are small and medium businesses who have access to very costly financing only. Incase these SMEs are in the supply chain of a top company (anchor) then the invoice of the company to the first supplier can be used to mint tokens. These tokens can then be passed along the supply chain representing future dated payment on a specific day. By submitting these tokens as collateral to the pool they can borrow money.

## Architechture

![image](https://github.com/ShreyPaharia/DeepFinV1/blob/v1_ethodyssey/DeepFinChain.png)

### The Lending Pool Contract

- The lending pool contract is a combination of Superfluid super app to manage streaming of interest and AAVE credit delegation contract for taking deposits and delegating credit on Aave.	

### Interest Rate Strategy

- Interest rate strategy would be similar to AAVE to keep the utilization optimal (80-90%). 
- For borrowers the base rate would be based on the credit rating and past repayments of anchor. This rate would be fixed for the term of loan. 
- For depositors the rate which they get would be based on the total interest income generated by the pool equally divided into the depositors

### Financing Request Manager

- The protocol implements the multi-sign strategy for verification of invoice and agreement between protocol and anchor of repayment on specific amount on a specific date.
- An organization which has a payable by an accepted anchor can submit their invoice for token minting
- This request goes to anchor’s dashboard, where they have the option of accepting or rejecting it.

### Tokenization

- The protocol implements tokenization strategy for invoices. 
- If the invoice is accepted, an ERC1155 tokens representing the future cashflow by anchor are minted and sent to the requesting organization’s wallet. These tokens also contain the details of the agreement in token meta data.
- On repayment the protocol changes the repaid flag on the token from false to true

### Cashflow Token

- Each new accepted invoice leads to minting of a new cashflow token
- Each cashflow token can be replaced with stable coins, using redeem functionality which will work once the repaid flag is set true.
- It also contains the following details:
  - Public details of the agreement
  - Payment date
  - Amount
  - Repay status
  - Anchor details
  - Link to the agreement between anchor and protocol
  - Link to the actual invoice


## Various blockchain protocol integrations 

### Superfluid

- Using lendingpool manager as super app which takes care of constantly flowing interest to the lenders and the stakeholders, super deposit tokens (1:1 pegged to USDC, native super token) are used to stream interest(multiple outflows) to all the parties with compouding over stable rate.
  
### Aave

- Leveraging lending capabilites by deposting colletral and gaining interest until is invoice settlement is realised and increasing flow of cash down the supply chain. Allowing to borrow(loan) against the part of invoice by locking cashflow tokens.
  
### Filecoin

- Using slate as decentralied distributed storage for storing the invoices and the agreements data.
  
### Chainlink

- Used for getting price feed for eth/usd to interconvert values between more than two assets allowing to pay invoice in several currencies.
  
### Portis

- Used to make the process of interacting with contract easier for SMEs and leveraging "trust this app" feature for single click transaction flow.

### Consensys

- We used the infura's RPC for network interaction and metamask wallet for end users to onboard quickly without any additional requirements. we plan to add infura's ITX in future for gasless transactions.

### The Graph
- Used to get the lending rates from corresponding Aave pools onto which tokens are transferred and credit is delegated.
- We deoployed our graphs [cashflow](https://thegraph.com/legacy-explorer/subgraph/hack3r-0m/cashflow) and [lending pool](https://thegraph.com/legacy-explorer/subgraph/hack3r-0m/lending-pool-df) to index the relevant data(mentioned in description of subgraph) to use it further in our UI to display stats, history and pending actions required from user.
  
  
## Polygon Deployments (Mumbai)

- LendingPoolDF: [0xB09aC2d78A7e8470E27B3ED6f834779fCb8C6A38](https://mumbai.polygonscan.com/address/0xB09aC2d78A7e8470E27B3ED6f834779fCb8C6A38)
- SuperDepositToken: [0x9048296bFb28AaBb53f945c9ba54694D305C72FC](https://mumbai.polygonscan.com/address/0x9048296bFb28AaBb53f945c9ba54694D305C72FC)
- CashflowToken: [0x648dfE57FFe7EB2a5461930b91B35A5eDE2aDdc2](https://mumbai.polygonscan.com/address/0x648dfE57FFe7EB2a5461930b91B35A5eDE2aDdc2)

(Testing contracts)

- LendingPoolDF: [0xd1773D02e065Db0d105F35D396E08D99AA58E36B](https://mumbai.polygonscan.com/address/0xd1773D02e065Db0d105F35D396E08D99AA58E36B)
- SuperDepositToken: [0xC86AE588dBF297Fa52285FB76B117D394516ca06](https://mumbai.polygonscan.com/address/0xC86AE588dBF297Fa52285FB76B117D394516ca06)
- CashflowToken: [0x1e69Dea883508812bDf18057637c336514c561db](https://mumbai.polygonscan.com/address/0x1e69Dea883508812bDf18057637c336514c561db)
