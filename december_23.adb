with Ada.Text_IO; use Ada.Text_IO;
with Coprocessor_23;

procedure December_23 is

   package Coprocessor_1 is new Coprocessor_23 ("20171223.txt",
                                              "20171223_Out.txt");

   package Coprocessor_2 is new Coprocessor_23 ("20171223.txt",
                                                "nul", True);
   -- Debug enabled

begin -- December_23
   Coprocessor_1.Execute;
   Put_line ("Multiply Count:" & Natural'Image (Coprocessor_1.Multiply_Count));
   Coprocessor_2.Execute;
   Put_line ("Register (h):" &
               Long_Long_Integer'Image (Coprocessor_2.Read_Register ('h')));
end December_23;
