

//input_dir="/Users/htran/Documents/object_counting/blobs_counting/color_images/SEG/";

dir=getDirectory("mouse");
print(dir)
//dir = "/Users/hoatran/Documents/python_workspace/Spatial3DTissueJ/testing_images/filtered/";  // for testing purpose, you can disable line above, and use this
if (dir=="") 
	exit ("No argument!");

print("Working dir: "+dir+"\n");
output_dir=File.getParent(dir)+"/cell_profiles/";

if(!File.exists(output_dir)) 
      File.mkdir(output_dir);

print("Creating output folder: "+output_dir+"\n");

files=getFileList(dir);

print("Nb of files in this folder: "+files.length+"\n");
suffixe=".tif";

for(f=0;f<files.length;f++)
{
     if(!File.isDirectory(dir+files[f])) {
				name=files[f];
				// NUC image ends with dapi.tif
				if(endsWith(name,"_SEG"+suffixe)){
					//print("Get the right channel : "+name);
					short_name = substring(name,0,lastIndexOf(name,"_SEG"+suffixe));  
					open(dir+name);
					run("3D Manager");
					run("3D Manager Options", "volume surface compactness centroid_(pix) centroid_(unit) distance_to_surface centre_of_mass_(pix) centre_of_mass_(unit) bounding_box radial_distance distance_between_centers=10 distance_max_contact=1.80 drawing=Contour");
					Ext.Manager3D_AddImage();
					Ext.Manager3D_Count(nb_obj); 
					print("number of objects",nb_obj);
					Ext.Manager3D_Measure();
					Ext.Manager3D_SaveResult("M",output_dir+short_name+"_PROFILES.csv");	
					Ext.Manager3D_CloseResult("M");
					selectWindow(name);
					close();
					Ext.Manager3D_Close();

				}
     }
  
}     		   		
					


  					
  					
