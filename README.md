# NMR2STL_V2


rough matlab code to turn 2D NMR files to STL format Instructions for NMR2STL code

This is an initial version of the program for testing. At this time, I have left the files as raw matlab code as compiling is currently breaking some features.

The application still has some limitations. Stability is not promised.

With these limitations, you must therefore do the following:

   -Your TOPSPIN raw data should be exported as a text file and named: NMR_TOPSPIN.txt

   -Your TOPSPIN raw data should be the full spectra, do not zoom in and/or cut section before you export it. Do not delete any of the data in the file before use.

   -Extract the zip to a folder, and put your raw data in this same folder. (I'll make it so it works in any directory at a later date if I get time)

  Run gui.m in MatLab editor and then open your file

NB: At present this code only works with Windows and with Bruker (TOPSPIN) data.
