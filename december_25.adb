with Ada.Text_IO; use Ada.Text_IO;

procedure December_25 is

   type States is (A, B, C, D, E, F);

   Tape_Limit : constant Integer := 10000000;

   subtype Tape_Indices is Integer range -Tape_Limit .. Tape_Limit;

   Tape : array (Tape_Indices) of Boolean := (others => False);

   Cursor : Tape_Indices := 0;
   Current_State : States := A;

   Checksum : Natural := 0;

begin -- December_25
   for I in Positive range 1 .. 12302209 loop
      Case Current_State is
         when A =>
            -- If the current value is 1:
            --    Write the value 0.
            --    Move one slot to the left.
            --    Continue with state D.
            -- If the current value is 0:
            --    Write the value 1.
            --    Move one slot to the right.
            --    Continue with state B.
            if Tape (Cursor) then
               Tape (Cursor) := False;
               Cursor := Cursor - 1;
               Current_State := D;
            else
               Tape (Cursor) := True;
               Cursor := Cursor + 1;
               Current_State := B;
            end if; -- Tape (Cursor)
         when B =>
            -- If the current value is 1:
            --    Write the value 0.
            --    Move one slot to the right.
            --    Continue with state F.
            -- If the current value is 0:
            --    Write the value 1.
            --    Move one slot to the right.
            --    Continue with state C.
            if Tape (Cursor) then
               Tape (Cursor) := False;
               Cursor := Cursor + 1;
               Current_State := F;
            else
               Tape (Cursor) := True;
               Cursor := Cursor + 1;
               Current_State := C;
            end if; -- Tape (Cursor)
         when C =>
            -- If the current value is 1:
            --    Write the value 1.
            --    Move one slot to the left.
            --    Continue with state A.
            -- If the current value is 0:
            --    Write the value 1.
            --    Move one slot to the left.
            --    Continue with state C.
            if Tape (Cursor) then
               Cursor := Cursor - 1;
               Current_State := A;
            else
               Tape (Cursor) := True;
               Cursor := Cursor - 1;
            end if; -- Tape (Cursor)
         when D =>
            -- If the current value is 1:
            --    Write the value 1.
            --    Move one slot to the right.
            --    Continue with state A.
            -- If the current value is 0:
            --    Write the value 0.
            --    Move one slot to the left.
            --    Continue with state E.
            if Tape (Cursor) then
               Cursor := Cursor + 1;
               Current_State := A;
            else
               Cursor := Cursor - 1;
               Current_State := E;
            end if; -- Tape (Cursor)
         when E =>
            -- If the current value is 1:
            --    Write the value 0.
            --    Move one slot to the right.
            --    Continue with state B.
            -- If the current value is 0:
            --    Write the value 1.
            --    Move one slot to the left.
            --    Continue with state A.
            if Tape (Cursor) then
               Tape (Cursor) := False;
               Cursor := Cursor + 1;
               Current_State := B;
            else
               Tape (Cursor) := True;
               Cursor := Cursor - 1;
               Current_State := A;
            end if; -- Tape (Cursor)
         when F=>
            -- If the current value is 1:
            --    Write the value 0.
            --    Move one slot to the right.
            --    Continue with state E.
            -- If the current value is 0:
            --    Write the value 0.
            --    Move one slot to the right.
            --    Continue with state C.
            if Tape (Cursor) then
               Tape (Cursor) := False;
               Cursor := Cursor + 1;
               Current_State := E;
            else
               Cursor := Cursor + 1;
               Current_State := C;
            end if; -- Tape (Cursor)
      end case; -- Current_State
   end loop;
   for Tape_Index in Tape_Indices loop
      if Tape (Tape_Index) then
         Checksum := Checksum + 1;
      end if; -- Tape_Index in Tape_Indices
   end loop;
   Put_Line ("Checksum:" & Natural'Image (Checksum));
end December_25;
