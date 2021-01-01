MODULE Vector;
IMPORT Files, Strings;
TYPE
    Vector* = POINTER TO ARRAY OF REAL;

PROCEDURE Init*(size: LONGINT; VAR vect: Vector);
    BEGIN
        NEW(vect, size);
    END Init;

PROCEDURE FromFile*(filename: ARRAY OF CHAR; size: LONGINT; VAR vect: Vector): INTEGER;
    (* Read file line by line, convert each line to float
       and populate vector. Return 0 on success, -1 otherwise. *)
    VAR
        i: LONGINT;             (* to hold index *)
        s: ARRAY 50 OF CHAR;    (* to hold each line *)
        x: REAL;                (* line converted to float *)
        f: Files.File; 
        r: Files.Rider;

    BEGIN

        f := Files.Old(filename);
        IF f = NIL THEN 
            RETURN -1;          (* Failed to open file *)
        END;
        Files.Set(r, f, 0);

        i := 0;
        LOOP
            Files.ReadLine(r, s);
            IF r.eof = TRUE THEN
                EXIT;
            ELSIF i >= size THEN
                RETURN -1;      (* File exceeds vector size *)
            ELSE
                Strings.StrToReal(s, x);
                vect[i] := x;
                i := i + 1;
            END;
        END; (* end loop *)

        RETURN 0;

    END FromFile;

END Vector.

