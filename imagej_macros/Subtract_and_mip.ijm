/*
 * This macro will run through a directory and do the following to items that have the correct suffix:
 * 
 * 1. Open image
 * 2. If subtract:
 * 		a. Subtract all other channels from each channel
 * 		b. Skip brightfield channels
 * 		c. Merge and save subtracted
 * 	3. If Z project
 * 		a. Project image
 * 		b. Save
 * 	
 * 	If you don't have a brightfield, select 0
 * 	
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".czi") suffix
#@ Integer (label = "Brightfield", value = 0, description = "Set to 0 to ignore") brightfield
#@ Boolean (label = "Subtract channels?") subtract
#@ Boolean (label = "Zproject?") zproj
#@ String (label = "Type of Z project", choices = {"Average Intensity", "Max Intensity", "Min Intensity", "Sum Slices", "Standard Deviation", "Median"}) typeOfZproj

setBatchMode(true);
start = getTime();

processFolder(input);

end = getTime();

totaltime = end - start;

totalmin = totaltime/60000;

print("took " + totalmin + " minutes");

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i], brightfield, zproj, typeOfZproj, subtract);
	}
}



function processFile(input, output, file, brightfield, zproj, typeOfZproj, subtract) {
	
	print("Opening: " + input + File.separator + file);
	
	run("Bio-Formats Windowless Importer", "open=[" + input + File.separator + file + "]");
	if(subtract){
		print("Subtracting...");
		run("Split Channels");
		bf = brightfield - 1;
		titles = getList("image.titles");
		final_channels = "";
		for (i = 0; i < titles.length; i++) {
			curWindow = titles[i];
			if (i != bf) {
				for (j = 0; j < titles.length; j++){
					if (j!=i && j!=bf){
						imageCalculator("Subtract stack create", curWindow, titles[j]);
						curWindow = getTitle();
					}else{
						print(j);
					}
				}
			}
			chan = i + 1;
			final_channels = final_channels + "c" + chan + "=[" + curWindow + "] ";
		}
		run("Merge Channels...", final_channels + "create");
		saveAs("Tiff", output + File.separator + "Sub_" + file);
	}
	
	if(zproj) {
		print("Projecting...");
		run("Z Project...", "projection=[" + typeOfZproj + "]");
		saveAs("Tiff", output + File.separator + "Zproj_" + file);
	}
	run("Close All");
}
