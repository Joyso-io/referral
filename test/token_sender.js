const TestToken = artifacts.require("./TestToken.sol")
const TokenSender = artifacts.require("./TokenSender.sol")

contract('TokenSender', function(accounts) {
  const owner = accounts[0]
  const user1 = accounts[1]
  const user2 = accounts[2]

  it("go throught the process", async function() {
    var token = await TestToken.new('tt', 'tt', 18, {from: owner})
    var tokenSender = await TokenSender.new({from: owner})
    var balance = await token.balanceOf.call(owner);
    console.log(balance.toNumber());

    await token.approve(tokenSender.address, 10000, {from: owner})
    var addresses = [user1, user2]
    var amounts = [200, 300]
    await tokenSender.bulkTransfer(addresses, amounts, token.address, {from: owner, gas:4200000})
    var balance1 = await token.balanceOf.call(user1)
    var balance2 = await token.balanceOf.call(user2)

    assert.equal(balance1, 200)
    assert.equal(balance2, 300)
  });

  it("transfer ether", async function() {
    var tokenSender = await TokenSender.new({from: owner})
    var amount1 = web3.toWei(1, "ether")
    var amount2 = web3.toWei(2, "ether")
    var total = web3.toWei(3, "ether")
    var user1_balance0 = await web3.eth.getBalance(user1)
    var user2_balance0 = await web3.eth.getBalance(user2)
    var addresses = [user1, user2]
    var amounts = [amount1, amount2]
    await tokenSender.bulkTransferEther(addresses, amounts, {from: owner, value: total})
    var user1_balance1 = await web3.eth.getBalance(user1)
    var user2_balance1 = await web3.eth.getBalance(user2)

    assert.equal(user1_balance1 - user1_balance0, amount1)
    assert.equal(user2_balance1 - user2_balance0, amount2)
  });
});
