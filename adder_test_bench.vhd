----------------------------
-- Adder Test Bench Solution
-- 1. p1_pack, 2. sh_reg, 3. control, 4. serial_adder
-- 5. adder, 6. adder_test_bench
----------------------------

---------------------------------------------------------
-- 1. p1_pack
---------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Package p1_pack is
Type sh_reg_sel is (no_op, load, shift);
End p1_pack;

---------------------------------------------------------
-- 2. sh_reg
---------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all, work.p1_pack.all;
Entity sh_reg is
Generic (n : natural := 4); -- specifiable parameter (default to 4)
Port (x : in std_logic_vector(n-1 downto 0);
      z : out std_logic;
      Sel : in sh_reg_sel;
      Ck : in std_logic);
End sh_reg; 

Architecture behav of sh_reg is
Signal temp : std_logic_vector(n-1 downto 0); -- holds the input
Begin -- architecture body 
  
process(ck)
begin
if ck = '1' and ck'event then  
case sel is
  when no_op => null;
  when load => temp <= x;
  when shift =>
    for i in n-2 downto 0 loop
      temp(i) <= temp (i+1); -- temp(i) refers to the i-th bit of temp
    end loop;
end case;
end if;
end process; 

z <= temp(0);

end behav;

---------------------------------------------------------------
-- 3. control
---------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all, work.p1_pack.all;
Entity control is
  port (go, ck, reset, done : in std_logic;
        sel : out sh_reg_sel;
        en : out std_logic);
end control;

architecture behav of control is -- declare enumeration type
type state is (idle, loading, shifting); -- internal state called n_s (next state)
signal n_s : state;
begin 
process(ck)
begin
  if ck = '1' and ck'event then -- ck rising edge fence
    if reset = '1' then n_s <= idle; else -- reset fence
      Case n_s is
    when idle =>
      -- assign control signals
      en <= '1'; -- serial_adder: no reset
      sel <= no_op; -- sh_reg's: no operation
      -- State Transition
      if go = '1' then n_s <= loading;
      end if;
    when loading =>
      -- assign control signals
      en <= '0'; -- serial_adder: reset
      sel <= load; -- sh_reg's: load
      -- state transition
      n_s <= shifting;
    when shifting =>
      -- assign control signals and state transition
      en <= '1'; -- serial_adder: no reset
      sel <= shift; -- sh_reg's: shift
      -- State Transition
      if done = '1' then n_s <= idle;
      end if;
    end case;
  end if;
end if;
end process;
end behav;

-----------------------------------------------------------
-- 4. serial_adder
-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

ENTITY serial_adder IS
  Generic(n : natural := 8);
PORT ( 
	SIGNAL a , b , clk, en : IN std_logic ;
	SIGNAL s : OUT std_logic_vector (N-1 DOWNTO 0);
	SIGNAL cout, done :OUT std_logic );
END serial_adder;

ARCHITECTURE behav OF serial_adder IS
   SIGNAL state , carry, sum : std_logic ;
   SIGNAL temp : std_logic_vector (N-1 DOWNTO 0) ;
        
BEGIN
trans_and_count :PROCESS ( clk , en )
   VARIABLE counter : INTEGER := 0;
   BEGIN
        IF (en = '0') THEN  -- reset.
            state <= '0';
            counter := 0;
            temp <= (others => '0');
            done <= '0';
        ELSIF clk = '1' and clk'event THEN
            IF (counter < N) THEN -- move to next bit
				done <= '0';
                state <= carry;
                counter := counter + 1;
                temp(N-1) <= sum;
                FOR i IN N-2 DOWNTO 0 LOOP
                    temp(i) <= temp(i+1);
                END LOOP;
            ELSE             -- the addition is done.
                done <= '1';
            END IF;
        END IF ;
   END PROCESS trans_and_count;
   -- wire state (storage for carry synch with ck) to Port cout
   cout <= state;

   output : PROCESS ( a , b , state )
   BEGIN
        sum <= a XOR b XOR state;   
        carry <= (a AND b) OR (a AND state) OR (b AND state);
   END PROCESS output;


   s <= temp; --wire to output

