with Ada.Containers.Synchronized_Queue_Interfaces;
with Ada.Containers.Unbounded_Synchronized_Queues;

package body Communications_18 is

   package Long_Long_Interface is new
     Ada.Containers.Synchronized_Queue_Interfaces (Long_Long_Integer);

   package Long_Long_Queue is new Ada.Containers.Unbounded_Synchronized_Queues
     (Long_Long_Interface);

   Zero_One_Queue, One_Zero_Queue : Long_Long_Queue.Queue;

   procedure Send (CPU_ID : in CPU_IDs; Item : in Long_Long_Integer) is

   begin -- Send
      if CPU_ID = 0 then
         Zero_One_Queue.Enqueue (Item);
      else
         One_Zero_Queue.Enqueue (Item);
      end if;
   end Send;

   function Receive (CPU_ID : in CPU_IDs) return Long_Long_Integer is

      Result : Long_Long_Integer;

   begin -- Receive
      if CPU_ID = 0 then
         One_Zero_Queue.Dequeue (Result);
      else
         Zero_One_Queue.Dequeue (Result);
      end if;
      return Result;
   end Receive;

end Communications_18;
