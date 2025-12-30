program day01;

uses Quicksort;

function Compress(x: Longint; y: Longint): Longint;
var
    r: Longint;
begin
    // Normalize to positive, 16 bit per coord
    x := x + 16384;
    y := y + 16384;
    if (x < 0) or (x >= 32767) then
        WriteLn('x out of bounds');
    if (y < 0) or (y >= 32767) then
        WriteLn('y out of bounds');
    r := x + (y << 16);
    Compress := r;
end;

var
    input: AnsiString;
    c: Char;
    i: Longint = 0;
    santaX: Longint = 0;
    santaY: Longint = 0;
    robotX: Longint = 0;
    robotY: Longint = 0;
    deltaX: Longint;
    deltaY: Longint;
    coords: array of Longint;
    coord: LongInt = 0;
    prev: Longint = 0;
    r: Longint = 0;

begin
    setLength(coords, 10000);
    ReadLn(input);
    coords[i] := Compress(santaX, santaY);
    i += 1;
    for c in input do
    begin
        deltaX := 0;
        deltaY := 0;
        if c = '<' then
            deltaX := -1
        else if c = '>' then
            deltaX := 1
        else if c = '^' then
            deltaY := 1
        else if c = 'v' then
            deltaY := -1;

        if (i >= Length(coords)) then
            WriteLn('i out of bounds');

        if (i Mod 2) = 1 then
        begin
            santaX += deltaX;
            santaY += deltaY;
            coords[i] := Compress(santaX, santaY);
        end
        else
        begin
            robotX += deltaX;
            robotY += deltaY;
            coords[i] := Compress(robotX, robotY);
        end;
        i += 1;
    end;
    setLength(coords, i);
    sort(coords);

    // Count unique
    for coord in coords do
    begin
        if coord <> prev then
            r += 1;
        prev := coord;
    end;
    WriteLn(r);
end.

