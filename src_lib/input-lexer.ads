with Ada.Text_IO;

package Input.Lexer is

   --  code taken from org.opentoken-6.0b/Language_Lexers/ada_lexer.ads
   --  code taken from org.opentoken-6.0b/Language_Lexers/ada_lexer.adb

   type Tokens is (
                   -- begin keywords
                   Project_Start_ID,
                   Project_Stop_ID,
                   Package_Start_ID,
                   Package_Stop_ID,
                   Class_Start_ID,
                   Class_Stop_ID,
                   Field_Start_ID,
                   Field_Stop_ID,
                   Use_ID,
                   -- end keywords
                   -- begin separators
                   Parenthese_Left_ID,
                   Parenthese_Right_ID,
                   Brace_Left_ID,
                   Brace_Right_ID,
                   Bracket_Left_ID,
                   Bracket_Right_ID,
                   Semi_Colon_ID,
                   Colon_ID,
                   Equal_ID,
                   Plus_ID,
                   Minus_ID,
                   Comma_ID,
                   Quote_ID,
                   Period_ID,
                   --  end separators,
                   Comment_ID,
                   Whitespace_ID,
                   Identifier_ID,
                   String_ID,

                   --  Attribute_Id, -- readOnly, unique
                   --  Word_Id, -- everything else
                   --
                   End_Of_File_ID,
                   --  Syntax error
                   Bad_Token_ID
                  );

   First_Keyword_Token : constant Tokens := Project_Start_ID;
   Last_Keyword_Token  : constant Tokens := Use_ID;
   First_Separator_Token : constant Tokens := Parenthese_Left_ID;
   Last_Separator_Token  : constant Tokens := Period_ID;


   type Token_Array_T is array (Tokens range <>) of String_Access_T;

   Keywords :
   constant Token_Array_T (First_Keyword_Token .. Last_Keyword_Token)
   := (
       Project_Start_ID => +"project",
       Project_Stop_ID  => +"end_project",
       Package_Start_ID => +"package",
       Package_Stop_ID  => +"end_package",
       Class_Start_ID   => +"class",
       Class_Stop_ID    => +"end_class",
       Field_Start_ID   => +"field",
       Field_Stop_ID    => +"end_field",
       Use_ID           => +"use"
      );

   Separators :
   constant Token_Array_T (First_Separator_Token .. Last_Separator_Token)
   := (
       Parenthese_Left_ID  => +"(",
       Parenthese_Right_ID => +")",
       Brace_Left_ID       => +"{",
       Brace_Right_ID      => +"}",
       Bracket_Left_ID     => +"[",
       Bracket_Right_ID    => +"]",
       Semi_Colon_ID       => +";",
       Colon_ID            => +":",
       Equal_ID            => +"=",
       Plus_ID             => +"+",
       Minus_ID            => +"-",
       Comma_ID            => +",",
       Quote_ID            => +"'",
       Period_ID           => +"."
      );

   procedure Initialize;

   procedure Set_Input_Feeder (File : in Ada.Text_IO.File_Type);
   --  Define the file where to find the code to be processed.
   --  The file must be open for reading.

   procedure Exception_On_Syntax_Error;
   procedure Bad_Token_On_Syntax_Error;
   --  In case of syntax errors:
   --  Define whether the Syntax_Error exception shall be raised (default)
   --  or the Bad_Token_T token shall be be returned.

   procedure Set_Comments_Reportable (To : in Boolean);
   --  Change reportability of comments (off by default).

   procedure Find_Next;
   --  Find the next reportable token.

   function Line   return Natural;
   function Column return Natural;
   function Token_ID return Tokens;
   function Lexeme   return String;
   --  Query the current token:

end Input.Lexer;
