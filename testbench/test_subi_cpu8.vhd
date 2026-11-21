library ieee;
use ieee.std_logic_1164.all;

-- testing the subi 
  --SUBI 05-01=04
  --constant prog_subi : rom := (
  --  	0=> x"10", 1 => x"05",  --LDI 5
  -- 	2=> x"12", 3 => x"01", --SUBI 1
  -- 	4=> x"30", --OUT
  --  	5=> x"FF",  --HLT
   -- others => x"FF");

entity test_subi_cpu8 is
end entity;

architecture bench of test_subi_cpu8 is

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
	--out_data should be 04 (05-01)
	wait;
end process;
end architecture;
