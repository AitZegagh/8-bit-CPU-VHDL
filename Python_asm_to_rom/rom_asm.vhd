library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_rom is
  port (addr : in  std_logic_vector(7 downto 0);
        data : out std_logic_vector(7 downto 0));
end entity;

architecture rtl of program_rom is

  type rom is array (0 to 255) of std_logic_vector(7 downto 0);

  constant program_bytes : rom := (
 0 => x"00",
 1 => x"10",
 2 => x"01",
 3 => x"11",
 4 => x"02",
 5 => x"30",
 6 => x"12",
 7 => x"01",
 8 => x"21",
 9 => x"0C",
 10 => x"20",
 11 => x"05",
 12 => x"30",
 13 => x"FF",
    others => x"FF");

begin
  data <= program_bytes(to_integer(unsigned(addr)));
end architecture;
