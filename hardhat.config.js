require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-web3");
require("hardhat-abi-exporter");
const { privateKey } = require("./secrets.json");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      // See the solidity docs for advice about optimization and evmVersion
      optimizer: {
        enabled: true,
        runs: 1,
      },
      //  evmVersion: "byzantium"
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
      accounts: [
        {
          balance: "100000000000000000000",
          // 0x038AfE1F8393b852817129709ffEa6211B12ab8d
          privateKey:
            "4149e3ed85d04f91783a1494e961aaee0ee1ace5890106965c68ba30e45d9210",
        },
        {
          balance: "300000000000000000000",
          // 0x2E5CA01422E48076150B0e7f126ab48E97Ee09Ac
          privateKey:
            "5166483b80cba5a1b5833f6cd2765d71c9820085d7437bed99ae288b975fba52",
        },
        {
          balance: "1000000000000000000",
          // 0x0E58268df8580334B15090b9D0a7e73e5185B99b
          privateKey:
            "e7cb0d971d967d04ac647fa7c5f1adfc2dcb126737b70ddfc4bbee03f9740ed1",
        },
        {
          balance: "20000000000000000000",
          // 0x4C725CB27700E09383d79346D71b3D6efd1c9444
          privateKey:
            "6c54bbcc10f0fdbff9b150be32a2381cb46af0f4d50b0858c01c850945008d57",
        },
      ],
    },
    testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [privateKey],
    },
    mainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [privateKey],
    },
  },
  abiExporter: {
    path: "./data/abi",
    clear: true,
    flat: true,
    only: [],
    spacing: 2,
  },
};
