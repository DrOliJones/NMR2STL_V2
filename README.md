# NMR2STL_V2

MATLAB code to convert 2D NMR files into the STL format suitable for 3D printing.

This is an initial version of the program for testing, and the application still has some limitations.

•	Your TOPSPIN raw data should be 2048x2048 points (seems to be the default export size for TOPSPIN). For other sizes, you will need to modify the code to the correct size (this information is usually included in the topspin ext export). Auto detection will be added in the future.

•	At present the code has only been tested with Windows and with Bruker (TOPSPIN) data. It should work on Mac with Bruker data as well but this is not guarenteed.

To Install:

•	Download the files from this repository and move all files in this to a folder of your choice.

•	Navigate to this folder in MATLAB.

•	Run gui.m in the MATLAB editor to launch the GUI

•	Select your TOPSPIN file with the browse file

•	Change the size and averaging parameters

•	Press Process to generate the preview and STL file. The stl file can then be taken to a 3D printer but may need further optimsation to print effectivly. This could be thickening of the walls and/or adding a base to the model. Free software such as Meshmixer can be used to do this.

--

TROUBLESHOOTING THE MODEL

Adding a base

Sometimes the base of the model is too thin. This makes the model fragile of the peaks in the model break of easily. Using R and Rayrender/ggplot packages seems to negate this issues as a base is added automatically

However if you do want to add a base to a Matlab created model the easiest option I have found is to use the add base to model function that is present on most 3D printer slicer software that you use to control the printer. There is also a fairly simple way to do it on Meshmixer that you can see how to use at https://www.youtube.com/watch?v=Mkzg_Qyj32A 

NB: Meshmixer is quite complex and powerful software but there are a lot of tutorials online that show you how to use its functions. It is just a question of exploring and trying things.

Model Thickness

In terms of thickening the model. Again, it is not always necessary. When you use the Matlab code from the paper to make the model setting the data reduction smoothing option to 32 or 64 before you run the code usually generates an stl that will print - thus avoiding the need to use Meshmixer. However if you do want to thicken the model there are a number of ways to do it on Meshmixer. The video at https://www.youtube.com/watch?app=desktop&v=sge8029CucM goes over most of these (Skip forward to about 1:50 to get to the details). You can easily find many more online tutorials online as well.

Once you done editing your 3D file in meshmixer simply select Export and choose the file type you want to save as. Generally, this will be STL format however other options include OBJ and VRML. 

Model Size

The other thing to check is the model size. One mistake I made early on was to have the print size too small. For example if the whole model is only 2cm by 2cm then the peaks will be too small to print but if you increase the model size to say 10 cm by 10cm (easily done on Meshmixer or 3d printer software) then the peaks are big enough to print.

A similar issue to size is the amount of blank space on a print. For example, some of the HSQC prints I have made only had peaks in a quarter of the spectra. The meant even if the print was 10cm by 10cm the part that actually had peaks in it was much smaller. I got round the by cutting the model in Meshmixer to just the park with peaks in it, and then scaling that up. There are a number of tutorials on how to split STLs in Meshmixer online. The one at https://www.youtube.com/watch?v=-3Qgq34OAQo give you the basics.


--

File Description:

gui.m/.fig: Contains the GUI and is the entry point for the code.

about.m/.fig: Contains the about window GUI

instruct.m/.fig: Contains the instruction window GUI

nmr_print.m: Contains the main functions including the data preparation code, and some third party codes dependencies including the following  

Stlwrite - write ASCII or Binary STL files, MATLAB Central File Exchange, https://www.mathworks.com/matlabcentral/fileexchange/20922-stlwrite-write-ascii-or-binary-stl-files Retrieved June 3, 2020.

and 

Surf2solid - make a solid volume from a surface for 3D printing, MATLAB Central File Exchange, https://www.mathworks.com/matlabcentral/fileexchange/42876-surf2solid-make-a-solid-volume-from-a-surface-for-3d-printing accessed 3rd June 2020.


