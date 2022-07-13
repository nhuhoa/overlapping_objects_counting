// TO DO: clean macro here

run("Invert");
run("Grays");
run("Mean...", "radius=5");
setAutoThreshold("Otsu");
//run("Threshold...");
resetThreshold();
run("Close");
run("Auto Threshold...", "method=[Try all] white");
close();
run("Duplicate...", " ");
saveAs("Tiff", "/Users/hoatran/Documents/python_workspace/overlapping_objects_counting/testing_color_image/HEDAB_channel2.tif");
setAutoThreshold("Otsu");
//run("Threshold...");
setAutoThreshold("Huang");
//setThreshold(0, 12);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Close");
run("Invert");


run("Grays");
run("Watershed");
selectWindow("Result of Cet-SN38_WT_10ng_3.jpg-(Colour_1).tif");
close();
selectWindow("HEDAB_channel2-mask.tif");
close();
selectWindow("Cet-SN38_WT_10ng_3-1.jpg-(Colour_2)");
close();
setOption("BlackBackground", false);
run("Erode");
imageCalculator("AND create", "Cet-SN38_WT_10ng_3.jpg-(Colour_1).tif","HEDAB_channel2-mask-1.tif");
selectWindow("Result of Cet-SN38_WT_10ng_3.jpg-(Colour_1).tif");
close();
run("Invert");
imageCalculator("AND create", "Cet-SN38_WT_10ng_3.jpg-(Colour_1).tif","HEDAB_channel2-mask-1.tif");
selectWindow("Result of Cet-SN38_WT_10ng_3.jpg-(Colour_1).tif");
saveAs("Tiff", "/Users/hoatran/Documents/python_workspace/overlapping_objects_counting/testing_color_image/test2/Test2.tif");
selectWindow("HEDAB_channel2-mask-1.tif");
saveAs("Tiff", "/Users/hoatran/Documents/python_workspace/overlapping_objects_counting/testing_color_image/test2/HEDAB_channel2-mask.tif");
close();
selectWindow("Cet-SN38_WT_10ng_3.jpg-(Colour_1).tif");
close();
open("/Users/hoatran/Documents/python_workspace/overlapping_objects_counting/testing_color_image/test2/SEG/_model_2D_paper_dsb2018_SEG.tif");
selectWindow("_model_2D_paper_dsb2018_SEG.tif");
run("3-3-2 RGB");


// Noted file Holes while background = 255
