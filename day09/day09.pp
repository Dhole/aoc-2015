program day09;

uses
    StrUtils, Types, sysutils;

function cityId(var cities: array of string; var len: Longint;
    city: string): Longint;
var
    i: Longint = 0;
begin
    for i := 0 to len-1 do begin
        if cities[i] = city then begin
            cityId := i;
            exit;
        end;
    end;
    cities[len] := city;
    cityId := len;
    len += 1;
end;

procedure swap(var xs: array of Longint; i, j: Longint);
var
    tmp: Longint;
begin
    tmp := xs[i];
    xs[i] := xs[j];
    xs[j] := tmp;
end;

procedure WriteList(xs: array of Longint);
var
    i: Longint;
begin
    for i := 0 to Length(xs)-1 do
        Write(xs[i], ', ');
end;

function distance(list: array of Longint;
    distances: array of Longint): Longint;
var
    i, d, src, dst: Longint;
begin
    distance := 0;
    for i := 0 to Length(list)-2 do begin
        src := list[i];
        dst := list[i+1];
        d := distances[src*Length(list) + dst];
        if d = maxLongInt then begin
            distance := maxLongInt;
            exit;
        end;
        distance += d;
    end;
end;

procedure travel(distances: array of Longint;
    var min, max: Longint;
    var list: array of Longint; k: Longint);
var
    i, d: Longint;
begin
    if k = Length(list) then begin
        d := distance(list, distances);
        if d < min then
            min := d;
        if d > max then
            max := d;
        WriteList(list);
        WriteLn('-> ', d);
    end else begin
        for i := k to Length(list)-1 do begin
            swap(list, k, i);
            travel(distances, min, max, list, k+1);
            swap(list, k, i);
        end;
    end;
end;

var
    line: AnsiString;
    parts: TStringDynArray;
    len: Longint = 0;
    cities: array of string;
    src, dst, dist: Longint;
    entries: array of array[0..2] of Longint;
    distances: array of Longint;
    list: array of Longint;
    i, min, max: Longint;
begin
    SetLength(cities, 100);
    SetLength(entries, 100);
    i := 0;
    While not EOF do
    begin
        ReadLn(line);
        parts := SplitString(line, ' ');
        src := cityId(cities, len, parts[0]);
        dst := cityId(cities, len, parts[2]);
        dist := StrToInt(parts[4]);
        entries[i][0] := src;
        entries[i][1] := dst;
        entries[i][2] := dist;
        // WriteLn(src, ' ', dst, ' ', dist);
        i += 1;
    end;
    SetLength(cities, len);
    SetLength(entries, i);

    SetLength(distances, len*len);
    for i := 0 to Length(distances)-1 do
        distances[i] := maxLongInt;

    WriteLn('cities len: ', Length(cities));
    WriteLn('distances len: ', Length(distances));
    for i := 0 to Length(entries)-1 do begin
        src := entries[i][0];
        dst := entries[i][1];
        dist := entries[i][2];
        // WriteLn(src*len + dst);
        // undirected graph / symmetric matrix
        distances[src*len + dst] := dist;
        distances[dst*len + src] := dist;
    end;
    WriteList(distances);
    WriteLn();

    SetLength(list, Length(cities));
    for i := 0 to Length(list)-1 do
        list[i] := i;

    min := maxLongInt;
    max := 0;
    travel(distances, min, max, list, 0);
    WriteLn(min);
    WriteLn(max);
end.
