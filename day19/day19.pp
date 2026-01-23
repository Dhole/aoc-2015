program day19;

uses
    StrUtils, Types, sysutils, quicksortU64;

type
    TList = array of integer;
    TRep = record
        before: integer;
        after: array of integer;
    end;

function nameId(var names: array of string; var len: Longint;
    name: string): Longint;
var
    i: Longint = 0;
begin
    // WriteLn('nameId ', name);
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

function lower(c: char): Boolean;
begin
    if (integer('a') <= integer(c)) and
        (integer(c) <= integer('z')) then
            lower := true
        else
            lower := false;
end;

function split(var names: array of string; var len: Longint;
    s: AnsiString): TList;
var
    i, j, l: integer;
    list: array of integer;
    tmp: string;
begin
    // WriteLn('split ', s, ' len=', Length(s));
    SetLength(list, 512);
    tmp := '..';
    i := 1;
    j := 0;
    while i <= Length(s) do begin
        tmp[1] := s[i];
        l := 1;
        i += 1;
        if i <= Length(s) then begin
            if lower(s[i]) then begin
                tmp[2] := s[i];
                l := 2;
                i += 1;
            end;
        end;
        list[j] := nameId(names, len, Copy(tmp, 1, l));
        j += 1;
    end;
    SetLength(list, j);
    split := list;
    // WriteLn();
end;

function hash(state: uInt64; input: array of integer;
    start: integer; finish: integer): uInt64;
var
    i: integer;
begin
    for i := start to finish-1 do begin
        // Write(input[i], ', ');
        state := ((state << 5) + state) + uInt64(input[i]);
    end;
    hash := state;
end;

function count(results: TArray): Longint;
var
    i: Longint;
    prev: uInt64;
begin
    sort(results);
    count := 0;
    prev := 0;
    for i := 0 to Length(results)-1 do begin
        if results[i] <> prev then
            count += 1;
        prev := results[i];
    end;
end;

function match(pattern: array of integer; list: array of integer;
    start: Longint): Boolean;
var
    i: Longint;
begin
    if Length(pattern) > (Length(list) - start) then begin
        match := false;
        exit;
    end;
    match := true;
    for i := 0 to Length(pattern)-1 do begin
        if pattern[i] <> list[start+i] then
            match := false;
    end;
end;

procedure show(list: TList);
var
    i: Longint;
begin
    for i := 0 to Length(list)-1 do begin
        if i <> 0 then
            Write(', ');
        Write(list[i]);
    end;
end;

function replace(list, before: TList; after: integer; i: Longint): TList;
var
    list2: TList;
    k: Longint;
begin
    list2 := Copy(list, 0, Length(list));
    list2[i] := after;
    for k := i+1 to Length(list2)-(Length(before)-1)-1 do begin
        list2[k] := list2[k+Length(before)-1];
    end;
    SetLength(list2, Length(list2)-(Length(before)-1));
    replace := list2;
end;

procedure undo(var min: Longint; depth: Longint;
    map: array of TRep; entry: TList);
var
    i, j, k: Longint;
    entry2: TList;
    pattern: array of integer;
begin
    // WriteLn('len=', Length(entry));
    if (Length(entry) = 1) and (entry[0] = 0) then begin
        if depth < min then begin
            WriteLn('min=', depth);
            min := depth;
        end;
        exit;
    end;
    if (depth > 2) then
        exit;
    for i := 0 to Length(entry)-1 do begin
        if depth = 0 then
            WriteLn(depth, ': ', i, '/', Length(entry));
        for j := 0 to Length(map)-1 do begin
            pattern := map[j].after;
            if match(pattern, entry, i) then begin
                // WriteLn('match at ', i);
                // Write('pattern=');
                // show(pattern);
                // WriteLn('  -> ', map[j].before);
                // Write('entry=');
                // show(entry);
                // WriteLn();
                entry2 := replace(entry, pattern, map[j].before, i);
                // Write('entry2=');
                // show(entry2);
                // WriteLn();
                undo(min, depth+1, map, entry2);
            end;
        end;
    end;
end;

// https://old.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/cy4etju/
procedure part2(map: array of TRep; var entry: TList);
var
    // min: Longint;
    parens: integer;
    comas: integer;
    i: integer;
begin
    // min := 999999999;
    // undo(min, 0, map, entry);
    // WriteLn(min);
    parens := 0;
    comas := 0;
    for i := 0 to Length(entry) do begin
        if (entry[i] = 8) or (entry[i] = 9) then
            parens += 1;
        if entry[i] = 15 then
            comas += 1;
    end;
    WriteLn(Length(entry) - parens - 2*comas - 1);
end;

var
    line: AnsiString;
    parts: TStringDynArray;
    names: array of string;
    len: Longint = 0;
    i, j: integer;
    lhs: integer;
    rhs: array of integer;
    map: array of TRep;
    entry: array of integer;
    state: uInt64;
    results: array of uInt64;
begin
    SetLength(names, 512);
    SetLength(map, 512);
    i := 0;
    While not EOF do begin
        ReadLn(line);
        if line = '' then
            break;
        parts := SplitString(line, ' ');
        lhs := nameId(names, len, parts[0]);
        rhs := split(names, len, parts[2]);
        map[i].before := lhs;
        map[i].after := rhs;
        i += 1;
    end;
    SetLength(map, i);
    SetLength(names, len);

    for i := 0 to Length(names)-1 do begin
        WriteLn(i, ': ', names[i]);
    end;

    ReadLn(line);
    entry := split(names, len, line);
    WriteLn('entry len=', Length(entry));

    // Part 2
    part2(map, entry);

    // len := 0;
    // SetLength(results, 1024);
    // for i := 0 to Length(entry)-1 do begin
    //     lhs := entry[i];
    //     for j := 0 to Length(map)-1 do begin
    //         if map[j].before <> lhs then
    //             continue;
    //         state := 5481;
    //         state := hash(state, entry, 0, i);
    //         // Write(' [ ');
    //         state := hash(state, map[j].after, 0, Length(map[j].after));
    //         // Write(' ] ');
    //         state := hash(state, entry, i+1, Length(entry));
    //         // WriteLn();
    //         // WriteLn(state);
    //         if len = Length(results) then
    //             SetLength(results, Length(results)*2);
    //         results[len] := state;
    //         len += 1;
    //     end;
    // end;
    // SetLength(results, len);
    // WriteLn('results len=', Length(results));
    // WriteLn(count(results));

    // for i := 0 to Length(map)-1 do begin
    //     Write(map[i].before, ' -> ');
    //     for j := 0 to Length(map[i].after)-1 do begin
    //         Write(map[i].after[j], ', ');
    //     end;
    //     WriteLn();
    // end;
end.
