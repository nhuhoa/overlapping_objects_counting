


print("\\Clear");
input_dir="/Users/htran/Documents/storage_tmp/merfish_XP2059/wavelength647/";
suffixe=".TIFF"; // change this setting if your image ends with .tiff or .TIFF

c=0;

FOV=25;
z=5;
suffix=".TIFF";
test_case = "FOV0"+FOV+"_z0"+z;
for (r=1; r<=8; r++) {

//r=8;


	short_name="merFISH_0"+r+"_0"+FOV+"_0"+z;
	image_fn=short_name+suffix;

	open(input_dir+image_fn);
	if (bitDepth > 8) {run("8-bit");}
	selectWindow(image_fn);
	run("Find Edges");
	getStatistics(area, mean, min, max, std);
	print(getTitle+":   max:   "+max+"  min: "+min+"  mean: "+mean+"  area: "+area+"  std:"+std);
	setResult("image", c, image_fn);
    setResult("std", c, std);
    setResult("mean", c, mean);
    setResult("max", c, max);
    updateResults();
    c++;
}

selectWindow("Results");
saveAs("Results",input_dir+"blur_metric_wavelength_647.csv");
run("Close All");

		