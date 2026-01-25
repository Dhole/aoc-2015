program day22;

uses
    Math;

type
    TPlayer = record
        hp: Longint;
        damage: Longint;
        armor: Longint;
        mana: Longint;
    end;

    TSpell = record
        cost: Longint;
        damage: Longint;
        armor: Longint;
        heal: Longint;
        mana: Longint;
        instant: Boolean;
        turns: Longint;
    end;

    TSpells = array[0..5-1] of TSpell;
    TSpellStatus = array[0..5-1] of Longint;

var
    x: Longint;
    test: array of Longint;

procedure printStats(player, boss: TPlayer);
begin
    WriteLn('- Player has ', player.hp, ' hit points, ', player.armor, ' armor, ', player.mana, ' mana');
    WriteLn('- Boss has ', boss.hp, ' hit points');
end;

procedure applySpells(var player, boss: TPlayer; var spellStatus: TSpellStatus;
    spells: TSpells; instant: Boolean);
var
    i: Longint;
    spell: TSpell;
begin
    if not instant then
        player.armor := 0;
    for i := 0 to Length(spells)-1 do begin
        spell := spells[i];
        if spell.instant <> instant then
            continue;
        if spellStatus[i] = 0 then
            continue;
        spellStatus[i] -= 1;

        // if spell.damage <> 0 then
        //     WriteLn('boss damage=', spell.damage);
        boss.hp -= spell.damage;
        player.hp += spell.heal;
        player.mana += spell.mana;
        player.armor += spell.armor;
    end;
end;

function checkEnd(player, boss: TPlayer; var minWin, cost: Longint): Boolean;
begin
    checkEnd := false;
    if player.hp <= 0 then begin
        checkEnd := true;
    end else if boss.hp <= 0 then begin
        checkEnd := true;
        if cost < minWin then
            minWin := cost;
        // WriteLn('player.hp=', player.hp);
        // WriteLn('boss.hp=', boss.hp);
        // WriteLn('win cost=', cost);
    end else if cost >= minWin then begin
        checkEnd := true;
    end;
end;

procedure search(playerInit, bossInit: TPlayer; spellStatusInit: TSpellStatus;
    spells: TSpells;
    var minWin: Longint; costInit: Longint);
var
    i, cost: Longint;
    player, boss: TPlayer;
    spellStatus: TSpellStatus;
    spell: TSpell;
begin
    for i := 0 to Length(spells)-1 do begin
    // i := test[x];
    // x += 1;
    // for i := i to i do begin
        player := playerInit;
        boss := bossInit;
        spellStatus := spellStatusInit;

        // player turn
        // WriteLn('-- Player turn --');
        // printStats(player, boss);
        // WriteLn();
        player.hp -= 1;
        if player.hp <= 0 then
            continue;
        applySpells(player, boss, spellStatus, spells, false);
        if checkEnd(player, boss, minWin, costInit) then
            continue;

        spell := spells[i];
        if spellStatus[i] > 0 then
            continue;
        if player.mana < spell.cost then
            continue;

        player.mana -= spell.cost;
        cost := costInit + spell.cost;
        spellStatus[i] := spell.turns;

        applySpells(player, boss, spellStatus, spells, true);
        if checkEnd(player, boss, minWin, cost) then
            continue;

        // boss turn
        // WriteLn('-- Boss turn --');
        // printStats(player, boss);
        // WriteLn();
        applySpells(player, boss, spellStatus, spells, false);
        if checkEnd(player, boss, minWin, cost) then
            continue;
        player.hp -= Max(1, boss.damage - player.armor);
        if checkEnd(player, boss, minWin, cost) then
            continue;
        search(player, boss, spellStatus, spells, minWin, cost);
    end;
end;

var
    player, boss: TPlayer;
    spells: TSpells;
    minWin: Longint;
    spellStatus: TSpellStatus;
begin
    // SetLength(test, 5);
    // test[0] := 4;
    // test[1] := 2;
    // test[2] := 1;
    // test[3] := 3;
    // test[4] := 0;
    // player.hp := 10;
    // player.mana := 250;
    // boss.hp := 14;
    // boss.damage := 8;

    // test[0] := 3;
    // test[1] := 0;
    // player.hp := 10;
    // player.mana := 250;
    // boss.hp := 13;
    // boss.damage := 8;

    player.hp := 50;
    player.damage := 0;
    player.armor := 0;
    player.mana := 500;

    boss.hp := 51;
    boss.damage := 9;
    boss.armor := 0;
    boss.mana := 0;

    spells[0].cost := 53;
    spells[0].damage := 4;
    spells[0].armor := 0;
    spells[0].heal := 0;
    spells[0].mana := 0;
    spells[0].instant := true;
    spells[0].turns := 1;

    spells[1].cost := 73;
    spells[1].damage := 2;
    spells[1].armor := 0;
    spells[1].heal := 2;
    spells[1].mana := 0;
    spells[1].instant := true;
    spells[1].turns := 1;

    spells[2].cost := 113;
    spells[2].damage := 0;
    spells[2].armor := 7;
    spells[2].heal := 0;
    spells[2].mana := 0;
    spells[2].instant := false;
    spells[2].turns := 6;

    spells[3].cost := 173;
    spells[3].damage := 3;
    spells[3].armor := 0;
    spells[3].heal := 0;
    spells[3].mana := 0;
    spells[3].instant := false;
    spells[3].turns := 6;

    spells[4].cost := 229;
    spells[4].damage := 0;
    spells[4].armor := 0;
    spells[4].heal := 0;
    spells[4].mana := 101;
    spells[4].instant := false;
    spells[4].turns := 5;

    spellStatus[0] := 0;
    spellStatus[1] := 0;
    spellStatus[2] := 0;
    spellStatus[3] := 0;
    spellStatus[4] := 0;

    minWin := 9999;
    search(player, boss, spellStatus, spells, minWin, 0);
    WriteLn(minWin);
end.

// 681: too low
// 787: too low
// 1216: invalid
// 847: invalid
