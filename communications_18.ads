package Communications_18 is

   subtype CPU_IDs is Long_Long_Integer range 0 .. 1;

   procedure Send (CPU_ID : in CPU_IDs; Item : in Long_Long_Integer);

   function Receive (CPU_ID : in CPU_IDs) return Long_Long_Integer;

end Communications_18;
