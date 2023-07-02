----------------------------------------------------------------------------------
-- Group Members; Clarence Barron, Rodrigo Corral, Paul Hughes

                         -- Serial Control --
-- This is the component is suppose to take into bytes from the pc serial connection
-- and control the display and leds accordingly depending on the mode given.
-- L = Leds On, M = Leds Off, D = Display
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SerialControl is
    Port ( reset : in std_logic;
           clock : in std_logic;
           bytesIn : in std_logic;
           segments : out std_logic_vector (6 downto 0);
           anodes : out std_logic_vector (3 downto 0);
           leds : out std_logic_vector (15 downto 0));
end SerialControl;

architecture SerialControl_ARCH of SerialControl is

 component SevenSegmentDriver
        port (
            reset: in std_logic;
            clock: in std_logic;
        
            digit3: in std_logic_vector(3 downto 0);  --leftmost digit
            digit2: in std_logic_vector(3 downto 0);  --2nd from left digit
            digit1: in std_logic_vector(3 downto 0);  --3rd from left digit
            digit0: in std_logic_vector(3 downto 0);  --rightmost digit
        
            blank3: in std_logic;    --leftmost digit
            blank2: in std_logic;    --2nd from left digit
            blank1: in std_logic;    --3rd from left digit
            blank0: in std_logic;    --rightmost digit
        
            sevenSegs: out std_logic_vector(6 downto 0);  --MSB=a, LSB=g
            anodes:    out std_logic_vector(3 downto 0)   --MSB=leftmost digit
        );
    end component;
    
component UartRx
        port (
            clock:      in  std_logic;
            reset:      in  std_logic;
            rxData:     in  std_logic;
            dataReady:  out std_logic;
            dataOut:    out std_logic_vector(7 downto 0)
            );
    end component UartRx; 
    type     serialMode_t  is (AWAIT_INPUT, LED_MODE, AWAIT_RESET, LED_FIRST_DIGIT, LED_SECOND_DIGIT, DISPLAY_MODE, DISPLAY_FIRST_DIGIT, WAIT_DISPLAYONE, WAIT_DISPLAYTWO, WAIT_DISPLAYTHREE, DISPLAY_SECOND_DIGIT, DISPLAY_THIRD_DIGIT, DISPLAY_FOURTH_DIGIT);
    type     ledMode_t     is (LED_WAIT, LED_OFF, LED_ON);
    constant ACTIVE:         std_logic := '1';
    signal   modeAndNum:     std_logic_vector(7 downto 0);
    signal   currentState:   serialMode_t;
    signal   nextState:      serialMode_t;
    signal   modeAndNumEn:   std_logic;
    signal   ledOnEn:        std_logic;
    signal   ledOffEn:       std_logic;
    signal   digitOneEn:     std_logic;
    signal   digitTwoEn:     std_logic;
    signal   digitThreeEn:   std_logic;
    signal   digitFourEn:    std_logic;
    signal   digitOneBits:   std_logic_vector(3 downto 0);
    signal   digitTwoBits:   std_logic_vector(3 downto 0);
    signal   digitThreeBits: std_logic_vector(3 downto 0);
    signal   digitFourBits:  std_logic_vector(3 downto 0);
    signal   ledMode:        ledMode_t;
    signal   ledPos:         integer range 0 to 16;
    
begin
-- The reciever taking in the bytes --
INPUT_RECEIVER: UartRx
       port map(
                clock =>     clock,
                reset =>     reset,
                rxData =>    bytesIn,
                dataReady => modeAndNumEn,
                dataOut =>   modeAndNum);      
-- Just a state proces to take in the current
-- state of the state machine             
INPUT_STATE: process (reset,clock)
begin
      if (reset = ACTIVE) then
        currentState <= AWAIT_INPUT;
      elsif (rising_edge(clock)) then
            currentstate <= nextState;
      end if;
end process INPUT_STATE;

