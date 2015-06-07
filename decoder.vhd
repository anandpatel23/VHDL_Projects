-- Anand Patel
-- Digital System Projects
-- 2 to 4 decoder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is 
	port(
		x: in std_logic_vector(1 downto 0);
		en: in std_logic;
		z: out std_logic_vector(3 downto 0));
end decoder;

architecture beh of decoder is 
	process(x, en)
	begin
		if en = '0' then
			z(0) <= '0';
			z(1) <= '0';
			z(2) <= '0';
			z(3) <= '0';
		else
			case x is 
				when "00" =>
					z(0) <= '1';
					z(1) <= '0';
					z(2) <= '0';
					z(3) <= '0';
				when "01" =>
					z(0) <= '0';
					z(1) <= '1';
					z(2) <= '0';
					z(3) <= '0';
				when "10" =>
					z(0) <= '0';
					z(1) <= '0';
					z(2) <= '1';
					z(3) <= '0';
				when "11" =>
					z(0) <= '0';
					z(1) <= '0';
					z(2) <= '0';
					z(3) <= '1';
			end case;
		end if;
	end process;
end beh;