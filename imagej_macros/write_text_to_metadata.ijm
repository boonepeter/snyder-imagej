
selectWindow("ch_description.txt");
str = getInfo("window.contents");

selectWindow("scan1_scan2.tif");
setMetadata("Info", str);