
library ieee;
use ieee.std_logic_1164.all;

--jump if A=0
  --constant prog_jz_taken : rom := (
    	--0=> x"10", 1=> x"00",--LDI 0
    	--2=> x"21", 3=> x"08",  --JZ 08 (A=0 so jump to adress 08)
    	--4=> x"10", 5=> x"11", --LDI 11 
    	--6=> x"30", --OUT
   	--7=> x"FF",  --HLT
   	--8=> x"10", 9=> x"22", --LDI 22
    	--10=> x"30",  --OUT
    	--11=> x"FF",  --HLT
    	--others => x"FF");

entity test_jz_taken_cpu8 is
end entity;

architecture bench of test_jz_taken_cpu8 is

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
	wait until halted = '1' for 500 ns;
	wait for 20 ns;
	--out_data should be at 22 because we skipped LDI 11 and jumped straight to the adress 08
	wait;
end process;
end architecture;
