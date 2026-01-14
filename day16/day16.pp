program day16;

uses
    StrUtils, Types, sysutils;

type
    TMap = array[0..9] of integer;
    TList = array of TMap;

function nameId(names: array of string; name: string): Longint;
var
    i: Longint = 0;
begin
    nameId := -1;
    for i := 0 to Length(names)-1 do begin
        if names[i] = name then begin
            nameId := i;
            exit;
        end;
    end;
end;

function find(list: TList; tape: TMap): Longint;
var
    i, j, v: Longint;
    match: Boolean;
begin
    find := -1;
    for i := 0 to Length(list)-1 do begin
        match := true;
        for j := 0 to Length(tape)-1 do begin
            v := list[i][j];
            if v <> -1 then begin
                if (j = 1) or (j = 7) then begin
                    match := match and (v > tape[j]);
                end else if (j = 3) or (j = 6) then begin
                    match := match and (v < tape[j]);
                end else begin
                    match := match and (v = tape[j]);
                end;
            end;
        end;
        if match then begin
            find := i;
            exit;
        end;
    end;
end;

var
    line: AnsiString;
    parts: TStringDynArray;
    tape: TMap;
    list: TList;
    i, j: Longint;
    names: array of string;
    elemId, value: Longint;
    tmp: string;
begin
    tape[0] := 3;
    tape[1] := 7;
    tape[2] := 2;
    tape[3] := 3;
    tape[4] := 0;
    tape[5] := 0;
    tape[6] := 5;
    tape[7] := 3;
    tape[8] := 2;
    tape[9] := 1;

    SetLength(names, 10);
    names[0] := 'children';
    names[1] := 'cats';
    names[2] := 'samoyeds';
    names[3] := 'pomeranians';
    names[4] := 'akitas';
    names[5] := 'vizslas';
    names[6] := 'goldfish';
    names[7] := 'trees';
    names[8] := 'cars';
    names[9] := 'perfumes';

    SetLength(list, 500);
    for i := 0 to Length(list)-1 do begin
        for j := 0 to 9 do begin
            list[i][j] := -1;
        end;
    end;

    i := 0;
    While not EOF do begin
        ReadLn(line);
        // Example: Sue 1: goldfish: 9, cars: 0, samoyeds: 9
        parts := SplitString(line, ' ');
        for j := 0 to 2 do begin
            tmp := parts[2 + 2*j];
            tmp := Copy(tmp, 1, Length(tmp)-1);
            elemId := nameId(names, tmp);
            if elemId = -1 then
                WriteLn('elem ', tmp, 'not valid');
            tmp := parts[2 + 2*j + 1];
            if j <> 2 then
                tmp := Copy(tmp, 1, Length(tmp)-1);
            value := StrToInt(tmp);
            list[i][elemId] := value;
        end;
        i += 1;
    end;
    WriteLn(find(list, tape)+1);
end.
