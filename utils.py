# Copyright (C) 2017 Zhixian MA <zx@mazhixian.me>

"""
Utilities for radio galaxies detection
"""

import os
import numpy as np
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
