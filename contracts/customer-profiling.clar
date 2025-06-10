;; Customer Profiling Contract
;; Profiles customer beauty preferences

;; Data structure for customer profiles
(define-map customer-profiles
  { customer: principal }
  {
    skin-type: (string-ascii 20),
    skin-concerns: (list 5 (string-ascii 20)),
    hair-type: (string-ascii 20),
    preferred-ingredients: (list 10 (string-ascii 30)),
    avoided-ingredients: (list 10 (string-ascii 30)),
    last-updated: uint
  }
)

;; Create or update a customer profile
(define-public (set-profile
    (skin-type (string-ascii 20))
    (skin-concerns (list 5 (string-ascii 20)))
    (hair-type (string-ascii 20))
    (preferred-ingredients (list 10 (string-ascii 30)))
    (avoided-ingredients (list 10 (string-ascii 30))))
  (begin
    (map-set customer-profiles
      { customer: tx-sender }
      {
        skin-type: skin-type,
        skin-concerns: skin-concerns,
        hair-type: hair-type,
        preferred-ingredients: preferred-ingredients,
        avoided-ingredients: avoided-ingredients,
        last-updated: block-height
      }
    )
    (ok true)
  )
)

;; Get a customer profile
(define-read-only (get-profile (customer principal))
  (map-get? customer-profiles { customer: customer })
)

;; Check if a customer has a profile
(define-read-only (has-profile (customer principal))
  (is-some (map-get? customer-profiles { customer: customer }))
)

;; Get customer's skin type
(define-read-only (get-skin-type (customer principal))
  (default-to "" (get skin-type (map-get? customer-profiles { customer: customer })))
)

;; Get customer's preferred ingredients
(define-read-only (get-preferred-ingredients (customer principal))
  (default-to (list) (get preferred-ingredients (map-get? customer-profiles { customer: customer })))
)

;; Get customer's avoided ingredients
(define-read-only (get-avoided-ingredients (customer principal))
  (default-to (list) (get avoided-ingredients (map-get? customer-profiles { customer: customer })))
)
