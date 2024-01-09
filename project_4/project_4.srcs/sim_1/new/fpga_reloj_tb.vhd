--Test bench de la entidad fpga_reloj

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity fpga_reloj_tb is
end fpga_reloj_tb;

architecture Behavioral of fpga_reloj_tb is

    component fpga_reloj is
        generic(DIGITS : positive := 6;
                RFRSH_RATE : positive := 100;
                CLK_FREQ : positive := 1E8
                );
        port(modo, pausar_reanudar, chorag, reset_button : in std_logic;
             reset_n : in std_logic;
             CLK100MHZ : in std_logic;
             digits_n, segments_n : out std_logic_vector(7 downto 0)
             );
    end component;
    
    signal modo, pausar_reanudar, chorag, reset_button, clk : std_logic := '0';
    signal digits_n, segments_n : std_logic_vector(7 downto 0);
    signal reset_n : std_logic := '0';
    
begin
    fpga1: fpga_reloj 
        port map(modo => modo,
                pausar_reanudar => pausar_reanudar, 
                chorag => chorag,
                reset_button => reset_button,
                reset_n => reset_n,
                CLK100MHZ =>clk,
                digits_n => digits_n,
                segments_n => segments_n
             );
        
        clock: clk <= not clk after 5 ns;
        reset_signal: reset_n <= '0', '1' after 75 ns;
        
        stimuli: process
        begin
        
        wait;
        end process;

end Behavioral;
