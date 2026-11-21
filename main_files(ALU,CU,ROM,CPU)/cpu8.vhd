library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu8 is
	port (clk, rst : in  std_logic;
	      imem_addr  : out std_logic_vector(7 downto 0);
	      imem_data : in  std_logic_vector(7 downto 0);
	      data_in_cpu : in  std_logic_vector(7 downto 0);
	      input_valid : in  std_logic;
	      out_data : out std_logic_vector(7 downto 0);
	      halted  : out std_logic);
end entity;

architecture dataflow of cpu8 is


	signal pc, ir, operand, a_reg, b_reg, out_reg : std_logic_vector(7 downto 0) := (others => '0');

	signal a_next, alu_result, alu_b : std_logic_vector(7 downto 0);
	signal a_zero : std_logic;

	signal pc_inc, pc_load, ir_load, operand_load : std_logic;
	signal a_load, alu_op, b_sel, b_load, out_load : std_logic;
	signal a_sel : std_logic_vector(1 downto 0);

begin

	CU: entity work.control_unit
	port map (clk => clk, rst => rst, IR => ir,
	          input_valid => input_valid, a_zero => a_zero,
	          pc_inc => pc_inc, pc_load => pc_load,
	          ir_load => ir_load, operand_load => operand_load,
	          a_load => a_load, a_sel => a_sel,
	          alu_op => alu_op, b_sel => b_sel, b_load => b_load,
	          out_load => out_load, halted => halted);

	--Input B is the operand for ADDI, SUBI and register B is for ADD, SUB
	alu_b   <= operand when b_sel = '0' else b_reg;

	u_alu : entity work.alu8
	port map (A => a_reg, B => alu_b, AS => alu_op, result => alu_result);

	a_zero <= '1' when a_reg = x"00" else '0';

	--where the new value of A comes from
	with a_sel select
	a_next <= data_in_cpu when "00",
	          operand     when "01",
	          alu_result  when others; -- "10"

	imem_addr <= pc;
	out_data  <= out_reg;


process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			pc      <= (others => '0');
			ir      <= (others => '0');
			operand <= (others => '0');
			a_reg   <= (others => '0');
			b_reg   <= (others => '0');
			out_reg <= (others => '0');
		else
			if ir_load = '1' then
				ir <= imem_data;
			end if;

			if operand_load = '1' then
				operand <= imem_data;
			end if;

			if a_load = '1' then
				a_reg <= a_next;
			end if;

			if b_load = '1' then
				b_reg <= a_reg;
			end if;

			if out_load = '1' then
				out_reg <= a_reg;
			end if;

			if pc_load = '1' then
				pc <= operand;
			elsif pc_inc = '1' then
				pc <= std_logic_vector(unsigned(pc) + 1);
			end if;
		end if;
	end if;
end process;

end architecture;
