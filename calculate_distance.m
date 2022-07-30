function distance = calculate_distance(nods,Communication_radius)
    distance = zeros(100,100);
    for i=1:100
        for j=1:100
            if norm(nods(i,:)-nods(j,:))<Communication_radius
                distance(i,j) = norm(nods(i,:)-nods(j,:));
            else
                distance(i,j) = Inf;
            end
        end
    end
end
            
