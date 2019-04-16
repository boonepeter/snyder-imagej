run("Fluorescent Cells (400K)");
//subtract channels from each other
run("Split Channels");
windowList = getList("image.titles");
mergeString = "";
for (i = 0; i < windowList.length; i++){
	curWindow = windowList[i];
	for (j = 0; j < windowList.length; j++){
		if(i == j){
			//this will skip subtraction if channels are the same
		}else{
			imageCalculator("subtract create", curWindow, windowList[j]);
			curWindow = getTitle();
		}
	}
	//somewhat clunky, but to merge channels this is a fairly easy way to build 
	//a string that we can run through the Merge Channels command
	chan = i + 1;
	mergeString = mergeString + "c" + chan + "=[" + curWindow + "] ";
	
}
mergeString = mergeString + "create"
print(mergeString);
run("Merge Channels...", mergeString);

//closes everything except the current window
close("\\Others");



 