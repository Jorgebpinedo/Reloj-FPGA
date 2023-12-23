library ieee;
use ieee.std_logic_1164.all;

use work.common.all;

entity VisualizadorBlinker is 
    generic
  (
    DIGITS     : positive :=  6; 
    RFRSH_RATE : positive := 100;
    CLK_FREQ   : positive := 1E8
  );
  port (
    RESET_N    : in  std_logic;
    CLK        : in  std_logic;
    BCD_IN     : in  int0_9_vector(DIGITS - 1 downto 0);
    seg_blink  : in std_logic;
    min_blink  : in std_logic;
    h_blink    : in std_logic;
    SEGMNTS_N  : out std_logic_vector(7 downto 0); -- Qué segmentos activar
    DIGITS_N   : out std_logic_vector(7 downto 0) -- Qué dígitos activar
  );
end entity;

architecture bhvl of VisualizadorBlinker is

component GenOndaCuadrada is
    generic(CLK_FREQ : positive := 1E8);
    port(clk : in std_logic;
         clk_squared : out std_logic
         );
end component;

component VISUALIZER is
  generic
  (
    DIGITS     : positive :=  6; 
    RFRSH_RATE : positive := 100;
    CLK_FREQ   : positive := 1E8
  );
  port (
    RESET_N    : in  std_logic;
    CLK        : in  std_logic;
    BCD_IN     : in  bcd_vector(DIGITS - 1 downto 0);
    SEGMNTS_N  : out std_logic_vector(7 downto 0); -- Qué segmentos activar
    DIGITS_N   : out std_logic_vector(7 downto 0) -- Qué dígitos activar
  );
end component;

component Blinker is
	port(
		clk_seg, reset_n: in std_logic;
		seg_blink, min_blink, h_blink : in std_logic;
		digits_in_n : in std_logic_vector(7 downto 0);
		digits_out_n : out std_logic_vector(7 downto 0)
	);
end component;

component Int09ToBcd is
	generic( DIGITS : positive := 6);
	port(
		BCD_IN : in int0_9_vector(DIGITS -1 downto 0);
		BCD_OUT: out bcd_vector(DIGITS -1 downto 0)
	);
end component;

signal digits_n_s : std_logic_vector(7 downto 0);
signal bcd_in_s : int0_9_vector(DIGITS -1 downto 0);
signal bcd_out_s : bcd_vector(DIGITS -1 downto 0);
signal clk_seg_s : std_logic;

begin

visualizador1: VISUALIZER 
                generic map( DIGITS => digits, RFRSH_RATE => rfrsh_rate, CLK_FREQ => clk_freq)
                port map(reset_n => reset_n, 
                         clk => clk,
                         bcd_in => bcd_out_s,
                         segmnts_n => segmnts_n,
                         digits_n => digits_n_s
                         );

blinker1: Blinker
            port map(clk_seg => clk_seg_s,
                     reset_n => reset_n,
                     seg_blink => seg_blink,
                     min_blink => min_blink,
                     h_blink => h_blink,
                     digits_in_n => digits_n_s,
                     digits_out_n => digits_n
                     );
                     
conversor_a_bcd: Int09ToBcd
	generic map( DIGITS => 6)
	port map(
		BCD_IN => bcd_in,
		BCD_OUT => bcd_out_s
	);


squared_wave1: GenOndaCuadrada
                generic map( CLK_FREQ => 5E7)
                port map (clk => clk,
                           clk_squared => clk_seg_s
                           );
end architecture;
