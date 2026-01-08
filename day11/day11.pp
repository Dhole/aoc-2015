program day11;

type
    TPass = array[0..8-1] of integer;

procedure inc(var pass: TPass);
var
    i: integer;
begin
    pass[0] += 1;
    for i := 0 to 8-2 do begin
        if pass[i] = 26 then begin
            pass[i] := 0;
            pass[i+1] += 1;
        end;
    end;
end;

function valid1(pass: TPass): Boolean;
var
    c: integer;
begin
    valid1 := true;
    for c in pass do
        if (c = integer('i') - integer('a')) or
            (c = integer('o') - integer('a')) or
            (c = integer('l') - integer('a')) then
                valid1 := false;
end;

function valid2(pass: TPass): Boolean;
var
    i: integer;
    incThree: Boolean = false;
    incCount: integer = 1;
    c, prev: integer;
begin
    prev := -2;
    for i := 0 to 8-1 do begin
        c := pass[i];

        if c = prev-1 then begin
            incCount += 1;
            if incCount = 3 then
                incThree := true;
        end else
            incCount := 1;
        prev := c;
    end;
    valid2 := incThree;
end;

function valid3(pass: TPass): Boolean;
var
    i: integer;
    dupes: array[0..26-1] of Boolean;
    count: integer = 0;
begin
    for i := 0 to Length(dupes)-1 do
        dupes[i] := false;
    for i := 0 to 8-2 do begin
        if pass[i] = pass[i+1] then
            dupes[pass[i]] := true;
    end;
    for i := 0 to Length(dupes)-1 do
        count += integer(dupes[i]);

    valid3 := count >= 2;
end;

var
    line: AnsiString;
    i: integer;
    pass: TPass;
begin
    ReadLn(line);
    for i := 0 to 8-1 do begin
        pass[7-i] := integer(line[i+1]) - integer('a');
    end;
    while true do begin
        inc(pass);
        if valid1(pass) and valid2(pass) and valid3(pass) then
            break;
    end;

    for i := 0 to 8-1 do begin
        Write(char(integer('a') + pass[7-i]))
    end;
    WriteLn();

end.
