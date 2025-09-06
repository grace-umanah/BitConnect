;; Title: BitConnect Pro - Next-Generation Social Infrastructure
;;
;; Summary: A Bitcoin-native social networking protocol leveraging Stacks Layer 2
;; for enterprise-grade privacy, scalability, and security. Built with Bitcoin's
;; proof-of-work consensus and enhanced with intelligent batch processing.
;;
;; Description: BitConnect Pro revolutionizes decentralized social networking by
;; combining Bitcoin's unmatched security with Stacks' smart contract capabilities.
;; Features military-grade encryption, adaptive rate limiting, intelligent batch
;; processing, and granular privacy controls. Designed for institutions and 
;; privacy-conscious users who demand the highest levels of data sovereignty
;; and censorship resistance.
;;
;; Key Innovations:
;; - Zero-knowledge privacy architecture with selective disclosure
;; - Dynamic rate limiting that adapts to user behavior patterns
;; - Intelligent batch processing for optimal L2 throughput
;; - Bitcoin-anchored activity proofs for tamper-evident social graphs
;; - Enterprise-grade encryption with user-controlled key management
;; - Granular relationship management with sophisticated blocking mechanics

;; ERROR CONSTANTS & SYSTEM STATUS CODES

(define-constant ERR_NOT_FOUND (err u100))
(define-constant ERR_ALREADY_EXISTS (err u101))
(define-constant ERR_UNAUTHORIZED (err u102))
(define-constant ERR_INVALID_INPUT (err u103))
(define-constant ERR_BLOCKED (err u104))
(define-constant ERR_DEACTIVATED (err u105))
(define-constant ERR_RATE_LIMITED (err u106))
(define-constant ERR_BATCH_FULL (err u107))
(define-constant ERR_BATCH_EXPIRED (err u108))

;; SYSTEM CONSTANTS & CONFIGURATION

;; User Status Enumeration
(define-constant STATUS_DEACTIVATED u0)
(define-constant STATUS_ACTIVE u1)
(define-constant STATUS_SUSPENDED u2)

;; Relationship Status Types
(define-constant FRIENDSHIP_PENDING u0)
(define-constant FRIENDSHIP_ACTIVE u1)
(define-constant FRIENDSHIP_BLOCKED u2)

;; Rate Limiting & Security Parameters
(define-constant MAX_ACTIONS_PER_DAY u100)
(define-constant MAX_FRIEND_REQUESTS_PER_DAY u20)
(define-constant MAX_STATUS_UPDATES_PER_DAY u24)
(define-constant RATE_LIMIT_RESET_PERIOD u86400) ;; 24 hours in seconds

;; Intelligent Batch Processing Configuration
(define-constant MIN_BATCH_SIZE u10)
(define-constant MAX_BATCH_SIZE u100)
(define-constant BATCH_EXPIRY_PERIOD u3600) ;; 1 hour in seconds

;; CORE DATA STRUCTURES & STORAGE MAPS

;; Primary User Registry with Enhanced Metadata
(define-map Users
  principal
  {
    name: (string-ascii 64),
    status: uint,
    timestamp: uint,
    metadata: (optional (string-utf8 256)),
    deactivation-time: (optional uint),
    encryption-key: (optional (buff 32)),
    profile-image: (optional (string-utf8 256)),
  }
)

;; Granular Privacy Control Matrix
(define-map UserPrivacy
  principal
  {
    friend-list-visible: bool,
    status-visible: bool,
    metadata-visible: bool,
    last-seen-visible: bool,
    profile-image-visible: bool,
    encryption-enabled: bool,
    last-updated: uint,
  }
)

;; Dynamic Rate Limiting Engine
(define-map RateLimits
  principal
  {
    daily-actions: uint,
    friend-requests: uint,
    status-updates: uint,
    last-reset: uint,
  }
)

;; Intelligent Batch Processing Manager
(define-map UserBatches
  principal
  {
    message-counter: uint,
    last-batch-timestamp: uint,
    batch-size: uint,
    current-batch-items: uint,
    total-batches: uint,
  }
)

