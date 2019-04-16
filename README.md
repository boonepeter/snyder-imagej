# snyder-imagej
A repository containing ImageJ macros for the [Snyder Lab](https://surgery.duke.edu/faculty/joshua-clair-snyder-phd). 

imagej-macros are written in imagej macro language

python-macros are written in [Jython](https://imagej.net/Jython_Scripting)


## How to use
This is how I would recommend using these macros:
- Download repository 
  - As zip or using `git clone https://github.com/boonepeter/snyder-imagej`
- Install or open [Fiji](https://imagej.net/Fiji/Downloads)
- Open the desired script in Fiji
  - Drag and drop or File > Open
- Click Run


## Building your own macro
A good place to start:
- `Plugins > Macros > Record...`
- Open up and image and process it
- `File > New > Script...`
- `Templates > ImageJ 1.x > Batch > Process Folder (IJ1 Macro)`
- Then copy your recorded macro into the function section
- You will need to generalize some of your recorded macro so it will work
- Add `setBatchMode(true);` before `processFolder(input);` to speed up your macro (ImageJ will not display images as it works)
  - See my [example script](https://github.com/boonepeter/snyder-imagej/blob/master/imagej_macros/sample_batch_macro.ijm) to view this
- AN IMPORTANT NOTE:
  - The macro recorder sometimes does not record certain settings if they are not changed. An example of this happens when you use `run("Analyze Particles")` on a binary image. This will measure all of the particles, but it will only output the measurements checked by the last user (or default). To make sure you get the measurements you want, you need to do `Analyze > Set Measurements...` and check what you want while the macro recorder is running. I would recommend you check settings like this while you are recording your macro so it will work later on.

## Resources
- [Intro to Macro Programming](https://imagej.net/Introduction_into_Macro_Programming) - Good place to start when recording macros
- [ImageJ Scripting](https://imagej.net/Scripting) - Overview of scripting
- [Image.sc Forum](https://forum.image.sc/) - Great resource for ImageJ and other image analysis questions. I am `@boonepeter` on there
- [Macro Language Reference](https://imagej.nih.gov/ij/developer/macro/macros.html) - Decent reference
- [Script Parameters](https://imagej.net/Script_Parameters) - These are a great way to generalize your script

