with Ada.Text_IO; use Ada.Text_IO;

procedure December_17 is

   Buffer_Size : constant Natural := 2018;  -- Part 1
   Step_Size : constant Natural := 303; -- Final

   subtype Buffer_Indices is Natural range 0 .. Buffer_Size - 1;
   Current_Position : Buffer_Indices := 1;
   Insert_Position : Buffer_Indices;
   Current_Buffer_Size : Positive;

   Buffer : array (Buffer_Indices) of Natural := (0, 1, others => Natural'Last);

   procedure Insert (Insert_Position : in Buffer_Indices;
                     To_Insert : in Buffer_Indices) is

   begin -- Insert
      for I in reverse Buffer_Indices range
        Insert_Position .. Current_Buffer_Size - 1 loop
         Buffer (I + 1) := Buffer (I);
      end loop;
      Buffer (Insert_Position ) := To_Insert;
   end Insert;

begin -- December_17
   for I in Buffer_Indices range 2 .. Buffer_Indices'Last loop
      Current_Buffer_Size := I ;
      Insert_Position := (Current_Position + Step_Size + 1) mod
        Current_Buffer_Size;
      Insert (Insert_Position, I);
      Current_Position := Insert_Position;
   end loop;
   Put_Line ("Number After" & Natural'Image (Buffer (Current_Position)) &
               " is" & Natural'Image (Buffer (Current_Position + 1)));
end December_17;
