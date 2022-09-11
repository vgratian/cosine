MODULE cosine
    IMPLICIT NONE

    CONTAINS

    FUNCTION similarity(A, B)
        REAL*8 :: similarity
        REAL*8, DIMENSION(:), INTENT(IN) :: A, B

        similarity = SUM(A*B) / SQRT( SUM(A*A) * SUM(B*B) )

    END FUNCTION similarity

END MODULE cosine
