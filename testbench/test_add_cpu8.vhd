library ieee;
use ieee.std_logic_1164.all;

--testting the add 
--A+B
  --constant prog_add : rom := (
    --0=> x"31",  --IN A 
    --1=> x"32", --TAB (copy  B=A)
    --2=> x"31", --IN the second value of A
    --3=> x"13",  --ADD A = A + B
    --4=> x"30", --OUT
    --5=> x"FF", --HLT
    --others => x"FF");
entity test_add_cpu8 is
end entity;

architecture bench of test_add_cpu8 is

	signal clk, rst : std_logic := '0';
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
               
	 --second value: 03
	data_in_cpu <= x"03";  input_valid <= '1';
	wait until rising_edge(clk);
	wait for 1 ns;
	input_valid <= '0';

	wait until halted = '1' for 500 ns;
	wait for 20 ns;
	wait;
	--result should be 08

end process;
end architecture;
