MODULE CosineS;
IMPORT Vector, Math;

PROCEDURE EuclideanMagnitude*(size: LONGINT; a, b: Vector.Vector): LONGREAL;
    VAR
        lenA, lenB: LONGREAL;
        value: LONGREAL;
        valuetmp: REAL;
        i: LONGINT;
    BEGIN
        lenA := 0.0;
        lenB := 0.0;
        FOR i := 0 TO size-1 DO
            lenA := lenA + (a[i] * a[i]);
            lenB := lenB + (b[i] * b[i]);
        END;
        value := (lenA * lenB);
        valuetmp := Math.sqrt(SHORT(value));
        value := LONG(valuetmp);
        RETURN value;
    END EuclideanMagnitude;

PROCEDURE DotProduct*(size: LONGINT; a, b: Vector.Vector): LONGREAL;
    VAR
        value: LONGREAL;
        i: LONGINT;
    BEGIN
        value := 0.0;
        FOR i := 0 TO size-1 DO
            value := value + (a[i] * b[i]);
        END;
        RETURN value;
    END DotProduct;

PROCEDURE Calculate*(size: LONGINT; a, b: Vector.Vector): LONGREAL;
    VAR 
        value, magn, dotprod: LONGREAL;
    BEGIN
        magn := EuclideanMagnitude(size, a, b);
        IF magn > 0 THEN
            dotprod := DotProduct(size, a, b);
            value := ( dotprod / magn );
        ELSE
            value := 0.0;
        END;
        RETURN value;
    END Calculate;

END CosineS.
