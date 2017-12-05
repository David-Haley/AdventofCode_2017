with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure December_01a is

Input_Text : Unbounded_String;
Sum : Natural := 0;

begin -- December_01a
   Input_Text := To_Unbounded_String (Get_Line);
   for Index in Positive range 1 .. Length (Input_Text) / 2 loop
      if Element (Input_Text, Index) =
        Element (Input_Text, Index + Length (Input_Text) / 2) then
         Sum := Sum +
           2 * Natural'Value ("10#" & Element (Input_Text, Index) & "#");
      end if;
   end loop;
   Put_Line (Natural'Image (Sum));
end December_01a;
