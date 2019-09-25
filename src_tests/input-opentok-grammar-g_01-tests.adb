

procedure Input.Opentok.Grammar.G_01.Tests
is

   Input_File_Full_Name : constant String :=
     "d:/Users/jpiffret/AppData/Roaming/Dropbox/projets_perso/ada/"
     &
     "code_generator_input/examples/model/input_01.txt";

   Input_File : T_IO.File_Type;

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

   Analyzer.Find_Next;

   String_Sequence.Parse (S, Analyzer);

end Input.Opentok.Grammar.G_01.Tests;
