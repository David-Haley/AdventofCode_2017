with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure December_01 is

Input_Text : Unbounded_String;
Sum : Natural := 0;

begin -- December_01
   Input_Text := To_Unbounded_String (Get_Line);
   for Index in Positive range 2 .. Length (Input_Text) loop
      if Element (Input_Text, Index - 1) = Element (Input_Text, Index) then
         Sum := Sum + Natural'Value ("10#" & Element (Input_Text, Index) & "#");
      end if;
   end loop;
   if Element (Input_Text, 1) = Element (Input_Text, Length (Input_Text)) then
      Sum := Sum + Natural'Value ("10#" & Element (Input_Text, 1) & "#");
   end if;
   Put_Line (Natural'Image (Sum));
end December_01;
