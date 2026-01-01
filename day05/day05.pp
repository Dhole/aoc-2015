program day05;

type
    TPair = array[0..1] of Char;
    TPairs = array of TPair;
    TTriple = array[0..2] of Char;
    TTriples = array of TTriple;

function isVowel(c: Char): Boolean;
begin
    if (c = 'a') or (c = 'e') or (c = 'i') or
        (c = 'o') or (c = 'u') then
            isVowel := true
    else
        isVowel := false;
end;

function isNice(s: AnsiString): Boolean;
var
    vowels: longInt = 0;
    twice: Boolean = false;
    bad: Boolean = false;
    c, prev: Char;
begin
    prev := '_';
    for c in s do
    begin
        vowels += Integer(isVowel(c));
        if prev = c then
            twice := true;
        if ((prev = 'a') and (c = 'b')) or
            ((prev = 'c') and (c = 'd')) or
            ((prev = 'p') and (c = 'q')) or
            ((prev = 'x') and (c = 'y')) then
            bad := true;
        prev := c;
    end;
    isNice := (vowels >= 3) and twice and (not bad);
end;

function getPairs(s: AnsiString): TPairs;
var
    i: Longint;
    pair: TPair;
begin
    SetLength(getPairs, Length(s)-1);
    for i := 0 to Length(s) - 2 do
    begin
        pair[0] := s[i+1];
        pair[1] := s[i+2];
        getPairs[i] := pair;
    end;
end;

function getTriples(s: AnsiString): TTriples;
var
    i: Longint;
    triple: TTriple;
begin
    SetLength(getTriples, Length(s)-2);
    for i := 0 to Length(s) - 3 do
    begin
        triple[0] := s[i+1];
        triple[1] := s[i+2];
        triple[2] := s[i+3];
        getTriples[i] := triple;
    end;
end;

function isNice2(s: AnsiString): Boolean;
var
    pair: TPair;
    pairs: TPairs;
    triple: TTriple;
    triples: TTriples;
    i, j: Longint;
    dupPair: Boolean = false;
    dupBetween: Boolean = false;
begin
    pairs := getPairs(s);
    for i := 0 to Length(pairs) - 1 do
    begin
        for j := i + 2 to Length(pairs) - 1 do
        begin
            if pairs[i] = pairs[j] then
                dupPair := true;
        end;
    end;
    triples := getTriples(s);
    for triple in triples do
    begin
        if triple[0] = triple[2] then
            dupBetween := true;
    end;
    // WriteLn('---');
    // for pair in pairs do
    // begin
    //     WriteLn(pair[0], pair[1]);
    // end;
    // for triple in triples do
    // begin
    //     WriteLn(triple[0], triple[1], triple[2]);
    // end;
    isNice2 := dupPair and dupBetween;
end;

var
    line: AnsiString;
    count: Longint = 0;

begin
    While not EOF do
    begin
        ReadLn(line);
        if isNice2(line) then
            count += 1;
    end;
    WriteLn(count);

end.
