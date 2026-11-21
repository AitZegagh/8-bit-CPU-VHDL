


ISA={
    "NOP" : 0x00,
    "LDI" : 0x10,
    "ADDI" : 0x11,
    "SUBI" : 0x12,
    "ADD" : 0x13,
    "SUB" : 0x14,
    "JMP" : 0x20,
    "JZ" : 0x21,
    "OUT" : 0x30,
    "IN" : 0x31,
    "TAB" : 0x32,
    "HLT" : 0xFF
}

labels ={}
addr=0
instructions = []

f=open("main.asm")

for line in f:
    line=line.strip()
    if line=="" : continue
    parts = line.split()

    if parts[0].endswith(":") :
        name=parts[0][:-1]
        labels[name]=addr
        parts=parts[1:]
        if parts == [] : continue

    if len(parts)>1 : addr=addr+2
    else : addr=addr+1
    instructions.append(parts)
    print(parts)


f.close()

program=[]

for parts in instructions :
    program.append(ISA[parts[0]])
    if len(parts)>1 : 
        if parts[1] in labels : value=labels[parts[1]]
        else : value = int(parts[1],0)
        program.append(value)

program_in_hex = [hex(x) for x in program]
print(program_in_hex)



head = """library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_rom is
  port (addr : in  std_logic_vector(7 downto 0);
        data : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of program_rom is

  type rom is array (0 to 255) of std_logic_vector(7 downto 0);

  constant program_bytes : rom := (
"""

tail = """    others => x"FF");

begin
  data <= program_bytes(to_integer(unsigned(addr)));
end architecture;
"""


out=open("rom_asm.vhd","w")
out.write(head)

for i,b in enumerate(program) :
    out.write(f' {i} => x"{b:02X}",\n')

out.write(tail)
out.close()
