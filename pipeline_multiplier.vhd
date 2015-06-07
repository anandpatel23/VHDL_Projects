-- Anand Patel
-- Digital System Projects
-- Pipeline Multplier
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipeline_multiplier is
	port(
		x: in std_logic_vector(2 downto 0);
		ck, b1, b2, reset, y: in std_logic;
		p: out std_logic);
end pipeline_multiplier;

architecture Behavioral of pipeline_multiplier is

signal yy, cc, ppss: std_logic_vector(2 downto 0);
signal en, w, pp: std_logic;
type state is (s0, s1, s2);
signal n_s: state;


component pmult_pe
	port( 
		xi, yi, psi, ci, ck, reset: in std_logic;
        yo, pso, co: out std_logic);
end component;

begin
	p <= pp; -- serial output of the pipeline multiplier
	cc(0) <= '0'; 
	yy(0) <= y; -- serial multiplier input
	
	G1: for i in 0 to 2 generate
		G2: if i = 0 generate
			U: pmult_pe port map(x(i), yy(i), ppss(i), cc(i), en, reset, yy(i+1), pp, cc(i+1));
		end generate G2;
		G3: if i > 0 AND i < 2 generate
			U: pmult_pe port map(x(i), yy(i), ppss(i), cc(i), en, reset, yy(i+1), ppss(i-1), cc(i+1));
		end generate G4;
		G4: if i = 2 generate
			U: pmult_pe port map(x(i), yy(i), ppss(i), cc(i), en, reset, open, ppss(i-1), w);					  
		end generate G4;
	end generate G1;

	process(en)
	variable temp: std_logic;
	begin
		if en='1' AND en'event then
			if reset = '1' then 
				temp := '0'; 
			else
				temp := w;
			end if;
		end if;
		ppss(2) <= temp;
	end process;

	process(ck)
	begin
		if ck'event AND ck='1' then
			case n_s is
				when s0 => 
					en <= '0';
					if b1 = '1' then 
						n_s <= s1; 
					end if;
				when s1 => 
					en <= '1';
					n_s <= s2;
				when s2 => 
					en <= '0';
					if b2 = '1' then 
						n_s <= s0; 
					end if;
			end case;
		end if;
	end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pmult_pe is
	port(
		xi, yi, psi, ci, ck, reset: in std_logic;
        yo, pso, co: out std_logic);
end pmult_pe;

architecture Behavioral of pmult_pe is
signal temp1, temp2, temp3: std_logic;
begin
	process(ck)
	begin
		if ck='1' AND ck'event then
			if reset ='1' then 
				temp1 <= '0'; 
				temp2 <= '0'; 
				temp3 <= '0'; 
			else
				temp1 <= yi;
				temp2 <= psi XOR ci XOR (xi AND yi);
				temp3 <= (psi AND ci) OR (ci AND xi AND yi) OR (xi AND yi AND psi);
			end if;
		end if;
	end process;
	yo <= temp1;
	pso <= temp2;
	co <= temp3;
end Behavioral;
