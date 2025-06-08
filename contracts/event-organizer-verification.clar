;; Event Organizer Verification Contract
;; Manages verification of event management companies

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-verified (err u102))
(define-constant err-not-found (err u103))

;; Data structures
(define-map verified-organizers principal
  {
    company-name: (string-ascii 100),
    registration-date: uint,
    verification-level: uint,
    is-active: bool
  })

(define-map organizer-applications principal
  {
    company-name: (string-ascii 100),
    contact-info: (string-ascii 200),
    application-date: uint,
    status: (string-ascii 20)
  })

(define-data-var total-verified uint u0)

;; Public functions
(define-public (apply-for-verification (company-name (string-ascii 100)) (contact-info (string-ascii 200)))
  (let ((applicant tx-sender))
    (map-set organizer-applications applicant
      {
        company-name: company-name,
        contact-info: contact-info,
        application-date: block-height,
        status: "pending"
      })
    (ok true)))

(define-public (verify-organizer (organizer principal) (verification-level uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (is-none (map-get? verified-organizers organizer)) err-already-verified)
    (let ((application (unwrap! (map-get? organizer-applications organizer) err-not-found)))
      (map-set verified-organizers organizer
        {
          company-name: (get company-name application),
          registration-date: block-height,
          verification-level: verification-level,
          is-active: true
        })
      (map-set organizer-applications organizer
        (merge application { status: "approved" }))
      (var-set total-verified (+ (var-get total-verified) u1))
      (ok true))))

(define-public (revoke-verification (organizer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let ((organizer-data (unwrap! (map-get? verified-organizers organizer) err-not-found)))
      (map-set verified-organizers organizer
        (merge organizer-data { is-active: false }))
      (ok true))))

;; Read-only functions
(define-read-only (is-verified-organizer (organizer principal))
  (match (map-get? verified-organizers organizer)
    organizer-data (get is-active organizer-data)
    false))

(define-read-only (get-organizer-info (organizer principal))
  (map-get? verified-organizers organizer))

(define-read-only (get-total-verified)
  (var-get total-verified))
