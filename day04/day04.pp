program day04;

uses
    md5, sysutils;

var
    input, messageStr: AnsiString;
    message: array of byte;
    digest: Hash;
    i, j: Longint;
    b: byte;

begin

    // digest := md5.md5([65]);
    // for b in digest do
    //     Write(IntToHex(b));
    // WriteLn();

    ReadLn(input);

    // i := 609043;
    // messageStr := Format('%s%d', [input, i]);
    // SetLength(message, Length(messageStr));
    // for i := 0 to Length(messageStr) - 1 do
    //     message[i] := Byte(messageStr[i+1]);
    // for i := 0 to Length(message) - 1 do
    // digest := md5.md5(message);
    // for b in digest do
    //     Write(IntToHex(b));
    // WriteLn();

    for i := 0 to 999999999 do
    begin
        messageStr := Format('%s%d', [input, i]);
        SetLength(message, Length(messageStr));
        for j := 0 to Length(messageStr) - 1 do
            message[j] := Byte(messageStr[j+1]);
        digest := md5.md5(message);
        if (digest[0] = 0) and
            (digest[1] = 0) and
            // ((digest[2] and $f0) = 0) then
            (digest[2] = 0) then
            Break;
    end;
    WriteLn(i);
    for b in digest do
        Write(IntToHex(b));
    WriteLn();

end.
