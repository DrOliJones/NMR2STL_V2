# NMR2STL_V2

MATLAB code to convert 2D NMR files into the STL format suitable for 3D printing.

This is an initial version of the program for testing, and the application still has some limitations.

•	Your TOPSPIN raw data should be 2048x2048 points (seems to be the default export size for TOPSPIN). For other sizes, you will need to modify the code to the correct size (this information is usually included in the topspin ext export). Auto detection will be added in the future.

•	At present the code has only been tested with Windows and with Bruker (TOPSPIN) data.

To Install:
•	Move all files to a folder of your choice and navigate to this folder in MATLAB.

•	Run gui.m in the MATLAB editor to launch the GUI

•	Select your TOPSPIN file with the browse file

•	Change the size and averaging parameters

•	Press Process to generate the preview and STL file


File Description:
gui.m/.fig: Contains the GUI and is the entry point for the code.

about.m/.fig: Contains the about window GUI

instruct.m/.fig: Contains the instruction window GUI

nmr_print.m: Contains the main functions including the data preparation code, and some third party codes dependencies.

