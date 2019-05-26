clear
addpath('utils/')
global kintree_table v_tem_vec shapedirs_vec J_reg_vec weights;
global N K;
load('models/male_simple.mat')

vis_vert = 0;

%%
%% flatten the parameters
% num of vertices
N = size(v_template, 1);
K = size(weights, 2);

% matlab starts from 1
faces = f + 1;
kintree_table = kintree_table + 1;
% shapedirs
shapedirs_vec = reshape(shapedirs.x, N * 3, 10);
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

%%
thetas = [1.157, 1.091, 1.213, 0.224, 0.062, 0.072, 0.143, -0.086, -0.049, 0.091, -0.019, -0.017, -0.008, -0.156, -0.080, 0.178, 0.063, 0.021, -0.024, -0.025, 0.040, -0.162, 0.162, 0.114, -0.227, -0.119, 0.054, 0.025, -0.027, 0.018, -0.066, 0.149, -0.193, -0.010, 0.085, 0.003, 0.081, 0.137, -0.037, -0.054, -0.158, -0.229, 0.068, 0.110, 0.462, 0.415, 0.020, -0.019, -0.121, -0.745, -0.525, 0.156, 0.122, 0.846, 0.047, -1.991, 0.993, 0.153, 0.382, -0.100, -0.305, -0.174, 0.806, -0.012, -0.011, -0.276, 0.255, 0.008, -0.103, 0.092, 0.084, 0.062];

% betas = 3 * (rand(10, 1) - 0.5);
betas = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]'*5 - 2.5;
%%
tic
for j = 1:1
    [verts, joints] = SMPLmodel(thetas, betas);
    %plotVertices(verts, faces, N)
end
toc
