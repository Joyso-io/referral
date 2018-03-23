const TestToken = artifacts.require("./TestToken.sol")
const TokenSender = artifacts.require("./TokenSender.sol")

contract('TokenSender', function(accounts) {
  const owner = accounts[0]
  const user1 = accounts[1]
  const user2 = accounts[2]

  it("go throught the process", async function() {
    var token = await TestToken.new('tt', 'tt', 18, {from: owner})
    var tokenSender = await TokenSender.new(token.address, {from: owner})

    await token.transfer(tokenSender.address, 100000000, {from: owner})
    var addresses = [user1, user2]
    var amount = [200000, 300000]
    await tokenSender.bulkTransfer(addresses, amount, {from: owner})
    var balance1 = await token.balanceOf.call(user1)
    var balance2 = await token.balanceOf.call(user2)

    assert.equal(balance1, 200000)
    assert.equal(balance2, 300000)
  });
});
