entity Receiver is
    Port(clk    :   in std_logic;
         rst    :   in std_logic;
         rx_en  :   in std_logic;
         clr    :   in std_logic;
         rx     :   in std_logic;
         
         rdy    :   out std_logic;
         dout   :   out std_logic_vector(7 downto 0));
end Receiver;

architecture Behavioral of Receiver is

    signal count    :   unsigned(3 downto 0)            := (others => '0');
    signal sample   :   unsigned(3 downto 0)            := (others => '0');
    signal temp     :   std_logic_vector(7 downto 0)   := (others => '0');
    
    type fsm is(idle,
                start,
                data,
                parity,
                stop);
    signal state    :   fsm     := start;
    
begin
    
    process (clk,rst) is
    begin
    
        if rising_edge(clk) then
        
            if rst = '1' then
                count   <=  (others => '0');
                sample  <=  (others => '0');
                temp    <=  (others => '0');
                dout    <=  (others => '0');
                state   <=  idle;
                rdy     <=  '0';
            
            else
                if clr = '1' then
                    rdy     <=  '0';
                else
                    if rx_en = '1' then
                        case state is
                            
                            when idle =>
                                    sample  <=  (others => '0');
                                    count   <=  (others => '0');
                                    temp    <=  (others => '0');
                                    state   <=  start;
                                
                            when start =>
                            
                                if rx = '0' and count = 0 then
                                    sample      <=  sample + 1;
                                                            
                                    if sample = 15 then
                                        state   <=  data;
                                        sample  <=  (others => '0');
                                        count   <=  (others => '0');
                                        temp    <=  (others => '0');
                                        
                                    end if;
                                
                                end if;
                            
                            when data =>
                                
                                sample  <=  sample + 1;
                                
                                if sample = 8 then
                                    temp(TO_INTEGER(count)) <=  rx;
                                    count                   <=  count + 1;
                                    
                                end if;
                                
                                if count = 8 and sample = 15 then
                                    state   <=  stop;
                                    
                                end if;
                            
                            when stop =>
                                
                                if sample = 15 then
                                    state   <=  idle;
                                    rdy     <=  '1';
                                    dout    <=  temp;
                                    sample  <=  (others => '0');
                                    count   <=  (others => '0');
                                    
                                else
                                    sample  <=  sample + 1;
                                    
                                end if;
                            
                            when others =>
                                
                                state   <=  idle;
                            
                        end case;
                        
                    end if;
                    
                end if;
            
            end if;
                        
        end if;
        
    end process;

end Behavioral;