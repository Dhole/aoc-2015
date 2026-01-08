program day10;

uses
    sysutils;

var
    line, line2: AnsiString;
    c: char;
    count: integer;
    i, j: Longint;
begin
    ReadLn(line);

    for j := 0 to 50-1 do begin
        count := 0;
        line2 := '';
        for i := 1 to Length(line) do begin
            count += 1;
            c := line[i];
            if (i = Length(line)) or (c <> line[i+1]) then begin
                line2 := line2 + Format('%d%s', [count, c]);
                count := 0;
            end;
        end;
        line := Copy(line2, 1, Length(line2));
    end;
    WriteLn(Length(line2));
end.
