;; Access Control Contract

;; Constants
(define-constant contract-owner tx-sender)

;; Maps
(define-map authorized-doctors
  principal
  {
    active: bool,
    patients: (list 200 principal)
  }
)

;; Public functions
(define-public (register-doctor (doctor principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ok (map-set authorized-doctors doctor
      {
        active: true,
        patients: (list)
      }
    ))
  )
)

(define-public (add-patient (doctor principal) (patient principal))
  (let
    ((current-data (unwrap! (map-get? authorized-doctors doctor) (err u404))))
    (ok (map-set authorized-doctors doctor
      (merge current-data
        {
          patients: (unwrap! (as-max-len? (append (get patients current-data) patient) u200) (err u500))
        }
      )
    ))
  )
)
