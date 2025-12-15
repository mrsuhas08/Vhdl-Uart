entity Tranmitter is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         wr_en  :   in std_logic;
         tx_en  :   in std_logic;
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
            if rst = '1' then
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
                    
                        if tx_en = '1' then
                            tx      <=  '0';
                            state   <=  data;
                            
                        else
                            state   <=  start;
                            
                        end if;
                        
                    when data =>
                        
                        if tx_en = '1' then
                        
                            if count = 8 then
                                state   <=  parity;
                                count   <=  (others => '0');
                            else
                                count   <=  count + 1;
                                tx      <=  temp(TO_INTEGER(count));
                            end if;
                        
                        end if;
                    
                    when parity =>
                    
                        if tx_en = '1' then
						
                            if count = 0 then
                                tx      <=  p;
                                count   <=  count + 1;
                                state   <=  stop;
                            end if;
							
                        end if;
                    
                    when stop =>
                        
                        if tx_en = '1' then
                            tx      <=  '1';
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