/*
 * Macro to split tifs into separate channels
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ Integer (label = "Ignore channel:") ignoreChan



setBatchMode(true);
print("Processing files in " + input);
start = getTime();
processFolder(input);
end = getTime();
took = (end - start)/60000;
print("Took " + took + " minutes.");


// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i], ignoreChan);
	}
}

function processFile(input, output, file, ignoreChan) {

	ignoreChan -= 1;

	open(input + File.separator + file);
	run("Split Channels");
	titles = getList("image.titles");
	for (i = 0; i < titles.length; i++) {
		if(i != ignoreChan){
			selectWindow(titles[i]);
			saveAs("Tiff", output + File.separator + titles[i]);
		}

		
	}
	run("Close All");	
}
