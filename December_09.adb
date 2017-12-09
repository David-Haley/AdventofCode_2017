with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure December_09 is
   Sum : Natural := 0;
   Depth : Natural := 0;
   Input_File : File_Type;
   Text : Unbounded_String;
   Stream_Length : Natural;
   Position : Natural := 1;
   Garbage : Natural := 0;

   Start_Group : constant Character := '{';
   End_Group : constant Character := '}';
   Start_Garbage : constant Character := '<';
   End_Garbage : constant Character := '>';
   Escape : constant Character := '!';

   procedure Process_Stream (Depth : in Natural;
                             Sum : in out Natural) is
      procedure Advance is

      begin -- Advance
         Position := Position + 1;
      end Advance;

   begin -- Process_Stream
      while Position <= Stream_Length loop
         case Element (Text, Position) is
            when Start_Group =>
               Advance;
               Process_Stream (Depth + 1, Sum);
            when End_Group =>
               Sum := Sum + Depth;
               exit;
            when Start_Garbage =>
               while Position <= Stream_Length and then
                 Element (Text, Position) /= End_Garbage loop
                  if Element (Text, Position) = Escape then
                     Advance; -- discard next character
                  else
                     Garbage := Garbage + 1;
                  end if;
                  Advance;
               end loop;
               Garbage := Garbage - 1; -- take off 1 for the Start_Garbage
            when Escape =>
               Advance; -- discard next character
            when Others =>
               null;
         end case;
         Advance;
      end loop;
   end Process_Stream;

begin -- December_09
   Open (Input_File, In_File, "20171209.txt");
   Text := To_Unbounded_String (Get_line (Input_File));
   Close (Input_File);
   Stream_Length := Length (Text);
   Put_Line ("Stream Length" & Natural'Image (Stream_Length));
   Process_Stream (Depth, Sum);
   Put_Line ("Score:" & Natural'Image (Sum));
   Put_Line ("Garbage:" & Natural'Image (Garbage));
end December_09;
