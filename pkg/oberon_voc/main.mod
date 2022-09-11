MODULE main;
IMPORT Args, Out, Cout, Platform, CosineS, Vector;
VAR
    i: INTEGER;
    size, repeat, secStart, usecStart, secEnd, usecEnd: LONGINT;
    t, runtime: LONGREAL;
    fn1, fn2: ARRAY 50 OF CHAR;
    vect1, vect2: Vector.Vector;
    value: LONGREAL;

BEGIN

    IF Args.argc # 5 THEN
        Out.String("Expected 4 args: repeat size file1 file2"); Out.Ln;
        HALT(1);
    END;

    Args.GetInt(1, repeat);
    Args.GetInt(2, size);
    Args.Get(3, fn1);
    Args.Get(4, fn2);

    Vector.Init(size, vect1);
    Vector.Init(size, vect2);

    IF Vector.FromFile(fn1, size, vect1) # 0 THEN
        Out.String("Error read "); Out.String(fn1); Out.Ln;
        HALT(1);
    END;
    IF Vector.FromFile(fn2, size, vect2) # 0 THEN;
        Out.String("Error read "); Out.String(fn2); Out.Ln;
        HALT(1);
    END;

    runtime := 0.0;

    FOR i := 1 TO SHORT(repeat) DO
        Platform.GetTimeOfDay(secStart, usecStart);
        value := CosineS.Calculate(size, vect1, vect2);
        Platform.GetTimeOfDay(secEnd, usecEnd);
        t := (secEnd - secStart) + ( (usecEnd - usecStart) / 1000000.0);
        runtime := runtime + t;
    END;

    runtime := (runtime / repeat);
    Cout.LongReals(value, runtime);

END main.
