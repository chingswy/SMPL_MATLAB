from __future__ import print_function
import cPickle as pickle
from scipy.io import savemat

model = pickle.load(open('basicModel_f_lbs_10_207_0_v1.0.0.pkl'))
print(model.keys())
savemat('female.mat',model)

model = pickle.load(open('basicmodel_m_lbs_10_207_0_v1.0.0.pkl'))
print(model.keys())
savemat('male.mat',model)

