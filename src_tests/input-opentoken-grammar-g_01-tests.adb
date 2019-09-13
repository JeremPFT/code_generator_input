--  with OpenToken.Text_Feeder.Text_IO;

procedure Input.OpenToken.Grammar.G_01.Tests
is

   Input_File_Full_Name : constant String :=
   "d:/Users/jpiffret/AppData/Roaming/Dropbox/projets_perso/ada/"
   &
   "code_generator_input/examples/model/input_01.txt";

   Line : String (1 .. 1024);
   Line_Length : Natural := 0;

begin

   T_IO.Put_Line ("opening file " & Input_File_Full_Name & "...");
   T_IO.Flush;

   T_IO.Open (
              File => Input_File
              ,
              Name => Input_File_Full_Name
              ,
              Mode => T_IO.In_File
             );

   --  Standard.OpenToken.Token.Set_Name (Od.all, "OD");
   Standard.OpenToken.Token.Set_Name (Prj.all, "Prj");
   Standard.OpenToken.Token.Set_Name (S.all, "S");

   Analyzer.Find_Next;

   String_Sequence.Parse (S, Analyzer);

end Input.OpenToken.Grammar.G_01.Tests;
