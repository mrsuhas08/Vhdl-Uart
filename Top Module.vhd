entity Uart is
    Port(clk        :   in std_logic;
         rst        :   in std_logic;
         wr_en      :   in std_logic;
         data_in    :   in std_logic_vector(7 downto 0);
         clr        :   in std_logic;
         
         rdy        :   out std_logic;
         busy       :   out std_logic;
         data_out   :   out std_logic_vector(7 downto 0));
end Uart;

architecture Behavioral of Uart is
    
    component Baud_rate is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         
         tx_en  :   out std_logic;
         rx_en  :   out std_logic);
    end component;
    
    component Tranmitter is
        Port(clk    :   in std_logic;
             rst    :   in std_logic;
             wr_en  :   in std_logic;
             tx_en  :   in std_logic;
             din    :   in std_logic_vector(7 downto 0);
             
             tx     :   out std_logic;
             busy   :   out std_logic);    
    end component;
    
    component Receiver is
        Port(clk    :   in std_logic;
             rst    :   in std_logic;
             rx_en  :   in std_logic;
             clr    :   in std_logic;
             rx     :   in std_logic;
             
             rdy    :   out std_logic;
             dout   :   out std_logic_vector(7 downto 0));
    end component;

    signal tx_temp  :   std_logic       := '0';
    signal rx_temp  :   std_logic       := '0';
    
    signal tx_rx    :   std_logic       := '0';
    
begin

    baudrate:   Baud_rate
            port map(clk    =>  clk,
                     rst    =>  rst,
                     tx_en  =>  tx_temp,
                     rx_en  =>  rx_temp);
                     
    trans:  Tranmitter
            port map(clk    =>  clk,
                     rst    =>  rst,
                     wr_en  =>  wr_en,
                     tx_en  =>  tx_temp,
                     din    =>  data_in,
                     tx     =>  tx_rx,
                     busy   =>  busy);
    
    receiv: Receiver
            port map(clk    =>  clk,
                     rst    =>  rst,
                     rx_en  =>  rx_temp,
                     clr    =>  clr,
                     rx     =>  tx_rx,
                     rdy    =>  rdy,
                     dout   =>  data_out);
    
end Behavioral;