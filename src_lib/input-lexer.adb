with Ada.Strings.Maps.Constants;

--  with Opentoken.Recognizer.Based_Integer_Ada_Style;
--  with Opentoken.Recognizer.Based_Real_Ada_Style;
with OpenToken.Recognizer.Character_Set;
with OpenToken.Recognizer.End_Of_File;
--  with OpenToken.Recognizer.Graphic_Character;
with OpenToken.Recognizer.Identifier;
--  with Opentoken.Recognizer.Integer;
with OpenToken.Recognizer.Keyword;
--  with Opentoken.Recognizer.Line_Comment;
with OpenToken.Recognizer.Nothing;
--  with Opentoken.Recognizer.Real;
with OpenToken.Recognizer.Separator;
--  with OpenToken.Recognizer.String;
with OpenToken.Text_Feeder.Text_IO;
with OpenToken.Token.Enumerated.Analyzer;
with OpenToken.Token.Enumerated;

package body Input.Lexer is

   pragma Warnings (Off, "anonymous access type allocator");
   package Master_Tokens is new OpenToken.Token.Enumerated
     (Tokens,
      Tokens'First,
      Tokens'Last,
      Tokens'Image);
   pragma Warnings (On, "anonymous access type allocator");

   package Tokenizer is new Master_Tokens.Analyzer;

   procedure Initialize_Syntax;

   procedure Initialize_Analyzer;

   Syntax : aliased Tokenizer.Syntax;

   Analyzer : aliased Tokenizer.Handle;

   ------------------------
   --  Initialize_Lexer  --
   ------------------------

   procedure Initialize
   is
   begin
      Initialize_Syntax;
      Initialize_Analyzer;
   end Initialize;

   --------------
   --  Syntax  --
   --------------

   procedure Initialize_Syntax
   is
      package Recog renames OpenToken.Recognizer;

      Letter_Set : Ada.Strings.Maps.Character_Set renames
        Ada.Strings.Maps.Constants.Letter_Set;

      Alphanumeric_Set : Ada.Strings.Maps.Character_Set renames
        Ada.Strings.Maps.Constants.Alphanumeric_Set;

      Standard_Whitespace : Ada.Strings.Maps.Character_Set renames
        OpenToken.Recognizer.Character_Set.Standard_Whitespace;

   begin
      for Token_Index in Tokens loop
         case Token_Index is

           when First_Keyword_Token .. Last_Keyword_Token =>
              Syntax (Token_Index) :=
                Tokenizer.Get (Recog.Keyword.Get (Keywords (Token_Index).all));

           when First_Separator_Token .. Last_Separator_Token =>
              Syntax (Token_Index) :=
                Tokenizer.Get (Recog.Separator.Get (Separators (Token_Index).all));

           when Whitespace_Id    =>
              Syntax (Token_Index) :=
                Tokenizer.Get
                  (Recog.Character_Set.Get
                     (Set        => Standard_Whitespace,
                      Reportable => False));

           when Identifier_Id =>
              Syntax (Token_Index) :=
                Tokenizer.Get (Recog.Identifier.Get
                                 (Start_Chars => Letter_Set,
                                  Body_Chars  => Alphanumeric_Set));

              --  when Attribute_Id =>
              --     Syntax (Token_Index) := Tokenizer.Get (Recog.String.Get);

              --  when Word_Id =>
              --     Syntax (Token_Index) := Tokenizer.Get (Recog.String.Get);

           when End_Of_File_Id =>
              Syntax (Token_Index) := Tokenizer.Get (Recog.End_Of_File.Get);

           when Bad_Token_Id =>
              Syntax (Token_Index) := Tokenizer.Get (Recog.Nothing.Get);
         end case;
      end loop;
   end Initialize_Syntax;

   ----------------
   --  Analyzer  --
   ----------------

   procedure Initialize_Analyzer
   is
   begin
      Analyzer := Tokenizer.Initialize (Syntax);
   end Initialize_Analyzer;

   ------------------------
   --  Set_Input_Feeder  --
   ------------------------

   procedure Set_Input_Feeder
     (File : in Ada.Text_IO.File_Type)
   is
   begin
      Dbg.Put_Line ("Set_Input_Feeder");

      T_IO.Set_Input (File);
      Analyzer.Set_Text_Feeder
        (OpenToken.Text_Feeder.Text_IO.Create (T_IO.Current_Input));
   end Set_Input_Feeder;

   ---------------------------------
   --  Exception_On_Syntax_Error  --
   ---------------------------------

   procedure Exception_On_Syntax_Error
   is
   begin
      Analyzer.Unset_Default;
   end Exception_On_Syntax_Error;

   ---------------------------------
   --  Bad_Token_On_Syntax_Error  --
   ---------------------------------

   procedure Bad_Token_On_Syntax_Error
   is
   begin
      Analyzer.Set_Default (Bad_Token_Id);
   end Bad_Token_On_Syntax_Error;

   -------------------------------
   --  Set_Comments_Reportable  --
   -------------------------------

   procedure Set_Comments_Reportable
     (To : in Boolean)
   is
      pragma Unreferenced (To);
   begin
      null;
   end Set_Comments_Reportable;

   -----------------
   --  Find_Next  --
   -----------------

   --  Exclusion : constant array (Boolean) of Ada.Strings.Maps.Character_Set :=
   --    (False => Ada.Strings.Maps.Null_Set,                -- character literal enabled
   --     True  => Ada.Strings.Maps.Constants.Graphic_Set);  --                   disabled

   procedure Find_Next
   is
   begin
      Analyzer.Find_Next (Look_Ahead => False);

      --  OpenToken.Recognizer.Graphic_Character.Redefine
      --    (OpenToken.Recognizer.Graphic_Character.Instance
      --       (Syntax (Character_Id).Recognizer.all),
      --     Exclusion (Token_Id = Identifier_Id));
   end Find_Next;

   ------------
   --  Line  --
   ------------

   function Line return Natural
   is
   begin
      return Analyzer.Line;
   end Line;

   --------------
   --  Column  --
   --------------

   function Column return Natural
   is
   begin
      return Analyzer.Column;
   end Column;

   ----------------
   --  Token_Id  --
   ----------------

   function Token_Id return Tokens
   is
   begin
      return Analyzer.Id;
   end Token_Id;

   --------------
   --  Lexeme  --
   --------------

   function Lexeme return String
   is
   begin
      return Analyzer.Lexeme;
   end Lexeme;

end Input.Lexer;
