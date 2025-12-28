program day01;

var
    input: AnsiString;
    c: Char;
    r: Integer = 0;
    i: Integer = 0;
    r2: Integer = 0;

begin
    ReadLn(input);
    for c in input do
    begin
        if c = '(' then
            r += 1
        else if c = ')' then
            r -= 1;
        if (r2 = 0) and (r = -1) then
            r2 := i + 1;
        i += 1;
    end;
    WriteLn(r); // part 1
    WriteLn(r2); // part 2
end.
