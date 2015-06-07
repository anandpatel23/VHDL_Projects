-- Anand Patel
-- Digital System Projects
-- Serial Adder 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serial_adder is 
	port(
		signal a, b, ck, en, b1, b2: in std_logic;
		signal s: out std_logic_vector(4 downto 0);
		signal cout, done: out std_logic);
end serial_adder;

architecture beh of serial_adder is 
signal state, carry, sum, clk: std_logic;
signal temp: std_logic_vector(4 downto 0);
type db_state is (not_rdy, rdy, pulse);
signal db_ns: db_state;
begin
	process(clk, en)
	variable counter: integer := 0;
	begin
		if en = '0' then -- reset
			state <= '0';
			counter := 0;
			temp <= (others => '0');
			done <= '0';
		elsif clk = '1' and clk'event then
			if (counter < 5) then -- move to next bit
				state <= carry;
				counter := counter + 1;
				temp(4) <= sum;
				done <= '1';
				for i in 3 downto 0 loop
					temp(i) <= temp(i+1);
				end loop;
			else -- the addition is done
				done <= '1';
			end if;
		end if;
	end process;
	
	-- wire state (storage for carry synch with clk) to Port cout
	cout <= state;
	
	-- full adder computing sum and carry
	process(a, b, state)
	begin
		sum <= a XOR b XOR state;
		carry <= (a AND b) OR (a AND state) OR (b AND state);
	end process;
	
	sum <= temp; -- wire to output 
	
	-- single step
	process(ck, b1, b2)
	begin
		if ck = '1' and ck'event then 
			case db_ns is 
				when not_rdy =>
					if b2 = '1' then
						db_ns <= rdy;
					end if;
					clk <= '0';
				when rdy =>
					if b1 = '1' then
						db_ns <= pulse;
					end if;
					clk <= '0';
				when pulse =>
					db_ns <= not_rdy;
					clk <= '1';
				when others => null;
			end case;
		end if;
	end process;
end beh;