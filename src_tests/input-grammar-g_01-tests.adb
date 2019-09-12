procedure Input.Grammar.G_01.Tests
is

   File : T_IO.File_Type;

   Input_File_Full_Name : constant String :=
   "d:/Users/jpiffret/AppData/Roaming/Dropbox/projets_perso/ada/"
   &
   "code_generator_input/examples/model/input_01.txt";

begin

   T_IO.Open (File, T_IO.In_File, Input_File_Full_Name);

end Input.Grammar.G_01.Tests;
