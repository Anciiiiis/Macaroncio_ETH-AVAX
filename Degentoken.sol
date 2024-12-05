// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    uint public ancisItemValue = 2; // Cost to redeem an ANCIS item
    mapping(address => string[]) ancisItems; // List of ANCIS items owned by an address
    mapping(address => uint) ownedItems; // Number of ANCIS items owned by an address

    constructor(address initialOwner) ERC20("DegenANCIS", "ANCIS") Ownable(initialOwner) {}

    // Mint tokens to a specified address
    function mintToken(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Get the balance of the caller
    function getBalance() external view returns (uint256) {
        return this.balanceOf(msg.sender);
    }

    // Transfer tokens to another address
    function transferToken(address _to, uint256 _amount) external {
        require(balanceOf(msg.sender) >= _amount, "Not enough tokens to transfer.");
        approve(msg.sender, _amount);
        transferFrom(msg.sender, _to, _amount);
    }

    // Burn tokens from the caller's balance
    function burnToken(uint _amount) public {
        require(balanceOf(msg.sender) >= _amount, "Not enough tokens to burn.");
        _burn(msg.sender, _amount);
    }

    // Redeem tokens for an ANCIS item
    function redeemANCISItem(string memory _ancsItemName) public {
        require(balanceOf(msg.sender) >= ancisItemValue, "Redeem failed: Not enough tokens.");

        _burn(msg.sender, ancisItemValue);
        ancisItems[msg.sender].push(_ancsItemName);
        ownedItems[msg.sender]++;
    }

    // Get the list of ANCIS items owned by the caller
    function getANCISItems() public view returns (string[] memory) {
        return ancisItems[msg.sender];
    }

    // Get the number of ANCIS items owned by the caller
    function getANCISItemCount() public view returns (uint) {
        return ownedItems[msg.sender];
    }
}
