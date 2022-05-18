# TOKEN DEPLOYED ON RINKEBY TESTNET

**OrangeToken:**<br/> 
<a href="https://rinkeby.etherscan.io/address/0x8152210d4664523ae2DeA69D183CFEAefE2100B8#code">https://rinkeby.etherscan.io/address/0x8152210d4664523ae2DeA69D183CFEAefE2100B8#code</a>

# PROJECT DEPLOYMENT FLOW

1. Clone the project from GitHub
2. Install dependencies
3. Customize configurations
4. Deploy

# 1. Clone the project from GitHub

Enter the following command in the terminal:

```shell
git clone https://github.com/Karynageek/crypto_h_w_1.git
```

# 2. Install dependencies

Before launch next command open the terminal into the the main folder of project
Then, enter:

```shell
npm install
```

# 3. Customize configurations

In this project:

1. rename the .env.example file to a file named .env
2. in the .env file change:

a) To get the Etherscan API key, go to
<a href="https://etherscan.io/myapikey">https://etherscan.io/myapikey</a>

c) your mnemonic of the account which will send the deployment transaction

# 4. Deploy

# DEPLOY ON RINKEBY TESTNET

```shell
npx hardhat run scripts/deploy.ts --network rinkeby
```

# VERIFICATION

Verification is automated

