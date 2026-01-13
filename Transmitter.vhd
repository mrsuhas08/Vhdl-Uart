----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2025 10:30:07
-- Design Name: 
-- Module Name: Tranmitter - Behavioral
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

entity Tranmitter is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         wr_en  :   in std_logic;
         tx_en_t  :   in std_logic;
         din    :   in std_logic_vector(7 downto 0);
         
         tx     :   out std_logic;
         busy   :   out std_logic);
         
end Tranmitter;

architecture Behavioral of Tranmitter is

    signal p        :   std_logic                       := '0';
    signal temp     :   std_logic_vector(7 downto 0)    := (others => '0');
    signal count    :   unsigned(3 downto 0)            := (others => '0');

    type fsm is(idle,
                start,
                data,
                parity,
                stop);
    signal state    :   fsm     := idle;
    
begin
    
    p   <=  din(7) xor din(6) xor din(5) xor din(4) xor din(3) xor din(2) xor din(1) xor din(0);
    
    process (clk,rst) is
    begin
        
        if rising_edge(clk) then
            if rst = '0' then
                tx      <=  '1';
                count   <=  (others => '0');
                temp    <=  (others => '0');
                state   <=  idle;
                
            else
                case state is
                
                    when idle =>
                    
                        if wr_en = '1' then
                            state   <=  start;
                            temp    <=  din;
                            count   <=  (others => '0');
                            
                        else
                            state   <=  idle;
                            
                        end if;
                    
                    when start =>
                    
                        if tx_en_t = '1' then
                            tx      <=  '0';
                            count   <=  (others => '0');
                            state   <=  data;
                            
                        else
                            state   <=  start;
                            
                        end if;
                        
                    when data =>
                        
                        if tx_en_t = '1' then
                        
                            if count >= 0 and count <=7 then
                                tx      <=  temp(0);
                                temp    <=  '0' & temp(7 downto 1);
                                count   <=  count + 1;
                                
                            elsif count = 8 then
                                tx      <=  p;
                                state   <=  parity;
                                count   <=  (others => '0');
                            end if;
                        
                        end if;
                    
                    when parity =>
                    
                        if tx_en_t = '1' then
                            if count >=0 then
                                count   <=  count + 1;
                                tx      <=  '1';
                                state   <=  stop;
                            end if;
                        end if;
                    
                    when stop =>
                        
                        if tx_en_t = '1' then
                            state   <=  idle;
                        end if;
                    
                    when others =>
                        
                        tx      <=  '1';
                        state   <=  idle;
                    
                end case;
                
            end if;
            
        end if;
        
    end process;
    
    busy    <=  '1'     when state  /=   idle   else    '0';

end Behavioral;
