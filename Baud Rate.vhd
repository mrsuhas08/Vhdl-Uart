----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2025 10:12:26
-- Design Name: 
-- Module Name: Baud_rate - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Baud_rate is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         
         tx_en_b:   out std_logic;
         rx_en_b:   out std_logic);
end Baud_rate;

architecture Behavioral of Baud_rate is

    signal tx_count     :   unsigned(12 downto 0)   := (others => '0');
    signal rx_count     :   unsigned(8 downto 0)    := (others => '0');
    
begin
--9600 bps
    process (clk,rst)is
    begin
            
        if rising_edge(clk) then
        
            if rst ='0' then
                tx_count    <=  (others => '0');
                rx_count    <=  (others => '0');
            
            else
                if tx_count = 5208 then
                    tx_count   <=   (others => '0');
                else 
                    tx_count <= tx_count + 1;
                end if;
            
                if rx_count = 325 then
                    rx_count   <=  (others => '0');
                else 
                    rx_count  <=  rx_count + 1;
                end if;
                
            end if;
            
        end if;
    
    end process;
    
    tx_en_b <=  '1'     when tx_count   =   0   else    '0';
    rx_en_b <=  '1'     when rx_count   =   0   else    '0';
    
end Behavioral;
