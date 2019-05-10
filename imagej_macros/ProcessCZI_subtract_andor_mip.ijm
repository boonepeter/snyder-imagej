/*
 * Macro to input czi or tif and export to another folder after performing some functions
 * 
 * Specify brightfield location and if you want to keep it
 * Specify if you want output image maximum image projected
 *
 * Obviously not the best macro...Kind of hacky sisnce it relies on weird loops to get the names for different channels.
 * You will lose metadata from the origional czi file. Maybe change macro to save as OPEN Microscopy tiff?
 * 
 * 
 */


//These parameters open up the dialoge and set the values at the start of the macro
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File type suffix", value = ".czi") suffix
#@ Integer (label = "Select brightfield channel (0 if none)", value = 0) brightfield
#@ Boolean (label = "Subtract all other channels from each channel?", value = true) subtract_bool
#@ Boolean (label = "Keep brightfield in final TIFF?", value = false) keep_bf 
#@ Boolean (label = "MIP the resulting image?", value = false) mip_image
#@ String (label = "Type of max project:", choices = {"Average Intensity", "Max Intensity", "Median"}, style = "listBox", value = "Max Intensity") type_MIP
#@ Boolean (label = "Save just the MIP?", value = false) save_just_mip

//You can comment out batch mode if you want to watch images flash on the screen. Runs much faster in batch mode
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
			//perform function on matching files
			//if subtract_bool isn't true will just open and save
			if(subtract_bool) subtractChannels(input, output, list[i]);
			else saveTiff(input, output, list[i]);
			
	}
}

function subtractChannels(input, output, file) {
	//open file with default Bio-Formats import settings. Will work for czi or tif files...probably more
	run("Bio-Formats Importer", "open=[" + input +File.separator + file + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

	//need channels later
	getDimensions(width, height, channels, slices, frames);
	
	run("Duplicate...", "duplicate");
	titles = getList("image.titles");
	run("Split Channels");
	selectWindow(file);
	run("Split Channels");
	
	if(!keep_bf&&brightfield!=0){
		selectWindow("C" + brightfield + "-" + file);
		run("Close");
	}

	//to subtract every other channel (other than brighfield and itself) from each channel
	for(i = 1; i <= channels; i++){
		if(i != brightfield){
			for(j = 1; j <= channels; j++){
				if(j!=i&&j!= brightfield){
					img1 = "C" + i + "-" + file;
					img2 = "C" + j + "-" + titles[1]; 
					imageCalculator("Subtract", img1, img2);
				}
				
			}
		}
	}

	//initialize channel_list, used to get titles to merge together
	channel_list = "";
	for(i = 1; i <= channels; i++){
		if(i != brightfield){
			channel_list = channel_list + "c" + i + "=[" + "C" + i + "-" + file + "] ";
		}
		else{
			if(keep_bf){
				channel_list = channel_list + "c" + i + "=[" + "C" + i + "-" + file + "] ";
			}
		}
		
	}
	
	run("Merge Channels...", channel_list + "create");

	if(mip_image){
		run("Z Project...", "projection=[" + type_MIP + "]");
		saveAs("Tiff", output + File.separator + type_MIP + "clean" + file);
		close();
		if(!save_just_mip){
			saveAs("Tiff", output + File.separator + "clean" + file);
			close();
		}
	}
	else{
		saveAs("Tiff", output + File.separator + "clean" + file);
		close();
	}
	run("Close All");
}


//will not perform subtraction. Otherwise the same as subtractChannels
function saveTiff(input, output, file){
	
	run("Bio-Formats Importer", "open=[" + input +File.separator + file + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	
	if(!keep_bf&&brightfield!=0){
		run("Split Channels");
		selectWindow("C" + brightfield + "-" + file);
		run("Close");
		channel_list = "";
		for(i = 1; i <= channels; i++){
			if(i != brightfield){
				channel_list = channel_list + "c" + i + "=[" + "C" + i + "-" + file + "] ";
			}
			else{
				if(keep_bf){
					channel_list = channel_list + "c" + i + "=[" + "C" + i + "-" + file + "] ";
				}
			}
		
		}
		run("Merge Channels...", channel_list + "create");		
	}
	if(mip_image){
		run("Z Project...", "projection=[" + type_MIP + "]");
		saveAs("Tiff", output + File.separator + type_MIP + file);
		close();
		if(!save_just_mip){
			saveAs("Tiff", output + File.separator + file);
		}
	}
	else{
		saveAs("Tiff", output + File.separator + file);
		close();
	}
	run("Close All");
}
