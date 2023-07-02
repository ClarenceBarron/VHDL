----------------------------------------------------------------------------------
-- Group Members; Clarence Barron, Rodrigo Corral, Paul Hughes

-- This is the wrapper file for the Serial Control file of the system.
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity SerialControl_Basys3 is
    Port ( clk:    in std_logic;
           btnD:   in std_logic;
           RsRx:   in std_logic;
           led:    out std_logic_vector (15 downto 0);
           seg:    out std_logic_vector (6 downto 0);        
           an:     out std_logic_vector (3 downto 0));
end SerialControl_Basys3;

architecture SerialControl_Basys3_ARCH of SerialControl_Basys3 is
           component SerialControl 
            Port ( reset : in std_logic;
                   clock : in std_logic;
                   bytesIn : in std_logic;
                   segments : out std_logic_vector (6 downto 0);
                   anodes : out std_logic_vector (3 downto 0);
                   leds : out std_logic_vector (15 downto 0));
            end component SerialControl;
begin
SYSTEM_WORKINGS: SerialControl
            port map( 
                   reset       => btnD,
                   clock       => clk,
                   bytesIn     => RsRx,
                   leds        => led,
                   segments    => seg,
                   anodes      => an);
                   
        

end SerialControl_Basys3_ARCH;
