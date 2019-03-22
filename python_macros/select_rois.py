# @ImagePlus imp


"""Short script to select regions of interest from the roi manager
based on certain criteria. Thanks to this post: 
https://forum.image.sc/t/select-rois-in-the-roi-manager-according-to-the-measured-data/908/2

"""






from ij.plugin.frame import RoiManager

threshold = 200
rm = RoiManager.getInstance()
selected = []

for i in range(rm.getCount()):
    roi = rm.getRoi(i)
    imp.setRoi(roi)
    if imp.getStatistics().area > threshold:
        selected.append(i)

rm.setSelectedIndexes(selected)

