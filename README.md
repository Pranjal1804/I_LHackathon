# Blockchain-Based Ticket Management System

A decentralized platform for managing train and flight ticket bookings using blockchain technology, ensuring transparency, immutability, and security. Built with Django for the backend and Solidity for smart contracts.

## Features

- **Decentralized Ticket Management**: Secure and transparent ticket booking using blockchain.
- **Smart Contracts**: Immutable and automated handling of transactions and ticket validation.
- **User-Friendly Interface**: Simplified booking and management with Django framework.
- **Security**: Tamper-proof system ensuring the integrity of bookings.
- **Scalability**: Designed to handle multiple users and transactions seamlessly.

## Technology Stack

- **Frontend**: HTML, CSS, JavaScript
- **Backend**: Django
- **Blockchain**: Ethereum, Solidity
- **Database**: SQL

## Setup and Installation

### Prerequisites

- Python 3.8 or higher
- Node.js and npm
- MetaMask Wallet
- Ganache (or any Ethereum test network)

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/blockchain-ticket-management.git
   cd blockchain-ticket-management
   ```

2. Install backend dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Install frontend dependencies:
   ```bash
   npm install
   ```

4. Compile the Solidity smart contracts:
   ```bash
   npx hardhat compile
   ```

5. Deploy the smart contracts:
   ```bash
   npx hardhat run scripts/deploy.js --network localhost
   ```

6. Configure Django settings with your database and blockchain details.

7. Run the Django development server:
   ```bash
   python manage.py runserver
   ```


## Usage

1. **Connect Wallet**: Open the application and connect your MetaMask wallet with a seamless animated flow.
2. **Book Tickets**: Navigate through the smooth booking interface with interactive animations for each step.
3. **Verify Transactions**: Watch a live progress bar as your ticket details are validated on the Ethereum blockchain.
4. **Manage Bookings**: Enjoy visually engaging card layouts for managing your tickets and viewing transaction history.

