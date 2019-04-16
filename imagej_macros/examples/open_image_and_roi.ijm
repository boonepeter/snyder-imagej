/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

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
	
	imtitle = split(file, ".");
	roiname = imtitle[0] + ".zip";
	open(input + File.separator + file);
	roiManager("Open", input + File.separator + roiname);
	run("From ROI Manager");
	saveAs("Tiff", output + File.separator + imtitle[0] + "_overlay.tif");
	run("Close All");
	selectWindow("ROI Manager"); 
	run("Close"); 
}
