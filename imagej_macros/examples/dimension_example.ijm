/*
 * Example of how to get information from an image or images that are open 
 *  
 */

//open 2 samples
run("Confocal Series (2.2MB)");
run("Fluorescent Cells (400K)");

print("Getting window list");
windowList = getList("image.titles");
listLength = windowList.length;

for (i=0; i < listLength; i++){
	curWindow = windowList[i];
	print("window " + i + " is " + curWindow);
}

//get dimmension information
for (i=0; i < listLength; i++){
	curWindow = windowList[i];
	selectWindow(curWindow);
	getDimensions(width, height, channels, slices, frames);
	print(curWindow + " dimensions:");
	print("width: " + width);
	print("height: " + height);
	print("channels: " + channels);
	print("slices: " + slices);
	print("frames: " + frames);
		
	if (slices > 1){
		print(curWindow + " is a Z-stack");
	}else{
		print(curWindow + " is not a Z-stack");
	}


	//Pixel size information
	getPixelSize(unit, pixelWidth, pixelHeight);
	print(curWindow + " pixel info");
	print("unit: " + unit);
	print("pixelWidth: " + pixelWidth);
	print("pixelHeight: " + pixelHeight);

}

selectWindow(windowList[0]);
run("Close All");

