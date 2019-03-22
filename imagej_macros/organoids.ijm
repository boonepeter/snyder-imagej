
maintitle = getTitle();
maintitle = split(maintitle, ".");
maintitle = maintitle[0];
print(maintitle);
run("Split Channels");
images = getList("image.titles");
imageCalculator("Add create stack", images[0] , images[2]);
images = getList("image.titles");
imageCalculator("Add create stack", images[4],images[3]);
images = getList("image.titles");

waitForUser("Threshold image, then hit OK");


run("Remove Outliers...", "radius=1 threshold=50 which=Bright stack");
run("Dilate", "stack");
run("Dilate", "stack");


run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid mean_distance_to_surface std_dev_distance_to_surface median_distance_to_surface centre_of_mass bounding_box dots_size=10 font_size=25 show_numbers white_numbers store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=[" + images[0] + "]");



run("3D Objects Counter", "threshold=1 slice=2 min.=5 max.=16272900 objects statistics");
saveAs("Results", "/Volumes/LaCie/Peter/veronica/out/" + maintitle + "_tfp.csv");
run("Close");


run("3D OC Options", "integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value dots_size=10 font_size=30 show_numbers white_numbers store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=[" + images[2] + "]");

run("3D Objects Counter", "threshold=1 slice=2 min.=5 max.=16272900 statistics");
saveAs("Results", "/Volumes/LaCie/Peter/veronica/out/" + maintitle + "_yfp.csv");
run("Close");

run("3D OC Options", "integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value dots_size=10 font_size=30 show_numbers white_numbers store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=[" + images[3] + "]");

run("3D Objects Counter", "threshold=1 slice=2 min.=5 max.=16272900 statistics");
saveAs("Results", "/Volumes/LaCie/Peter/veronica/out/" + maintitle + "_mko.csv");
run("Close");


images = getList("image.titles")
selectWindow(images[6]);
run("16-bit");
run("Merge Channels...", "c1=[" + images[0] + "] c2=[" + images[1] + "] c3=[" + images[2] + "] c4=[" + images[3] + "] c5=[" + images[6] + "] create");
run("Save", "save=[/Volumes/Lacie/Peter/veronica/out/tif/" + maintitle + ".tif]");



