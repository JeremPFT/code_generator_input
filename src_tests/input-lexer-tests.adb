with Ada.Command_Line;
with Ada.Exceptions;

with OpenToken;

procedure Input.Lexer.Tests
is
   package Cmd renames Ada.Command_Line;

   File : T_IO.File_Type;

begin
   T_IO.Open (File, T_IO.In_File, Cmd.Argument (1));

   Initialize;

   Set_Input_Feeder (File);

   --  ada_lexer reports ? in comment as bad token!
   Set_Action_On_Error (Return_Bad_Token);

   loop
      Find_Next;

      declare
         Line_Img   : String renames Line'Img
         (Line'Img'First + 1 .. Line'Img'Last);

         Column_Img : String renames Column'Img
         (Column'Img'First + 1 .. Column'Img'Last);
      begin

         T_IO.Put_Line ("(" & Line_Img & "," & Column_Img & ") ::"
                        & Token_ID'Img & " = "
                        & "'" & Lexeme & "'");

         exit when Token_ID = EOF_ID
         or else T_IO.End_Of_File (File);
      end;
   end loop;

exception
when E : OpenToken.Syntax_Error =>
   T_IO.Put_Line (T_IO.Line (File)'Img
                  & ": "
                  & Ada.Exceptions.Exception_Message (E));
end Input.Lexer.Tests;
