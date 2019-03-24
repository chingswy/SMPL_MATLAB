clear
addpath('utils/')
load('models/male_simple.mat')

vis_vert = 0;
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
if vis_vert
    figure(1)
    plotVertices(v_tem_vec, faces, N);
end

%% input parameters
tic
thetas = [1.157, 1.091, 1.213, 0.224, 0.062, 0.072, 0.143, -0.086, -0.049, 0.091, -0.019, -0.017, -0.008, -0.156, -0.080, 0.178, 0.063, 0.021, -0.024, -0.025, 0.040, -0.162, 0.162, 0.114, -0.227, -0.119, 0.054, 0.025, -0.027, 0.018, -0.066, 0.149, -0.193, -0.010, 0.085, 0.003, 0.081, 0.137, -0.037, -0.054, -0.158, -0.229, 0.068, 0.110, 0.462, 0.415, 0.020, -0.019, -0.121, -0.745, -0.525, 0.156, 0.122, 0.846, 0.047, -1.991, 0.993, 0.153, 0.382, -0.100, -0.305, -0.174, 0.806, -0.012, -0.011, -0.276, 0.255, 0.008, -0.103, 0.092, 0.084, 0.062];

betas = 3 * (rand(10, 1) - 0.5);

%% shape blending
v_shapeblend = shapedirs_vec * betas;

v_shaped = v_tem_vec + v_shapeblend;
j_shaped = J_reg_vec * v_shaped;
%%
if vis_vert
    figure(2)
    plotVertices(v_shaped, faces, N)
end

%% rotation matrix
% !ATTN!!!! matlab starts at 1!!!!
global_transform = zeros(K, 4, 4);
global_transform_remove = zeros(K, 4, 4);

for i = 1:K

    if i == 1% for root
        global_transform(i, 1:3, 1:3) = so3exp(thetas(3 * i - 2:3 * i));
        global_transform(i, 1, 4) = j_shaped(i);
        global_transform(i, 2, 4) = j_shaped(i + K);
        global_transform(i, 3, 4) = j_shaped(i + 2 * K);
        global_transform(i, 4, 4) = 1;
    else
        rotmat = so3exp(thetas(3 * i - 2:3 * i));
        trans = ones(4, 1);
        trans(1, 1) = j_shaped(i) - j_shaped(kintree_table(1, i));
        trans(2, 1) = j_shaped(i + K) - j_shaped(kintree_table(1, i) + K);
        trans(3, 1) = j_shaped(i + 2 * K) - j_shaped(kintree_table(1, i) + 2 * K);
        local_trans = eye(4);
        local_trans(1:3, 1:3) = rotmat;
        local_trans(1:3, 4) = trans(1:3, 1);
        %         disp(trans)
        global_transform(i, :, :) = squeeze(global_transform(kintree_table(1, i), :, :)) ...
            * local_trans;
    end

    % calculate the removed rotmat
    jZero = [j_shaped(i); j_shaped(i + K); j_shaped(i + 2 * K); 0];
    fx = squeeze(global_transform(i, :, :)) * jZero;
    pack = zeros(4);
    pack(1:3, 4) = fx(1:3, 1);
    global_transform_remove(i, 1:4, 1:4) = squeeze(global_transform(i, :, :)) - pack;
end % end transformation

j_poses = reshape(global_transform(:, 1:3, 4), 72, 1);
%% pose blending

% skip this

%% rotate all the vertices
global_transform_remove_vec = reshape(global_transform_remove, 24, 16);
% (6980,16) = (6980,24) * (24,16)
coefficients = weights * global_transform_remove_vec;
% (N,4,4) <- (N,16)
coefficients = reshape(coefficients, N, 4, 4);
v_shaped_nor = reshape(v_shaped, N, 4);
v_rot = zeros(N, 4);
% for i = 1:N
%    rotmat = squeeze(coefficients(i,:,:));
%    v_tem = rotmat*v_shaped_nor(i,:)';
%    v_rot(i,:) = v_tem';
% end
for j = 1:4
    v_rot(:, j) = coefficients(:, j, 1) .* v_shaped_nor(:, 1) + ...
        coefficients(:, j, 2) .* v_shaped_nor(:, 2) + ...
        coefficients(:, j, 3) .* v_shaped_nor(:, 3) + ...
        coefficients(:, j, 4) .* v_shaped_nor(:, 4);
end

toc
%%
if vis_vert
    figure(3)
    plotVertices(v_rot, faces, N)
end
