/*
 * This macro will threshold, analyze, measure, and prompt user for directory to 
 * save results file
 */

run("Cell Colony (31K)");
run("Auto Threshold", "method=Otsu");
run("Set Measurements...", "area centroid perimeter shape redirect=None decimal=3");
run("Analyze Particles...", "display add");

//prompt for directory
dir = getDirectory("Choose a Directory");
saveAs("Results", dir + File.separator + "results.csv");

run("Close All");
close("Results");
close("ROI Manager");
