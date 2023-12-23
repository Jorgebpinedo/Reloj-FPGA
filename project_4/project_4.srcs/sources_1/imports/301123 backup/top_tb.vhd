library ieee;
use ieee.std_logic_1164.all;
use work.common.all;

entity top_tb is
end top_tb;

architecture tb of top_tb is

   component top is 
port(CLK100MHZ, sblink, mblink, hblink, cen, reset_n : in std_logic;
    SEGMNTS_N  : out std_logic_vector(7 downto 0); -- Qué segmentos activar
    DIGITS_N   : out std_logic_vector(7 downto 0) -- Qué dígitos activar
    );
end component;
    
    signal clk : std_logic := '0';
    signal sblink, mblink, hblink, cen, reset_n : std_logic;
    signal segments_n, digits_n : std_logic_vector(7 downto 0);
    signal wtf : int0_9_vector(5 downto 0);

begin

    dut : top
        port map(clk100mhz => clk, sblink => sblink, mblink => mblink, hblink => hblink, cen=>cen,
         reset_n =>reset_n, segmnts_n => segments_n, digits_n =>digits_n);

	clock: clk <= not clk after 5 ns;
    reset_signal: reset_n <= '0', '1' after 75 ns;
    
    stimuli : process
    begin
    wait for 10ns;
        sblink <= '0'; mblink <= '0'; hblink <= '0'; cen <= '1';
        wait;

    end process;

end tb;