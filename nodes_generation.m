function [nods,energies] = nodes_generation(~)
    nods = zeros(100,2);
    for i=0:9
        for j=0:9
            nods(10*i+j+1,1) = 110*rand + 110*i;
            nods(10*i+j+1,2) = 110*rand + 110*j;
        end
    end
    energies = 10*randi([1,3],100,1);
end