MODULE vector

    IMPLICIT NONE

    CONTAINS

    SUBROUTINE load_vector(fp, n, v)
        ! filepath, where to load the vector from
        CHARACTER(LEN=15), INTENT(IN) :: fp
        ! expected size of the vector
        INTEGER, INTENT(IN) :: n
        ! array to hold the vector
        REAL*8, DIMENSION(:), ALLOCATABLE, INTENT(INOUT) :: v
        ! index
        INTEGER :: i

        ALLOCATE(v(n))

        OPEN(10, FILE=fp)

        DO i=1,n
            READ(10,*) v(i)
        END DO

        CLOSE(10)

    END SUBROUTINE load_vector

END MODULE vector