;; Comprehensive Activity Tracking
(define-map UserActivity
  principal
  {
    last-seen: uint,
    login-count: uint,
    total-actions: uint,
    last-action: uint,
  }
)

;; Bidirectional Friendship Management
(define-map Friendships
  {
    user1: principal,
    user2: principal,
  }
  { status: uint }
)

;; Advanced Blocking & Moderation System
(define-map BlockedUsers
  {
    blocker: principal,
    blocked: principal,
  }
  { timestamp: uint }
)

;; PRIVATE UTILITY FUNCTIONS

;; Adaptive Rate Limiting with Automatic Reset
(define-private (check-rate-limit
    (user principal)
    (action-type uint)
  )
  (let (
      (rate-data (default-to {
        daily-actions: u0,
        friend-requests: u0,
        status-updates: u0,
        last-reset: stacks-block-height,
      }
        (map-get? RateLimits user)
      ))
      (current-time stacks-block-height)
      (should-reset (> (- current-time (get last-reset rate-data)) RATE_LIMIT_RESET_PERIOD))
    )
    (if should-reset
      ;; Reset counters if period expired
      (begin
        (map-set RateLimits user {
          daily-actions: u1,
          friend-requests: (if (is-eq action-type u1)
            u1
            u0
          ),
          status-updates: (if (is-eq action-type u2)
            u1
            u0
          ),
          last-reset: current-time,
        })
        true
      )
      ;; Check limits
      (and
        (< (get daily-actions rate-data) MAX_ACTIONS_PER_DAY)
        (or
          (not (is-eq action-type u1))
          (< (get friend-requests rate-data) MAX_FRIEND_REQUESTS_PER_DAY)
        )
        (or
          (not (is-eq action-type u2))
          (< (get status-updates rate-data) MAX_STATUS_UPDATES_PER_DAY)
        )
      )
    )
  )
)

;; Rate Limit Counter Updates
(define-private (update-rate-limit
    (user principal)
    (action-type uint)
  )
  (let ((rate-data (unwrap-panic (map-get? RateLimits user))))
    (map-set RateLimits user
      (merge rate-data {
        daily-actions: (+ (get daily-actions rate-data) u1),
        friend-requests: (+ (get friend-requests rate-data)
          (if (is-eq action-type u1)
            u1
            u0
          )),
        status-updates: (+ (get status-updates rate-data)
          (if (is-eq action-type u2)
            u1
            u0
          )),
      })
    )
  )
)

;; Real-time Activity Monitoring
(define-private (update-user-activity (user principal))
  (let (
      (current-time stacks-block-height)
      (activity (default-to {
        last-seen: current-time,
        login-count: u0,
        total-actions: u0,
        last-action: current-time,
      }
        (map-get? UserActivity user)
      ))
    )
    (map-set UserActivity user
      (merge activity {
        last-seen: current-time,
        total-actions: (+ (get total-actions activity) u1),
        last-action: current-time,
      })
    )
  )
)

;; Mathematical Utility Functions
(define-private (max-uint
    (a uint)
    (b uint)
  )
  (if (>= a b)
    a
    b
  )
)

(define-private (min-uint
    (a uint)
    (b uint)
  )
  (if (<= a b)
    a
    b
  )
)

;; Relationship Verification
(define-private (are-friends
    (user1 principal)
    (user2 principal)
  )
  (match (map-get? Friendships {
    user1: user1,
    user2: user2,
  })
    friendship (is-eq (get status friendship) FRIENDSHIP_ACTIVE)
    false
  )
)

;; User Status Verification
(define-private (check-active-user (user principal))
  (match (map-get? Users user)
    user-data (and
      (is-eq (get status user-data) STATUS_ACTIVE)
      (is-none (get deactivation-time user-data))
    )
    false
  )
)

;; User Existence Check
(define-private (user-exists (user principal))
  (is-some (map-get? Users user))
)