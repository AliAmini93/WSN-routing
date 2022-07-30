clear;
clc;
close all;
tic
load('nods_armin.mat')
load('energies.mat')
o_e = energies; %old_energies
Com_rad = 150; %Communication_radius
distance = calculate_distance(nods,Com_rad);
pheromone = (distance<Inf) ;
for i=1:100
    pheromone(i,i)=0;
end
pheromone_old = pheromone;
etha = 1./distance;
for i=1:100
    etha(i,i)=0;
end
n = 25; %Number of Ants
k = 4098; %Packet Size
rho = 0.1; %Evaporation Rate
E_elec = 50*10^(-9);
E_amp = 0.1*10^(-9);
E_RX = k*E_elec;
E_TX = k*E_elec + E_amp*k*(distance.^2);
E_TX = (k*E_elec + E_amp*k*(distance.^2)).*(E_TX>E_RX);
MaxIt = 10000;
MaximunRound = 2;
Average_Residual_Energy = zeros(MaximunRound,10);
Standard_Deviation_of_Residual_Energy = zeros(MaximunRound,10);
Minimum_Residual_Energy = zeros(MaximunRound,10);
k = 0;
while k<MaximunRound
    pheromone = pheromone_old;
    energies = o_e;
    source_index = randi([1,100]);
    sink_index = randi([1,100]); 
    while source_index==sink_index
            sink_index = randi([1,100]);
    end
    source_nod = nods(source_index,:);
    sink_nod = nods(sink_index,:);
    neighbour_node = neighbour_finding(sink_index,distance);
    for i=1:MaxIt
        alpha = i/MaxIt;
        dlta_pheromone = zeros(100,100);
        for j=1:n
            delta = path_finding(alpha,etha,pheromone,energies,E_RX,E_TX,1,source_index,sink_index,neighbour_node);
            dlta_pheromone = dlta_pheromone + delta;
        end
        pheromone = (1-rho)*pheromone + dlta_pheromone;
    end
    k = k+1;
    for i=3:12
        [~,energy_consumption] = energy_consume(alpha,etha,pheromone,E_RX,E_TX,i*100,source_index,sink_index,neighbour_node);
        Minimum_Residual_Energy(k,i-2) = min(energies - energy_consumption);
        Average_Residual_Energy(k,i-2) = mean(energies - energy_consumption);
        Standard_Deviation_of_Residual_Energy(k,i-2) = std(energies - energy_consumption);
    end
end
Average_Residual_Energy = mean(Average_Residual_Energy);
Standard_Deviation_of_Residual_Energy = mean(Standard_Deviation_of_Residual_Energy);
Minimum_Residual_Energy = mean(Minimum_Residual_Energy);
[path,energy_consumption] = energy_consume(1,etha,pheromone,E_RX,E_TX,1200,source_index,sink_index,neighbour_node);
X=(nods(:,1))';
Y=(nods(:,2))';
X_length=length(X);
hold on
for nn=1:X_length
    x=X(nn);
    y=Y(nn);
    if nn==source_index
        plot(x,y,'bo','LineWidth',5,'MarkerSize',2);
    elseif nn==sink_index
        plot(x,y,'bd','LineWidth',5,'MarkerSize',2);
    else
        plot(x,y,'rx','LineWidth',5,'MarkerSize',3);
    end
end
axis([0 1100 0 1100])
ind = zeros(1,1201);
count = 1;
for i=1:length(path)
    if path(i)==sink_index
        count = count + 1;
        ind(count) = i;
    end
end
for i=1:1200
    p=[];
    q=[];
    pat = path(ind(i)+1:ind(i+1));
    for qq=1:length(pat)
        p(qq) = nods(pat(qq),1);
    end
    for qq=1:length(pat)
        q(qq) = nods(pat(qq),2);
    end
    plot(p,q,'k')
end
ite = 3:12;
ite = 100*ite;
figure(2)
plot(ite,Standard_Deviation_of_Residual_Energy,'r')
xlabel('No of Packs')
ylabel('SD of Res Energy')
figure(3)
plot(ite,Average_Residual_Energy,'b')
xlabel('No of Packs')
ylabel('Avg Res Energy')
figure(4)
plot(ite,Minimum_Residual_Energy,'k')
xlabel('No of Packs')
ylabel('Min Res Energy')
toc