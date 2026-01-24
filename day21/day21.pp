program day21;

uses
    Math;

type
    TPlayer = record
        hp: integer;
        damage: integer;
        armor: integer;
    end;

    TItem = record
        cost: integer;
        damage: integer;
        armor: integer;
    end;

function battle(player, boss: TPlayer): Boolean;
var
    playerTurn: Boolean;
begin
    playerTurn := true;
    while true do begin
        if playerTurn then begin
            boss.hp -= Max(1, player.damage - boss.armor);
            playerTurn := false;
        end else begin
            player.hp -= Max(1, boss.damage - player.armor);
            playerTurn := true;
        end;
        if player.hp <= 0 then begin
            battle := false;
            exit;
        end;
        if boss.hp <= 0 then begin
            battle := true;
            exit;
        end;
    end;
end;

var
    player, boss: TPlayer;
    weapons: array[0..5-1] of TItem;
    armor: array[0..6-1] of TItem;
    rings: array[0..8-1] of TItem;
    w_i, a_i, r1_i, r2_i: integer;
    minWin, maxLose, cost: integer;
begin
    boss.hp := 104;
    boss.damage := 8;
    boss.armor := 1;
    player.hp := 100;

    weapons[0].cost :=  8; weapons[0].damage := 4; weapons[0].armor := 0;
    weapons[1].cost := 10; weapons[1].damage := 5; weapons[1].armor := 0;
    weapons[2].cost := 25; weapons[2].damage := 6; weapons[2].armor := 0;
    weapons[3].cost := 40; weapons[3].damage := 7; weapons[3].armor := 0;
    weapons[4].cost := 74; weapons[4].damage := 8; weapons[4].armor := 0;

    armor[0].cost :=  13; armor[0].damage := 0; armor[0].armor := 1;
    armor[1].cost :=  31; armor[1].damage := 0; armor[1].armor := 2;
    armor[2].cost :=  53; armor[2].damage := 0; armor[2].armor := 3;
    armor[3].cost :=  75; armor[3].damage := 0; armor[3].armor := 4;
    armor[4].cost := 102; armor[4].damage := 0; armor[4].armor := 5;
    armor[5].cost :=   0; armor[5].damage := 0; armor[5].armor := 0;

    rings[0].cost :=  25; rings[0].damage := 1; rings[0].armor := 0;
    rings[1].cost :=  50; rings[1].damage := 2; rings[1].armor := 0;
    rings[2].cost := 100; rings[2].damage := 3; rings[2].armor := 0;
    rings[3].cost :=  20; rings[3].damage := 0; rings[3].armor := 1;
    rings[4].cost :=  40; rings[4].damage := 0; rings[4].armor := 2;
    rings[5].cost :=  80; rings[5].damage := 0; rings[5].armor := 3;
    rings[6].cost :=   0; rings[6].damage := 0; rings[6].armor := 0;
    rings[7].cost :=   0; rings[7].damage := 0; rings[7].armor := 0;

    minWin := 9999;
    maxLose := 0;

    for w_i := 0 to Length(weapons)-1 do begin
    for a_i := 0 to Length(armor)-1 do begin
    for r1_i := 0 to Length(rings)-1 do begin
    for r2_i := r1_i+1 to Length(rings)-1 do begin
        cost := weapons[w_i].cost + armor[a_i].cost +
            rings[r1_i].cost + rings[r2_i].cost;
        player.damage := weapons[w_i].damage + armor[a_i].damage +
            rings[r1_i].damage + rings[r2_i].damage;
        player.armor := weapons[w_i].armor + armor[a_i].armor +
            rings[r1_i].armor + rings[r2_i].armor;
        if battle(player, boss) then begin
            if cost < minWin then
                minWin := cost;
        end else begin
            if cost > maxLose then
                maxLose := cost;
        end;
    end;
    end;
    end;
    end;

    WriteLn(minWin);
    WriteLn(maxLose);
end.
