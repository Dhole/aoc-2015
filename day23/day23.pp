program day23;

uses
    StrUtils, Types, sysutils;

type
    TOp = (hlf, tpl, inc, jmp, jie, jio);
    TInst = record
        op: TOp;
        reg: integer;
        imm: integer;
    end;
    TRegs = array[0..1] of uInt64;

function decOp(s: string): TOp;
begin
    if s = 'hlf' then
        decOp := hlf
    else if s = 'tpl' then
        decOp := tpl
    else if s = 'inc' then
        decOp := inc
    else if s = 'jmp' then
        decOp := jmp
    else if s = 'jie' then
        decOp := jie
    else if s = 'jio' then
        decOp := jio
    else
        WriteLn('invalid op: ', s);
end;

function decReg(s: string): integer;
begin
    if s[1] = 'a' then
        decReg := 0
    else if s[1] = 'b' then
        decReg := 1
    else
        WriteLn('invalid reg: ', s);
end;

procedure run(var regs: TRegs; prog: array of TInst);
var
    pc: integer;
    inst: TInst;
begin
    pc := 0;
    while (0 <= pc) and (pc < Length(prog)) do begin
        inst := prog[pc];
        case inst.op of
            hlf: begin
                regs[inst.reg] := regs[inst.reg] div 2;
                pc += 1;
            end; tpl: begin
                regs[inst.reg] := regs[inst.reg] * 3;
                pc += 1;
            end; inc: begin
                regs[inst.reg] := regs[inst.reg] + 1;
                pc += 1;
            end; jmp: begin
                pc += inst.imm;
            end; jie: begin
                if (regs[inst.reg] mod 2) = 0 then
                    pc += inst.imm
                else
                    pc += 1;
            end; jio: begin
                if regs[inst.reg] = 1 then
                    pc += inst.imm
                else
                    pc += 1;
            end;
        end;
    end;
end;

var
    prog: array of TInst;
    line: AnsiString;
    parts: TStringDynArray;
    i, imm, reg: integer;
    op: TOp;
    regs: TRegs;
begin
    SetLength(prog, 128);
    i := 0;
    While not EOF do begin
        ReadLn(line);
        parts := SplitString(line, ' ');
        op := decOp(parts[0]);
        if op = jmp then begin
            reg := 0;
            imm := StrToInt(parts[1]);
        end else if (op = jie) or (op = jio) then begin
            reg := decReg(parts[1]);
            imm := StrToInt(parts[2]);
        end else begin
            reg := decReg(parts[1]);
            imm := 0;
        end;
        prog[i].op := op;
        prog[i].reg := reg;
        prog[i].imm := imm;
        i += 1;
    end;
    SetLength(prog, i);
    regs[0] := 1;
    regs[1] := 0;
    run(regs, prog);
    WriteLn(regs[1]);
end.
