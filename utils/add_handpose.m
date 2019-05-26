function theta_full = add_handpose(thetas)
%add_handpose - from the pca pose to full hand pose
%
% Syntax: theta_full = add_handpose(theta)
%
% 
    % full pose
    global ncomps body_pose_dofs selected_components hands_mean;
    full_hand_pose = thetas(body_pose_dofs + 1:ncomps*2 + body_pose_dofs)*selected_components;
    fullpose = [thetas(1:body_pose_dofs), hands_mean' + full_hand_pose];
    theta_full = fullpose;
end