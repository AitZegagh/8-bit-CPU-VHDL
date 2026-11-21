library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
	port (clk, rst, a_zero, input_valid: in  std_logic;
	      IR: in  std_logic_vector(7 downto 0);
	      pc_inc,pc_load,ir_load,operand_load,a_load : out std_logic;
	      a_sel : out std_logic_vector(1 downto 0);  --00=data_in_cpu, 01=operand, 10=ALU result
	      alu_op: out std_logic;  --0 = add, 1 = subtract
	      b_sel: out std_logic; --ALU input B: 0-> B=operand, 1->B=register B
	      b_load: out std_logic; -- B<=A
	      out_load : out std_logic;
	      halted : out std_logic);
end entity;

architecture rtl of control_unit is

	type state_t is (FETCH_OPCODE, DECODE, FETCH_OPERAND, EXECUTE, S_HALTED);
	signal state, nstate : state_t;

begin

process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then state <= FETCH_OPCODE;
		else state <= nstate;
		end if;
	end if;
end process;

process(state, IR, input_valid, a_zero)
begin
	--initialization
	pc_inc<= '0';
	pc_load <= '0';
	ir_load <= '0';
	operand_load <= '0';
	a_load  <= '0';
	a_sel <= "00";
	alu_op <= '0';
	b_sel<= '0';
	b_load <= '0';
	out_load <= '0';
	nstate<= state;

	case state is

		when FETCH_OPCODE =>
			ir_load<= '1';
			pc_inc<= '1';
			nstate<= DECODE;

		when DECODE =>
			case IR is
				--instructions: LDI, ADDI, SUBI, JMP, JZ
				when x"10" | x"11" | x"12" | x"20" | x"21" => nstate <= FETCH_OPERAND;

				--instructions: NOP, ADD, SUB, OUT, IN, TAB, HLT
				when x"00" | x"13" | x"14" | x"30" | x"31" | x"32" | x"FF" => nstate <= EXECUTE;
				when others => nstate <= S_HALTED;
			end case;

		when FETCH_OPERAND =>
			operand_load <= '1';
			pc_inc<= '1';
			nstate <= EXECUTE;

		when EXECUTE =>
			nstate <= FETCH_OPCODE;
			case IR is

				when x"00"=> null; --NOP


				when x"10" =>   --LDI v : A<=v
					a_sel <="01";
					a_load <='1';


				when x"11" =>   --ADDI v -> A<=A+v
					a_sel <="10";
					alu_op <='0';
					b_sel <='0';
					a_load <='1';


				when x"12" =>    --SUBI v -> A <=A-v
					a_sel <="10";
					alu_op <='1';
					b_sel <='0';
					a_load <='1';


				when x"13" =>    --ADD -> A<= A+B
					a_sel <= "10";
					alu_op <= '0';
					b_sel <= '1';
					a_load <= '1';


				when x"14" =>     --SUB -> A<=A-B
					a_sel <= "10";
					alu_op <= '1';
					b_sel <= '1';
					a_load <= '1';

				when x"20" =>   --JMP
					pc_load <= '1';


				when x"21" =>  --JZ
					if a_zero = '1' then pc_load <= '1';
					end if;


				when x"30" =>  --OUT
					out_load <= '1';


				when x"31" =>  --IN
					if input_valid = '1' then
						a_sel  <= "00";
						a_load <= '1';
					else
						nstate <= EXECUTE;
					end if;



				when x"32" =>    --TAB : B <= A
					b_load <= '1';


				when x"FF" =>    --HLT
					nstate <= S_HALTED;


				when others =>
					nstate <= S_HALTED;


			end case;

		when S_HALTED =>
			nstate <= S_HALTED; --use rst to get out

	end case;
end process;

	halted <= '1' when state = S_HALTED else '0';

end architecture;
