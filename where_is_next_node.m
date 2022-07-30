function link = where_is_next_node(alpha,eta,pheromon,rout)
    last_node = rout(length(rout));
    pheromon_path = pheromon(last_node,:);
    eta_path = eta(last_node,:);
    for i=1:length(rout)
        pheromon_path(rout(i)) = 0;
    end
    for i=1:length(rout)
        eta_path(rout(i)) = 0;
    end
    link = 101;
    if sum(pheromon_path)==0
        link = 0;
    end
    pheromon_path = alpha*pheromon_path + (1-alpha)*eta_path;
    pheromon_path = pheromon_path/sum(pheromon_path);
    if link ==101
        link = roulette_wheel(pheromon_path);
    end
end