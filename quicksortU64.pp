unit QuicksortU64;

interface
    type
        TArray = array of uInt64;

    procedure sort(a: TArray);

implementation

    procedure swap(a: TArray; i: Longint; j: Longint);
    var
        tmp: uInt64;
    begin
        tmp := a[i];
        a[i] := a[j];
        a[j] := tmp;
    end;

    function partition(a: TArray; lo: Longint; hi: Longint): Longint;
    var
        i, j: Longint;
        pivot: uInt64;
    begin
        pivot := a[hi];
        i := lo;
        for j := lo to hi - 1 do
        begin
            if a[j] <= pivot then
            begin
                swap(a, i, j);
                i := i + 1
            end;
        end;
        swap(a, i, hi);
        partition := i;
    end;

    procedure quicksort(a: TArray; lo: Longint; hi: Longint);
    var
        p: Longint;
    begin
        if (lo >= hi) or (lo < 0) then
            exit;
        p := partition(a, lo, hi);
        quicksort(a, lo, p - 1);
        quicksort(a, p + 1, hi);
    end;

    procedure sort(a: TArray);
    begin
        quicksort(a, 0, length(a) - 1);
    end;
end.

// var
//     input: Tarray;
//     x: Longint;
// 
// begin
//     setLength(input, 5);
//     input[0] := 5;
//     input[1] := 4;
//     input[2] := 3;
//     input[3] := 6;
//     input[4] := 1;
//     sort(input);
//     for x in input do
//         writeLn(x);
// end.
