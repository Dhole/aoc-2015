program day07;

uses
    StrUtils, Types, sysutils;

type
    TOp = (opAssign, opNot, opAnd, opOr, opLShift, opRShift);
    TWire = record
        fixed: Boolean;
        v: UInt16;
    end;
    TWireVals = array[0..27*26-1] of UInt16;
    TWireSets = array[0..27*27-1] of Boolean;
    TGate = record
        op: TOp;
        src0: TWire;
        src1: TWire;
        dst: UInt16;
    end;
    TGateState = record
        gate: TGate;
        ok: Boolean;
    end;

function wireIdx(w: string): UInt16;
begin
    if Length(w) = 1 then
        wireIdx := UInt16(w[1]) - UInt16('`')
    else
    begin
        wireIdx := UInt16(w[2]) - UInt16('`');
        wireIdx += 27 * (UInt16(w[1]) - UInt16('`'));
    end;
end;

function parseWire(w: string): TWire;
begin
    if (integer(w[1]) >= integer('a')) and
        (integer(w[1]) <= integer('z')) then begin
            parseWire.fixed := false;
            parseWire.v := wireIdx(w);
    end else begin
        parseWire.fixed := true;
        parseWire.v := StrToInt(w);
    end;

end;

function parse(line: string): TGate;
var
    parts: TStringDynArray;
begin
    // WriteLn(line);
    parts := SplitString(line, ' -> ');
    // WriteLn('"', parts[0], '" "', parts[1], '"');
    parse.dst := wireIdx(parts[1]);
    parts := SplitString(parts[0], ' ');
    if Length(parts) = 1 then begin
        parse.op := opAssign;
        parse.src0 := parseWire(parts[0]);
        parse.src1 := parse.src0;
    end else if Length(parts) = 2 then begin
        parse.op := opNot;
        parse.src0 := parseWire(parts[1]);
        parse.src1 := parse.src0;
    end else if Length(parts) = 3 then begin
        parse.src0 := parseWire(parts[0]);
        parse.src1 := parseWire(parts[2]);
        if parts[1] = 'AND' then
            parse.op := opAnd
        else if parts[1] = 'OR' then
            parse.op := opOr
        else if parts[1] = 'LSHIFT' then
            parse.op := opLShift
        else if parts[1] = 'RSHIFT' then
            parse.op := opRShift
        else
            WriteLn('unknown op ', parts[1]);
    end;
end;

function get(wires: TWireVals;
    wiresSet: TWireSets;
    wire: TWire;
    var v: Uint16): Boolean;
begin
    if wire.fixed = true then begin
        v := wire.v;
        get := true;
    end else begin
        if wiresSet[wire.v] = true then begin
            v := wires[wire.v];
            get := true;
        end else
            get := false;
    end;
end;

function update(var wires: TWireVals;
    var wiresSet: TWireSets;
    gate: TGate): Boolean;
var
    x, y, r: UInt16;
begin
    update := false;
    if not get(wires, wiresSet, gate.src0, x) then
        exit;
    if not get(wires, wiresSet, gate.src1, y) then
        exit;
    // part 2
    if wiresSet[gate.dst] = true then begin
        update := true;
        exit;
    end;

    if gate.op = opAssign then
        r := x
    else if gate.op = opNot then
        r := not x
    else if gate.op = opAnd then
        r := x and y
    else if gate.op = opOr then
        r := x or y
    else if gate.op = opLShift then
        r := x << y
    else if gate.op = opRShift then
        r := x >> y
    else begin
        WriteLn('invalid op');
    end;

    wires[gate.dst] := r;
    wiresSet[gate.dst] := true;
    update := true;
end;

var
    line: AnsiString;
    gate: TGate;
    gateState: TGateState;
    gates: array of TGateState;
    wires: TWireVals;
    wiresSet: TWireSets;
    i: Longint;
    ok: Boolean;
    progress: Boolean;
begin
    SetLength(gates, 400);
    i := 0;

    // part 2
    line := '956 -> b';
    gate := parse(line);
    gates[i].gate := gate;
    gates[i].ok := false;
    i += 1;

    While not EOF do
    begin
        ReadLn(line);
        gate := parse(line);
        gates[i].gate := gate;
        gates[i].ok := false;
        i += 1;
    end;
    SetLength(gates, i);

    for i := 0 to 27*27-1 do
        wiresSet[i] := false;

    while true do begin
        progress := false;
        for i := 0 to Length(gates) - 1 do begin
            gateState := gates[i];
            if gateState.ok then
                continue;
            ok := update(wires, wiresSet, gateState.gate);
            if ok then begin
                progress := true;
                gates[i].ok := true;
            end;
        end;
        if not progress then begin
            WriteLn('no progress');
            break;
        end;
    end;

    WriteLn(wires[wireIdx('a')]);

end.
