function [j_shaped, v_shaped] = shapeblend(betas)
    %SHAPEBLEND Summary of this function goes here
    %   Detailed explanation goes here
    %% shape blending
    global shapedirs_vec v_tem_vec J_reg_vec;
    v_shapeblend = shapedirs_vec * betas;

    v_shaped = v_tem_vec + v_shapeblend;
    j_shaped = J_reg_vec * v_shaped;

end
