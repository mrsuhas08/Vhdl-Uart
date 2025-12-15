entity Baud_rate is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         
         tx_en  :   out std_logic;
         rx_en  :   out std_logic);
end Baud_rate;

architecture Behavioral of Baud_rate is

    signal tx_count     :   unsigned(12 downto 0)   := (others => '0');
    signal rx_count     :   unsigned(8 downto 0)    := (others => '0');
    
begin
--9600 bps
    process (clk,rst)is
    begin
            
        if rising_edge(clk) then
        
            if rst ='1' then
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
    
    tx_en   <=  '1'     when tx_count   =   0   else    '0';
    rx_en   <=  '1'     when rx_count   =   0   else    '0';
    
end Behavioral;