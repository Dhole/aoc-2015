program day12;

uses
    StrUtils, Types, sysutils;

function isNum(c: Char): Boolean;
begin
    if (integer('0') <= integer(c)) and (integer(c) <= integer('9')) or
        (c = '-') then
            isNum := true
    else
        isNum := false;
end;

function parse(line: AnsiString; var i: Longint): Longint;
var
    numStr: string;
    c: Char;
    start, len, sum: Longint;
    hasRed: Boolean;
begin
    hasRed := false;
    sum := 0;
    start := -1;
    len := 0;
    while i <= Length(line) do begin
        if i <= Length(line)-5 then begin
            if (line[i+0] = ':') and
                (line[i+1] = '"') and
                (line[i+2] = 'r') and
                (line[i+3] = 'e') and
                (line[i+4] = 'd') and
                (line[i+5] = '"') then
                    hasRed := true;
        end;
        c := line[i];
        // WriteLn(c);
        if isNum(c) then begin
            len += 1;
            if start = -1 then
                start := i
        end else if start <> -1 then begin
            numStr := Copy(line, start, len);
            sum += StrToInt(numStr);
            start := -1;
            len := 0;
        end;
        i += 1;
        if c = '{' then begin
            sum += parse(line, i)
        end else if c = '}' then begin
            if hasRed then
                parse := 0
            else
                parse := sum;
            exit;
        end;
    end;
    parse := sum;
end;

var
    line: AnsiString;
    sum: Longint;
    i: Longint;
begin
    ReadLn(line);
    i := 1;
    sum := parse(line, i);
    WriteLn(sum);
end.
