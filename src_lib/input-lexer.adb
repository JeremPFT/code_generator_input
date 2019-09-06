--  with Ada.Strings.Maps.Constants;
--  with Opentoken.Recognizer.Based_Integer_Ada_Style;
--  with Opentoken.Recognizer.Based_Real_Ada_Style;
--  with Opentoken.Recognizer.Character_Set;
--  with Opentoken.Recognizer.End_Of_File;
--  with Opentoken.Recognizer.Graphic_Character;
--  with Opentoken.Recognizer.Identifier;
--  with Opentoken.Recognizer.Integer;
--  with Opentoken.Recognizer.Keyword;
--  with Opentoken.Recognizer.Line_Comment;
--  with Opentoken.Recognizer.Nothing;
--  with Opentoken.Recognizer.Real;
--  with Opentoken.Recognizer.Separator;
--  with Opentoken.Recognizer.String;
--  with Opentoken.Text_Feeder.Text_IO;
with Opentoken.Token.Enumerated.Analyzer;
with Opentoken.Token.Enumerated;

package body Input.Lexer is

   pragma Warnings (Off, "anonymous access type allocator");
   package Master_Tokens is new Opentoken.Token.Enumerated
     (Tokens,
      Tokens'First,
      Tokens'Last,
      Tokens'Image);
   pragma Warnings (On, "anonymous access type allocator");

   package Tokenizer is new Master_Tokens.Analyzer;
   pragma Unreferenced (Tokenizer);

   procedure Set_Input_Feeder
     (File : in Ada.Text_IO.File_Type)
   is
      pragma Unreferenced (File);
   begin
      Dbg.Put_Line ("Set_Input_Feeder");
   end Set_Input_Feeder;

   function Syntax
     return Tokenizer.Syntax
   is
      Token_Index : Tokens;
      package Recog renames Opentoken.Recognizer;
   begin
      case Index is
        when First_Keyword_Token .. Last_Keyword_Token =>
           Tokenizer.Get (Recog.Keyword.Get (Keywords (Index).all));
        when Attribute_Id =>
           Tokenizer.Get (Recog.String.Get);
        when Word_Id =>
           Tokenizer.Get (Recog.String.Get);
        when End_Of_File_Id =>
           Tokenizer.Get (Recog.End_Of_File.Get);
        when Bad_Token_Id =>
           Tokenizer.Get (Recog.Nothing.Get);
      end case;
   end Syntax;

   procedure Exception_On_Syntax_Error
   is
   begin
      null;
   end Exception_On_Syntax_Error;

   procedure Bad_Token_On_Syntax_Error
   is
   begin
      null;
   end Bad_Token_On_Syntax_Error;


   procedure Set_Comments_Reportable
     (To : in Boolean)
   is
      pragma Unreferenced (To);
   begin
      null;
   end Set_Comments_Reportable;


   procedure Find_Next
   is
   begin
      null;
   end Find_Next;


   function Line return Natural
   is
   begin
      return 0;
   end Line;

   function Column return Natural
   is
   begin
      return 0;
   end Column;


   function Token_Id return Tokens
   is
   begin
      return Bad_Token_Id;
   end Token_Id;

   function Lexeme return String
   is
   begin
      return "Bad_Token_Id";
   end Lexeme;


end Input.Lexer;
