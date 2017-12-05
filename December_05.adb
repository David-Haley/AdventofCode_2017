with Ada.Text_IO; use Ada.Text_IO;

procedure December_05 is


   Step_Count, Line_Count : Natural := 0;
   Input_File : File_Type;

   package Int_IO is new Integer_IO (Integer); use Int_IO;

begin -- December_05
   Open (Input_File, In_File, "20171205.txt");
   while not End_Of_File (Input_File) loop
      Line_Count := Line_Count + 1;
      Skip_Line (Input_File);
   end loop;
   Reset (Input_File);
   declare
      Increment : constant Natural := 1;
      subtype Jump_Indices is Natural range 0 .. Line_Count - 1;
      Jump_Table : array (Jump_Indices) of Integer;
      Next_Jump, Previous : Jump_Indices := 0;
   begin
      for Index in Jump_Indices loop
         Get (input_File, Jump_Table (Index));
      end loop;
      loop
         Step_Count := Step_Count + 1;
         if Jump_Table (Next_Jump) + Next_Jump > Jump_Indices'Last then
            exit;
         else
            Next_Jump := Jump_Table (Next_Jump) + Next_Jump;
            Jump_Table (Previous) := Jump_Table (Previous) + Increment;
            Previous := Next_Jump;
         end if;
      end loop;
   end; -- declaration block
   Put_Line ("Step Count:" & Natural'Image (Step_Count));
end December_05;
