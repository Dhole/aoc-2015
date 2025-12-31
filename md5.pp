unit md5;

interface
    type
        u32 = longWord;
        Bytes = array of byte;
        Hash = array[0..16-1] of byte;

    function md5(input: Bytes): Hash;

implementation

    uses
        sysutils;

    const
        s: array[0..63] of u32 =
            (7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
             5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
             4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
             6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21);
        K: array[0..63] of u32 =
            ($d76aa478, $e8c7b756, $242070db, $c1bdceee,
             $f57c0faf, $4787c62a, $a8304613, $fd469501,
             $698098d8, $8b44f7af, $ffff5bb1, $895cd7be,
             $6b901122, $fd987193, $a679438e, $49b40821,
             $f61e2562, $c040b340, $265e5a51, $e9b6c7aa,
             $d62f105d, $02441453, $d8a1e681, $e7d3fbc8,
             $21e1cde6, $c33707d6, $f4d50d87, $455a14ed,
             $a9e3e905, $fcefa3f8, $676f02d9, $8d2a4c8a,
             $fffa3942, $8771f681, $6d9d6122, $fde5380c,
             $a4beea44, $4bdecfa9, $f6bb4b60, $bebfbc70,
             $289b7ec6, $eaa127fa, $d4ef3085, $04881d05,
             $d9d4d039, $e6db99e5, $1fa27cf8, $c4ac5665,
             $f4292244, $432aff97, $ab9423a7, $fc93a039,
             $655b59c3, $8f0ccc92, $ffeff47d, $85845dd1,
             $6fa87e4f, $fe2ce6e0, $a3014314, $4e0811a1,
             $f7537e82, $bd3af235, $2ad7d2bb, $eb86d391);

    function BytesToU32(input: Bytes; i: Longint): u32;
    begin
        BytesToU32 := input[i] + (input[i+1] << 8) +
            (input[i+2] << 16) + (input[i+3] << 24);
    end;

    procedure U32ToBytes(var dst: Hash; i: LongInt; v: u32);
    begin
        dst[i] := v and $ff;
        dst[i+1] := (v >> 8) and $ff;
        dst[i+2] := (v >> 16) and $ff;
        dst[i+3] := (v >> 24) and $ff;
    end;

    function leftrotate(x: u32; r: Longint): u32;
    begin
        leftrotate := (x << r) + (x >> (32 - r));
    end;

    function md5(input: Bytes): Hash;
    var
        message: array of byte;
        a0, b0, c0, d0: u32;
        A, B, C, D: u32;
        F, g: u32;
        M: array of u32;
        i, j: Longint;
        len: Longint;

    begin
        a0 := $67452301;
        b0 := $efcdab89;
        c0 := $98badcfe;
        d0 := $10325476;

        len := ((Length(input) + 9) Div 64) * 64;
        if ((Length(input) + 9) Mod 64) <> 0 then
            len += 64;
        SetLength(message, Int64(len));
        for i := 0 to Length(input) - 1 do
            message[i] := input[i];
        message[Length(input)] := $80;
        for i := Length(input) + 1 to Length(message) - 8 - 1 do
            message[i] := 0;
        for i := 0 to 8 - 1 do
            message[Length(message) - 8 + i] :=
                ((Length(input) * 8) >> (i * 8)) and $ff;

        SetLength(M, 16);
        for j := 0 to (Length(message) div 64) - 1 do
        begin
            for i := 0 to 16 - 1 do
                M[i] := BytesToU32(message, 64*j + 4*i);
            A := a0;
            B := b0;
            C := c0;
            D := d0;

            for i := 0 to 64 - 1 do
            begin
                if i < 16 then
                begin
                    F := (B and C) or ((not B) and D);
                    g := i;
                end
                else if (16 <= i) and (i < 32) then
                begin
                    F := (D and B) or ((not D) and C);
                    g := (5*i + 1) Mod 16;
                end
                else if (32 <= i) and (i < 48) then
                begin
                    F := B xor C xor D;
                    g := (3*i + 5) Mod 16;
                end
                else
                begin
                    F := C xor (B or (not D));
                    g := (7*i) Mod 16;
                end;

                F := F + A + K[i] + M[g];
                A := D;
                D := C;
                C := B;
                B := B + leftrotate(F, s[i]);
            end;

            a0 := a0 + A;
            b0 := b0 + B;
            c0 := c0 + C;
            d0 := d0 + D;
        end;

        U32ToBytes(md5, 0, a0);
        U32ToBytes(md5, 4, b0);
        U32ToBytes(md5, 8, c0);
        U32ToBytes(md5, 12, d0);
    end;
end.

// var
//     digest: Hash;
//     b: byte;
// begin
//     digest := md5([]);
//     for b in digest do
//         Write(IntToHex(b));
//     WriteLn();
//     // WriteLn(BytesToU32([1, 2, 3, 4], 0));
// end.
