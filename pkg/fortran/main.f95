PROGRAM main
    USE cosine, ONLY: similarity
    USE vector, ONLY: load_vector
    USE args,   ONLY: parse_or_exit

    IMPLICIT NONE

    ! local variables:
    ! vector size, number of times to repeat, index
    INTEGER :: n, k, i
    ! vectors for which we will calculate the similarity
    REAL*8, DIMENSION(:), ALLOCATABLE :: vect1, vect2
    ! files holding the vectors
    CHARACTER(LEN=25) :: fp1, fp2
    ! similarity value
    REAL*8 :: sim
    ! variables to measure average time of calculation
    REAL :: start, finish, runtime, time

    CALL parse_or_exit(n, k, fp1, fp2)

    CALL load_vector(fp1, n, vect1)
    CALL load_vector(fp2, n, vect2)

    DO i=1, k
        CALL CPU_TIME(start)
        sim = similarity(vect1, vect2)
        CALL CPU_TIME(finish)
        time = finish - start
        runtime = runtime + time
        !WRITE (*,*) i,' - start=',start,'end=',finish,'   => time=',time,'    => runtime=',runtime
    END DO

    ! average runtime
    runtime = runtime / k

    WRITE (*, FMT='(f23.20)', ADVANCE='no') sim
    WRITE (*, FMT='(f18.15)', ADVANCE='no') runtime

END PROGRAM main
