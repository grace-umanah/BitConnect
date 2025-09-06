# BitConnect Pro - Enterprise Social Networking Protocol

[![Stacks](https://img.shields.io/badge/Built_with-Stacks-5546FF?style=flat-square&logo=stacks&logoColor=white)](https://stacks.co)
[![Clarity](https://img.shields.io/badge/Language-Clarity-orange?style=flat-square)](https://clarity-lang.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Vitest-729B1B?style=flat-square)](https://vitest.dev)

> Next-generation Bitcoin-native social infrastructure leveraging Stacks Layer 2 for enterprise-grade privacy, scalability, and security.

## 🚀 Overview

BitConnect Pro is a revolutionary decentralized social networking protocol that combines Bitcoin's unmatched security with Stacks' smart contract capabilities. Designed for institutions and privacy-conscious users who demand the highest levels of data sovereignty and censorship resistance.

### Key Features

- **🔐 Zero-Knowledge Privacy Architecture**: Selective disclosure mechanisms with end-to-end encryption
- **⚡ Adaptive Rate Limiting**: Dynamic rate limiting that adapts to user behavior patterns
- **📦 Intelligent Batch Processing**: Optimized L2 throughput with automatic batch size adjustment
- **🛡️ Bitcoin-Anchored Security**: Tamper-evident social graphs anchored to Bitcoin's proof-of-work
- **🔑 User-Controlled Encryption**: Enterprise-grade encryption with user-managed keys
- **👥 Granular Relationship Management**: Sophisticated friendship and blocking mechanics

## 🏗️ Architecture

### Core Components

#### Data Structures

1. **Users Map**: Primary user registry with enhanced metadata support
2. **UserPrivacy Map**: Granular privacy control matrix
3. **RateLimits Map**: Dynamic rate limiting engine
4. **UserBatches Map**: Intelligent batch processing manager
5. **UserActivity Map**: Comprehensive activity tracking
6. **Friendships Map**: Bidirectional friendship management
7. **BlockedUsers Map**: Advanced blocking & moderation system

#### Security Features

- **Adaptive Rate Limiting**: Automatically resets every 24 hours with configurable thresholds
- **Privacy Controls**: Fine-grained visibility settings for all user data
- **Encryption Support**: Optional end-to-end encryption with 32-byte keys
- **Activity Monitoring**: Real-time tracking of user actions and login sessions

## 📖 API Reference

### Public Functions

#### User Management

##### `update-user-profile`

Updates user profile information with optional encryption.

```clarity
(update-user-profile 
  (name (optional (string-ascii 64)))
  (metadata (optional (string-utf8 256))) 
  (encryption-key (optional (buff 32)))
  (profile-image (optional (string-utf8 256))))
```

**Parameters:**

- `name`: Optional display name (up to 64 ASCII characters)
- `metadata`: Optional profile metadata (up to 256 UTF-8 characters)
- `encryption-key`: Optional 32-byte encryption key
- `profile-image`: Optional profile image URL/hash

**Returns:** `(response bool uint)`

##### `record-login`

Records secure login activity and updates session tracking.

```clarity
(record-login)
```

**Returns:** `(response bool uint)`

#### Privacy Management

##### `update-advanced-privacy-settings`

Configures granular privacy controls for user data visibility.

```clarity
(update-advanced-privacy-settings
  (friend-list-visible bool)
  (status-visible bool)
  (metadata-visible bool)
  (last-seen-visible bool)
  (profile-image-visible bool)
  (encryption-enabled bool))
```

**Parameters:**

- `friend-list-visible`: Controls friend list visibility
- `status-visible`: Controls status visibility
- `metadata-visible`: Controls metadata visibility
- `last-seen-visible`: Controls last seen timestamp visibility
- `profile-image-visible`: Controls profile image visibility
- `encryption-enabled`: Enables/disables encryption for user data

**Returns:** `(response bool uint)`

#### Batch Processing

##### `optimize-batch-size`

Automatically optimizes batch size based on usage patterns.

```clarity
(optimize-batch-size (user principal))
```

**Parameters:**

- `user`: Target user's principal address

**Returns:** `(response bool uint)`

##### `set-batch-size`

Manually configures batch processing size for optimal performance.

```clarity
(set-batch-size (new-size uint))
```

**Parameters:**

- `new-size`: New batch size (must be between 10-100)

**Returns:** `(response bool uint)`

### Constants

#### System Configuration

```clarity
;; Rate Limiting Parameters
MAX_ACTIONS_PER_DAY: 100
MAX_FRIEND_REQUESTS_PER_DAY: 20
MAX_STATUS_UPDATES_PER_DAY: 24
RATE_LIMIT_RESET_PERIOD: 86400 ;; 24 hours

;; Batch Processing Configuration
MIN_BATCH_SIZE: 10
MAX_BATCH_SIZE: 100
BATCH_EXPIRY_PERIOD: 3600 ;; 1 hour
```

#### User Status Codes

```clarity
STATUS_DEACTIVATED: 0
STATUS_ACTIVE: 1
STATUS_SUSPENDED: 2
```

#### Error Codes

```clarity
ERR_NOT_FOUND: 100
ERR_ALREADY_EXISTS: 101
ERR_UNAUTHORIZED: 102
ERR_INVALID_INPUT: 103
ERR_BLOCKED: 104
ERR_DEACTIVATED: 105
ERR_RATE_LIMITED: 106
ERR_BATCH_FULL: 107
ERR_BATCH_EXPIRED: 108
```

## 🛠️ Development Setup

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) >= 2.0.0
- [Node.js](https://nodejs.org/) >= 18.0.0
- [npm](https://www.npmjs.com/) >= 8.0.0

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/grace-umanah/BitConnect.git
   cd BitConnect
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Check contract syntax:**

   ```bash
   clarinet check
   ```

### Testing

Run the comprehensive test suite:

```bash
# Run all tests
npm test

# Run tests with coverage and cost reports
npm run test:report

# Watch mode for development
npm run test:watch
```

### Contract Validation

```bash
# Syntax check
clarinet check

# Contract analysis
clarinet analyze

# Format code
clarinet fmt --fix
```

## 🔧 Configuration

### Network Settings

The contract supports multiple network configurations:

- **Devnet**: Local development environment
- **Testnet**: Stacks testnet deployment
- **Mainnet**: Production deployment

Configuration files are located in the `settings/` directory.

### Environment Variables

```toml
[network]
name = "devnet"
deployment_fee_rate = 10

[accounts.deployer]
# Configuration for deployer account
balance = 100_000_000_000_000
sbtc_balance = 1_000_000_000
```

## 🚀 Deployment

### Local Deployment (Devnet)

```bash
# Start local devnet
clarinet devnet start

# Deploy contracts
clarinet deploy --devnet
```

### Testnet Deployment

```bash
# Deploy to testnet
clarinet deploy --testnet
```

### Mainnet Deployment

```bash
# Deploy to mainnet (requires mainnet configuration)
clarinet deploy --mainnet
```

## 📊 Performance & Scalability

### Batch Processing Optimization

The intelligent batch processing system automatically adjusts batch sizes based on usage patterns:

- **Minimum batch size**: 10 items
- **Maximum batch size**: 100 items
- **Automatic optimization**: Based on user activity patterns
- **Batch expiry**: 1 hour timeout with automatic reset

### Rate Limiting

Dynamic rate limiting prevents abuse while maintaining user experience:

- **Daily actions**: 100 per user
- **Friend requests**: 20 per day
- **Status updates**: 24 per day
- **Automatic reset**: Every 24 hours

## 🔒 Security Considerations

### Privacy Protection

- All user data visibility is controlled by granular privacy settings
- Optional end-to-end encryption with user-controlled keys
- Selective disclosure mechanisms for data sharing

### Rate Limiting & Security

- Adaptive rate limiting prevents spam and abuse
- Automatic reset mechanisms ensure fair usage
- Configurable thresholds for different action types

### Access Control

- Function-level access control with user status validation
- Comprehensive blocking and moderation system
- Activity monitoring and audit trails

## 🤝 Contributing

We welcome contributions to BitConnect Pro! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

### Code Standards

- Follow Clarity best practices
- Maintain comprehensive test coverage
- Document all public functions
- Use consistent naming conventions

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Stacks Documentation**: [https://docs.stacks.co](https://docs.stacks.co)
- **Clarity Language**: [https://clarity-lang.org](https://clarity-lang.org)
- **Clarinet SDK**: [https://github.com/hirosystems/clarinet](https://github.com/hirosystems/clarinet)
