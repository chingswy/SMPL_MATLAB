# SMPL_MATLAB
The MATLAB implementation of SMPL human model
## Overview
For more details about SMPL model, see [SMPL](http://smpl.is.tue.mpg.de/). The official implementation was mainly based on [chumpy](https://github.com/mattloper/chumpy) in Python 2.

- Why did I implement this in MATLAB?
  - I don't know. And the MATLAB is also so slow.

You can find other implementations in the github
- Numpy and Tensorflow Implementation

  Contributor: [CalciferZh](https://github.com/CalciferZh).
- PyTorch Implementation with Batch Input

  Contributor: [Lotayou](https://github.com/Lotayou) and [sebftw](https://github.com/sebftw)
  
## Usage
1. Download the model file [here](http://smpl.is.tue.mpg.de/downloads).
2. Run `python2 preprocess.py` to convert the `.pkl` model file to `'mat`
3. The `SMPL.m` is the matlab model file.
