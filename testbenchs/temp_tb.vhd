library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity TEMP_TB is
end TEMP_TB;
 
architecture BEHAVIORAL of TEMP_TB is 

  -- component declaration for the unit under test (uut)
  component TEMP
    generic (
      DIGITS : positive := 6;
      N : int0_10_vector(5 downto 0) := (3,10,6,10,6,10)
    );
    port(
      BCD_IN  : in  int0_9_vector(DIGITS - 1 downto 0);
      RESET_N : in  std_logic;
      CLK     : in  std_logic;
      CE_N    : in  std_logic;
      BCD_OUT : inout int0_9_vector(DIGITS - 1 downto 0)
    );
  end component;

  --Inputs
  signal reset_n : std_logic;
  signal clk     : std_logic;
  signal ce_n    : std_logic;
  signal bcd_in  : int0_9_vector(5 downto 0);
  --Outputs
  signal bcd_out : int0_9_vector(5 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
  uut: TEMP
    port map (
      BCD_IN => BCD_IN,
      RESET_N => RESET_N,
      CLK     => CLK,
      CE_N    => CE_N,
      BCD_OUT => BCD_OUT
    );

  -- Clock process definitions
  clk_process: process
  begin
    clk <= '0';
    wait for 0.5 * clk_period;
    clk <= '1';
    wait for 0.5 * clk_period;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    ce_n <= '1';
    bcd_in(0) <= 2;
    bcd_in(1) <= 2;
    bcd_in(2) <= 2;
    bcd_in(3) <= 2;
    bcd_in(4) <= 2;
    bcd_in(5) <= 2;
    reset_n <= '0' after 0.25 * clk_period;
    wait until clk = '1';
    reset_n <= '1' after 2 * clk_period;
    for i in 1 to 5 loop
      wait until clk = '1';
    end loop;
    ce_n <= '0' after 0.25 * clk_period;
    wait until clk = '1';
    ce_n <= '1' after 2 * clk_period;
    for i in 1 to 1000 loop
      wait until clk = '1';
    end loop;
    reset_n <= '0' after 0.25 * clk_period;
    wait until clk = '1';
    reset_n <= '1' after 2 * clk_period;
    for i in 1 to 1000000 loop
      wait until clk = '1';
    end loop;
    
    wait for 0.25 * clk_period;
    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end;
