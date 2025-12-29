program day02;

uses
    StrUtils, Types, sysutils;

// Integer has 2 bytes which is too small, so we use Longint which has 4 bytes
function WrappingPaper(l: Longint; w: Longint; h: Longint): Longint;
var
    a, b, c, total: Longint;
begin
    a := l*w;
    b := w*h;
    c := l*h;
    total := 2*a + 2*b + 2*c;
    if (a <= b) and (a <= c) then
        total += a
    else if (b <= a) and (b <= c) then
        total += b
    else
        total += c;
    WrappingPaper := total;
end;

function Ribbon(l: Longint; w: Longint; h: Longint): Longint;
var
    total: Longint;
begin
    total := l*w*h;
    if (l >= w) and (l >= h) then
        total += 2*w + 2*h
    else if (w >= l) and (w >= h) then
        total += 2*l + 2*h
    else
        total += 2*l + 2*w;
    Ribbon := total;
end;

var
    line: AnsiString;
    l, w, h, totalWrap, totalRibbon: Longint;
    parts: TStringDynArray;

begin
    totalWrap := 0;
    totalRibbon := 0;
    While not EOF do
    begin
        ReadLn(line);
        parts := SplitString(line, 'x');
        l := StrToInt(parts[0]);
        w := StrToInt(parts[1]);
        h := StrToInt(parts[2]);
        totalWrap += WrappingPaper(l, w, h);
        totalRibbon += Ribbon(l, w, h);
    end;
    WriteLn(totalWrap);
    WriteLn(totalRibbon);
end.
