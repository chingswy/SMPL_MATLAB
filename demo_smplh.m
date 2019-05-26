clear all
addpath('utils/')
global kintree_table v_tem_vec shapedirs_vec J_reg_vec weights;
global N K;
load('models/smplh_male.mat')

vis_vert = 0;

%%
%% flatten the parameters
% num of vertices
N = size(v_template, 1);
K = size(weights, 2);

%%
% matlab starts from 1
faces = f + 1;
kintree_table = kintree_table + 1;
% shapedirs
shapedirs_vec = reshape(shapedirs, N * 3, 10);
% add zero to homo
shapedirs_vec = [shapedirs_vec; zeros(N, 10)];
% template vertices, to vector:(3N,1)
v_tem_vec = reshape(v_template, N * 3, 1);
% add 1, to (4N,1) homo
v_tem_vec = [v_tem_vec; ones(N, 1)];

% make joints regressor
% ATTN! the last block is set to Zero
% so the joints is not the homo
zeros_24x6890 = sparse(K, N);
J_reg_vec = [J_regressor, zeros_24x6890, zeros_24x6890, zeros_24x6890;
        zeros_24x6890, J_regressor, zeros_24x6890, zeros_24x6890;
        zeros_24x6890, zeros_24x6890, J_regressor, zeros_24x6890;
        zeros_24x6890, zeros_24x6890, zeros_24x6890, zeros_24x6890];

%% load the hand part
% same to `smpl_handpca_wrapper.py`
global body_pose_dofs ncomps selected_components hands_mean;
body_pose_dofs = 66;
ncomps = 6;  % for one hand, pca coeff
hand_l = load('models/mano_LEFT.mat');
hand_r = load('models/mano_RIGHT.mat');
hands_componentsl = hand_l.hands_components;
hands_meanl       = hand_l.hands_mean';
hands_coeffsl     = hand_l.hands_coeffs(:, 1:ncomps);
hands_componentsr = hand_r.hands_components;
hands_meanr       = hand_r.hands_mean';
hands_coeffsr     = hand_r.hands_coeffs(:, 1:ncomps);

selected_components = ...
 [hands_componentsl(1:ncomps,:), zeros([ncomps, size(hands_componentsl,2)]);...
  zeros([ncomps, size(hands_componentsr,2)]), hands_componentsr(1:ncomps,:);...
 ];

hands_mean  = [hands_meanl; hands_meanr];

pose_coef = zeros([body_pose_dofs + size(selected_components,1),1]);
% matlab 1 index;

    
%%
thetas = [-0.17192541, +0.36310464, +0.05572387, -0.42836206, -0.00707548, +0.03556427,...
             +0.18696896, -0.22704364, -0.39019834, +0.20273526, +0.07125099, +0.07105988,...
             +0.71328310, -0.29426986, -0.18284189, +0.72134655, +0.07865227, +0.08342645,...
             +0.00934835, +0.12881420, -0.02610217, -0.15579594, +0.25352553, -0.26097519,...
             -0.04529948, -0.14718626, +0.52724564, -0.07638319, +0.03324086, +0.05886086,...
             -0.05683995, -0.04069042, +0.68593617, -0.75870686, -0.08579930, -0.55086359,...
             -0.02401033, -0.46217096, -0.03665799, +0.12397343, +0.10974685, -0.41607569,...
             -0.26874970, +0.40249335, +0.21223768, +0.03365140, -0.05243080, +0.16074013,...
             +0.13433811, +0.10414972, -0.98688595, -0.17270103, +0.29374368, +0.61868383,...
             +0.00458329, -0.15357027, +0.09531648, -0.10624117, +0.94679869, -0.26851003,...
             +0.58547889, -0.13735695, -0.39952280, -0.16598853, -0.14982575, -0.27937399,...
             +0.12354536, -0.55101035, -0.41938681, +0.52238684, -0.23376718, -0.29814804,...
             -0.42671473, -0.85829819, -0.50662164, +1.97374622, -0.84298473, -1.29958491];

% betas = 3 * (rand(10, 1) - 0.5);
betas = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]'*5 - 2.5;
%%
tic
for j = 1:1
    [verts, joints] = SMPLH(thetas, betas);
    plotVertices(verts, faces, N)
end
toc
