
Trans  = coefficients;
verts = v_shaped_nor;
out = zeros(N,4);

for j = 1:4
   out(:,j) = Trans(:,j,1).*verts(:,1) +...
              Trans(:,j,2).*verts(:,2) +...
              Trans(:,j,3).*verts(:,3) +...
              Trans(:,j,4).*verts(:,4); 
end