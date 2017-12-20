with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure December_19 is
   Input_File : File_Type;
   Text : Unbounded_String;

   subtype Coordinates is Natural range 1 .. 200;
   Vert : constant Character := '|';
   Horz : constant Character := '-';
   Turn : constant Character := '+';
   Term : constant Character := ' ';


   Grid : array (Coordinates, Coordinates) of Character;

   Type Directions is (Up, Down, Left, Right);

   type State_Record is record
      X : Coordinates;
      Y : Coordinates := 1;
      Direction : Directions := Down;
      Path : Unbounded_String := Null_Unbounded_String;
      Path_Length : Positive := 1; -- includes entrance character
      At_End : Boolean;
   end record;

   Status : State_Record;

   function Find_Entrance return Coordinates is
      -- returnx Column of entrance
   begin -- Find_Entrance
      For Column in Coordinates loop
         if Grid (Column, 1) = Vert then
            return Column;
         end if;
      end loop;
      return 1; -- only to keep the compiler happy
   end Find_Entrance;

   function Next_State (Status : in State_Record) return State_Record is

      New_State : State_Record;

   begin
      New_State := Status;
      case Grid (Status.X, Status.Y) is
         when Vert =>
            if Status.Direction = Up then
               New_State.Y := Status.Y - 1;
            elsif Status.Direction = Down then
               New_State.Y := Status.Y + 1;
            elsif Status.Direction = Left then
               New_State.X := Status.X - 2;
            elsif Status.Direction = Right then
               New_State.X := Status.X + 2;
            end if;
         when Horz =>
            if Status.Direction = Left then
               New_State.X := Status.X - 1;
            elsif Status.Direction = Right then
               New_State.X := Status.X + 1;
            elsif Status.Direction = Up then
               New_State.Y := Status.Y - 2;
            elsif Status.Direction = Down then
               New_State.Y := Status.Y + 2;
            end if;
         when Turn =>
            if Status.Direction = Up or Status.Direction = Down then
               if Status.X + 1 <= Coordinates'Last and then
                 Grid (Status.X + 1, Status.Y) = Horz then
                  New_State.Direction := Right;
                  New_State.X := Status.X + 1;
               elsif Status.X - 1 >= Coordinates'First and then
                 Grid (Status.X - 1, Status.Y) = Horz then
                  New_State.Direction := Left;
                  New_State.X := Status.X - 1;
               else
                  New_State.At_End := True;
               end if;
            elsif Status.Direction = Left or Status.Direction = Right then
               if Status.Y + 1 <= Coordinates'Last and then
                 Grid (Status.X, Status.Y + 1) = Vert then
                  New_State.Direction := Down;
                  New_State.Y := Status.Y + 1;
               elsif  Status.Y - 1 >= Coordinates'First and then
                 Grid (Status.X, Status.Y - 1) = Vert then
                  New_State.Direction := Up;
                  New_State.Y := Status.Y - 1;
               else
                  New_State.At_End := True;
               end if;
            end if;
         when Term =>
            New_State.At_End := True;
         when others =>
            Append (New_State.Path, Grid (Status.X, Status.Y));
            if Status.Direction = UP and then
              Status.Y - 1 >= Coordinates'First and then
              Grid (Status.X, Status.Y - 1) = Vert then
               New_State.Y := Status.Y - 1;
            elsif Status.Direction = Down and then
              Status.Y + 1 <= Coordinates'Last and then
              Grid (Status.X, Status.Y + 1) = Vert then
               New_State.Y := Status.Y + 1;
            elsif Status.Direction = Left and then
              Status.X - 1 >= Coordinates'First and then
              Grid (Status.X - 1, Status.Y) = Horz then
               New_State.X := Status.X - 1;
            elsif Status.Direction = Right and then
              Status.X + 1 <= Coordinates'Last and then
              Grid (Status.X + 1, Status.Y) = Horz then
               New_State.X := Status.X + 1;
            else
               New_State.At_End := True;
            end if;
      end case; -- Status.Direction
      New_State.Path_Length := Status.Path_Length +
      abs (New_State.X - Status.X) +
      abs (New_State.Y - Status.Y);
      return New_State;
   end Next_State;

begin -- December_19
   Open (Input_File, In_File, "20171219.txt");
   for Row in Coordinates loop
      Text := To_Unbounded_String (Get_Line (Input_File));
      for Column in Coordinates loop
         if Column <= Length (Text) then
            Grid (Column, Row) := Element (Text, Column);
         else
            Grid (Column, Row) := Term;
         end if;
      end loop;
   end loop;
   Close (Input_File);
   Status.X := Find_Entrance;
   while not Status.At_End loop
      Status := Next_State (Status);
   end loop;
   Put_Line ("Path: " & To_String (Status.Path));
   Put_Line ("Path Length: " & Positive'Image (Status.Path_Length));
end December_19;
