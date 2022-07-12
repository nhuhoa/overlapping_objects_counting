"""
Hoa Tran
Wrap-up function to run STARDIST automatically
Return the segmentation results of different models. 
First, installing stardist at https://github.com/stardist/stardist
"""
from __future__ import print_function, unicode_literals, absolute_import, division
import argparse
import os
import pandas as pd
import numpy as np
import scipy
import sys
import matplotlib
import matplotlib.pyplot as plt
matplotlib.use('Agg')
matplotlib.rcParams["image.interpolation"] = None
# from packaging import version
#%matplotlib inline
#%config InlineBackend.figure_format = 'retina'

from glob import glob
from tifffile import imread, imsave
from csbdeep.utils import Path, normalize
from csbdeep.io import save_tiff_imagej_compatible
from stardist import random_label_cmap, _draw_polygons, export_imagej_rois
from stardist.models import StarDist2D
from zipfile import ZIP_DEFLATED

def predict_seg(model_name, obs_img, img_title, output_dir, output_fn=None):
    model = StarDist2D.from_pretrained(model_name)
    labels, polys = model.predict_instances_big(obs_img, axes='YX', block_size=1024, min_overlap=64, context=94)
    np.random.seed(0)
    cmap = random_label_cmap()
#     show_image(labels, cmap=cmap)
    if output_fn is None:
        output_fn = img_title[:-4]   # remove .tif at the end of file
    imsave(os.path.join(output_dir,output_fn+'_model_'+model_name+'_SEG.tif'), labels, compress=ZIP_DEFLATED)
    export_imagej_rois(os.path.join(output_dir,output_fn+'_model_'+model_name+'_SEG_ROI'), polys['coord'], compression=ZIP_DEFLATED)
    #show_image(output_dir, output_fn+'_model_'+model_name+'_demo',labels, cmap=cmap)
    
def run_stardist(input_dir, image_fn, output_dir, 
                 trained_model, output_fn=None, is_normalized=False):
    
#     X = sorted(glob(input_fn))
#     X = list(map(imread,X))
#     print(X[0].shape)
#     n_channel = 1 if X[0].ndim == 2 else X[0].shape[-1]
#     axis_norm = (0,1)   # normalize channels independently
#     # axis_norm = (0,1,2) # normalize channels jointly
#     if n_channel > 1:
#         print("Normalizing image channels %s." % ('jointly' if axis_norm is None or 2 in axis_norm else 'independently'))
    if not os.path.exists(output_dir): os.makedirs(output_dir)

    obs_img = imread(os.path.join(input_dir, image_fn))
#     n_channel = 1 if X[0].ndim == 2 else X[0].shape[-1]
    n_channel = 1 
    axis_norm = (0,1)   # normalize channels independently
    if not is_normalized: 
        obs_img = normalize(obs_img, 1, 100, axis=axis_norm)
    normalizer = None
    
#     StarDist2D.from_pretrained()
    if trained_model=='all':
        model_ls = ['2D_versatile_fluo','2D_paper_dsb2018','2D_versatile_he'] # , '2D_demo', '2D_versatile_he' is for histologist images
        for m in model_ls:
            predict_seg(m, obs_img, image_fn, output_dir, output_fn)
    
    else: # given a trainer model
        predict_seg(trained_model, obs_img, image_fn, output_dir, output_fn)
        
    
def save_images(output_dir, basename):
    outname = os.path.join(output_dir, basename + '.tif')
#     plt.savefig(outname, dpi=200)
    plt.savefig(outname, dpi=200, bbox_inches='tight')
    plt.close()
    
def show_image(output_dir, basename, img, **kwargs):
    """Plot large image at different resolutions."""
    fig, ax = plt.subplots(1,4, figsize=(16,4))
    mid = [s//2 + 600 for s in img.shape[:2]]
    for a,t,u in zip(ax.ravel(),[1,2,4,8],[16,8,4,2]):
        sl = tuple(slice(c - s//t//2, c + s//t//2, u) for s,c in zip(img.shape[:2],mid))
        a.imshow(img[sl], **kwargs)
        a.axis('off')
    plt.tight_layout()
#     plt.show()
    save_images(output_dir, basename)
    
    
# trained_model: can be: '2D_versatile_fluo', '2D_versatile_he', '2D_paper_dsb2018', '2D_demo', default all: run all models and generate segmented results

# is_normalized: raw data or normalized data. 


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_dir', required=True)  #dir that contain input image 
    parser.add_argument('--image_fn', required=True)
    parser.add_argument('--is_normalized', required=False, default=False) 
    parser.add_argument('--output_fn', default='')
    parser.add_argument('--trained_model', default='all') 
    parser.add_argument('--output_dir', required=True)
#     parser.add_argument('--datatag', default='')
    args = vars(parser.parse_args())
    print(args['input_dir'])
    print(args['image_fn'])
    print(args['output_fn'])
    print(args['trained_model'])
    print(args['output_dir'])
    print(args['is_normalized'])
#     print(args['datatag'])
    run_stardist(args['input_dir'], args['image_fn'], args['output_dir'], args['trained_model'], args['output_fn'], args['is_normalized'])
    
    
