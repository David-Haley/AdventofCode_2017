with Ada.Text_IO; use Ada.Text_IO;
with Ada.Assertions; use Ada.Assertions;

procedure December_24 is

   subtype Pins is Natural range 0 .. 50;
   type Bridge_Elements is record
      End_A : Pins;
      End_B :Pins;
      Used : Boolean := False;
   end record;

   subtype Component_Indices is Natural range 0 .. 53;

   type Components is array (Component_Indices) of Bridge_Elements;

   Component : Components;
   Bridge_Strength, Maximum_Bridge_Strength,
   Long_Bridge_Strength : Natural := 0;
   Longest_Bridge : Natural := 0;
   Start, Next : Component_Indices;
   Found : Boolean;

   package Pin_IO is new Ada.Text_IO.Integer_IO (Pins); use Pin_IO;

   procedure Read_Components (Component : out Components) is

      Input_File : File_Type;
      Slash : Character;

   begin -- Read_Components
      Open (Input_File, In_File, "20171224.txt");
      For I in Component_indices loop
         Get (Input_File, Component (I).End_A);
         Get (Input_File, Slash);
         Assert (Slash = '/', "Slash not found");
         Get (Input_File, Component (I).End_B);
         Skip_Line (Input_File);
      end loop;
      Close (Input_File);
   end Read_Components;

   procedure Find (Start : in Component_indices; To_Find : in Pins;
                   Next : out Component_Indices; Found : out Boolean) is

      Temp : Pins;

   begin -- Find
      Next := Component_Indices'First;
      Found := False;
      for I in Component_Indices range Start .. Component_Indices'Last loop
         if (Component (I).End_A = To_Find or Component (I).End_B = To_Find) and
           not Component (I).Used then
            Next := I;
            Found := True;
            if Component (I).End_B = To_Find then
               -- reverse order so End_A matches search value
               Temp := Component (I).End_A;
               Component (I).End_A := Component (I).End_B;
               Component (I).End_B := Temp;
            end if;
            exit;
         end if;  -- found
      end loop;
   end Find;

   procedure Build (Left_End : in Component_Indices;
                    Bridge_Length : in Natural) is

      Start, Next : Component_Indices := Component_Indices'First;
      Found : Boolean;

   begin --Build
      Component (Left_End).Used := True;
      Bridge_Strength := Bridge_Strength + Component (Left_End).End_A +
        Component (Left_End).End_B;
      if Bridge_Strength > Maximum_Bridge_Strength then
         Maximum_Bridge_Strength := Bridge_Strength;
      end if;
      if Bridge_Length > Longest_Bridge then
         Longest_Bridge := Bridge_Length;
         Long_Bridge_Strength := Bridge_Strength;
      elsif Bridge_Length = Longest_Bridge and
        Bridge_Strength > Long_Bridge_Strength then
         Long_Bridge_Strength := Bridge_Strength;
      end if;
      loop
         Find (Start, Component (Left_End).End_B, Next, Found);
         if Found then
            Build (Next, Bridge_Length + 1);
         else
            exit;
         end if;
         If Next < Component_Indices'Last then
            Start := Next + 1;
         else
            exit;
         end if;
      end loop;
      Bridge_Strength := Bridge_Strength - Component (Left_End).End_A -
        Component (Left_End).End_B;
      Component (Left_End).Used := False;
   end Build;

begin -- December_24
   Read_Components (Component);
   Start := Component_Indices'First;
   loop
      Find (Start, 0, Next, Found);
      if Found then
         Build (Next, 1);
      else
         exit;
      end if;
      If Next < Component_Indices'Last then
         Start := Next + 1;
      else
         exit;
      end if;
   end loop;
   Put_Line ("Maximum Bridge Strength:" &
               Natural'Image (Maximum_Bridge_Strength));
   Put_Line ("Longest Bridge:" & Natural'Image (Longest_Bridge) &
               " Strength:" & Natural'Image (Long_Bridge_Strength));
end December_24;
