--+----------------------------------------------------------------------------
--| 
--| DESCRIPTION   : This file implements the top level module for a BASYS 
--|
--|     Ripple-Carry Adder: S = A + B
--|
--|     Our **user** will input the following:
--|
--|     - $C_{in}$ on switch 0
--|     - $A$ on switches 4-1
--|     - $B$ on switches 15-12
--|
--|     Our **user** will expect the following outputs:
--|
--|     - $Sum$ on LED 3-0
--|     - $C_{out} on LED 15
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
	port(
		-- Switches
		sw		:	in  std_logic_vector(15 downto 0);
		
		-- LEDs
		led	    :	out	std_logic_vector(15 downto 0)
	);
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
	
    -- declare the component of your top-level design
    component ripple_adder
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Cin : in STD_LOGIC;
               S : out STD_LOGIC_VECTOR (3 downto 0);
               Cout : out STD_LOGIC);
    end component;

    -- declare any signals you will need
    signal w_A   : STD_LOGIC_VECTOR(3 downto 0);
    signal w_B   : STD_LOGIC_VECTOR(3 downto 0);
    signal w_Cin : STD_LOGIC;
    signal w_S   : STD_LOGIC_VECTOR(3 downto 0);
    signal w_Cout: STD_LOGIC;
  
begin
	-- PORT MAPS --------------------
	ripple_inst : ripple_adder
	   port map (
	       A => w_A,
	       B => w_B,
	       Cin => w_Cin,
	       S => w_S,
	       Cout => w_Cout
	   );
	-- CONCURRENT STATEMENTS --------
	w_A <= sw(4 downto 1);
	w_B <= sw(15 downto 12);
	w_Cin <= sw(0);
	
	led(3 downto 0) <= w_S;
	led(15) <= w_Cout;
	led(14 downto 4) <= (others => '0'); -- Ground unused LEDs
	---------------------------------
end top_basys3_arch;
