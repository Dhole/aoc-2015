program day15;

uses
    StrUtils, Types, sysutils;

type
    TProps = array of array[0..4] of Longint;
    TRes = array of Longint;

function score(props: TProps; res: TRes; alt: Boolean): Longint;
var
    totals: array[0..3] of Longint;
    i, j, penalty: Longint;
begin
    penalty := 0;
    for j := 0 to 3 do
        totals[j] := 0;
    for j := 0 to 3 do begin
        for i := 0 to Length(res)-1 do begin
            totals[j] += res[i] * props[i][j];
        end;
        // Write('total[', j, ']=', totals[j], ' ');
        if totals[j] <= 0 then begin
            if totals[j] < penalty then
                penalty := totals[j];
            // penalty += totals[j];
            totals[j] := 0;
        end;
    end;
    // WriteLn();
    score := 1;
    for i := 0 to 3 do
        score *= totals[i];
    if alt then
        score += penalty;
end;

function descend(props: TProps; var res: TRes): Boolean;
var
    i, j, oldScore, newScore: Longint;
begin
    oldScore := score(props, res, true);
    descend := false;
    for i := 0 to Length(res)-1 do begin
        if res[i] <= 0 then
            continue;
        for j := 0 to Length(res)-1 do begin
            if i = j then
                continue;
            res[i] -= 1;
            res[j] += 1;
            newScore := score(props, res, true);
            // WriteLn(i, ',', j, ': ', oldScore, ' -> ', newScore);
            if newScore > oldScore then begin
                descend := true;
                exit;
            end else begin
                res[i] += 1;
                res[j] -= 1;
            end;
        end;
    end;
end;

procedure find(props: TProps; i: Longint; var res: TRes; var max: Longint);
var
    j, k, sum, localScore, cals: Longint;
begin
    for j := 0 to 100 do begin
        res[i] := j;
        if i = Length(res)-1 then begin
            sum := 0;
            for k := 0 to Length(res)-1 do
                sum += res[k];
            if sum = 100 then begin
                cals := 0;
                for k := 0 to Length(res)-1 do
                    cals += res[k] * props[k][4];
                if cals = 500 then begin
                    localScore := score(props, res, false);
                    if localScore > max then
                        max := localScore;
                end;
            end;
        end else begin
            find(props, i+1, res, max);
        end;
    end;
end;

var
    line: AnsiString;
    parts: TStringDynArray;
    cap, dur, fla, tex, cal: Longint;
    props: TProps;
    res: TRes;
    i, max: Longint;
begin
    SetLength(props, 128);
    SetLength(res, 128);
    i := 0;
    While not EOF do begin
        ReadLn(line);
        parts := SplitString(line, ' ');
        cap := StrToInt(Copy(parts[2], 1, Length(parts[2])-1));
        dur := StrToInt(Copy(parts[4], 1, Length(parts[4])-1));
        fla := StrToInt(Copy(parts[6], 1, Length(parts[6])-1));
        tex := StrToInt(Copy(parts[8], 1, Length(parts[8])-1));
        cal := StrToInt(parts[10]);
        // WriteLn(cap, ' ', dur, ' ', fla, ' ', tex, ' ', cal);
        props[i][0] := cap;
        props[i][1] := dur;
        props[i][2] := fla;
        props[i][3] := tex;
        props[i][4] := cal;
        res[i] := 0;
        i += 1;
    end;
    SetLength(props, i);
    SetLength(res, i);

    // for i := 0 to Length(res)-1 do
    //     res[i] := 100 div Length(res);
    // while true do begin
    //     if not descend(props, res) then
    //         break;
    //     for i := 0 to Length(res)-1 do
    //         Write(res[i], ' ');
    //     WriteLn('(', score(props, res, true), '/', score(props, res, false), ')');
    // end;
    // WriteLn(score(props, res, false));
    
    find(props, 0, res, max);
    WriteLn(max);
end.
