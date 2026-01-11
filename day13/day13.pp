program day13;

uses
    StrUtils, Types, sysutils;

function nameId(var names: array of string; var len: Longint;
    name: string): Longint;
var
    i: Longint = 0;
begin
    for i := 0 to len-1 do begin
        if names[i] = name then begin
            nameId := i;
            exit;
        end;
    end;
    names[len] := name;
    nameId := len;
    len += 1;
end;

function score(list: array of Longint;
    rel: array of Longint): Longint;
var
    i, s, src, dst, n: Longint;
begin
    n := Length(list);
    score := 0;
    for i := 0 to n-1 do begin
        src := list[i];
        if i = 0 then
            dst := list[n-1]
        else
            dst := list[i-1];
        s := rel[src*Length(list) + dst];
        // Write(s, ' (', i, ') ');
        score += s;

        src := list[i];
        dst := list[(i+1) mod n];
        s := rel[src*Length(list) + dst];
        // Write(s, ' | ');
        score += s;
    end;
    // WriteLn();
end;

procedure swap(var xs: array of Longint; i, j: Longint);
var
    tmp: Longint;
begin
    tmp := xs[i];
    xs[i] := xs[j];
    xs[j] := tmp;
end;

procedure permute(rel: array of Longint;
    var max: Longint;
    var list: array of Longint; k: Longint);
var
    i, s: Longint;
begin
    if k = Length(list) then begin
        s := score(list, rel);
        if s > max then
            max := s;
        // WriteList(list);
        // WriteLn('-> ', s);
    end else begin
        for i := k to Length(list)-1 do begin
            swap(list, k, i);
            permute(rel, max, list, k+1);
            swap(list, k, i);
        end;
    end;
end;

var
    line: AnsiString;
    parts: TStringDynArray;
    src, dst: Longint;
    entries: array of array[0..2] of Longint;
    len: Longint = 0;
    names: array of string;
    v, i, j, max: Longint;
    rel: array of Longint;
    list: array of Longint;
begin
    SetLength(names, 100);
    SetLength(entries, 100);
    i := 0;
    While not EOF do begin
        ReadLn(line);
        line := Copy(line, 1, Length(line)-1); // Remove dot
        parts := SplitString(line, ' ');
        src := nameId(names, len, parts[0]);
        dst := nameId(names, len, parts[10]);
        v := StrToInt(parts[3]);
        if parts[2] = 'lose' then
            v := -1 * v;
        // WriteLn(src, ' ', dst, ' ', v);
        entries[i][0] := src;
        entries[i][1] := dst;
        entries[i][2] := v;
        i += 1;
    end;
    // WriteLn();

    // Part 2
    len += 1;
    for j := 0 to len-1 do begin
        entries[i][0] := len-1;
        entries[i][1] := j;
        entries[i][2] := 0;
        i += 1;
        entries[i][0] := j;
        entries[i][1] := len-1;
        entries[i][2] := 0;
        i += 1;
    end;

    SetLength(names, len);
    SetLength(entries, i);

    SetLength(rel, len*len);
    for i := 0 to Length(entries)-1 do begin
        src := entries[i][0];
        dst := entries[i][1];
        v := entries[i][2];
        rel[src*len + dst] := v;
    end;

    SetLength(list, len);
    for i := 0 to Length(list)-1 do
        list[i] := i;

    max := 0;
    permute(rel, max, list, 0);
    WriteLn(max);
end.
