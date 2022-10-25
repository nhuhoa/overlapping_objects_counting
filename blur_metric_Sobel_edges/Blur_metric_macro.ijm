


print("\\Clear");
input_dir="/Users/htran/Documents/storage_tmp/merfish_XP2059/blur_metric/";
input_image="merFISH_02_025_05.tif";
suffixe=".tif"; // change this setting if your image ends with .tiff or .TIFF
short_name = substring(input_image,0,lastIndexOf(input_image,suffixe));
c=0;
open(input_dir+input_image);
for(gb=0;gb<=6;gb++)
{
	if(gb==0){  //raw image
		selectWindow(input_image);
		obs_image=short_name +"_RAW";
		//if (bitDepth > 8) {run("8-bit");}
		run("Duplicate...", "title=["+ obs_image+"]");
		selectWindow(obs_image);
		run("Find Edges");
		getStatistics(area, mean, min, max, std);
		print(getTitle+":   max:   "+max+"  min: "+min+"  mean: "+mean+"  area: "+area+"  std:"+std);
		setResult("image", c, obs_image);
	    setResult("std", c, std);
	    setResult("mean", c, mean);
	    setResult("max", c, max);
	    updateResults();
	    c++;
		
	}else{
		obs_image=short_name +"_blurLevel_"+gb;
		selectWindow(input_image);
		//if (bitDepth > 8) {run("8-bit");}
		run("Duplicate...", "title=["+ obs_image+"]");
		
		selectWindow(obs_image);
		run("Gaussian Blur...", "sigma="+gb);
		//name=short_name+"-GB"+gb+".tif";
		//selectWindow(obs_image);
		run("Find Edges");
		getStatistics(area, mean, min, max, std);
		print(getTitle+":   max:   "+max+"  min: "+min+"  mean: "+mean+"  area: "+area+"  std:"+std);
		setResult("image", c, obs_image);
	    setResult("std", c, std);
	    setResult("mean", c, mean);
	    setResult("max", c, max);
	    updateResults();
	    c++;
		
		
	}
	
    
	
	
}	

selectWindow("Results");
saveAs("Results",input_dir+"blur_metric.csv");
run("Close All");

		