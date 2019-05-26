function [global_transform, global_transform_remove] = ...
        transforms(thetas, j_shaped)
    global kintree_table;
    global K;
    %TRANSFORMS Summary of this function goes here
    %   Detailed explanation goes here
    global_transform = zeros(K, 4, 4);
    global_transform_remove = zeros(K, 4, 4);
%     J_DgtDtheta = zeros(K*16,3*K);
%     J_DgtrDtheta = zeros(K*16,3*K);
%     J_DgtDjsh = zeros(K*16,3*K);
%     J_DgtDjsh = zeros(K*16,3*K);
%     J_DrDtheta = zeros(K*9,3*K);
%     J_DtransDjsh = zeros(K*3,K*3);
%     J_DtransDthetas = zeros(K*3,K*3);
%     jacob = cell(K,1);
    %!ATTN: The j_shaped is [x,x,x,y,y,y,z,z,z]
    % we first calculate [x;y;z;x;y;z]
    for i = 1:K

        if i == 1% for root
%             [rotmat,jacob{i}] = so3exp(thetas(3 * i - 2:3 * i));
            [rotmat] = so3exp(thetas(3 * i - 2:3 * i));
            
            global_transform(i, 1:3, 1:3) = rotmat;
%             J_DrDtheta(9*(i-1)+1:9*i,3 * i - 2:3 * i) = jacob{i};
            % copy the Drotmat/Dtheta to Dtransform/Dtheta
          
            global_transform(i, 1, 4) = j_shaped(i);
            global_transform(i, 2, 4) = j_shaped(i + K);
            global_transform(i, 3, 4) = j_shaped(i + 2 * K);
            global_transform(i, 4, 4) = 1;
            
%             J_DtransDjsh(3*(i-1)+1:3*(i-1)+3,3*(i-1)+1:3*(i-1)+3) = eye(3);
            
        else
%             [rotmat,jacob{i}] = so3exp(thetas(3 * i - 2:3 * i));
            [rotmat] = so3exp(thetas(3 * i - 2:3 * i));
            
            % jacob succeed from parents
            % (rotmat \otimes I) \cdot (9,3K) -> (9,3K)
%             partial = kron(rotmat',eye(3));
%             i_parent = kintree_table(1, i);
%             J_DrDtheta(9*(i-1)+1:9*i,:) = partial*...
%                     J_DrDtheta(9*(i_parent-1)+1:9*(i_parent-1)+9,:);
            % jacob of itself
%             partial = kron(eye(3),squeeze(global_transform(i_parent,1:3,1:3)));
%             J_DrDtheta(9*(i-1)+1:9*i,3 * i - 2:3 * i) = partial*jacob{i};
            
            trans = ones(4, 1);
            trans(1, 1) = j_shaped(i) - j_shaped(kintree_table(1, i));
            trans(2, 1) = j_shaped(i + K) - j_shaped(kintree_table(1, i) + K);
            trans(3, 1) = j_shaped(i + 2 * K) - j_shaped(kintree_table(1, i) + 2 * K);
            
%             J_DtransDjsh(3*(i-1)+1:3*(i-1)+3,3*(i-1)+1:3*(i-1)+3) = ...
%                 squeeze(global_transform(i_parent, 1:3, 1:3))*eye(3);
%             J_DtransDjsh(3*(i-1)+1:3*(i-1)+3,3*(i_parent-1)+1:3*(i_parent-1)+3)...
%                 = -squeeze(global_transform(i_parent, 1:3, 1:3))*eye(3);
%             J_DtransDjsh(3*(i-1)+1:3*(i-1)+3,:) = ...
%                 J_DtransDjsh(3*(i-1)+1:3*(i-1)+3,:) + ...
%                 J_DtransDjsh(3*(i_parent-1)+1:3*(i_parent-1)+3,:);
%             % j = R(J_i - J_iparents) + T
%             J_DtransDthetas(3*(i-1)+1:3*(i-1)+3,3*(i-1)+1:3*(i-1)+3) = ...
%                 kron([j_shaped(i);j_shaped(i+K);j_shaped(i+2*K)]',eye(3))*jacob{i_parent}...
%                 -kron([j_shaped(i_parent);j_shaped(i_parent+K);j_shaped(i_parent+2*K)]',...
%                     eye(3))*jacob{i_parent};
%             J_DtransDthetas(3*(i-1)+1:3*(i-1)+3,:) = ...
%                 J_DtransDthetas(3*(i-1)+1:3*(i-1)+3,:) + ...
%                 J_DtransDthetas(3*(i_parent-1)+1:3*(i_parent-1)+3,:);
            
            local_trans = eye(4);
            local_trans(1:3, 1:3) = rotmat;
            local_trans(1:3, 4) = trans(1:3, 1);
            %         disp(trans)
            global_transform(i, :, :) = squeeze(global_transform(kintree_table(1, i), :, :)) ...
                * local_trans;
        end
%         J_DgtDtheta(16*(i-1)+1:16*(i-1)+3,:) = J_DrDtheta(9*(i-1)+1:9*(i-1)+3,:);
%         J_DgtDtheta(16*(i-1)+5:16*(i-1)+7,:) = J_DrDtheta(9*(i-1)+4:9*(i-1)+6,:);
%         J_DgtDtheta(16*(i-1)+9:16*(i-1)+11,:) = J_DrDtheta(9*(i-1)+7:9*(i-1)+9,:);
            
        % calculate the removed rotmat
        jZero = [j_shaped(i); j_shaped(i + K); j_shaped(i + 2 * K); 0];
        fx = squeeze(global_transform(i, :, :)) * jZero;
%         disp(i);
%         disp('GlobalTransform')
%         disp(squeeze(global_transform(i, :, :)))
%         disp('jzero:')
%         disp(jZero)
%         disp('fx:')
%         disp(fx);
        pack = zeros(4);
        pack(1:3, 4) = fx(1:3, 1);
        global_transform_remove(i, 1:4, 1:4) = squeeze(global_transform(i, :, :)) - pack;
    end % end transformation

end
