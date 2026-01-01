program day06;

uses
    StrUtils, Types, sysutils;

type
    TCoord = record
        x: Longint;
        y: Longint;
    end;
    TOp = (turnOn, turnOff, toggle);
    TInst = record
        op: TOp;
        src: TCoord;
        dst: TCoord;
    end;
    TGrid = array[0..999,0..999] of Boolean;
    TGrid2 = array[0..999,0..999] of Longint;

function parseCoord(line: AnsiString): TCoord;
var
    parts: TStringDynArray;
begin
    parts := SplitString(line, ',');
    parseCoord.x := StrToInt(parts[0]);
    parseCoord.y := StrToInt(parts[1]);
end;

function parseInst(line: AnsiString): TInst;
var
    parts: TStringDynArray;
    i: Longint;
begin
    parts := SplitString(line, ' ');
    if parts[0] = 'toggle' then
    begin
        parseInst.op := toggle;
        i := 1;
    end
    else if parts[0] = 'turn' then
    begin
        if parts[1] = 'on' then
            parseInst.op := turnOn
        else if parts[1] = 'off' then
            parseInst.op := turnOff;
        i := 2;
    end;
    parseInst.src := parseCoord(parts[i]);
    parseInst.dst := parseCoord(parts[i+2]);
end;

procedure update(var grid: TGrid; inst: TInst);
var
    i, j: Longint;
begin
    // WriteLn(inst.op, ' (',
    //     inst.src.x, ',', inst.src.y, ') (',
    //     inst.dst.x, ',', inst.dst.y, ')');
    for i := inst.src.x to inst.dst.x do
    begin
        for j := inst.src.y to inst.dst.y do
        begin
            if inst.op = turnOn then
                grid[i, j] := true
            else if inst.op = turnOff then
                grid[i, j] := false
            else if inst.op = toggle then
                grid[i, j] := not grid[i, j];
        end;
    end;
end;

procedure update2(var grid: TGrid2; inst: TInst);
var
    i, j: Longint;
begin
    // WriteLn(inst.op, ' (',
    //     inst.src.x, ',', inst.src.y, ') (',
    //     inst.dst.x, ',', inst.dst.y, ')');
    for i := inst.src.x to inst.dst.x do
    begin
        for j := inst.src.y to inst.dst.y do
        begin
            if inst.op = turnOn then
                grid[i, j] += 1
            else if inst.op = turnOff then
            begin
                if grid[i, j] > 0 then
                    grid[i, j] -= 1
            end
            else if inst.op = toggle then
                grid[i, j] += 2;
        end;
    end;
end;

var
    line: AnsiString;
    grid: TGrid2;
    i, j, count: Longint;
    inst: TInst;
begin
    for i := 0 to 999 do
    begin
        for j := 0 to 999 do
            grid[i, j] := 0;
    end;

    While not EOF do
    begin
        ReadLn(line);
        inst := parseInst(line);
        update2(grid, inst);
    end;

    count := 0;
    for i := 0 to 999 do
    begin
        for j := 0 to 999 do
            count += grid[i, j];
    end;
    WriteLn(count);
end.
