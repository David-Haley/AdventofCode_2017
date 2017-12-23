with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with CPU_18;

procedure December_18a is

   package CPU0 is new CPU_18 (0, "20171218.txt", "20171218_out0.txt");

   package CPU1 is new CPU_18 (1, "20171218.txt", "20171218_out1.txt");

begin -- December_18a
   CPU0.Run_CPU.Start_CPU;
   CPU1.Run_CPU.Start_CPU;
end December_18a;
