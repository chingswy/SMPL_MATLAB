# SMPL_MATLAB
The MATLAB implementation of SMPL human model

## Usage
1. Download the model file [here](http://smpl.is.tue.mpg.de/downloads). And place it to `models/` folder.
2. `cd models` and Run `python2 preprocess.py` to convert the `.pkl` model file to `.mat`. You need the package `pickle` to read the `pkl` file, and `scipy` to write the model data to `mat` format.
3. The `SMPL.m` is the matlab model file.


## Overview
For more details about SMPL model, see [SMPL](http://smpl.is.tue.mpg.de/). The official implementation was mainly based on [chumpy](https://github.com/mattloper/chumpy) in Python 2.

- Why did I implement this in MATLAB?
  - I don't know. And the MATLAB is also so slow.

You can find other implementations in the github
- Numpy and Tensorflow Implementation

  Contributor: [CalciferZh](https://github.com/CalciferZh).
- PyTorch Implementation with Batch Input

  Contributor: [Lotayou](https://github.com/Lotayou) and [sebftw](https://github.com/sebftw)
  
