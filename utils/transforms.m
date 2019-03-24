function [global_transform, global_transform_remove] = ...
        transforms(thetas, j_shaped)
    global kintree_table;
    global K;
    %TRANSFORMS Summary of this function goes here
    %   Detailed explanation goes here
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

end
