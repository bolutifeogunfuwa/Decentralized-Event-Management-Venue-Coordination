;; Attendee Management Contract
;; Manages event attendees

(define-constant err-not-authorized (err u400))
(define-constant err-event-not-found (err u401))
(define-constant err-already-registered (err u402))
(define-constant err-event-full (err u403))
(define-constant err-registration-closed (err u404))

;; Data structures
(define-map events uint
  {
    organizer: principal,
    name: (string-ascii 100),
    description: (string-ascii 500),
    venue-id: uint,
    start-date: uint,
    end-date: uint,
    max-attendees: uint,
    ticket-price: uint,
    registration-deadline: uint,
    is-active: bool
  })

(define-map event-registrations (tuple (event-id uint) (attendee principal))
  {
    registration-date: uint,
    ticket-type: (string-ascii 50),
    payment-status: (string-ascii 20),
    check-in-status: bool
  })

(define-map event-attendee-count uint uint)

(define-data-var next-event-id uint u1)

;; Public functions
(define-public (create-event (name (string-ascii 100)) (description (string-ascii 500)) (venue-id uint) (start-date uint) (end-date uint) (max-attendees uint) (ticket-price uint) (registration-deadline uint))
  (let ((event-id (var-get next-event-id)))
    (map-set events event-id
      {
        organizer: tx-sender,
        name: name,
        description: description,
        venue-id: venue-id,
        start-date: start-date,
        end-date: end-date,
        max-attendees: max-attendees,
        ticket-price: ticket-price,
        registration-deadline: registration-deadline,
        is-active: true
      })
    (map-set event-attendee-count event-id u0)
    (var-set next-event-id (+ event-id u1))
    (ok event-id)))

(define-public (register-for-event (event-id uint) (ticket-type (string-ascii 50)))
  (let ((event (unwrap! (map-get? events event-id) err-event-not-found))
        (current-count (default-to u0 (map-get? event-attendee-count event-id))))
    (asserts! (is-none (map-get? event-registrations (tuple (event-id event-id) (attendee tx-sender)))) err-already-registered)
    (asserts! (< current-count (get max-attendees event)) err-event-full)
    (asserts! (<= block-height (get registration-deadline event)) err-registration-closed)

    (map-set event-registrations (tuple (event-id event-id) (attendee tx-sender))
      {
        registration-date: block-height,
        ticket-type: ticket-type,
        payment-status: "pending",
        check-in-status: false
      })
    (map-set event-attendee-count event-id (+ current-count u1))
    (ok true)))

(define-public (check-in-attendee (event-id uint) (attendee principal))
  (let ((event (unwrap! (map-get? events event-id) err-event-not-found))
        (registration (unwrap! (map-get? event-registrations (tuple (event-id event-id) (attendee attendee))) err-not-authorized)))
    (asserts! (is-eq tx-sender (get organizer event)) err-not-authorized)
    (map-set event-registrations (tuple (event-id event-id) (attendee attendee))
      (merge registration { check-in-status: true }))
    (ok true)))

(define-public (cancel-registration (event-id uint))
  (let ((registration (unwrap! (map-get? event-registrations (tuple (event-id event-id) (attendee tx-sender))) err-not-authorized))
        (current-count (default-to u0 (map-get? event-attendee-count event-id))))
    (map-delete event-registrations (tuple (event-id event-id) (attendee tx-sender)))
    (map-set event-attendee-count event-id (- current-count u1))
    (ok true)))

;; Read-only functions
(define-read-only (get-event (event-id uint))
  (map-get? events event-id))

(define-read-only (get-registration (event-id uint) (attendee principal))
  (map-get? event-registrations (tuple (event-id event-id) (attendee attendee))))

(define-read-only (get-attendee-count (event-id uint))
  (default-to u0 (map-get? event-attendee-count event-id)))

(define-read-only (is-registered (event-id uint) (attendee principal))
  (is-some (map-get? event-registrations (tuple (event-id event-id) (attendee attendee)))))
