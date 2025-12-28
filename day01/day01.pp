program day01;

var
    input: AnsiString;
    c: Char;
    r: Integer = 0;
    i: Integer = 0;

begin
    ReadLn(input);
    for c in input do
    begin
        if c = '(' then
            r += 1
        else if c = ')' then
            r -= 1;
        i += 1;
    end;
    WriteLn(i);
    WriteLn(r);
end.
