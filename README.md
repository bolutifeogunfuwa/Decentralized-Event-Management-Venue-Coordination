# Decentralized Event Management Venue Coordination

A comprehensive blockchain-based event management system built on the Stacks blockchain using Clarity smart contracts. This system provides decentralized coordination for event organizers, venues, vendors, attendees, and payments.

## 🏗️ System Architecture

The system consists of five interconnected smart contracts:

### 1. Event Organizer Verification Contract
- **Purpose**: Validates and manages event management companies
- **Key Features**:
    - Application process for event organizers
    - Multi-level verification system
    - Owner-controlled approval process
    - Verification status management

### 2. Venue Booking Contract
- **Purpose**: Manages event venue bookings and availability
- **Key Features**:
    - Venue registration by owners
    - Date-based availability tracking
    - Booking creation and management
    - Automatic conflict prevention

### 3. Vendor Coordination Contract
- **Purpose**: Coordinates event vendors and service contracts
- **Key Features**:
    - Vendor registration and profiles
    - Contract creation and management
    - Service agreement tracking
    - Vendor rating system

### 4. Attendee Management Contract
- **Purpose**: Manages event creation and attendee registration
- **Key Features**:
    - Event creation by verified organizers
    - Attendee registration system
    - Capacity management
    - Check-in functionality

### 5. Payment Processing Contract
- **Purpose**: Handles secure payment processing with escrow
- **Key Features**:
    - User balance management
    - Escrow-based payments
    - Multi-party payment authorization
    - Refund capabilities

## 🚀 Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js (for testing)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd decentralized-event-management
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## 📋 Contract Specifications

### Event Organizer Verification

**Main Functions:**
- \`apply-for-verification\`: Submit application for organizer verification
- \`verify-organizer\`: Approve organizer applications (owner only)
- \`revoke-verification\`: Revoke organizer verification (owner only)
- \`is-verified-organizer\`: Check if an organizer is verified

**Data Structures:**
- \`verified-organizers\`: Map of verified organizer details
- \`organizer-applications\`: Map of pending applications

### Venue Booking

**Main Functions:**
- \`register-venue\`: Register a new venue
- \`book-venue\`: Create a venue booking
- \`cancel-booking\`: Cancel an existing booking
- \`check-availability\`: Check venue availability for specific dates

**Data Structures:**
- \`venues\`: Map of registered venues
- \`bookings\`: Map of venue bookings
- \`venue-availability\`: Date-based availability tracking

### Vendor Coordination

**Main Functions:**
- \`register-vendor\`: Register as a service vendor
- \`create-vendor-contract\`: Create service contracts
- \`accept-contract\`: Accept service contracts (vendor)
- \`complete-contract\`: Mark contracts as completed
- \`rate-vendor\`: Rate vendor services

**Data Structures:**
- \`vendors\`: Map of registered vendors
- \`vendor-contracts\`: Map of service contracts
- \`vendor-ratings\`: Vendor rating system

### Attendee Management

**Main Functions:**
- \`create-event\`: Create new events (verified organizers only)
- \`register-for-event\`: Register as event attendee
- \`check-in-attendee\`: Check in attendees (organizers only)
- \`cancel-registration\`: Cancel event registration

**Data Structures:**
- \`events\`: Map of created events
- \`event-registrations\`: Map of attendee registrations
- \`event-attendee-count\`: Track event capacity

### Payment Processing

**Main Functions:**
- \`deposit-funds\`: Add funds to user balance
- \`create-payment\`: Create escrow-based payments
- \`process-payment\`: Complete payment transactions
- \`refund-payment\`: Process payment refunds
- \`withdraw-funds\`: Withdraw available funds

**Data Structures:**
- \`payments\`: Map of payment transactions
- \`user-balances\`: User account balances
- \`escrow-balances\`: Escrowed payment amounts

## 🔒 Security Features

### Access Control
- Owner-only functions for critical operations
- Organizer verification requirements
- Multi-party payment authorization

### Data Integrity
- Immutable transaction records
- Atomic operations for complex transactions
- Comprehensive error handling

### Financial Security
- Escrow-based payment system
- Balance verification before transactions
- Refund capabilities for dispute resolution

## 🧪 Testing

The project includes comprehensive test suites for all contracts:

- **Unit Tests**: Individual function testing
- **Integration Tests**: Cross-contract functionality
- **Edge Case Testing**: Error conditions and boundary cases

Run tests with:
\`\`\`bash
npm test
\`\`\`

## 📊 Usage Examples

### 1. Organizer Verification Flow
\`\`\`clarity
;; Apply for verification
(contract-call? .event-organizer-verification apply-for-verification "Event Masters LLC" "contact@eventmasters.com")

;; Owner approves (verification level 3)
(contract-call? .event-organizer-verification verify-organizer 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG u3)
\`\`\`

### 2. Venue Booking Flow
\`\`\`clarity
;; Register venue
(contract-call? .venue-booking register-venue "Grand Ballroom" "123 Main St" u500 u1000)

;; Book venue for 3 days
(contract-call? .venue-booking book-venue u1 u100 u103)
\`\`\`

### 3. Payment Processing Flow
\`\`\`clarity
;; Deposit funds
(contract-call? .payment-processing deposit-funds u5000)

;; Create payment
(contract-call? .payment-processing create-payment 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG u1000 "venue-booking" u1)

;; Process payment
(contract-call? .payment-processing process-payment u1)
\`\`\`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🔮 Future Enhancements

- Multi-signature wallet integration
- Advanced analytics and reporting
- Mobile application interface
- Integration with external payment systems
- Advanced dispute resolution mechanisms

