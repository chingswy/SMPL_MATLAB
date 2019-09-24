from __future__ import print_function
try:
    import cPickle as pickle
except ImportError:
    import pickle
from scipy.io import savemat
import numpy as np
from os.path import join
import os

def read_pickle(filename):
    with open(filename, 'rb') as smplh_file:
        model = pickle.load(smplh_file, encoding='latin1')
    return model


savemat('female.mat',read_pickle('SMPL_MALE.pkl'))
savemat('male.mat',read_pickle('SMPL_FEMALE.pkl'))

# for the hand model

gender = ['male', 'female']
for gen in gender:
    model_name = 'SMPLH_%s.pkl'%(gen)
    if os.path.exists(model_name):
        model = read_pickle(model_name)
        print(model.keys())
        model['shapedirs'] = np.array(model['shapedirs'])
        savemat('smplh_%s.mat'%(gen),model)
    else:
        print('>>> File not exists ', model_name)

direct = ['LEFT', 'RIGHT']
for d in direct:
    model_name = 'MANO_%s.pkl'%(d)
    if os.path.exists(model_name):
        model = read_pickle(model_name)
        print(model.keys())
        model['shapedirs'] = np.array(model['shapedirs'])
        savemat('mano_%s.mat'%(d),model)
    else:
        print('>>> File not exists ', model_name)


