library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity tb_cambiar_hora is
end tb_cambiar_hora;
 
architecture BEHAVIORAL of tb_cambiar_hora is 

component CAMBIAR_HORA is
    generic (DIGITS : int0_9 := 6);
    
    port(
    CLK:      in std_logic;
    INC_SEG:  in std_logic;
    INC_MIN:  in std_logic;
    INC_H:    in std_logic;
    RESET_N:  in std_logic;
    CE_N:     in std_logic;
    BCD_OUT : out int0_9_vector(DIGITS - 1 downto 0)
    );
end component;

  --Inputs
  signal reset_n : std_logic;
  signal clk     : std_logic;
  signal ce_n    : std_logic;
  signal incseg, incmin, inch    : std_logic:='0';

  --Outputs
  signal bcd_out : int0_9_vector(5 downto 0);

  -- Clock period definitions
  constant clk_period : time := 10 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
  uut: CAMBIAR_HORA
    port map(
    CLK => clk,
    INC_SEG => incseg,
    INC_MIN => incmin,
    INC_H => inch,
    RESET_N => reset_n,
    CE_N => ce_n,
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
    ce_n <= '1';
    wait until reset_n = '1';
    for i in 1 to 5 loop
      wait until clk = '1';
    end loop;
    ce_n <= '0' after 0.25 * clk_period;
    wait until clk = '1';
    ce_n <= '1' after 0.25 * clk_period;
    for i in 1 to 69 loop
      wait until clk = '1';
      incseg <= '1';
    end loop;
    for i in 1 to 69 loop
      wait until clk = '1';
      incmin <= '1';
    end loop;
    for i in 1 to 69 loop
      wait until clk = '1';
      inch <= '1';
    end loop;
-- 420
    wait for 0.25 * clk_period;
    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end;
