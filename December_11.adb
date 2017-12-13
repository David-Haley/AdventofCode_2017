with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Interfaces; use Interfaces;

procedure December_11 is
   Input_File : File_Type;
   Stream_Length : Natural;
   Text : Unbounded_String;
   Direction_Set : Character_Set := To_Set ("ensw");
   First, Start_From : Positive;
   Last : Natural;
   Maximum_Distance : Natural := 0;

   type Directions is (N, S, NE, NW, SE, SW);

   X, Y : Integer;

   function Get_Direction return Directions is

      Result : Directions;

   begin -- Get_Direction
      Find_Token (text, Direction_Set, Start_From, Inside, First, Last);
      Result := Directions'Value
        (To_String (Unbounded_Slice (Text, First, Last)));
      Start_From := Last + 1;
      return Result;
   end Get_Direction;

   procedure Step (X, Y : in out Integer; Direction : in Directions) is

   begin -- Step
      case Direction is
         when N =>
            Y := Y + 2;
         when S =>
            Y := Y - 2;
         when NE =>
            X := X + 1;
            Y := Y + 1;
         when NW =>
            X := X - 1;
            Y := Y + 1;
         when SE =>
            X := X + 1;
            Y := Y - 1;
         when SW =>
            X := X - 1;
            Y := Y - 1;
      end case; -- Direction
   end Step;

   function Distance (X, Y : in Integer) return Natural is

   begin -- Distance
      if abs (X) = abs (Y) then
         return abs (X);
         -- diaginal
      elsif X = 0 then
         return abs (Y) / 2;
         -- vertical
      elsif (abs (Y) = 1) or (abs (Y) = 2) then
         return abs (X);
         -- horizontal
      elsif abs (Y) > abs (X) then
         return (abs (y) - abs (x)) / 2 + abs (x);
      else
         if abs (Y) mod 2 = 0 then
            return abs (Y) - 2  + abs (x) - (abs (y) - 2);
         else
            return abs (Y) - 1  + abs (x) - (abs (y) - 1);
         end if; -- Y even
      end if;
   end Distance;

begin -- December_11
   Open (Input_File, In_File, "20171211.txt");
   Text := To_Unbounded_String (Get_line (Input_File));
   Close (Input_File);
   Stream_Length := Ada.Strings.Unbounded.Length (Text);
   Start_From := 1;
   X := 0;
   Y := 0;
   while Start_From < Stream_Length loop
      Step (X, Y, Get_Direction);
      if Distance (X, Y) > Maximum_Distance then
         Maximum_Distance := Distance (X, Y);
      end if;
   end loop; -- process one item
   Put_Line ("X:" & Integer'Image (X) & " Y: " & Integer'Image (X));
   Put_Line ("Maximum:" & Natural'Image (Maximum_Distance));
end December_11;
