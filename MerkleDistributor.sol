// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MerkleDistributor
 * @dev Distributes tokens to users based on a Merkle Tree proof.
 */
contract MerkleDistributor is Ownable {
    address public immutable token;
    bytes32 public immutable merkleRoot;

    // Mapping to track if an index has already been claimed
    mapping(uint256 => bool) private claimedBitMap;

    event Claimed(uint256 index, address account, uint256 amount);

    constructor(address _token, bytes32 _merkleRoot) Ownable(msg.sender) {
        token = _token;
        merkleRoot = _merkleRoot;
    }

    function isClaimed(uint256 index) public view returns (bool) {
        return claimedBitMap[index];
    }

    /**
     * @dev Claim tokens using a Merkle proof.
     * @param index The index in the Merkle tree.
     * @param account The address claiming the tokens.
     * @param amount The amount of tokens to claim.
     * @param merkleProof The cryptographic proof that the entry exists in the tree.
     */
    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {
        require(!isClaimed(index), "Airdrop already claimed.");

        // Verify the merkle proof
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), "Invalid proof.");

        // Mark it claimed and send tokens
        claimedBitMap[index] = true;
        require(IERC20(token).transfer(account, amount), "Transfer failed.");

        emit Claimed(index, account, amount);
    }

    /**
     * @dev Allows owner to withdraw remaining tokens after airdrop ends.
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner(), balance);
    }
}
