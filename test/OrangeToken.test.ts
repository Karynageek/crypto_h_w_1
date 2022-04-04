import { expect } from "chai";
import { ethers } from "hardhat";
import { parseEther } from "@ethersproject/units";
import { OrangeToken__factory } from "../typechain-types/factories/OrangeToken__factory";
import { OrangeToken } from "../typechain-types/OrangeToken";

describe('Orange Token contract', () => {
  let token: OrangeToken;
  let owner: any;
  let addr1: any;
  let addr2: any;
  let addrs: any;
  const name = 'Orange Token';
  const symbol = 'ORT';
  const decimals = 18;
  const totalSupply = parseEther('1000000000');
  const zeroAddress = '0x0000000000000000000000000000000000000000';

  beforeEach(async () => {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    const OrangeToken = (await ethers.getContractFactory('OrangeToken')) as OrangeToken__factory;
    token = await OrangeToken.deploy();

    await token.deployed();
  });

  describe("deployment", () => {
    it('track the name', async () => {
      expect(await token.name()).to.equal(name);
    })

    it('track the symbol', async () => {
      expect(await token.symbol()).to.equal(symbol);
    })

    it('track the decimals', async () => {
      expect(await token.decimals()).to.equal(decimals);
    })

    it('track the total supply', async () => {
      expect(await token.totalSupply()).to.equal(totalSupply);
    })

    it('assigns the total supply to the deployer', async () => {
      expect(await token.balanceOf(owner.address)).to.equal(totalSupply);
    })
  });

  describe('transfers tokens', () => {
    it('transfers successfully', async () => {
      const amount = parseEther('100');

      const addr1BalanceBefore = await token.balanceOf(owner.address);

      const result = await token.transfer(addr1.address, amount);

      const addr1BalanceAfter = await token.balanceOf(owner.address);

      expect(addr1BalanceAfter).to.equal(addr1BalanceBefore.sub(amount));

      await expect(result).to.emit(token, "Transfer")
        .withArgs(owner.address, addr1.address, amount);
    })

    it('rejects insufficient balances', async () => {
      await expect(token.transfer(addr1.address, parseEther('10000000000'))).to.be.revertedWith('Insufficient balance');
    })
  })

  describe('approving tokens', () => {
    it('approves successfully', async () => {
      const amount = parseEther('100');
      const result = await token.approve(addr1.address, amount);
      const allowance = await token.allowance(owner.address, addr1.address)

      expect(allowance).to.equal(amount);

      await expect(result).to.emit(token, "Approval")
        .withArgs(owner.address, addr1.address, amount);
    })
  })

  describe('delegated token transfers', () => {
    const amount = parseEther('100');

    it('transfers successfully', async () => {
      await token.approve(addr1.address, amount);

      const addr1BalanceBefore = await token.balanceOf(owner.address);

      const result = await token.transferFrom(owner.address, addr1.address, amount);

      const addr1BalanceAfter = await token.balanceOf(owner.address);

      expect(addr1BalanceAfter).to.equal(addr1BalanceBefore.sub(amount));

      await expect(result).to.emit(token, "Transfer")
        .withArgs(owner.address, addr1.address, amount);
    })

    it('rejects insufficient balances', async () => {
      await expect(token.transferFrom(owner.address, addr1.address, parseEther('10000000000'))).to.be.revertedWith('Insufficient balance');
    })

    it('rejects not allowed amount', async () => {
      await expect(token.transferFrom(owner.address, addr1.address, amount)).to.be.revertedWith('Not allowed amount');
    })
  })

  describe('mint', () => {
    const amount = parseEther('100');

    it('mints successfully', async () => {
      const ownerBalanceBefore = await token.balanceOf(owner.address);
      const totalSupplyeBefore = await token.totalSupply();

      const result = await token.mint(owner.address, amount);

      const ownerBalanceAfter = await token.balanceOf(owner.address);
      const totalSupplyeAfter = await token.totalSupply();

      expect(ownerBalanceAfter).to.equal(ownerBalanceBefore.add(amount));
      expect(totalSupplyeAfter).to.equal(totalSupplyeBefore.add(amount));

      await expect(result).to.emit(token, "Transfer")
        .withArgs(zeroAddress, owner.address, amount);
    })

    it('rejects mint by zero address', async () => {
      await expect(token.mint(zeroAddress, amount)).to.be.revertedWith('Mint to the zero address');
    })
  })

  describe('burn', () => {
    const amount = parseEther('100');

    it('burns successfully', async () => {
      const ownerBalanceBefore = await token.balanceOf(owner.address);
      const totalSupplyeBefore = await token.totalSupply();

      const result = await token.burn(owner.address, amount);

      const ownerBalanceAfter = await token.balanceOf(owner.address);
      const totalSupplyeAfter = await token.totalSupply();

      expect(ownerBalanceAfter).to.equal(ownerBalanceBefore.sub(amount));
      expect(totalSupplyeAfter).to.equal(totalSupplyeBefore.sub(amount));

      await expect(result).to.emit(token, "Transfer")
        .withArgs(owner.address, zeroAddress, amount);
    })

    it('rejects burn by zero address', async () => {
      await expect(token.burn(zeroAddress, amount)).to.be.revertedWith('Burn to the zero address');
    })

    it('rejects burn when amount exceeds balance', async () => {
      await expect(token.burn(addr2.address, amount)).to.be.revertedWith('Amount exceeds balance');
    })
  })
});
