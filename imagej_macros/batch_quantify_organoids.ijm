/*
 * Using macro template to process folders.
 * 
 * This macro was used to process organoid images for veronica. 
 * 
 * It assumes a few things:
 *    There are 4 channels
 *    Brightfield is channel #2
 *    mko channel is #3 (uses a different threshold method for mko)
 * 
 * What this macro does:
 * 1. Open image
 * 2. Sum the fluorescent channels together
 * 3. Z project the sum
 * 4. Blur
 * 5. Threshold
 * 6. Erode 4x
 * 7. Analyze particles
 * 8. Overlay back on original stack, save stack
 * 9. For each fluorescent channel:
 *    a. Threshold
 *    b. Overlay ROI
 *    c. Measure
 *    d. Save results as csv
 * 
 *    
 * 
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix


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
	saveAs("Tif", output + File.separator + maintitle + "_raw_roi" + ".tif");
	close();
	
	for (i = 0; i < nChannels; i++) {
		if (i == (BF - 1)){
			continue;
		}
		selectWindow(images[i]);
		if(nSlices > 1){
			run("Z Project...", "projection=[Max Intensity]");	
		}

		//use different threshold method for mko channel
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
