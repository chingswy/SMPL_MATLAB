from __future__ import print_function
import cPickle as pickle
from scipy.io import savemat

# model = pickle.load(open('basicModel_f_lbs_10_207_0_v1.0.0.pkl'))
# print(model.keys())
# savemat('female.mat',model)

# model = pickle.load(open('basicmodel_m_lbs_10_207_0_v1.0.0.pkl'))
# print(model.keys())
# savemat('male.mat',model)

# for the hand model

gender = ['male', 'female']
for gen in gender:
    model = pickle.load(open('SMPLH_%s.pkl'%(gen)))
    import ipdb; ipdb.set_trace()
    print(model.keys())
    savemat('smplh_%s.mat'%(gen),model)

direct = ['LEFT', 'RIGHT']
for d in direct:
    model = pickle.load(open('MANO_%s.pkl'%(d)))
    print(model.keys())
    savemat('mano_%s.mat'%(d),model)

