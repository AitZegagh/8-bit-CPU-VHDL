library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_rom is
	port (addr : in  std_logic_vector(7 downto 0);
	      data : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of program_rom is

	type rom is array (0 to 255) of std_logic_vector(7 downto 0);

	constant prog_inout : rom := (
		0=> x"31", --IN
		1=> x"30", --OUT
		2=> x"FF", --HLT
		others => x"FF");

	constant prog_ldi : rom := (
		0=> x"00",--NOP
		1=> x"10", 2 => x"0B",--LDI 0B
		3=> x"30", --OUT
		4=> x"FF", --HLT
		others => x"FF");

	--A+B
	constant prog_add : rom := (
		0=> x"31",  --IN A
		1=> x"32", --copy  B = A
		2=> x"31", --IN the second value of A
		3=> x"13",  --ADD A = A + B
		4=> x"30", --OUT
		5=> x"FF", --HLT
		others => x"FF");

	--A-B,  same logic as the add
	constant prog_sub : rom := (
		0=> x"31",
		1=> x"32",
		2=> x"31",
		3=> x"14",   --SUB
		4=> x"30",
		5=> x"FF",
		others => x"FF");

	--LDI and ADD A=B+v
	constant prog_ldi_add : rom := (
		0=> x"10",1=> x"0B",  --LDI 0B
		2=> x"32",   --TAB B = 0B
		3=> x"10",4=> x"03", --LDI 03
		5=> x"13",  --ADD A=03+0B
		6=> x"30", --OUT
		7=> x"FF",  --HLT
		others => x"FF");

	--ADDI 05+03=08
	constant prog_addi : rom := (
		0=> x"10", 1=> x"05",--LDI 5
		2=> x"11", 3=> x"03", --ADDI 3
		4=> x"30", --OUT
		5=> x"FF", --HLT
		others => x"FF");



	--SUBI 05-01=04
	constant prog_subi : rom := (
		0=> x"10", 1 => x"05",  --LDI 5
		2=> x"12", 3 => x"01", --SUBI 1
		4=> x"30", --OUT
		5=> x"FF",  --HLT
		others => x"FF");


	--JMP
	constant prog_jmp : rom := (
		0=> x"10", 1 => x"22",  --LDI 22
		2=> x"20", 3 => x"06", --JMP 06 (skip 4 and 5)
		4=> x"10", 5 => x"11", -- LDI 11 (instruction skipped)
		6=> x"30",  -- OUT
		7=> x"FF",  -- HLT
		others => x"FF");

	--jump if A=0
	constant prog_jz_taken : rom := (
		0=> x"10", 1=> x"00",--LDI 0
		2=> x"21", 3=> x"08",  --JZ 08
		4=> x"10", 5=> x"11", --LDI 11 (skipped)
		6=> x"30", --OUT
		7=> x"FF",  --HLT
		8=> x"10", 9=> x"22", --LDI 22
		10=> x"30",  --OUT
		11=> x"FF",  --HLT
		others => x"FF");


	--countdown from 03 to 00
	constant prog_countdown : rom := (
		0=> x"00", --NOP
		1=> x"10",2=> x"01", --LDI 1
		3=> x"11",4=> x"02",--ADDI 2
		5=> x"30", --OUT
		6=> x"12",7=> x"01",--SUBI 1
		8=> x"21",9=> x"0C",--JZ 0C(jump to 13 if A=0)
		10=> x"20",11 => x"05",--JMP 05
		12=> x"30", --OUT
		13=> x"FF", --HLT
		others => x"FF");

	--choose the program here
	constant program_bytes : rom := prog_countdown;

begin

	data <= program_bytes(to_integer(unsigned(addr)));

end architecture;
