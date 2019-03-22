# snyder-imagej
A repository containing ImageJ macros for the Snyder lab.


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

## Resources
[Image.sc Forum](https://forum.image.sc/) - Great resource for ImageJ and other image analysis questions. I am `@boonepeter` on there
[Macro Language Reference](https://imagej.nih.gov/ij/developer/macro/macros.html) - Decent reference
[Script Parameters](https://imagej.net/Script_Parameters) - These are a great way to generalize your script
