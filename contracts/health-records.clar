;; Health Records Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-data (err u101))

;; Data structures
(define-map health-records
  principal
  {
    heart-rate: uint,
    blood-pressure: uint,
    temperature: uint,
    timestamp: uint,
    last-update: uint
  }
)

;; Public functions
(define-public (add-health-data (heart-rate uint) (blood-pressure uint) (temperature uint))
  (let
    (
      (timestamp (unwrap! (get-block-info? time (- block-height u1)) err-invalid-data))
    )
    (ok (map-set health-records tx-sender
      {
        heart-rate: heart-rate,
        blood-pressure: blood-pressure,
        temperature: temperature,
        timestamp: timestamp,
        last-update: block-height
      }
    ))
  )
)

;; Read-only functions
(define-read-only (get-health-data (patient principal))
  (ok (map-get? health-records patient))
)
