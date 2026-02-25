# Merkle Airdrop Distributor

An expert-grade implementation of a Merkle-proof-based airdrop contract. This system is designed for high scalability, allowing a protocol to whitelist an unlimited number of recipients without paying high gas fees for on-chain storage.

## Overview
Instead of storing a mapping of all eligible addresses, this contract stores a **Merkle Root**. Users provide a **Merkle Proof** when claiming, which the contract verifies against the root to prove eligibility.

### Key Features
* **Massive Scalability:** Distribute tokens to millions of addresses with a single transaction.
* **Gas Efficiency:** Claims are inexpensive as they only involve a few cryptographic hashes.
* **Double-Claim Protection:** Uses a bitmask or mapping to ensure each eligible entry is claimed only once.
* **Security:** Built with OpenZeppelin's cryptographically secure `MerkleProof` library.

## Technical Stack
* **Language:** Solidity ^0.8.20
* **Library:** OpenZeppelin Cryptography
* **License:** MIT

## Getting Started
1. Generate a Merkle Tree off-chain (using JavaScript/Python) containing `(address, amount)`.
2. Deploy this contract with the resulting **Merkle Root**.
3. Users use the provided off-chain tool to generate their specific proof and call `claim()`.
