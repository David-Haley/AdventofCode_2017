with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

generic
Source_File_Name : String;
   Trace_File_Name : String;
   Debug_Switch : Boolean := False;

package Coprocessor_23 is

   subtype Registers is Character range 'a' .. 'h';

   procedure Execute;

   function Multiply_Count return Natural;

   function Read_Register (Register: in Registers) return Long_Long_Integer;

end Coprocessor_23;
