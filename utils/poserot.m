function [ v_rot ] = poserot(global_transform_remove, v_shaped)
    %POSEROT Summary of this function goes here
    %   Detailed explanation goes here
    global weights N;
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

end
