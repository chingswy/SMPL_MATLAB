function [verts, joints] = SMPLmodel(thetas, betas)
    [j_shaped, v_shaped, J_DjshDbetas,J_DvshDbetas] = shapeblend(betas);
    [global_transform, global_transform_remove] = ...
        transforms(thetas, j_shaped);
    [ v_rot,J_DvrotDtrans,J_DvrotDvshaped ] = ...
        poserot(global_transform_remove, v_shaped);
    verts = v_rot;
    joints = reshape(global_transform(:, 1:3, 4), 72, 1);

end
