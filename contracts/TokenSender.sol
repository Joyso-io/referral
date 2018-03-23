pragma solidity ^0.4.17;
import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";


contract TokenSender {

    event TransferFail(uint256 index, address receiver, uint256 amount);

    function bulkTransfer(address[] receivers, uint256[] amounts, address token) external {
        address sender = msg.sender;
        uint256 length = receivers.length;
        for (uint256 i = 0; i < length; i++) {
            if (!ERC20(token).transferFrom(sender, receivers[i], amounts[i])) {
                TransferFail(i, receivers[i], amounts[i]);
                return;
            }
        }
    }
}
