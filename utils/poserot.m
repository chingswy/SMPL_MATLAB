function [ v_rot, J_DvrotDtrans, J_DvrotDvshaped ] = ...
    poserot(global_transform_remove, v_shaped)
    %POSEROT Summary of this function goes here
    %   Detailed explanation goes here
    global weights N K;
    %% rotate all the vertices
    % global_transform_remove:(K,4,4)
    global_transform_remove_vec = reshape(global_transform_remove, 24, 16);
    
    % (6980,16) = (6980,24) * (24,16)
    coefficients = weights * global_transform_remove_vec;
    % (N,4,4) <- (N,16)
    coefficients = reshape(coefficients, N, 4, 4);
    v_shaped_nor = reshape(v_shaped, N, 4);
    v_rot = zeros(N, 4);
    for j = 1:4
        v_rot(:, j) = coefficients(:, j, 1) .* v_shaped_nor(:, 1) + ...
            coefficients(:, j, 2) .* v_shaped_nor(:, 2) + ...
            coefficients(:, j, 3) .* v_shaped_nor(:, 3) + ...
            coefficients(:, j, 4) .* v_shaped_nor(:, 4);
    end
    if nargout > 1
        % this jacobian is static
        % we could pre-calculate it
        % J_DvrotDtrans: (N,4,16)
        J_DvrotDtrans = zeros(N,4,24,16);
        for n = 1:N
           for k = 1:K
               J_DvrotDtrans(n,:,k,:) = kron(v_shaped_nor(n,:),eye(4));
           end
        end
        J_DvrotDvshaped = coefficients;
    end

end
