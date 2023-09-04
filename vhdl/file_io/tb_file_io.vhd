----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-09-03
-- Design Name:    tb_file_io
-- Module Name:    
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 4.0.0-dev
-- Description:    
-- Dependencies:   
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
 
entity tb_file_io is
 
end tb_file_io;
 
 
architecture behave of tb_file_io is
 
  -----------------------------------------------------------------------------
  -- Declare the Component Under Test
  -----------------------------------------------------------------------------
  component module_ripple_carry_adder is
    generic (
      g_WIDTH : natural);
    port (
      i_add_term1 : in  std_logic_vector(g_WIDTH-1 downto 0);
      i_add_term2 : in  std_logic_vector(g_WIDTH-1 downto 0);
      o_result    : out std_logic_vector(g_WIDTH downto 0)
      );
  end component module_ripple_carry_adder;
 
 
  -----------------------------------------------------------------------------
  -- Testbench Internal Signals
  -----------------------------------------------------------------------------
  file file_VECTORS : text;
  file file_RESULTS : text;
 
  constant c_WIDTH : natural := 4;
 
  signal r_ADD_TERM1 : std_logic_vector(c_WIDTH-1 downto 0) := (others => '0');
  signal r_ADD_TERM2 : std_logic_vector(c_WIDTH-1 downto 0) := (others => '0');
  signal w_SUM       : std_logic_vector(c_WIDTH downto 0);
   
begin
 
  -----------------------------------------------------------------------------
  -- Instantiate and Map UUT
  -----------------------------------------------------------------------------
  MODULE_RIPPLE_CARRY_ADDER_INST : module_ripple_carry_adder
    generic map (
      g_WIDTH => c_WIDTH)
    port map (
      i_add_term1 => r_ADD_TERM1,
      i_add_term2 => r_ADD_TERM2,
      o_result    => w_SUM
      );
 
 
  ---------------------------------------------------------------------------
  -- This procedure reads the file input_vectors.txt which is located in the
  -- simulation project area.
  -- It will read the data in and send it to the ripple-adder component
  -- to perform the operations.  The result is written to the
  -- output_results.txt file, located in the same directory.
  ---------------------------------------------------------------------------
  process
    variable v_ILINE     : line;
    variable v_OLINE     : line;
    variable v_ADD_TERM1 : std_logic_vector(c_WIDTH-1 downto 0);
    variable v_ADD_TERM2 : std_logic_vector(c_WIDTH-1 downto 0);
    variable v_SPACE     : character;
     
  begin
 
    file_open(file_VECTORS, "input_vectors.txt",  read_mode);
    file_open(file_RESULTS, "output_results.txt", write_mode);
 
    while not endfile(file_VECTORS) loop
      readline(file_VECTORS, v_ILINE);
      read(v_ILINE, v_ADD_TERM1);
      read(v_ILINE, v_SPACE);           -- read in the space character
      read(v_ILINE, v_ADD_TERM2);
 
      -- Pass the variable to a signal to allow the ripple-carry to use it
      r_ADD_TERM1 <= v_ADD_TERM1;
      r_ADD_TERM2 <= v_ADD_TERM2;
 
      wait for 60 ns;
 
      write(v_OLINE, w_SUM, right, c_WIDTH);
      writeline(file_RESULTS, v_OLINE);
    end loop;
 
    file_close(file_VECTORS);
    file_close(file_RESULTS);
     
    wait;
  end process;
 
end behave;
