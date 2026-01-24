program day20;

var
    target, v, n, i: Longint;
begin
    // target := 36000000;
    target := 4000;
    v := 0;
    n := 1;
    while true do begin
        v += n*10;
        if v >= target then
            break;
        n := 2 * n;
    end;
    n := n div 2;
    n := 1;
    while true do begin
        v := 0;
        for i := 1 to n do begin
            if (n mod i) = 0 then
                v += i * 10;
        end;
        WriteLn(n, ' -> ', v);
        // WriteLn(v);
        if v >= target then
            break;
        n += 1;
    end;
    WriteLn(n);
end.

// 1048740 is wrong
//
// target 360_000 answer is 10080 -> 393120
