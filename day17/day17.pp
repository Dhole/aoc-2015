program day17;

uses
    StrUtils, Types, sysutils;

function sum(sizes: array of Longint; list: array of Longint;
    k: Longint): Longint;
var
    i: Longint;
begin
    sum := 0;
    for i := 0 to k-1 do begin
        // Write(list[i], ' ');
        sum += sizes[list[i]];
    end;
    // WriteLn(' | ', sum);
end;

procedure check(sizes: array of Longint;
    var count: Longint;
    var list: array of Longint; n: Longint);
begin
    if sum(sizes, list, n) = 150 then
        count += 1;
end;

procedure subset(sizes: array of Longint;
    var count: Longint;
    var list: array of Longint;
    pos, start, len: Longint);
var
    i: Longint;
begin
    for i := start to Length(list)-1 do begin
        // WriteLn(i, start, len);
        list[pos] := i;
        if pos = len-1 then
            check(sizes, count, list, len)
        else
            subset(sizes, count, list, pos+1, i+1, len);
    end;
end;

procedure subsets(sizes: array of Longint;
    var count: Longint;
    var list: array of Longint);
var
    n: Longint;
begin
    for n := 1 to Length(list) do begin
        // WriteLn('size = ', n);
        subset(sizes, count, list, 0, 0, n);
        if count <> 0 then
            exit;
    end;
end;


var
    line: AnsiString;
    sizes, list: array of Longint;
    i, count: Longint;
begin
    SetLength(sizes, 128);
    SetLength(list, 128);
    i := 0;
    While not EOF do begin
        ReadLn(line);
        sizes[i] := StrToInt(line);
        list[i] := i;
        i += 1;
    end;
    SetLength(sizes, i);
    SetLength(list, i);

    count := 0;
    subsets(sizes, count, list);
    WriteLn(count);
end.
