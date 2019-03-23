function plotSkeleton(joints,E)
%PLOTSKELETON Summary of this function goes here
    nE = size(E,2) - 1;
    E = E';
    Xt = reshape(joints,nE+1,3)';
    hold on;
    color = ['g','r','k','g','r','k','g','r','k','g','r','k','g','r','k','g','r','g','r','g','r','g','r'];
    for ie = 2:nE + 1
        plot3(Xt(1,E(ie,:)),Xt(2,E(ie,:)),Xt(3,E(ie,:)),color(ie-1),...
            'LineWidth',2)
    end


end

