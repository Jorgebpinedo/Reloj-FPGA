library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity BCDCNTR_TB is
end BCDCNTR_TB;
 
architecture BEHAVIORAL of BCDCNTR_TB is 

  -- Component Declaration for the Unit Under Test (UUT)
  component BCDCNTR
    generic ( N : natural := 10);
    port(
      reset_n : in  std_logic;
      clk     : in  std_logic;
      cin     : in  std_logic;
      cout    : out std_logic;
      bcd_out : out int0_9
    );
  end component;

  --Inputs
  signal reset_n : std_logic;
  signal clk     : std_logic;
  signal cin     : std_logic;

  --Outputs
  signal cout    : std_logic;
  signal bcd_out : int0_9;

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: BCDCNTR
    port map (
      RESET_N => reset_n,
      CLK     => clk,
      CIN     => cin,
      COUT    => cout,
      BCD_OUT => bcd_out
    );

  -- Clock process definitions
  clk_process: process
  begin
    clk <= '0';
    wait for 0.5 * clk_period;
    clk <= '1';
    wait for 0.5 * clk_period;
  end process;

  reset_n <= '0' after 0.25 * clk_period, '1' after 0.75 * clk_period;
  
  -- Stimulus process
  stim_proc: process
  begin
    cin <= '1';
    wait until reset_n = '1';
    for i in 1 to 5 loop
      wait until clk = '1';
    end loop;
    cin <= '0' after 0.25 * clk_period;
    wait until clk = '1';
    cin <= '1' after 0.25 * clk_period;
    for i in 1 to 6 loop
      wait until clk = '1';
    end loop;

    wait for 0.25 * clk_period;
    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end;

