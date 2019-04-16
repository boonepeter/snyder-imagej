/*
 * Saves a cropped rectangle around each ROI as a separate tif file in the output folder
 */

#@ File (label = "Output Directory", style = "directory") outDir
setBatchMode(true);

imtitles = getList("image.titles");
imlist = split(imtitles[0], ".");
imtitle = imlist[0];



roiCount = roiManager("count");

for (i = 0; i < roiCount; i++) {
	filenum = i + 1;
	filename = imtitle + "_" + i + ".tif";
	roiManager("select", i);
	run("Duplicate...", "duplicate");
	saveAs("Tiff", outDir + File.separator + filename);
	close();
}
