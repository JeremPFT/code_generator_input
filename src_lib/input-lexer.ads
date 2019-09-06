with Ada.Text_IO;

package Input.Lexer is

   --  code taken from org.opentoken-6.0b/Language_Lexers/ada_lexer.ads
   --  code taken from org.opentoken-6.0b/Language_Lexers/ada_lexer.adb

   type Tokens is (
                   Package_Id,
                   End_Package_Id,
                   Use_Id,
                   Class_Id,
                   End_Class_Id,
                   Field_Id,
                   End_Field_Id,
                   Attribute_Id, -- readOnly, unique
                   Word_Id, -- everything else

                   --
                   End_Of_File_Id,
                   --  Syntax error
                   Bad_Token_Id
                  );

   First_Keyword_Token : constant Tokens := Package_Id;
   Last_Keyword_Token  : constant Tokens := End_Field_Id;


   type Keywords_Array_T is array (Tokens range First_Keyword_Token
                                   .. Last_Keyword_Token)
     of String_Access_T;

   Keywords : constant Keywords_Array_T :=
     (
      Package_Id     => +"package",
      End_Package_Id => +"end_package",
      Use_Id         => +"use",
      Class_Id       => +"class",
      End_Class_Id   => +"end_class",
      Field_Id       => +"field",
      End_Field_Id   => +"end_field"
     );

   --  Define the file where to find the code to be processed.
   --  The file must be open for reading.
   procedure Set_Input_Feeder (File : in Ada.Text_IO.File_Type);

   --  In case of syntax errors:
   --  Define whether the Syntax_Error exception shall be raised (default)
   --  or the Bad_Token_T token shall be be returned.
   procedure Exception_On_Syntax_Error;
   procedure Bad_Token_On_Syntax_Error;

   --  Change reportability of comments (off by default).
   procedure Set_Comments_Reportable (To : in Boolean);

   --  Find the next reportable token.
   procedure Find_Next;

   --  Query the current token:

   function Line   return Natural;
   function Column return Natural;

   function Token_Id return Tokens;
   function Lexeme   return String;

end Input.Lexer;
