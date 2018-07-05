pragma solidity ^0.4.24;
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract TokenSender {

    event TransferFail(uint256 index, address receiver, uint256 amount);

    function bulkTransfer(address[] receivers, uint256[] amounts, address token) external {
        address sender = msg.sender;
        uint256 length = receivers.length;
        for (uint256 i = 0; i < length; i++) {
            if (!ERC20(token).transferFrom(sender, receivers[i], amounts[i])) {
                emit TransferFail(i, receivers[i], amounts[i]);
                return;
            }
        }
    }

    function bulkTransferEther(address[] receivers, uint256[] amounts) external payable {
        uint256 length = receivers.length;
        uint256 totalSend = 0;
        for (uint256 i = 0; i < length; i++){
            if (!receivers[i].send(amounts[i])) {
                emit TransferFail(i, receivers[i], amounts[i]);
                return;
            }
            totalSend += amounts[i];
        }
        uint256 balances = msg.value - totalSend;
        if (balances > 0) {
            msg.sender.transfer(balances);
        }
        require(this.balance == 0);
    }
}
