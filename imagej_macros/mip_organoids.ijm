
maintitle = getTitle();
maintitle = split(maintitle, ".");
maintitle = maintitle[0];
run("Split Channels");
images = getList("image.titles");
imageCalculator("Add create stack", images[0] , images[2]);
images = getList("image.titles");
imageCalculator("Add create stack", images[4],images[3]);
images = getList("image.titles");

run("Z Project...", "projection=[Max Intensity]");
run("Gaussian Blur...", "sigma=6");
setAutoThreshold("Huang dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Erode");
run("Analyze Particles...", "display clear include add in_situ");

images = getList("image.titles");

run("Merge Channels...", "c1=[" + images[0] + "] c2=[" + images[1] + "] c3=[" + images[2] + "] c4=[" + images[3] + "] create");
run("From ROI Manager");
run("Z Project...", "projection=[Max Intensity]");
waitForUser("ok to close all");


