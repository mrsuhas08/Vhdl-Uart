----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2025 11:53:05
-- Design Name: 
-- Module Name: Uart - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Uart is
    Port(clk        :   in std_logic;
         rst        :   in std_logic;
         
         tx_en_b    :   out std_logic;--34
         rx_en_b    :   out std_logic;--35
         
         tx         :   out std_logic;--36
         tx_en_t    :   in std_logic;--31
         
         rx         :   in std_logic;--33
         rx_en_r    :   in std_logic);--32
end Uart;

architecture Behavioral of Uart is
    
    component Baud_rate is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         
         tx_en_b:   out std_logic;
         rx_en_b:   out std_logic);
    end component;
    
    component Tranmitter is
        Port(clk    :   in std_logic;
             rst    :   in std_logic;
             wr_en  :   in std_logic;
             tx_en_t:   in std_logic;
             din    :   in std_logic_vector(7 downto 0);
             
             tx     :   out std_logic;
             busy   :   out std_logic);    
    end component;
    
    component Receiver is
        Port(clk    :   in std_logic;
             rst    :   in std_logic;
             rx_en_r:   in std_logic;
             clr    :   in std_logic;
             rx     :   in std_logic;
             
             rdy    :   out std_logic;
             dout   :   out std_logic_vector(7 downto 0));
    end component;
    
    COMPONENT ila_0
        PORT(clk : IN STD_LOGIC;
             probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
             probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
             probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
             probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
             probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
             probe5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT vio_0
        PORT(clk : IN STD_LOGIC;
             probe_OUT0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
             probe_OUT1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
             probe_OUT2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
             probe_OUT3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    
    signal rst_vio  :   std_logic       := '0';
    
    signal tx_temp  :   std_logic       := '0';
    signal rx_temp  :   std_logic       := '0';
    
    signal tx_rx    :   std_logic       := '0';
    
    signal wr_en    : std_logic         := '0';
    signal data_in  : std_logic_vector(7 downto 0)  := (others => '0');
    signal clr      : std_logic         := '0';
         
    signal rdy      : std_logic         := '0';
    signal busy     : std_logic         := '0';
    signal data_out : std_logic_vector(7 downto 0)  := (others => '0');
    
begin

    baudrate:   Baud_rate
            port map(clk    =>  clk,
                     rst    =>  rst_vio,
                     tx_en_b=>  tx_en_b,
                     rx_en_b=>  rx_en_b);
    
    trans:  Tranmitter
            port map(clk    =>  clk,
                     rst    =>  rst_vio,
                     tx_en_t=>  tx_en_t,
                     wr_en  =>  wr_en,
                     din    =>  data_in,
                     tx     =>  tx,
                     busy   =>  busy);
    
    receiv: Receiver
            port map(clk    =>  clk,
                     rst    =>  rst_vio,
                     rx_en_r=>  rx_en_r,
                     clr    =>  clr,
                     rx     =>  rx,
                     rdy    =>  rdy,
                     dout   =>  data_out);
    
    signals: ila_0
            PORT MAP(clk => clk,
                     probe0(0)  =>  tx_en_t, 
                     probe1(0)  =>  rx_en_r, 
                     probe2(0)  =>  rx, 
                     probe3(0)  =>  rdy,
                     probe4(0)  =>  busy,
                     probe5     =>  data_out);
    
    your_instance_name : vio_0
            PORT MAP(clk => clk,
                     probe_OUT0(0)  =>  rst_vio,
                     probe_OUT1(0)  =>  clr,
                     probe_OUT2(0)  =>  wr_en,
                     probe_OUT3     =>  data_in);
    
end Behavioral;
