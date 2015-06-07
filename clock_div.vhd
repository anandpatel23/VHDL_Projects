-- Anand Patel
-- Digital System Projects
-- Clock Divider
library IEEE;
use STD_LOGIC_1164.ALL;

entity ck_div is 
	port(
		ck, reset: in std_logic;
		z: out std_logic);
end ck_div;

architecture beh of ck_div is
signal ck1: std_logic;
begin
	process(ck) -- this process divides (slows) the system clock frequency by 10**7
	variable count: integer; 
	begin
		if ck = '1' an ck'event then
			if reset = '1' then
				count := 0;
				ck1 <= '0';
			else
				if count = 9999999 then
					ck1 <= not ck1;
					count := 0;
				else 
					count := count + 1;
				end if;
			end if;
		end if;
	end process;
	
	process(ck1) -- we can use ck1 to drive another process
	begin
		if ck1 = '1' then
			z <= '1';
		elsif ck1 = '0' then
			z <= '0';
		else null;
		end if;
	end process;
end beh;