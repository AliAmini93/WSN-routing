function neighbour_node = neighbour_finding(sink_index,distance)
    neighbour_node = [];
    count = 0;
    for i=1:100
        if distance(sink_index,i)<150 && distance(sink_index,i)>0
            count = count + 1;
            neighbour_node(count) = i;
        end
    end
end
            