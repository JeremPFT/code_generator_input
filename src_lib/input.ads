with Ada.Text_IO;
with Ada.Characters.Latin_1;

package Input is

   type String_Access_T is access all String;

   package Dbg renames Ada.Text_IO;
   package T_IO renames Ada.Text_IO;

   function "+" (Image : in String) return String_Access_T
     is (new String'(Image));

   package Latin_1 renames Ada.Characters.Latin_1;

   EOL_Dos  : constant String := Latin_1.CR & Latin_1.LF;
   EOL_Unix : constant String := Latin_1.CR'Image;
   EOL      : String renames EOL_Unix;

end Input;
