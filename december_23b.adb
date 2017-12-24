with Ada.Text_IO; use Ada.Text_IO;

procedure December_23b is

   Lower_Limit : constant Positive :=  65 * 100 + 100000;
   Upper_Limit : constant Positive := Lower_Limit + 17000;
   Increment : constant Positive := 17;
   Number : Positive := Lower_Limit;
   Prime: array (1 .. Upper_Limit) of Boolean := (1 => False, others => True);
   Base: Positive := 2;
   Cnt: Positive;
   Prime_Count : Natural := 0;
begin -- December_23b
   while Base * Base <= Upper_Limit loop
      if Prime(Base) then
         Cnt := Base + Base;
         loop
            exit when Cnt > Upper_Limit;
            Prime(Cnt) := False;
            Cnt := Cnt + Base;
         end loop;
      end if;
      Base := Base + 1;
   end loop;
   while Number <= Upper_Limit loop
      if not Prime(Number) then
         Prime_Count := Prime_Count + 1;
      end if;
      Number := Number + Increment;
   end loop;
   Put_Line ("Non primed in range" & Positive'Image(Lower_Limit) &
               " .." & Positive'Image (Upper_Limit) & " is:" &
               Natural'Image (Prime_Count));
end ;
