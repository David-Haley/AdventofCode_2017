with Ada.Text_IO; use Ada.Text_IO;

procedure December_02a is

   subtype Indices is Integer range 1 .. 16;
   Data : array (Indices) of Integer;
   Quotient : integer;
   Sum : Integer := 0;
   Input_File : File_Type;

   package Int_IO is new Integer_IO (Integer); use Int_IO;

begin -- December_02a
   Open (Input_File, In_File, "20171202.txt");
   while not End_Of_File (Input_File) loop
      for Index in Data'First .. Data'Last loop
         Get (Input_File, Data (Index));
      end loop;
      for Dividend_Index in Data'First .. Data'Last loop
         for Divisor_Index in Data'First .. Data'Last loop
            if Dividend_Index /= Divisor_Index then
               if Data (Dividend_Index) mod Data (Divisor_Index) = 0 then
                  Quotient := Data (Dividend_Index) / Data (Divisor_Index);
               end if;
            end if;
         end loop; -- Divisor_Index
      end loop; -- Dividend_Index
      Sum := Sum + Quotient;
      Skip_Line (Input_File);
   end loop;
   Put ("Checksum: ");
   Put (Sum);
   New_Line;
end December_02a;
