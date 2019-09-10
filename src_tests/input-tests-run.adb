with Input.Lexer;

with Ada.Command_Line;
with Ada.Exceptions;

with OpenToken;

procedure Input.Tests.Run
is
   package Cmd renames Ada.Command_Line;

   File : T_IO.File_Type;
begin
   T_IO.Open (File, T_IO.In_File, Cmd.Argument (1));

   Lexer.Initialize;

   Lexer.Set_Input_Feeder (File);

   --  ada_lexer reports ? in comment as bad token!
   Lexer.Bad_Token_On_Syntax_Error;

   loop
      Lexer.Find_Next;

      declare
         Line_Img : String renames Lexer.Line'Img
           (Lexer.Line'Img'First + 1 .. Lexer.Line'Img'Last);
         Column_Img : String renames Lexer.Column'Img
           (Lexer.Column'Img'First + 1 .. Lexer.Column'Img'Last);
      begin

         T_IO.Put_Line ("(" & Line_Img & "," & Column_Img & ") ::"
                          & Lexer.Token_ID'Img & " = "
                          & "'" & Lexer.Lexeme & "'");

         exit when Lexer."=" (Lexer.Token_ID, Lexer.End_Of_File_ID)
           or else T_IO.End_Of_File (File);
      end;
   end loop;

exception
when E : OpenToken.Syntax_Error =>
   T_IO.Put_Line (T_IO.Line (File)'Img
                    & ": "
                    & Ada.Exceptions.Exception_Message (E));
end Input.Tests.Run;
