
library ieee;
use ieee.std_logic_1164.all;

-- testting the sub : 9-5=4
  --A-B,  same logic as the add 
  --constant prog_sub : rom := (
    --0=> x"31", 
    --1=> x"32",
    --2=> x"31",                           
    --3=> x"14",   --SUB                       
    --4=> x"30",                          
    --5=> x"FF",                          
    --others => x"FF");
entity test_sub_cpu8 is
end entity;

architecture bench of test_sub_cpu8 is

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
	wait for 50 ns;

	--First value: 05
	data_in_cpu <= x"05";  input_valid <= '1';
	wait until rising_edge(clk);
	wait for 1 ns;
	input_valid <= '0';
	wait for 80 ns;

	--second value: 09
	data_in_cpu <= x"09";  input_valid <= '1';
	wait until rising_edge(clk);
	wait for 1 ns;
	input_valid <= '0';

	wait until halted = '1' for 500 ns;
	wait for 20 ns;
	--out_data should be 04 (09-05)
	wait;
end process;
end architecture;