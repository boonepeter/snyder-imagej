run("Fluorescent Cells (400K)");

run("Split Channels");

//You can put a stoping point in your macro. You can manually set thresholds
//or do other tasks before hitting "ok"
waitForUser("Are you sure you want to close all of these windows?");

run("Close All");