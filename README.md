# Basic Launchpad Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```

Install package npm install

Compiling

npx hardhat compile

Testing

npx hardhat test

You can deploy in the localhost network following these steps:

Start a local node

npx hardhat node

Open a new terminal and deploy the smart contract in the localhost network

npx hardhat run --network localhost scripts/deploy.js

As general rule, you can target any network configured in the hardhat.config.js

npx hardhat run --network <your-network> scripts/deploy.js

Console

npx hardhat console --network localhost

For Clean compile

npx hardhat clean


Testnet contract address
0xbaF193D89E3803614B7c4576C3eBda4b97C53B82

npx hardhat verify --network testnet 0x1B0e7860a2354A7A32A1fc0D5F9188d242Bad708 