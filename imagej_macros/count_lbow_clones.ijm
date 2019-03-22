/*
 * Before running, change "Set measurements" to inculde the information that you want
 * 
 * 
 * 
 */
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ Integer (label = "Brightfield") brightfield
#@ String (label = "Type of Z project", choices = {"Average Intensity", "Max Intensity", "Min Intensity", "Sum Slices", "Standard Deviation", "Median"}) typeOfZproj

setBatchMode(true);
run("Close All");

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
			processFile(input, output, list[i], brightfield, typeOfZproj);
	}
}


//where all of the work happens
function processFile(input, output, file, brightfield, typeOfZproj) {
	
	print("Opening: " + input + File.separator + file);
	run("Bio-Formats Windowless Importer", "open=" + input + File.separator + file);

	//split channels and subtract from each other
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
	
	//loop through and subtract
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
	//close all but the most recent image
	images = getList("image.titles");
	for (i = 0; i < (images.length - 1); i++) {
		selectWindow(images[i]);
		run("Close");
	}


	//processing specific to these images
	run("Remove Outliers...", "radius=1 threshold=50 which=Bright stack");
	run("Gaussian Blur...", "sigma=4 stack");
	run("Z Project...", "projection=[" + typeOfZproj + "]");
	images = getList("image.titles");
	for (i = 0; i < (images.length - 1); i++) {
		selectWindow(images[i]);
		run("Close");
	}

	
	
	run("Split Channels");
	images = getList("image.titles");
	for (i = 0; i < images.length; i++) {
		selectWindow(images[i]);

		//use different threshold for mko channel because of higher background
		//setAutoThreshold("Otsu dark");
		if (i == 2){
			setAutoThreshold("MaxEntropy dark");
		}else {
			setAutoThreshold("Otsu dark");
		}
		//TODO
		//need to set a low cutoff, because when there are no nuclei in the image these 
		//thresholding methods threshold the autofluorescent tissue from the black background
		//and find many spots

		
		run("Convert to Mask");
		run("Dilate");
		run("Dilate");
		run("Dilate");
		run("Analyze Particles...", "display clear include summarize add in_situ");
		selectWindow("Results");
		mytitle = split(images[i], ".");
		saveAs("Results", output + File.separator + mytitle[0] + ".csv");
		roiManager("save", output + File.separator + mytitle[0] + ".zip");
		roiManager("reset");
		run("Close");
		selectWindow(images[i]);
		saveAs("Tiff", output + File.separator + images[i]);
	}
	run("Close All");
}



