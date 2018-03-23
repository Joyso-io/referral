pragma solidity ^0.4.17;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";


contract TokenSender is Ownable {
    address public token;

    event TransferFail(uint256 index, address receiver, uint256 amount);

    function TokenSender(address _token) public {
        token = _token;
    }

    function bulkTransfer(address[] receivers, uint256[] amounts) onlyOwner external {
        for (uint256 i = 0; i < receivers.length; i++) {
            if (!ERC20Basic(token).transfer(receivers[i], amounts[i])) {
                TransferFail(i, receivers[i], amounts[i]);
                return;
            }
        }
    }

    function withdraw() onlyOwner external {
        uint256 balance = ERC20Basic(token).balanceOf(this);
        ERC20Basic(token).transfer(owner, balance);
    }
}
