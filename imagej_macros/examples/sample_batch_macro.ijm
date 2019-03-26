/*
 * Macro template to process multiple images in a folder
 * Some example code in the process file function
 * 
 */


//These are parameters, a little trick you can use to open up a prompt at the begining of the macro
//See https://imagej.net/Script_Parameters for more info
//Most of these are not used
#@ String (label = "Example Choice string", choices={"Max Intensity", "Average Intensity"}) exampleChoice
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ Boolean (label = "Example checkbox boolean", value = true) exampleBool
#@ Integer (label = "Example integer", value = 0) exampleInt
#@ String (label = "Large Box String", value = "enter message here", style = "text area") exampleString
#@ String (label = "Small Box String", value = "enter message here", style = "text field") exampleStringtwo
#@ ColorRGB (label = "example color") exampleColor
#@ Date (label = "example date") exampleDate



//This is where the action actually happens. Set batch mode true does not display windows when running (faster)
setBatchMode(true);
processFolder(input);




// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i], exampleChoice);
	}
}

function processFile(input, output, file, exampleChoice) {
	// Do the processing here by adding your own code.
	print("Processing: " + input + File.separator + file);


	//when opening a czi file you will want to use the bioformats plugin
	run("Bio-Formats Importer", "open=[" + input + File.separator + file + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	//imediately close this image
	run("Close All");

	//open sample image instead of your file
	run("Confocal Series (2.2MB)");
	
	run("Smooth");
	
	print("You chose " + exampleChoice + " as projection type");
	run("Z Project...", "projection=[" + exampleChoice + "]");
	
	run("Split Channels");
	
	//this gives you a list of all open windows
	windowList = getList("image.titles");

	//you access items in a list like this
	window1 = windowList[0];
	window2 = windowList[1];
	window3 = windowList[2];

	//you can loop through windows like this
	for (i = 0; i < windowList.length; i++) {
		window = windowList[i];
		print(window);
		selectWindow(window);
		//this gives you information about the current window
		getDimensions(width, height, channels, slices, frames);
		if (slices > 1){
			print("skipping image " + window + " beacause it is a stack");
			continue;
		}
		setAutoThreshold("Huang dark");
		run("Convert to Mask");
	}
	run("Merge Channels...", "c1=" + window2 + " c2=" + window3 + " create");
	print("Saving to: " + output);
}
