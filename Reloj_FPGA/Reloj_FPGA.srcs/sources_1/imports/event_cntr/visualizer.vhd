----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:54 11/15/2019 
-- Design Name: 
-- Module Name:    visualizer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity VISUALIZER is
  generic
  (
    DIGITS     : positive :=  3;
    RFRSH_RATE : positive := 30;
    CLK_FREQ   : positive := 1E8
  );
  port (
    RESET_N    : in  std_logic;
    CLK        : in  std_logic;
    BCD_IN     : in  bcd_vector(DIGITS - 1 downto 0);
    SEGMNTS_N  : out std_logic_vector(7 downto 0);
    DIGITS_N   : out std_logic_vector(7 downto 0)
  );
end VISUALIZER;

architecture STRUCTURAL of VISUALIZER is

  component MUXER is
    generic (
      DIGITS : positive
    );
    port (
      SEL     : in  std_logic_vector(DIGITS - 1 downto 0);
      BCD_IN  : in  bcd_vector(DIGITS - 1 downto 0);
      BCD_OUT : out bcd
    );
  end component;

  component TIMER is
    generic (
      MODULO  : positive
    );
    port ( 
      RESET_N : in   std_logic;
      CLK     : in   std_logic;
      STROBE  : out  std_logic
    );
  end component;

  component SCANNER is
    generic (
      DIGITS : positive
    );
    port (
      RESET_N : in  std_logic;
      CLK     : in  std_logic;
      CE      : in  std_logic;
      SEL     : out std_logic_vector(DIGITS - 1 downto 0)
    );
  end component;

  component BIN2SEG is
    port (
      BCDVAL   : in  bcd;
      SEGMENTS : out std_logic_vector(6 downto 0)
    );
  end component;

  signal clk_strobe : std_logic;
  signal bcd_data   : bcd;
  signal segments   : std_logic_vector(6 downto 0);
  signal sel        : std_logic_vector(DIGITS - 1 downto 0);

begin

  muxer1: MUXER
    generic map (
      DIGITS => DIGITS
    )
    port map (
      SEL     => sel,
      BCD_IN  => bcd_in,
      BCD_OUT => bcd_data
    );

  timer1: TIMER
    generic map (
      MODULO  => CLK_FREQ / (RFRSH_RATE * DIGITS)
    )
    port map ( 
      RESET_N => RESET_N,
      CLK     => CLK,
      STROBE  => clk_strobe
    );

  scanner1: SCANNER
    generic map (
      DIGITS => DIGITS
    )
    port map (
      RESET_N => RESET_N,
      CLK     => CLK,
      CE      => clk_strobe,
      SEL     => sel
    );

  bin2seg1: BIN2SEG
    port map (
      BCDVAL   => bcd_data,
      SEGMENTS => SEGMNTS_N(SEGMNTS_N'high downto 1)
    );

  SEGMNTS_N(0) <= '1';

  DIGITS_N(DIGITS_N'HIGH downto DIGITS) <= (others => '1');
  DIGITS_N(DIGITS - 1 downto 0) <= sel;

end STRUCTURAL;
