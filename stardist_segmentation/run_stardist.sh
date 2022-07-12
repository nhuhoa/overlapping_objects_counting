#!/bin/sh

## Point to your images directory
## ex: basePath=yourdir/testing_color_image/
basePath=/home/htran/Projects/git_repos/overlapping_objects_counting/testing_color_image/

## Point to your script directory where you keep Stardist script
## ex: basePath=yourdir/stardist_segmentation/
script_dir=/home/htran/Projects/git_repos/overlapping_objects_counting/stardist_segmentation/

log_file="${basePath}stardist_run.log"
exec >> $log_file 2>&1 && tail $log_file


inputDir="${basePath}"
image_fn=Cet-SN38_WT_10ng_3_color_deconv.tif
outputDir="${inputDir}SEG/"
echo $inputDir
echo $outputDir
echo "Segment files..."
script_fn="${script_dir}/exe_stardist_small_image.py" # for small image, ex: less than 1024 pixels in X, Y
# script_fn="${script_dir}/exe_stardist_big_image.py" # for big image
python_env_path="/home/htran/anaconda3/envs/mypytorch/bin/python"

$python_env_path $script_fn --input_dir $inputDir --image_fn $image_fn --output_dir $outputDir



