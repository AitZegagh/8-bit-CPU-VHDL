
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu8 is
  	port (A : in  std_logic_vector(7 downto 0);  
       	  B : in  std_logic_vector(7 downto 0);  
      	  AS: in  std_logic;  --0 for add and 1 for sub
       	  result : out std_logic_vector(7 downto 0));
end entity;


architecture rtl of alu8 is
begin
result<=std_logic_vector(unsigned(A) + unsigned(B)) when AS = '0' else std_logic_vector(unsigned(A) - unsigned(B));
end rtl;


