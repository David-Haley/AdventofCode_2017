with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure December_22 is

   Maximum_Coordinate : constant Integer := 1000;

   subtype Coordinates is integer range -Maximum_Coordinate ..
     Maximum_Coordinate;
   Infected : constant Character := '#';
   Clean : constant Character := '.';

   type Grids is array (Coordinates, Coordinates) of Boolean;

   Grid : Grids  := (others => (others => False));

   Type Directions is (Up, Down, Left, Right);

   type Carrier_States is record
      X : Coordinates :=  0;
      Y : Coordinates := 0;
      Direction : Directions := Up;
      Infection_Count : Natural := 0;
   end record;

   Carrier_State : Carrier_States;

   procedure Read_Grid (Grid : out Grids) is

      Input_File : File_Type;
      Text : Unbounded_String;

      Offset : Integer;

   begin -- Read_Grid
      Open (Input_File, In_File, "20171222.txt");
      Text := To_Unbounded_String (Get_Line (Input_File));
      Offset := Length (Text) / 2;
      Reset (Input_File);
      for Row in reverse Coordinates range -Offset .. Offset loop
         Text := To_Unbounded_String (Get_Line (Input_File));
         for Column in Coordinates range -Offset .. Offset loop
            Grid (Column, Row) := Element (Text, Column + Offset + 1) =
              Infected;
         end loop; -- Column
      end loop; -- Row
      Close (Input_File);
   end Read_Grid;

   Procedure Next_State (Carrier_State : in out Carrier_States;
                        Grid : in out Grids) is

   begin -- Next_State
      if Grid (Carrier_State.X, Carrier_State.Y) then
         -- Infected turn Right
         case Carrier_State.Direction is
            when Up =>
               Carrier_State.Direction := Right;
            when Right =>
               Carrier_State.Direction := Down;
            when Down =>
               Carrier_State.Direction := Left;
            when Left =>
               Carrier_State.Direction := Up;
         end case; -- Carrier_State.Direction
         Grid (Carrier_State.X, Carrier_State.Y) := False; -- Clean
      else
         -- Clean turn Left
         case Carrier_State.Direction is
            when Up =>
               Carrier_State.Direction := Left;
            when Right =>
               Carrier_State.Direction := Up;
            when Down =>
               Carrier_State.Direction := Right;
            when Left =>
               Carrier_State.Direction := Down;
         end case; -- Carrier_State.Direction
         Grid (Carrier_State.X, Carrier_State.Y) := True; -- Infect
         Carrier_State.Infection_Count := Carrier_State.Infection_Count + 1;
      end if;  -- Grid (Carrier_State.X; Carrier_State.Y)
      case Carrier_State.Direction is
         when Up =>
            Carrier_State.Y := Carrier_State.Y + 1;
         when Right =>
            Carrier_State.X := Carrier_State.X + 1;
         when Down =>
            Carrier_State.Y := Carrier_State.Y - 1;
         when Left =>
            Carrier_State.X := Carrier_State.X - 1;
      end case; -- Carrier_State.Direction
   end Next_State;

   procedure Put_Grid (Grid : in Grids; Limit : in Integer) is

   begin -- Put Grid
      for Y in reverse Coordinates range -Limit .. Limit loop
         for X in Coordinates range -Limit .. Limit loop
            If Grid (X, Y) then
               Put (Infected);
            else
               Put (Clean);
            end if; -- Grid (X, Y)
         end loop; -- X
         New_Line;
      end loop; -- Y
   end Put_Grid;

begin -- December_22
   Read_Grid (Grid);
   Put_Grid (Grid, 12);
   for I in Positive range 1 .. 10000 loop
      Next_State (Carrier_State, Grid);
   end loop;
   Put_Line ("Infected Count:" &
               Natural'Image (Carrier_State.Infection_Count));
end December_22;
