function [path,new_energies] = energy_consume(alpha,eta,pheromon,E_RX,E_TX,np,source_index,sink_index,neighbour_node)
    path = [];
    ns = 0;
    energies = zeros(100,1);
    while ns<np
        cost = 0;
        impas = 0;
        finish = 0;
        rout = source_index;
        while finish==0
            last_node = rout(length(rout));
            for i=1:length(neighbour_node)
                if last_node == neighbour_node(i)
                    rout = [rout,sink_index];
                    finish = 1;
                    break;
                end
            end
            if finish==1
                break;
            end
            link = where_is_next_node(alpha,eta,pheromon,rout);
            rout = [rout,link];
            last_node = rout(length(rout));
            if last_node==0 || last_node==101
                impas = 1;
                break
            end
        end
        if impas == 1
            continue
        end
        for k=1:length(rout)
            if k==1
                energies(rout(k)) = energies(rout(k)) + E_TX(rout(1),rout(2));
                cost = cost + E_TX(rout(1),rout(2));
            elseif k==length(rout)
                energies(rout(k)) = energies(rout(k)) + E_RX;
                cost = cost + E_RX;
            else
                energies(rout(k)) = energies(rout(k)) + E_TX(rout(k),rout(k+1)) + E_RX;
                cost = cost + E_TX(rout(k),rout(k+1)) + E_RX;
            end
        end
        path = [path,rout];
        ns = ns+1;
    end
    new_energies = energies;
end