pragma solidity ^0.4.17;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";


contract Referral is Ownable {
    address public  JOY = 0xDDe12a12A6f67156e0DA672be05c374e1B0a3e57;

    event TransferFail(address _address, uint256 _reward);

    function Referral(address _joy) public {
        JOY = _joy;
    }

    function giveaway(address[] addresses, uint256[] rewards) onlyOwner external {
        for (uint256 i = 0; i < addresses.length; i++) {
            if (!ERC20Basic(JOY).transfer(addresses[i], rewards[i])) {
                TransferFail(addresses[i], rewards[i]);
            }
        }
    }

    function withdraw() onlyOwner external {
        uint256 balance = ERC20Basic(JOY).balanceOf(this);
        ERC20Basic(JOY).transfer(owner, balance);
    }
    
}
