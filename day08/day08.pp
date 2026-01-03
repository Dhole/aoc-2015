program day08;

function decodeSize(line: AnsiString): Longint;
var
    i: Longint = 1;
    c: Char;
begin
    decodeSize := -2; // two double quotes
    while i <= Length(line) do begin
        decodeSize += 1;
        c := line[i];
        if c = '\' then begin
            if line[i+1] = 'x' then
                i += 4
            else
                i += 2;
        end else
            i += 1;
    end;
end;

function encodeSize(line: AnsiString): Longint;
var
    c: Char;
begin
    encodeSize := 2; // two double quotes
    for c in line do begin
        if c = '"' then
            encodeSize += 2
        else if c = '\' then
            encodeSize += 2
        else
            encodeSize += 1;
    end;
end;

var
    line: AnsiString;
    count: Longint = 0;
begin
    While not EOF do
    begin
        ReadLn(line);
        // count += Length(line);
        // count -= decodeSize(line);
        count += encodeSize(line);
        count -= Length(line);
    end;
    WriteLn(count);
end.
