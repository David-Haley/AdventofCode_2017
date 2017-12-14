with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure December_13 is

   Input_File : File_Type;
   Input_Line : Unbounded_String := Null_Unbounded_String;
   First, Start_From : Positive;
   Last : Natural;

   Natural_Set : Character_Set := To_Set ("0123456789");

   subtype Layers is Natural range 0 .. 96;
   subtype Scanner_Ranges is Natural range 2 .. 20;
   subtype Cycles is Natural range Scanner_Ranges'First ..
     (Scanner_Ranges'Last - 1) * 2;

   type Scanners is record
      Scanner_Range: Scanner_Ranges;
      Is_Scanner : Boolean := False;
      Cycle_Length : Cycles;
   end record; -- Scanners

   type Firewalls is array (Layers) of Scanners;

   Firewall : Firewalls;
   Layer : Layers;
   Severity : Natural := 0;
   Start_Time : Natural := 0;
   Caught : Boolean;


   function Get_Layer return Layers is

      Result : Layers;

   begin -- Get_Layer
      Start_From := 1;
      Find_Token (Input_Line, Natural_Set, Start_From, Inside, First, Last);
      Result := Layers'Value
        (To_String (Unbounded_Slice (Input_Line, First, Last)));
      Start_From := Last + 1;
      return Result;
   end Get_Layer;

   function Get_Scanner_Range return Scanner_Ranges is

   begin -- Get_Scanner_Range
      Find_Token (Input_Line, Natural_Set, Start_From, Inside, First, Last);
      return Scanner_Ranges'Value
        (To_String (Unbounded_Slice (Input_Line, First, Last)));
   end Get_Scanner_Range ;

   function Catch (Firewall : in Firewalls; Start_Time : in Natural;
                   Layer : in Layers) return Boolean is

   begin -- Catch
      return Firewall (Layer).Is_Scanner and then ((Start_Time + Layer) mod
        Firewall (Layer).Cycle_Length) = 0;
   end Catch;

begin -- December_13
   Open (Input_File, In_File, "20171213.txt");
   while not End_Of_File (Input_File) loop
      Input_Line := To_Unbounded_String (Get_Line (Input_File));
      Layer := Get_Layer;
      Firewall (Layer).Is_Scanner := True;
      Firewall (Layer).Scanner_Range := Get_Scanner_Range;
      Firewall (Layer).Cycle_Length := (Firewall(Layer).Scanner_Range - 1) * 2;
   end loop; -- Process one line
   Close (Input_File);
   for Layer in Layers loop
      if Catch (Firewall, 0, Layer) then
         Severity := Severity + Layer * Firewall (Layer).Scanner_Range;
      end if; -- caught
   end loop;
   Put_Line ("Severity:" & Natural'Image (Severity));
   loop -- Start Time
      for Layer in Layers loop
         Caught := Catch (Firewall, Start_Time, Layer);
         exit when Caught;
      end loop;
      if Caught then
         Start_Time := Start_Time + 1;
      else
         exit;
      end if;
   end loop; -- Start Time
   Put_Line ("Start Time:" & Natural'Image (Start_Time));
end December_13;
