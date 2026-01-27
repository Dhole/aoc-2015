program day25;

var
    row, col, targetRow, targetCol: integer;
    i, j: longInt;
    code: longInt;
begin
    targetRow := 2947;
    targetCol := 3029;
    // targetRow := 4;
    // targetCol := 2;

    j := 1;
    code := 20151125;
    while true do begin
        for i := 0 to j do begin
            col := i+1;
            row := j-i+1;
            code := (code * 252533) mod 33554393;
            // WriteLn(row, ',', col, ': ', code);
            if (row = targetRow) and (col = targetCol) then begin
                WriteLn('code=', code);
                halt(0);
            end;
        end;
        j += 1;
    end;
end.
