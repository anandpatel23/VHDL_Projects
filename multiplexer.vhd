-- Anand Patel
-- Digital System Projects 
-- 4-input, 1-output Multiplexer
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
	port(
		sel: in std_logic_vector(1 downto 0);
		x: in std_logic_vector(3 downto 0);
		z: out std_logic;
		z_L: out std_logic);
end mux;

architecture beh of mux is
begin

	process(sel, x)
	begin
		case sel is 
			when "00" =>
				z <= x(0);
				z_L <= not x(0);
			when "01" =>
				z <= x(1);
				z_L <= x(1);
			when "10" =>
				z <= x(2);
				z_L <= not x(2);
			when "11" =>
				z <= x(3);
				z_L <= not x(3);
			when others =>
				z <= '1';
				z_L <= '1';
		end case;
	end process;
end beh;