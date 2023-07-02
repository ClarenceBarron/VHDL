----------------------------------------------------------------------------------
-- refereeTibreaker_tb
-- This this is a test bench for RefereeTibreaker component. 
-- This test bench will apply all possible input combonations of Referee votes so that we can analysis
-- the output behavior.
----------------------------------------------------------------------------------

--- Start of Test Bench Code ---

library IEEE;
use ieee.std_logic_1164.all;

entity RefereeTiebreaker_tb is
end RefereeTiebreaker_tb;


architecture RefereeTiebreaker_tb_arch of RefereeTiebreaker_tb is
--Delclaration Area Start

-- refVotes consolidates headRef & ref01 & ref02 & ref03 into a single vectore
-- for an easy signal declaration

        signal headRef: std_logic;
        signal ref01 :  std_logic;
        signal ref02 :  std_logic;
        signal ref03 :  std_logic;
        signal finalRuling : std_logic;

        component refereeTiebreaker
            Port ( headRef : in std_logic;
                ref01 : in std_logic;
                ref02 : in std_logic;
                ref03 : in std_logic;
                finalRuling : out std_logic);
        end component;
        
        signal refVotes: std_logic_vector (3 downto 0);
 -- Declaration Area End
 

begin
    -- Unit-Under-Test ---
    UUT:RefereeTiebreaker port map(
        headRef => headRef,
        ref01 => ref01,
        ref02 => ref02,
        ref03 => ref03,
        finalRuling => finalRuling);
        
      
      -- Helps proc the ports for each bit --
      headRef <= refVotes(3);
      ref01 <= refVotes(2);
      ref02 <= refVotes(1);
      ref03 <= refVotes(0);
      
    -- Signal Drivers ---
    -- Driver Process that helps refVotes proc in all conditions to test to see if archetecure works --  
    SIGNAL_DRIVER: process
    begin
        refVotes <= "0000"; 
        Wait for 20ns;
       refVotes <= "1001"; 
        Wait for 20ns;
        refVotes <= "0001"; 
        Wait for 20ns;
        refVotes <= "0010"; 
        Wait for 20ns;
        refVotes <= "0011"; 
        Wait for 20ns;
        refVotes <= "1100";
        Wait for 20ns;
        refVotes <= "0100"; 
        Wait for 20ns;
        refVotes <= "0101"; 
        Wait for 20ns;
        refVotes <= "0110"; 
        Wait for 20ns;
       refVotes <= "0111";
        Wait for 20ns;
        refVotes <= "1000"; 
        Wait for 20ns;
        refVotes <= "1010"; 
        Wait for 20ns;
        refVotes <= "1011"; 
        Wait for 20ns;
        refVotes <= "1101"; 
        Wait for 20ns;
        refVotes <= "1110"; 
        Wait for 20ns;
         refVotes <= "1111"; 
        Wait for 20ns; 
         
        wait;
   end process SIGNAL_DRIVER;
    
    
                                            
       
      
end RefereeTiebreaker_tb_arch;


--- End of Test Bench Code ---





