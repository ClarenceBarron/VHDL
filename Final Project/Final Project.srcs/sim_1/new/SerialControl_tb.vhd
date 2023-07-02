----------------------------------------------------------------------------------
-- Group Members; Clarence Barron, Rodrigo Corral, Paul Hughes

-- This is the test bench to test to see if the Serial Control component
-- works with the design using the LEDs and the Displays.
-- In order to work the test bench, comment out either the LED
-- Process or the Display Process then change the middle 8 bits.
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity SerialControl_tb is
end SerialControl_tb;

architecture SerialControl_tb_ARCH of SerialControl_tb is
    component SerialControl 
    Port ( reset : in std_logic;
           clock : in std_logic;
           bytesIn : in std_logic;
           segments : out std_logic_vector (6 downto 0);
           anodes : out std_logic_vector (3 downto 0);
           leds : out std_logic_vector (15 downto 0));
    end component SerialControl;
signal reset:    std_logic;
signal clock:    std_logic;
signal bytesIn:  std_logic;
signal segments: std_logic_vector (6 downto 0);
signal anodes:   std_logic_vector (3 downto 0);
signal leds:     std_logic_vector (15 downto 0);
constant ACTIVE:         std_logic := '1';
constant BAUD_RATE:   integer :=  115_200;
constant BIT_TIME:    time    := (1_000_000_000/BAUD_RATE) * 1 ns;
constant CLOCK_FREQ:  integer := 100_000_000;
begin
UUT: SerialControl port map(
            reset => reset,
            clock => clock,
            bytesIn => bytesIn,
            segments => segments,
            anodes => anodes,
            leds => leds);
            
SYS_CLOCK: process
begin
    clock <= not ACTIVE;
    wait for 5 ns;
    clock <= ACTIVE;
    wait for 5 ns;
   end process SYS_CLOCK;

 RESET_CLOCK: process
    begin
        reset <= ACTIVE;
        wait for  200ns;
        reset <= not ACTIVE;
        wait;
    end process;

-- Test Bench for the LEDS --
--  LED_TEST_DRIVER: process
--    begin
--        ----set serial line to idle-----------------------------------------------
--        bytesIn <= '1';
--        wait for 316 ns;

        
--        ----transmit L---------------------------------------------------------
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;

        
--        ----transmit 1 for Tens place ---------------------------------------------------------
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;

                
--        ----transmit 5 for Ones place ---------------------------------------------------------
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '0';
--        wait for BIT_TIME;
--        bytesIn <= '1';
--        wait for BIT_TIME;

--        wait;
--    end process LED_TEST_DRIVER;
    
DISPLAY_TEST: process
 begin
        ----set serial line to idle-----------------------------------------------
        bytesIn <= '1';
        wait for 316 ns;

        
        ----transmit 'D'---------------------------------------------------------
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;

        
        ----transmit 1 for Tens place ---------------------------------------------------------
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;

                
        ----transmit 5 for Ones place ---------------------------------------------------------
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        
          ----transmit 8 for Ones place ---------------------------------------------------------
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        
          ----transmit 2 for Ones place ---------------------------------------------------------
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '0';
        wait for BIT_TIME;
        bytesIn <= '1';
        wait for BIT_TIME;
end process DISPLAY_TEST;
            
end SerialControl_tb_ARCH;
