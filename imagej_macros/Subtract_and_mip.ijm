/*
 * 
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ Integer (label = "Brightfield") brightfield
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
	
	run("Bio-Formats Windowless Importer", "open=" + input + File.separator + file);
	if(subtract){
		print("Subtracting...");
		run("Duplicate...", "duplicate");
		titles = getList("image.titles");
		selectWindow(titles[0]);
		run("Split Channels");
		selectWindow(titles[1]);
		run("Split Channels");
		bf = brightfield - 1;
		titles = getList("image.titles");
		chan = titles.length/2;
		final_channels = "";
		for (i = 0; i < chan; i++) {
			final_channels = final_channels + "c" + (i + 1) + "=" + titles[i] + " ";
			if (i != bf) {
				for (j = 0; j < chan; j++){
					if (j!=i && j!=bf){
						imageCalculator("Subtract stack", titles[i], titles[j + chan]);
					}
				}
			}
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
