with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Interfaces; use Interfaces;
with Knot_Hash; use Knot_Hash;

procedure December_10a is
   Input_File : File_Type;
   Hash_Result : Hash_Results;

   procedure Put_Byte (Value : Unsigned_8) is

      function Digit_Out (N : in Unsigned_8) return Character is

      begin -- Digit_out
         if N <= 9 then
            return Character'Val (N + Character'Pos ('0'));
         else
            return Character'Val (N - 10 + Character'Pos ('a'));
         end if;
      end Digit_Out;

   begin
      Put (Digit_Out (Value / 16) & Digit_Out (Value mod 16));
   end;

begin -- December_10a
   Open (Input_File, In_File, "20171210.txt");
   Hash_Result := Hash (To_Unbounded_String (Get_line (Input_File)));
   Close (Input_File);
   Put ("Result: ");
   for Block_index in Block_Indices loop
      Put_Byte (Hash_Result (Block_index));
   end loop; -- Block_Indices
   New_line;
end December_10a;
