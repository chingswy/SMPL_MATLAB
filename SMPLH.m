function [verts, joints] = SMPLH(thetas, betas)
    [j_shaped, v_shaped] = shapeblend(betas);
    [global_transform, global_transform_remove] = ...
        transforms(thetas, j_shaped);
    [ v_rot] = ...
        poserot(global_transform_remove, v_shaped);
    verts = v_rot;
    joints = reshape(global_transform(:, 1:3, 4), 72, 1);

end
