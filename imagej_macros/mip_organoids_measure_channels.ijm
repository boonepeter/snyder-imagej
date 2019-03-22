
OUT_FOLDER = "/Volumes/LaCie/Peter/veronica/out_good";
BF = 2; //brightfield

run("Bio-Formats Windowless Importer", "open=[/Volumes/LaCie/Peter/veronica/organoids exp4_day5_noGF_1-16-19/well3/Image 21_Stitch.czi]");


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









run("Z Project...", "projection=[Max Intensity]");
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
saveAs("Tif", OUT_FOLDER + File.separator + maintitle + "_raw" + ".tif");
close();

for (i = 0; i < nChannels; i++) {
	if (i == (BF - 1)){
		continue;
	}
	selectWindow(images[i]);
	run("Z Project...", "projection=[Max Intensity]");
	if (i == 2){
		run("Convert to Mask", "method=MaxEntropy background=Dark calculate black");
	}else {
		run("Convert to Mask", "method=Otsu background=Dark calculate black");	
	}
	run("From ROI Manager");
	roiManager("measure");
	channel = i + 1;
	savepath = OUT_FOLDER + File.separator + maintitle + "_ch_" + channel + ".csv";
	saveAs("Results", savepath);
	close("Results");
	
}

run("Close All");
roiManager("reset");
