program day24;

uses
    StrUtils, Types, sysutils;

type
    TList = array of integer;
    TInput = record
        sum: Longint;
        items: TList;
        list0: TList;
        qe: uInt64;
        group: integer;
    end;
    TState = record
        minItems1: Longint;
        minQE: uInt64;
    end;

procedure search(input: TInput; var state: TState); forward;

function setSub(items, list: TList; len: Longint): TList;
var
    res: TList;
    i, j, k: integer;
begin
    SetLength(res, Length(items) - len);
    i := 0;
    j := 0;
    k := 0;
    while k < Length(res) do begin
        if (j = len) or (items[i] < list[j]) then begin
            res[k] := items[i];
            k += 1;
            i += 1;
        end else if items[i] = list[j] then begin
            i += 1;
            j += 1;
        end else begin
            WriteLn('error');
            Write('items: ');
            for i := 0 to Length(items)-1 do
                Write(items[i], ', ');
            WriteLn();
            Write('list: ');
            for i := 0 to len-1 do
                Write(list[i], ', ');
            WriteLn();
            Write('res: ');
            for i := 0 to k-1 do
                Write(res[i], ', ');
            WriteLn();
            halt(0);
        end;
    end;
    setSub := res;
end;

procedure check(input: TInput; var state: TState;
    list: TList; len: Longint);
var
    i: integer;
    s: Longint;
begin
    s := 0;
    for i := 0 to len-1 do
        s += list[i];
    if s <> input.sum then
        exit;
    if input.group = 1 then begin
        if len >= state.minItems1 then
            exit;
        input.qe := 1;
        for i := 0 to len-1 do begin
            input.qe *= list[i];
            if input.qe >= state.minQE then
                exit;
        end;
        input.group := 2;
        input.items := setSub(input.items, list, len);
        // DBG
        input.list0 := Copy(list, 0, len);
        search(input, state);
    end else if input.group = 2 then begin
        input.group := 3;
        input.items := setSub(input.items, list, len);
        search(input, state);
    end else if input.group = 3 then begin
        if len < state.minItems1 then begin
            state.minItems1 := len;
            if input.qe < state.minQE then begin
                state.minQE := input.qe;
            end;
        end;
        WriteLn('minItems=', state.minItems1);
        WriteLn('minQE=', state.minQE);
        Write('list0: ');
        for i := 0 to Length(input.list0)-1 do
            Write(input.list0[i], ', ');
        WriteLn();
        Write('list: ');
        for i := 0 to len-1 do
            Write(list[i], ', ');
        WriteLn();
        halt(0);
    end else begin
        WriteLn('invalid group=', input.group);
    end;
    // for i := 0 to len-1 do
    //     Write(list[i], ', ');
    // WriteLn();
end;

procedure subset(input: TInput; var list: TList;
    var state: Tstate;
    pos, start, len: Longint);
var
    i: Longint;
begin
    for i := start to Length(list)-1 do begin
        list[pos] := input.items[i];
        if pos = len-1 then
            check(input, state, list, len)
        else
            subset(input, list, state, pos+1, i+1, len);
    end;
end;

procedure search(input: TInput; var state: TState);
var
    list: TList;
    n: integer;
begin
    SetLength(list, Length(input.items));
    for n := 1 to Length(input.items)-1 do begin
        subset(input, list, state, 0, 0, n);
    end;
end;

var
    line: AnsiString;
    i: integer;
    sum3: Longint;
    input: TInput;
    state: TState;
begin
    SetLength(input.items, 128);
    i := 0;
    While not EOF do begin
        ReadLn(line);
        input.items[i] := StrToInt(line);
        i += 1;
    end;
    SetLength(input.items, i);

    sum3 := 0;
    for i := 0 to Length(input.items)-1 do
        sum3 += input.items[i];
    input.sum := sum3 div 4;
    WriteLn('sum3=', sum3, ', sum/4=', input.sum);
    input.qe := 8888;
    input.group := 1;

    state.minItems1 := 9999;
    state.minQE := 9999999999999;

    search(input, state);
    WriteLn('minItems=', state.minItems1);
    WriteLn('minQE=', state.minQE);
end.


// minQE=691407338 is too low
// minQE=947346631 is too low
