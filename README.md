# Solana Air-Gapped Debian Workflow with QR Code Authentication 🔐🔗

![Example Image](example.png)

This screenshot captures the signing process: The air-gapped machine has already received the transaction data, created the cryptographic signature, and generated a QR code. This QR code is about to be scanned by the online machine, which will immediately broadcast the signed transaction to the network.

This project presents a secure, Bash-based operational framework for managing Solana digital assets and staking operations through a dual-machine architecture. Private cryptographic keys remain exclusively within the offline environment, with inter-machine communication facilitated entirely through QR code transmission. ✨

## 🔐 Security Architecture

The system operates on the fundamental principle of **Physical Air-Gap Isolation**:

1. **Online Workstation**: Responsible for transaction preparation, nonce retrieval, and broadcasting of signed transaction data to the Solana network.
2. **Air-Gapped Workstation (Offline)**: Maintains custody of private cryptographic keys and performs transaction signing operations in an isolated environment.
3. **QR-Bridge Protocol**: Data transmission occurs exclusively through visual encoding using `qrencode` and `zbar-tools`, thereby eliminating any potential for digital network exposure. *(Note: When scripts are invoked with the `--debug` flag, data may alternatively be entered manually as plaintext strings for diagnostic purposes.)*

## 🛠 System Requirements & Compatibility

Developed and validated on **Debian Trixie** and **Debian Forky** distributions.

### ✅ Requirements for Both Machines
- **Solana CLI Tools** — Installation instructions available at the [Official Solana CLI Documentation](https://docs.solana.com/cli/install-solana-cli-tools)
- **QR Code Processing Libraries** — `zbar-tools`, `qrencode`, `bc` (available through standard package repositories)

### 🌐 Additional Requirements for Online Workstation
- Active internet connectivity to a Solana RPC endpoint (Mainnet or Devnet)
- **Critical**: The `~/.config/solana/id.json` wallet must contain a minimal SOL balance sufficient to cover account creation rent-exemption requirements

---

## 📂 System Architecture & File Organization

| Script Name | Execution Environment | Functional Description |
| --- | --- | --- |
| `AIRGAP_1_KEYPAIRS_INIT.sh` | Offline | Generates cryptographic keypairs and displays public key via QR code |
| `ONLINE_1_KEYPAIRS_INIT.sh` | Online | Provisions on-chain nonce accounts for durable transaction signing |
| `ONLINE_2_TRANSACTIONS.sh` | Online | Transaction construction interface for SOL and SPL token operations |
| `AIRGAP_2_TRANSACTIONS_SIGN.sh` | Offline | Cryptographic signing module for SOL and SPL token transactions |
| `ONLINE_3_STAKE_INIT.sh` | Online | Initializes and funds stake account structures on-chain |
| `ONLINE_4_STAKE.sh` | Online | Comprehensive staking management interface (delegation, deactivation, withdrawal, consolidation) |
| `AIRGAP_3_STAKE_SIGN.sh` | Offline | Core signing logic for staking-related operations |

---

## 📁 The `./solana/` Directory

Both machines maintain a `./solana/` directory for keypairs and metadata, created automatically by initialization scripts.

### 🧊 Air-Gapped Machine
- **Keypair files**: `PUBKEY.json` format
  - Example: `7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU.json`
- **addresses.json**: Tracks vote accounts and stake accounts associated with each keypair

### 🌍 Online Machine
- **Nonce account files**: `PUBKEY-nonce-NETWORK.json`
  - Example: `7xKXtg2CW87d97TXJSDpbD5jBkheTqA83TZRuJosgAsU-nonce-devnet.json`
- **Stake account files**: `PUBKEY-stake-NETWORK.json`
  - Example: `2t39hwDJfRP1atSX6oSuFV4cQwcdAa52fhKssGRWGHFE-stake-devnet.json`
- **addresses.json**: Tracks vote accounts and stake accounts associated with each keypair

### 🧾 Filename Syntax
- Air-Gapped keypairs: `PUBKEY.json`
- Online nonce accounts: `PUBKEY-nonce-NETWORK.json`
- Online stake accounts: `PUBKEY-stake-NETWORK.json`
