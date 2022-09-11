MODULE Cout;
IMPORT SYSTEM;

(* wrapper to use C printf
   thanks to @norayr for writing this *)

PROCEDURE -Astdio '#include <stdio.h>';

PROCEDURE -LongReals*(l1, l2: LONGREAL)
    'printf ("%.20f %.15f", l1, l2)';

END Cout.
