;; Brand Verification Contract
;; Validates beauty product brands on the blockchain

(define-data-var admin principal tx-sender)

;; Data structure for brands
(define-map brands
  { brand-id: uint }
  {
    name: (string-ascii 50),
    verified: bool,
    website: (string-ascii 100),
    registration-date: uint
  }
)

;; Counter for brand IDs
(define-data-var next-brand-id uint u1)

;; Register a new brand
(define-public (register-brand (name (string-ascii 50)) (website (string-ascii 100)))
  (let
    (
      (brand-id (var-get next-brand-id))
    )
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (map-insert brands
      { brand-id: brand-id }
      {
        name: name,
        verified: false,
        website: website,
        registration-date: block-height
      }
    )
    (var-set next-brand-id (+ brand-id u1))
    (ok brand-id)
  )
)

;; Verify a brand
(define-public (verify-brand (brand-id uint))
  (let
    (
      (brand (unwrap! (map-get? brands { brand-id: brand-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (map-set brands
      { brand-id: brand-id }
      (merge brand { verified: true })
    )
    (ok true)
  )
)

;; Check if a brand is verified
(define-read-only (is-brand-verified (brand-id uint))
  (default-to false (get verified (map-get? brands { brand-id: brand-id })))
)

;; Get brand details
(define-read-only (get-brand (brand-id uint))
  (map-get? brands { brand-id: brand-id })
)

;; Set a new admin
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (var-set admin new-admin)
    (ok true)
  )
)
