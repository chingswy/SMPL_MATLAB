function [j_shaped, v_shaped, J_DjshDbetas,J_DvshDbetas] = shapeblend(betas)
    %SHAPEBLEND Summary of this function goes here
    %   Detailed explanation goes here
    %% shape blending
    global shapedirs_vec v_tem_vec J_reg_vec;
    v_shapeblend = shapedirs_vec * betas;

    v_shaped = v_tem_vec + v_shapeblend;
    j_shaped = J_reg_vec * v_shaped;
    if nargout > 2
        % this jacobian is static
        % we could pre-calculate it
        J_DvshDbetas = shapedirs_vec;
        J_DjshDbetas = J_reg_vec*shapedirs_vec;
    end
end
