program day14;

uses
    StrUtils, Types, sysutils, Math, Quicksort;

type
    TData = array of array[0..2] of Longint;
    TArray = array of Longint;

function distance(t, speed, fly_time, rest_time: Longint): Longint;
var
    rounds, rem: Longint;
begin
    rounds := Floor(Float(t) / Float(fly_time + rest_time));
    rem := t mod (fly_time + rest_time);
    distance := rounds * fly_time * speed + Min(rem, fly_time) * speed;
end;

// Part 2
procedure simulate(duration: Longint; data: TData;
    var position: TArray; var score: TArray);
var
    i, t, speed, fly_time, rest_time, best: Longint;
begin
    for t := 0 to duration-1 do begin
        best := 0;
        for i := 0 to Length(data)-1 do begin
            speed := data[i][0];
            fly_time := data[i][1];
            rest_time := data[i][2];
            if (t mod (fly_time + rest_time)) < fly_time then
                position[i] += speed;
            if position[i] > best then
                best := position[i];
        end;

        for i := 0 to Length(data)-1 do begin
            if position[i] = best then
                score[i] += 1;
        end;
    end;
end;

var
    line: AnsiString;
    parts: TStringDynArray;
    speed, fly_time, rest_time: Longint;
    // distances: array of Longint;
    data: TData;
    position: TArray;
    score: TArray;
    i: Longint = 0;
    duration: Longint;
begin
    duration := 2503;
    // SetLength(distances, 128);
    SetLength(data, 128);
    SetLength(position, 128);
    SetLength(score, 128);
    While not EOF do begin
        ReadLn(line);
        parts := SplitString(line, ' ');
        speed := StrToInt(parts[3]);
        fly_time := StrToInt(parts[6]);
        rest_time := StrToInt(parts[13]);
        // distances[i] := distance(duration, speed, fly_time, rest_time);
        data[i][0] := speed;
        data[i][1] := fly_time;
        data[i][2] := rest_time;
        position[i] := 0;
        score[i] := 0;
        i += 1;
    end;
    // SetLength(distances, i);
    // sort(distances);
    // WriteLn(distances[Length(distances)-1]);
    SetLength(data, i);
    SetLength(position, i);
    simulate(duration, data, position, score);
    sort(score);
    WriteLn(score[Length(score)-1]);
end.
