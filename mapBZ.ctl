;; Program to define and run square lattice and circular hole structure

;; First define parameters. Some of them will be changed and some of them will be fixed

;; Geometry parameters

(define-param a 350)	;lattice constant
(define-param thnm 200)	;thickness
(define-param Rnm 140)	;radius
(define-param res 50)	;resolution
(define-param nbands 2)	;number of bands to calculate

;; Constants

(define-param eps 4)	;dielectric epsilon
(define-param myvacuum 1)	;vacuum
(define-param kpts 11)	;number of points (+2) where we should calculate the band structure
(define-param c (* 299792458 1e9))	;speed of ligh in nm/s
(define-param supercell-x 1); the number of supercell periods in x
(define-param supercell-y 1); the number of supercell periods in y
(define-param supercell-z 10) ; the number of supercell periods in z

;; Scaled quantities

(define-param th (/ thnm a))	;scaled thickness
(define-param R (/ Rnm a))	;scaled radius
(define-param wX 1)	; lattice constant along X
(define-param wY 1)	; lattice constant along Y


;; Set lattice - superbox
(set! geometry-lattice 	;set lattice size
 (make lattice
  (size supercell-x supercell-y supercell-z)))

;; Set geometry  
(set! geometry
 (append 
  (list 
   (make block (material (make dielectric (epsilon eps))) (center 0 0 0) (size wX wY th))
   (make cylinder (material (make dielectric (epsilon myvacuum))) (center 0 0 0) (radius R) (height th)))))
   
(set! output-epsilon (lambda () (print "skipping output-epsilon\n")))

;; Band structure points
(define G (vector3 0.0 0 0))	; Gamma point
(define X (vector3 0.5 0 0))	; X point
(define Y (vector3 0 0.5 0))	; Y point
(define M (vector3 0.5 0.5 0))	; M points

(define-param x1 0)	;lattice constant
(define-param x2 0.5)	;lattice constant

(define X1 (vector3 x1 x2 0))	; X1 for starting scan

(set! k-points (list X1))

(set! num-bands nbands)
(set-param! resolution res)

;; RUN
(run-zeven); (output-at-kpoint X fix-efield-phase output-efield output-epsilon))


;; Output frequncies
(define band1 1)
(define band2 2)

(define lowb (list-ref freqs (- band1 1)))
(define flowb (* (/ c a) lowb))	;lower band frequency
(define highb (list-ref freqs (- band2 1)))
(define fhighb (* (/ c a) highb))	;higher band frequency

(display "lower band: ")
(display flowb)
(display "higher band: ")
(display fhighb)

