function link = roulette_wheel(pheromon_path)
    s = 0;
    e = pheromon_path(1);
    r = rand;
    for i=1:100
        if r>s && r<e
            link = i;
            break
        end
        s = e;
        e = e + pheromon_path(i+1);
    end
    