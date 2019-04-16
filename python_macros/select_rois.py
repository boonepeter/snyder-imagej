# @ImagePlus imp


"""Short script to select regions of interest from the roi manager
based on certain criteria. Thanks to this post: 
https://forum.image.sc/t/select-rois-in-the-roi-manager-according-to-the-measured-data/908/2

"""






from ij.plugin.frame import RoiManager


rm = RoiManager.getInstance()
selected = []

for i in range(rm.getCount()):
    roi = rm.getRoi(i)
    imp.setRoi(roi)
    #You can get any statistics from this list: https://imagej.nih.gov/ij/developer/api/ij/process/ImageStatistics.html
    if imp.getStatistics().area < 10:
        selected.append(i)

rm.setSelectedIndexes(selected)
#this deletes the selected rois
rm.runCommand("Delete")
