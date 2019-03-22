/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.
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
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	
	BF = 2; //brightfield
	
	run("Bio-Formats Windowless Importer", "open=[" + input + File.separator + file + "]");
	
	
	maintitle = getTitle();
	maintitle = split(maintitle, ".");
	maintitle = maintitle[0];
	run("Split Channels");
	images = getList("image.titles");
	nChannels = images.length;
	
	imageCalculator("Add create stack", images[0] , images[2]);
	images = getList("image.titles");
	imageCalculator("Add create stack", images[4],images[3]);
	images = getList("image.titles");
	if(nSlices > 1){
		run("Z Project...", "projection=[Max Intensity]");	
	}
	run("Gaussian Blur...", "sigma=6");
	setAutoThreshold("Huang dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	for (i = 0; i < 4; i++) {
		run("Erode");
	}
	
	
	run("Analyze Particles...", "clear include add in_situ");
	
	images = getList("image.titles");
	
	run("Merge Channels...", "c1=[" + images[0] + "] c2=[" + images[1] + "] c3=[" + images[2] + "] c4=[" + images[3] + "] create keep");
	run("From ROI Manager");
	saveAs("Tif", output + File.separator + maintitle + "_raw" + ".tif");
	close();
	
	for (i = 0; i < nChannels; i++) {
		if (i == (BF - 1)){
			continue;
		}
		selectWindow(images[i]);
		if(nSlices > 1){
			run("Z Project...", "projection=[Max Intensity]");	
		}
		
		if (i == 2){
			run("Convert to Mask", "method=MaxEntropy background=Dark calculate black");
		}else {
			run("Convert to Mask", "method=Otsu background=Dark calculate black");	
		}
		run("From ROI Manager");
		roiManager("measure");
		channel = i + 1;
		savepath = output + File.separator + maintitle + "_ch_" + channel + ".csv";
		saveAs("Results", savepath);
		close("Results");
		
	}
	
	run("Close All");
	roiManager("reset");
	
}
