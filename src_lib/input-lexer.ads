with Ada.Text_IO;

package Input.Lexer is

   --  code taken from org.opentoken-6.0b/Language_Lexers/ada_lexer.ads
   --  code taken from org.opentoken-6.0b/Language_Lexers/ada_lexer.adb

   type Tokens is (
                   -- begin keywords
                   Package_Id,
                   Package_End_Id,
                   Class_Id,
                   Class_End_Id,
                   Field_Id,
                   Field_End_Id,
                   Use_Id,
                   -- end keywords
                   -- begin separators
                   Parenthese_Left_Id,
                   Parenthese_Right_Id,
                   Brace_Left_Id,
                   Brace_Right_Id,
                   Bracket_Left_Id,
                   Bracket_Right_Id,
                   Semi_Colon_Id,
                   Colon_Id,
                   Equal_Id,
                   Plus_Id,
                   Minus_Id,
                   Comma_Id,
                   Quote_Id,
                   --  end separators,
                   Period_Id,
                   -- end separator
                   Whitespace_Id,
                   Identifier_Id,

                   --  Attribute_Id, -- readOnly, unique
                   --  Word_Id, -- everything else
                   --
                   End_Of_File_Id,
                   --  Syntax error
                   Bad_Token_Id
                  );

   First_Keyword_Token : constant Tokens := Package_Id;
   Last_Keyword_Token  : constant Tokens := Use_Id;
   First_Separator_Token : constant Tokens := Parenthese_Left_Id;
   Last_Separator_Token  : constant Tokens := Period_Id;


   type Token_Array_T is array (Tokens range <>) of String_Access_T;

   Keywords : constant Token_Array_T :=
     (
      Package_Id     => +"package",
      Package_End_Id => +"end_package",
      Class_Id       => +"class",
      Class_End_Id   => +"end_class",
      Field_Id       => +"field",
      Field_End_Id   => +"end_field",
      Use_Id         => +"use"
     );

   Separators : constant Token_Array_T :=
     (
      Parenthese_Left_Id  => +"(",
      Parenthese_Right_Id => +")",
      Brace_Left_Id       => +"{",
      Brace_Right_Id      => +"}",
      Bracket_Left_Id     => +"[",
      Bracket_Right_Id    => +"]",
      Semi_Colon_Id       => +";",
      Colon_Id            => +":",
      Equal_Id            => +"=",
      Plus_Id             => +"+",
      Minus_Id            => +"-",
      Comma_Id            => +",",
      Quote_Id            => +"'",
      Period_Id           => +"."
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
   function Token_Id return Tokens;
   function Lexeme   return String;
   --  Query the current token:

end Input.Lexer;
