----------------------------------------------------------------------------------
-- RefereeTieBreaker
-- Clarence Barron
--
-- Help as a tiebreaker for referee calls. Allows one head ref and three other refs to vote on a ruling.
-- If the vote is a tie, the head ref will over rule the other ref
----------------------------------------------------------------------------------

--- Start of Archeitechture code ---
library IEEE;
use ieee.std_logic_1164.all;


entity refereeTiebreaker is
    Port ( headRef : in std_logic;
           ref01 : in std_logic;
           ref02 : in std_logic;
           ref03 : in std_logic;
           finalRuling : out std_logic);
end refereeTiebreaker;

architecture RefereeTieBreaker_ARCH of refereeTiebreaker is
signal refVotes: std_logic_vector (3 downto 0);
begin

-- Combines all the variables into one single string in order to let the 
 -- selected signal assignement read and forfil the condition
refVotes <= headRef & ref01 & ref02 & ref03;

-- Selected Signal Assignement --
-- headRef is chosen when two bits match each other, 
-- ref01, will help override the  headRef if it is a 3:1 vote 
-- ref02 will be chosen if ref01 is the opposite bit of the other three
-- ref 03 will be chosen if it is any other unlisted condition for the other three referees.
-- The output will be the final ruling of either 1 or 0 depending on the condition met
with refVotes select
    finalRuling <= headRef when "0011",
                   headRef when "0101",
                   headRef when "0110",
                   headRef when "1001",
                   headRef when "1010",
                   headRef when "1100",
                   ref01 when "0001",
                   ref01 when "0010",
                   ref01 when "0111",
                   ref01 when "1000",
                   ref01 when "1110",
                   ref01 when "1101",
                   ref02 when "0100",
                   ref03 when others;
                   
end RefereeTieBreaker_ARCH;

-- End of Archetecture code ---
