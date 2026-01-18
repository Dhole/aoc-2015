program day18;

type
    TGrid = array of integer;

const
    W = 100;
    H = 100;

function gridGet(g: TGrid; x: integer; y: integer): integer;
begin
    if ((x = 0) and (y = 0)) or
        ((x = 0) and (y = H-1)) or
        ((x = W-1) and (y = 0)) or
        ((x = W-1) and (y = W-1)) then begin
            gridGet := 1;
            exit;
        end;
    if (0 <= x) and (x < W) and
        (0 <= y) and (y < H) then
            gridGet := g[W*y + x]
        else
            gridGet := 0;
end;

procedure gridSet(g: TGrid; x: integer; y: integer; v: integer);
begin
    g[W*y + x] := v;
end;

function newGrid(): TGrid;
var
    g: TGrid;
    x, y: integer;
begin
    SetLength(g, W*H);
    for y := 0 to H-1 do
        for x := 0 to W-1 do
            gridSet(g, x, y, 0);
    newGrid := g;
end;

procedure advance(g0, g1: TGrid);
var
    x, y, dx, dy, count, v: integer;
begin
    for y := 0 to H-1 do begin
        for x := 0 to W-1 do begin
            count := 0;
            for dy := -1 to 1 do begin
                for dx := -1 to 1 do begin
                    if (dy = 0) and (dx = 0) then
                        continue;
                    count += gridGet(g0, x+dx, y+dy);
                end;
            end;
            if gridGet(g0, x, y) = 1 then begin
                // is on
                if (count = 2) or (count = 3) then
                    v := 1 // stay on
                else
                    v := 0; // turn off
            end else begin
                // is off
                if (count = 3) then
                    v := 1 // turn on
                else
                    v := 0; // stay off
            end;
            gridSet(g1, x, y, v);
        end;
    end;
end;

function count(g: TGrid): integer;
var
    x, y: integer;
begin
    count := 0;
    for y := 0 to H-1 do
        for x := 0 to W-1 do
            count += gridGet(g, x, y);
end;

var
    line: AnsiString;
    x, y: integer;
    v: integer;
    g0, g1, tmp: TGrid;
begin
    x := 0;
    y := 0;
    g0 := newGrid();
    g1 := newGrid();
    While not EOF do begin
        ReadLn(line);
        for x := 0 to W-1 do begin
            if line[x+1] = '#' then
                v := 1
            else
                v := 0;
            gridSet(g0, x, y, v);
        end;
        y += 1;
    end;
    for x := 0 to 100-1 do begin
        advance(g0, g1);
        tmp := g0;
        g0 := g1;
        g1 := tmp;
    end;
    WriteLn(count(g0));
end.
