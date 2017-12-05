with Ada.Text_IO; use Ada.Text_IO;

procedure December_03a is

   -- 147  142  133  122   59
   -- 304    5    4    2   57
   -- 330   10    1    1   54
   -- 351   11   23   25   26
   -- 362  747  806--->   ...

   Max_Coordinate : constant Integer := 1000;

   subtype Bounds is integer range 0 .. Max_Coordinate;

   subtype Coordinates is integer range - Max_Coordinate .. Max_Coordinate;

   subtype Values is Natural;

   Grid : array (Coordinates, Coordinates) of Values;

   Current_Bound : Bounds := 0;

   X, Y : Coordinates := 0; -- address 1 lives here (0, 0)

   Penultimate_Value : Values;

   package Value_IO is new Integer_IO (Values);

   package Coordinate_IO is new Integer_IO (Coordinates);

   function Value_Of ( X, Y : in Coordinates; Current_Bound : in Bounds)
                      return Values is

      Value : Values := 0;

   begin -- Value_Of
      if X + 1 <= Current_Bound then
         Value := Value + Grid (X + 1, Y);
         if Y + 1 <= Current_Bound then
            Value := Value + Grid (X + 1, Y + 1);
         end if;
         if Y - 1 >= -Current_Bound then
            Value := Value + Grid (X + 1, Y - 1);
         end if;
      end if; -- X + 1 <= Current_Bound
      if X - 1 >= - Current_Bound then
         Value := Value + Grid (X - 1, Y);
         if Y + 1 <= Current_Bound then
            Value := Value + Grid (X - 1, Y + 1);
         end if;
         if Y - 1 >= -Current_Bound then
            Value := Value + Grid (X - 1, Y - 1);
         end if;
      end if; -- X - 1 >= - Current_Bound
      if Y + 1 <= Current_Bound then
         Value := Value + Grid (X, Y + 1);
      end if;
      if Y - 1 >= -Current_Bound then
         Value := Value + Grid (X, Y - 1);
      end if;
      return Value;
   end Value_Of;

begin -- December_03a
   for X in Coordinates loop
      for Y in Coordinates loop
         Grid (X, Y) := 0;
      end loop;
   end loop;
   Grid (0, 0) := 1; -- don't know how to initialise this otherwise
   Put ("Value: ");
   Value_IO.Get (Penultimate_Value);
   while Penultimate_Value >= Grid (X, Y) loop
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
      Grid (X, Y) := Value_Of (X, Y, Current_Bound);
   end loop; -- Penultimate_Value >= Grid (X, Y)
   Put ( '(');
   Coordinate_IO.Put (X);
   Put ( ',' );
   Coordinate_IO.Put (Y);
   Put ( ") Value: ");
   Value_IO.Put (Grid (X, Y));
   New_Line;
end December_03a;
