with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Communications_18; use Communications_18;

generic
   CPU_ID : CPU_IDs;
   Source_File_Name : String;
   Trace_File_Name : String;

package CPU_18 is

   task Run_CPU is
      entry Start_CPU;
   end;

end CPU_18;
