-- Anand Patel
-- Digital System Projects
-- Array Multiplier
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity arrayMult is
	port (
		x, y: in std_logic_vector(3 downto 0);
        p: out std_logic_vector(7 downto 0));
end arrayMult;

architecture struc of arrayMult is
type twoD is array (natural range <>, natural range <>) of std_logic;
signal xi,yi,psi,ci: twoD(3 downto 0, 3 downto 0);

component pe
	port (
		xi, yi, psi, ci: in std_logic;
		xo, yo, pso, co: out std_logic);
end component;

begin

INTX: for j in 0 to 3 generate
      xi(0,j) <= x(j); 
	  psi(0, j) <= '0';
end generate INTX;

INTY: for i in 0 to 3 generate
      yi(i,0) <= y(i); 
	  ci(i, 0) <= '0';
end generate INTY;	

G1: for i in 0 to 3 generate
	G2: for j in 0 to 3 generate
		G3: if j = 0 AND i < 3 generate
			ELM: pe port map(xi(i,j),yi(i,j),psi(i,j),ci(i,j), xi(i,j+1),yi(i+1,j),p(i),ci(i,j+1));
		end generate G3;
		G4: if j > 0 AND j < 3 AND i < 3 generate
			ELM: pe port map(xi(i,j),yi(i,j),psi(i,j),ci(i,j), xi(i,j+1),yi(i+1,j),psi(i+1,j-1),ci(i,j+1));
		end generate G4;
		G5: if j = 3 AND i < 3 generate
			ELM: pe port map(xi(i,j),yi(i,j),psi(i,j),ci(i,j), xi(i+1,j),open ,psi(i+1,j-1),psi(i+1,j));
		end generate G5;
		G6: if j < 3 AND i = 3 generate
			ELM: pe port map(xi(i,j),yi(i,j),psi(i,j),ci(i,j), open, yi(i,j+1),p(i+j),ci(i,j+1));
		end generate G6;	
		G7: if j = 3 AND i = 3 generate
			ELM: pe port map(xi(i,j),yi(i,j),psi(i,j),ci(i,j), open, open,p(i+j),p(i+j+1));
		end generate G7;
	end generate G2;
end generate G1;
end struc;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pe is
	port(
		xi, yi, psi, ci: in std_logic;
		xo, yo, pso, co: out std_logic);
end pe;

architecture Behavioral of pe is
signal w: std_logic;
begin
	xo <= xi; 
	yo <= yi; 
	pso <= w XOR ci XOR psi;
	co <= (psi AND w) OR (w AND ci) OR (ci AND psi);
	w <= xi AND yi;
end Behavioral;