-- The state machine is meant to change depending on what is given
-- from the reciever and changes accordingly and
-- stores the digits given in from the reciever
INPUT_TRANSITION: process (modeAndNum, modeAndNumEn)
begin
    case currentState is 
        when AWAIT_INPUT => 
             if(modeAndNumEn = ACTIVE and modeAndNum = x"4C") then
                ledMode <= LED_ON;
                nextState <= LED_FIRST_DIGIT;
             elsif(modeAndNumEn = ACTIVE and modeAndNum = x"4D") then
                ledMode <= LED_OFF;
                nextState <= LED_FIRST_DIGIT;
             elsif(modeAndNumEn = ACTIVE and modeAndNum = x"44") then
                nextState <= DISPLAY_MODE;
             else
                nextState <= AWAIT_INPUT;
             end if;
             
                     
        when LED_FIRST_DIGIT =>
            digitOneEn <= ACTIVE;
            digitTwoEn <= not ACTIVE; 
            if (modeAndNumEn = ACTIVE) then
                nextState <= LED_SECOND_DIGIT;
            end if;
         
        when LED_SECOND_DIGIT =>
            digitOneEn <= not ACTIVE;
            digitTwoEn <= ACTIVE; 
            if(modeAndNumEn <= ACTIVE) then
                nextstate <= LED_MODE;
            end if;
        
         when LED_MODE =>
           if (ledMode = LED_ON) then
                    ledOnEn <= ACTIVE;
                    nextState <= AWAIT_RESET;
                elsif(ledMode = LED_OFF) then
                    ledOffEn <= ACTIVE;
                    nextState <= AWAIT_RESET;
          end if;  
         
         when DISPLAY_MODE => 
            if (modeAndNumEn = ACTIVE) then 
                nextState <= DISPLAY_FIRST_DIGIT;
            else
                nextState <= DISPLAY_MODE;
            end if;
              
         when DISPLAY_FIRST_DIGIT =>
              digitOneEn <= ACTIVE;
              nextState <= WAIT_DISPLAYONE;   
                   
         when WAIT_DISPLAYONE =>
               if (modeAndNumEn = ACTIVE) then
                  nextState <= DISPLAY_SECOND_DIGIT;
               else
                   nextState <= WAIT_DISPLAYONE;
                   digitOneEn <= not ACTIVE;                
               end if;
                 
          when DISPLAY_SECOND_DIGIT =>
              digitTwoEn <= ACTIVE;
              nextState <= WAIT_DISPLAYTWO;   
                   
          when WAIT_DISPLAYTWO =>
               if (modeAndNumEn = ACTIVE) then
                  nextState <= DISPLAY_THIRD_DIGIT;
               else
                   nextState <= WAIT_DISPLAYTWO;
                   digitTwoEn <= not ACTIVE;                
               end if;
               
          when DISPLAY_THIRD_DIGIT =>
              digitThreeEn <= ACTIVE;
              nextState <= WAIT_DISPLAYTHREE;   
                   
         when WAIT_DISPLAYTHREE =>
               if (modeAndNumEn = ACTIVE) then
                  nextState <= DISPLAY_FOURTH_DIGIT;
                  digitThreeEn <= not ACTIVE;
               else
                   nextState <= WAIT_DISPLAYTHREE;
                   digitThreeEn <= not ACTIVE;                
               end if;
           
           when DISPLAY_FOURTH_DIGIT =>
              digitFourEn <=  ACTIVE;
              digitTwoEn <= not ACTIVE;
              if (modeAndNumEn = ACTIVE) then
                digitFourEn <= not ACTIVE;
                nextState <= AWAIT_RESET;
           end if;
           
           when AWAIT_RESET =>
                digitOneEn      <=   not ACTIVE;
                digitTwoEn      <=   not ACTIVE;
                digitThreeEn    <=   not ACTIVE;
                digitFourEn     <=   not ACTIVE;  
    end case;
end process INPUT_TRANSITION;

-- Holds the first digit given by the last 3 bits of
-- the byte given from the reciever
-- The bits from the byte given [3 downto 0]
-- is consitant for all the digit processes
DIGIT01: process(reset,clock)
 begin
    if (reset = ACTIVE) then
        digitOneBits <= (others => '0');
    elsif (rising_edge(clock))then
          if (digitOneEn = ACTIVE) then
            digitOneBits <= modeAndNum(3 downto 0);
          end if;
  end if;
 end process DIGIT01;

-- Holds the second digit -- 
DIGIT02: process(reset,clock)
 begin
    if (reset = ACTIVE) then
        digitTwoBits <= (others => '0');
    elsif (rising_edge(clock))then
          if (digitTwoEn = ACTIVE) then
            digitTwoBits <= modeAndNum(3 downto 0);
          end if;
  end if;
 end process DIGIT02; 
 
 -- Holds the third digit --
DIGIT03: process(reset,clock)
 begin
    if (reset = ACTIVE) then
        digitThreeBits <= (others => '0');
    elsif (rising_edge(clock))then
          if (digitThreeEn = ACTIVE) then
            digitThreeBits <= modeAndNum(3 downto 0);
          end if;
  end if;
 end process DIGIT03; 
 -- Holds the fourth digit --
DIGIT04: process(reset,clock)
 begin
    if (reset = ACTIVE) then
        digitFourBits <= (others => '0');
    elsif (rising_edge(clock))then
          if (digitFourEn = ACTIVE) then
            digitFourBits <= modeAndNum(3 downto 0);
          end if;
  end if;
end process DIGIT04;

-- Converts the Digit 1 and Digit 2 values
-- to integers
LED_CONVERT_INT: process(digitOneBits, digitTwoBits)
variable tensDigit: integer range 0 to 9;
variable onesDigit: integer range 0 to 9;
begin
    tensDigit := (to_integer(unsigned(digitOneBits)) * 10);
    onesDigit := to_integer(unsigned(digitTwoBits));   
    ledPos <= (tensDigit + onesDigit);
end process LED_CONVERT_INT;

-- Drives the LEDs depending on if they turn off or turn on --
LED_DRIVER: process (reset,clock)
begin
    if (reset = ACTIVE) then
        leds <= "0000000000000000";
    elsif (rising_edge(clock)) then
        if (ledOnEn = ACTIVE) then
            leds(ledPos) <= ACTIVE;
        elsif (ledOffEn = ACTIVE) then
            leds(ledPos) <= not ACTIVE;
        end if;
    end if;
end process LED_DRIVER;

DISPLAY_DRIVER:  SevenSegmentDriver port map(
                           reset        => reset,
                           clock        => clock,
                           digit3       => digitOneBits,
                           digit2       => digitTwoBits,
                           digit1       => digitThreeBits,
                           digit0       => digitFourBits,
                           blank3       => not ACTIVE,
                           blank2       => not ACTIVE,
                           blank1       => not ACTIVE,
                           blank0       => not ACTIVE,
                           sevenSegs    => segments,
                           anodes       => anodes);
end SerialControl_ARCH;
