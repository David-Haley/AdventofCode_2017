with Ada.Text_IO; use Ada.Text_IO;

procedure December_02 is

   Minimum, Maximum, Item : integer;
   Sum : Integer := 0;
   First_Item : Boolean;
   Input_File : File_Type;

   package Int_IO is new Integer_IO (Integer); use Int_IO;

begin -- December_02
   Open (Input_File, In_File, "20171202.txt");
   while not End_Of_File (Input_File) loop
      First_Item := True;
      while not End_Of_Line (Input_File) loop
         Get (Input_File, Item);
         if First_Item then
            Minimum := Item;
            Maximum := Item;
            First_Item := False;
         end if;
         if Minimum > Item then
            Minimum := Item;
         end if;
         if Maximum < Item then
            Maximum := Item;
         end if;
      end loop;
      Sum := Sum + (Maximum -Minimum);
      Skip_Line (Input_File);
   end loop;
   Put ("Checksum: ");
   Put (Sum);
   New_Line;
end December_02;