END behav;

--------------------------------------------------------------
-- 5. adder
--------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all, work.p1_pack.all;

Entity adder is
Generic (K: natural := 4); -- k will be mapped onto the components used
Port ( a, b : in std_logic_vector(k-1 downto 0);
        C : out std_logic_vector(k-1 downto 0);
        C_out : out std_logic;
        Go,reset,ck : in std_logic);
End adder;

Architecture struc of adder is
-- Component declaration (copy-paste of entity declaration)

component serial_adder
generic(N : natural := 8);
port (a,b,clk,en : IN std_logic ;
s : OUT std_logic_vector (N-1 DOWNTO 0);
cout, done : OUT std_logic );
end component;

-- declare other components here

component sh_reg
Generic (n : natural := 4); -- specifiable parameter (default to 4)
Port (x : in std_logic_vector(n-1 downto 0);
      z : out std_logic;
      Sel : in sh_reg_sel;
      Ck : in std_logic);
End component;

component control
port (go, ck, reset, done : in std_logic;
        sel : out sh_reg_sel;
        en : out std_logic);
end component;


-- Internal signals (wires)
signal sel : sh_reg_sel;
signal a_bit,b_bit,done,en : std_logic;

begin

-- instantiation and wiring

s_adder: serial_adder generic map(k)
           port map(a_bit,b_bit,ck,en,c,c_out,done);
reg_A:   sh_reg       generic map(k)
           port map(a,a_bit,sel,ck);
reg_B:   sh_reg       generic map(k)
           port map(b,b_bit,sel,ck);
ctrl:    control
           port map(Go, ck, reset, done, sel, en);

end struc;
--------------------------------------------------------------------
-- 6. adder_test_bench
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL, ieee.std_logic_arith.all,
ieee.std_logic_unsigned.all;

-- test bench for adder

entity adder_test_bench is
constant number_of_test : natural := 3;
constant n : natural := 4;
end adder_test_bench;

architecture beh of adder_test_bench is
-- declaration phase
-- wires
signal go, reset, cout : std_logic;
signal ck : std_logic := '0';
signal a, b, c : std_logic_vector(n-1 downto 0);
-- test vectors
type test_array is array (natural range <>) of std_logic_vector(n-1 downto 0);
signal A_test : test_array(0 to number_of_test - 1):=("1101","1100","0110");
signal B_test : test_array(0 to number_of_test - 1):=("0101","1001","0111");
-- state machine (tester)
type tester_state is (init, test, check);
signal n_s : tester_state;

component adder
Generic (K: natural := 4); -- k will be mapped onto the components used
Port ( a, b : in std_logic_vector(k-1 downto 0);
        C : out std_logic_vector(k-1 downto 0);
        C_out : out std_logic;
        Go,reset,ck : in std_logic);
end component;

begin
-- instantiate device-under-test
dut: adder generic map(n) 
      port map(a, b, c, cout, go, reset, ck);
-- clock generation
ck <= not ck after 50 ns;
-- test procedure
process(ck)
variable count_vector : integer := 0;
variable count_cycle : integer;
begin
if ck'event and ck = '1' then
	case n_s is
		when init => count_cycle := 0;
			a <= A_test(count_vector); 
			b <= B_test(count_vector);
			n_s <= test;
			go <= '1'; reset <= '0'; -- upon leaving init set go and don't reset
		when test => count_cycle := count_cycle + 1;
			if count_cycle = n + 5 then n_s <= check;
				go <= '0'; reset <= '0';
			end if;
		when check =>
			assert(conv_integer(unsigned(cout&c)) = conv_integer(unsigned(a)) +
			conv_integer(unsigned(b))) report "INCORRECT RESULT" severity ERROR;
			count_vector := count_vector + 1;
			assert count_vector /= number_of_test report "Test completed" severity FAILURE;
			go <= '0'; reset <= '1';
			n_s <= init;
	end case;
end if;
end process;
end beh;
