with Ada.Text_IO; use Ada.Text_IO;

procedure December_03 is

-- 17  16  15  14  13
-- 18   5   4   3  12
-- 19   6   1   2  11
-- 20   7   8   9  10
-- 21  22  23---> ...

   Max_Coordinate : constant Integer := 1000;

   subtype Bounds is integer range 0 .. Max_Coordinate;

   subtype Coordinates is integer range - Max_Coordinate .. Max_Coordinate;

   subtype Grid_Addresses is Positive range 1 .. (2 * Max_Coordinate + 1) ** 2;

   subtype Distances is Natural range 0 .. (Max_Coordinate + 1) ** 2;

   Current_Bound : Bounds := 0;

   X, Y : Coordinates := 0; -- address 1 lives here (0, 0)

   Required_Address : Grid_Addresses;

   Distance : Distances;

   package Address_IO is new Integer_IO (Grid_Addresses);

   package Coordinate_IO is new Integer_IO (Coordinates);

   package Distance_IO is new Integer_IO (Distances);

begin -- December_03
   Put ("Address: ");
   Address_IO.Get (Required_Address);
   for Current_Address in Grid_Addresses range 2 .. Required_Address loop
      if X = Current_Bound and Y = - Current_Bound then
         -- bottom right corner has been reached
         Current_Bound := Current_Bound + 1;
         X := Current_Bound;
      elsif X = Current_Bound and Y < Current_Bound then
         -- Step up
         Y := Y + 1;
      elsif Y = Current_Bound and X > - Current_Bound then
         -- step left
         X := X - 1;
      elsif X = - Current_Bound and Y > - Current_Bound then
         -- step down
         Y := Y - 1;
      elsif Y = - Current_Bound and X < Current_Bound then
         -- step right
         X := X + 1;
      end if;
   end loop; -- Current_Address in Grid_Addresses range 2 .. Required_Address
   Distance := abs (X) + abs (Y);
   Put ( '(');
   Coordinate_IO.Put (X);
   Put ( ',' );
   Coordinate_IO.Put (Y);
   Put ( ") Distance: ");
   Distance_IO.Put (Distance);
   New_Line;
end December_03;
