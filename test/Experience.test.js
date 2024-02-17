const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Experience", function () {
  async function deployFixture() {
    const [owner, account2] = await ethers.getSigners();

    const Experience = await ethers.getContractFactory("Experience");
    const expContract = await Experience.deploy(
      "1000000000000000000000000",
      []
    );

    return { expContract, owner, account2 };
  }

  describe("Deployment", function () {
    it("Should x", async function () {
      const { expContract } = await loadFixture(deployFixture);
      const contractBalance = await expContract.balanceOf(
        expContract.getAddress()
      );
      console.log(contractBalance);
    });

    it("Should x", async function () {
      const { expContract, owner } = await loadFixture(deployFixture);

      await expContract.register("kimerran");

      console.log(">", await expContract.getKudosBalance(owner.address));
    });

    it("Should x", async function () {
      const { expContract, owner, account2 } = await loadFixture(deployFixture);

      await expContract.register("kimerran");

      await expContract.connect(owner).kudos(account2.address);

      console.log(">", await expContract.balanceOf(account2.address));
      console.log(">", await expContract.getKudosBalance(owner.address));
    });

    it("Should x", async function () {
      const { expContract, owner, account2 } = await loadFixture(deployFixture);

      await expContract.register("kimerran");

      await expContract.connect(owner).reward(100_000, account2.address);

      console.log(">", await expContract.balanceOf(expContract.getAddress()));
    });

    it("Should x", async function () {
      const { expContract, owner, account2 } = await loadFixture(deployFixture);

      await expContract.register("kimerran");

      for (let index = 1; index <= 100; index++) {
        await expContract.connect(owner).kudos(account2.address);
      }

      console.log(">", await expContract.balanceOf(account2.address));
      console.log(">", await expContract.getKudosBalance(owner.address));
    });
  });
});
