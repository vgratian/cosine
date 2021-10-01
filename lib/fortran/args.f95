MODULE args
    IMPLICIT NONE

    CONTAINS

    SUBROUTINE parse_or_exit(n, k, fp1, fp2)

        INTEGER, INTENT(OUT) :: n, k
        CHARACTER(LEN=25), INTENT(OUT) :: fp1, fp2
        CHARACTER(LEN=25) :: n_char, k_char

        IF (COMMAND_ARGUMENT_COUNT() /= 4) THEN
            WRITE (*,*) 'Usage: <repeat> <size> <file1> <file2>'
            CALL EXIT(1)
        END IF

        CALL GET_COMMAND_ARGUMENT(1, k_char)
        CALL GET_COMMAND_ARGUMENT(2, n_char)
        CALL GET_COMMAND_ARGUMENT(3, fp1)
        CALL GET_COMMAND_ARGUMENT(4, fp2)

        READ (k_char,*) k
        READ (n_char,*) n

    END SUBROUTINE parse_or_exit

END MODULE args
