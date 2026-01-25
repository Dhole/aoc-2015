program day20;

var
    target, v, n, max, i: Longint;
begin
    target := 36000000;
    // target := 4000;
    n := 1;
    max := 0;
    while true do begin
        v := 0;
        // Write('[');
        for i := 1 to n do begin
            if ((n mod i) = 0) and ((n div i) <= 50) then begin
                // Write(i, ', ');
                v += i * 11;
            end;
        end;
        // WriteLn(']');
        // if v > max then begin
        //     max := v;
        //     WriteLn(n, ' -> ', v, ' ***');
        // end else
        //    WriteLn(n, ' -> ', v);
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
