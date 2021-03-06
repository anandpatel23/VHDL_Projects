-- Anand Patel
-- Digital System Projects
-- Block RAM -> implement random access memory as a block RAM generated by block memory generator
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity block_ram16x4 is 
	port(
		ck, output_en: in std_logic;
		wen: in std_logic_vector(0 downto 0);
		addr: in std_logic_vector(3 downto 0);
		din: in std_logic_vector(3 downto 0);
		dout: out std_logic_vector(3 downto 0));
end block_ram16x4;

architecture struc of block_ram16x4 is 

component blk_mem_gen_0
	port(
		clka: in std_logic;
		ena: in std_logic;
		wea: in std_logic_vector(0 downto 0);
		addra: in std_logic_vector(3 downto 0);
		dina: in std_logic_vector(3 downto 0);
		douta: out std_logic_vector(3 downto 0));
end component;

begin
	U2: blk_mem_gen_0
		port map(
			clka => ck,
			ena => output_en,
			wea => wen,
			addra => addr,
			dina => din,
			douta => dout);
end struc;