# Copyright (C) 2017 Zhixian MA <zx@mazhixian.me>

"""
Utilities for radio galaxies detection
"""

import os
import numpy as np
import pandas as pd
from astropy.io import fits

def load_fits(filepath):
    """Load fits file, output the hdu"""
    with fits.open(filepath) as hdu:
        h = hdu[0]

    return h.header, h.data

def get_filename(filepath):
    """Get name of the file"""
    # Extract the absolute name
    file_abs = filepath.split('/')[-1]
    # Remove profix
    filename = file_abs.split('.')[0:-1]
    filename = '_'.join(filename)

    return filename

def combine_fits(filelist):
    """Combine the files by adding them together..."""
    # Init a hdu
    hdu = fits.ImageHDU()
    fname = []
    for i, f in enumerate(filelist):
        fname.append(str(get_filename(f)))
        hp = fits.open(f)
        h = hp[0]
        if hdu.data is None:
            hdu.data = h.data
        else:
            try:
                hdu.data += h.data
            except:
                print("Combined image should be the same shape.")
                continue
    # update header
    hdu.header["CONSISTS"] = str(' '.join(fname))
    # update history
    hdu.header["HISTORY"] = 'utils.combine_fits([%s])' % ' '.join(filelist)
    hdu.header["PATH"] = os.path.realpath('./')

    return hdu

def getOrderedDict(keys,keysid):
    """Get ordered dict"""
    from collections import OrderedDict
    d = OrderedDict()
    for i in keysid:
        d[keys[i]] = []
    return d

def getPSdict():
    """Output PS dict according to given typecode
    1 - FRI, 2 - FRII, 3 - RQQ, 4 - SF, 5 - SB
    """
    keys = ["redshift","x","y","flux","major","minor","pa","x_l1","y_l1","flux_l1",
            "major_l1","minor_l1","x_l2","y_l2","flux_l2","major_l2","minor_l2",
            "x_h1","y_h1","flux_h1","x_h2","y_h2","flux_h2"]
    ps = {"1": None, "2": None, "3": None, "4": None, "5": None}
    id_dict = {"1": [0,1,2,3,7,8,9,10,11,12,13,14,15,16],
               "2": [0,1,2,3,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22],
               "3": [0,1,2,3],
               "4": [0,1,2,3,4,5,6],
               "5": [0,1,2,3,4,5,6]}
    for key in ps.keys():
        ps[key] = getOrderedDict(keys=keys,keysid=id_dict[key])
    
    return ps

def getPSparam(psline,typedict):
    "get ps parameters"
    # split
    psparams = np.array(psline[0:-1].split(","))
    # remove " "
    psparams = psparams[psparams != ""]
    # update typedict
    for i,key in enumerate(typedict.keys()):
        typedict[key].append(float(psparams[i+1]))
    
    return typedict

def getRegion(pstype,psparam):
    """Generate ds9 style region list"""
    if pstype == 1 or pstype == 2:
        id_l1 = np.array([7,6,9,10,11])
        id_l2 = np.array([13,12,15,16,17])
        reg1 = "ellipse(" + ",".join(psparam[id_l1].astype(str)) + ")\n"
        reg2 = "ellipse(" + ",".join(psparam[id_l2].astype(str)) + ")\n"
        reg = reg1+reg2
    elif pstype == 3:
        idx = [2,1]
        reg = "circle(" + ",".join(psparam[idx].astype(str)) + ", 1.0)\n"
    elif pstype == 4 or pstype == 5:
        idx = [2,1,4,5,6]
        reg = "ellipse(" + ",".join(psparam[idx].astype(str)) + ")\n"
    else:
        reg = None
    
    return reg

def writeRegion(pstype,psparam,idx_type,savepath):
    """Write ps list to region files."""
    with open(savepath, 'w') as fp:
        # ds9 style header
        fp.write('# Region file format: DS9 version 4.1\n')
        fp.write('global color=red dashlist=8 3 width=1 font="helvetica 10 normal roman" select=1 highlite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1\n')
        fp.write('image\n')
        for i in idx_type:
            reg = getRegion(pstype[i],psparam[i,:])
            fp.write(reg)
