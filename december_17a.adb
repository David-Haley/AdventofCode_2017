with Ada.Text_IO; use Ada.Text_IO;

procedure December_17a is
   Buffer_Size : constant Natural := 50000001;  -- Part 2
   Step_Size : constant Natural := 303; -- Final

   subtype Buffer_Indices is Natural range 0 .. Buffer_Size - 1;
   Current_Position : Buffer_Indices := 1;
   Insert_Position : Buffer_Indices;
   Current_Buffer_Size : Positive;
   Zero_Location : Buffer_Indices := 0;
   Next_To_Zero_Value : Natural;

begin -- December_17a
   for I in Buffer_Indices range 2 .. Buffer_Indices'Last loop
      Current_Buffer_Size := I ;
      Insert_Position := (Current_Position + Step_Size + 1) mod
        Current_Buffer_Size;
      if Insert_Position <= Zero_Location then
         Zero_Location := Zero_Location + 1;
      elsif Insert_Position = Zero_Location + 1 then
         Next_To_Zero_Value := I;
      end if;
      Current_Position := Insert_Position;
   end loop;
   Put_Line ("Value after 0 Buffer (" & Buffer_Indices'Image (Zero_Location + 1) & "):" &
               Natural'Image (Next_To_Zero_Value));
end December_17a;
