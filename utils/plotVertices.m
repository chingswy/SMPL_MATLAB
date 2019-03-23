function plotVertices( v_shaped ,faces,N)
%PLOTVERTICES Summary of this function goes here
%   Detailed explanation goes here
    if size(v_shaped,2) == 3
        v = v_shaped;
    else
        v = reshape(v_shaped,N,4);
        v = v(:,1:3);
    end
    patch('Faces', faces, 'Vertices',v, 'FaceColor', 'w')
    view(3)
    axis equal

end

