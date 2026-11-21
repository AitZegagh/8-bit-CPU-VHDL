library ieee;
use ieee.std_logic_1164.all;

 --countdown from 03 to 00
 -- constant prog_countdown : rom := (
    --0=> x"00", --NOP
    --1=> x"10",2=> x"01", --LDI 1
    --3=> x"11",4=> x"02",--ADDI 2
    --5=> x"30", --OUT
    --6=> x"12",7=> x"01",--SUBI 1
    --8=> x"21",9=> x"0C",--JZ 0C(jump to 13 if A=0)
    --10=> x"20",11 => x"05",--JMP 05
    --12=> x"30", --OUT
    --13=> x"FF", --HLT
    --others => x"FF");

entity test_countdown_cpu8 is
end entity;

architecture bench of test_countdown_cpu8 is

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal input_valid : std_logic := '0';
	signal halted : std_logic;

	signal imem_addr, imem_data, out_data : std_logic_vector(7 downto 0);
	signal data_in_cpu : std_logic_vector(7 downto 0) := (others => '0');

begin
	i_rom : entity work.program_rom port map (addr => imem_addr, data => imem_data);

	i_cpu : entity work.cpu8
   		 port map (clk => clk, rst => rst,
                 imem_addr => imem_addr, imem_data => imem_data,
                 data_in_cpu => data_in_cpu, input_valid => input_valid,
                 out_data => out_data, halted => halted);

		clk <= not clk after 5 ns;

process
	begin
    --initialization
	rst <= '1';
	input_valid <= '0';
	data_in_cpu <= x"00";
	wait for 22 ns;
	rst <= '0';
	wait until halted = '1';
	wait for 20 ns;
	wait;
       --out_data must take 03, then 02, then 01, then 00
    
  end process;

end architecture;

