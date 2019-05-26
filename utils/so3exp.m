% Emanuele Ruffaldi 2017 @ SSSA
function [rotationMatrix, dRdr] = so3exp(rotationVector)
    rotationVector = rotationVector';
    needJacobian = (nargout > 1);
    theta = norm(rotationVector);
    if theta < 1e-6
        rotationMatrix = eye(3, 'like', rotationVector);

        if needJacobian
            dRdr = [0 0 0; ...
                    0 0 1; ...
                    0 -1 0; ...
                    0 0 -1; ...
                    0 0 0; ...
                    1 0 0; ...
                    0 1 0; ...
                    -1 0 0; ...
                    0 0 0];
            dRdr = cast(dRdr, 'like', rotationVector);
        end

        return;
    end

    u = rotationVector./ theta;
    u = u(:);
    w1 = u(1);
    w2 = u(2);
    w3 = u(3);

    A = [0, -w3, w2; ...
            w3, 0, -w1; ...
            -w2, w1, 0];

    B = u * u';

    alpha = cos(theta);
    beta = sin(theta);
    gamma = 1 - alpha;

    rotationMatrix = eye(3, 'like', rotationVector) * alpha + beta * A + gamma * B;

    if needJacobian
        I = eye(3, 'like', rotationVector);

        % m3 = [rotationVector,theta], theta = |rotationVector|
        dm3dr = [I; u']; % 4x3

        % m2 = [u;theta]
        dm2dm3 = [I./theta -rotationVector./theta^2; ...
                zeros(1, 3, 'like', rotationVector) 1]; % 4x4

        % m1 = [alpha;beta;gamma;A;B];
        dm1dm2 = zeros(21, 4, 'like', rotationVector);
        dm1dm2(1, 4) = -beta;
        dm1dm2(2, 4) = alpha;
        dm1dm2(3, 4) = beta;
        dm1dm2(4:12, 1:3) = [0 0 0 0 0 1 0 -1 0; ...
                            0 0 -1 0 0 0 1 0 0; ...
                            0 1 0 -1 0 0 0 0 0]';

        dm1dm2(13:21, 1) = [2 * w1, w2, w3, w2, 0, 0, w3, 0, 0];
        dm1dm2(13:21, 2) = [0, w1, 0, w1, 2 * w2, w3, 0, w3, 0];
        dm1dm2(13:21, 3) = [0, 0, w1, 0, 0, w2, w1, w2, 2 * w3];

        dRdm1 = zeros(9, 21, 'like', rotationVector);
        dRdm1([1 5 9], 1) = 1;
        dRdm1(:, 2) = A(:);
        dRdm1(:, 3) = B(:);
        dRdm1(:, 4:12) = beta * eye(9, 'like', rotationVector);
        dRdm1(:, 13:21) = gamma * eye(9, 'like', rotationVector);

        dRdr = dRdm1 * dm1dm2 * dm2dm3 * dm3dr;
    end
    % this jacobian is column first
