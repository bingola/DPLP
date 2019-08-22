clc
clear all
f=5;
netV={'USAir','Celegans','Ecoli','Yeast','facebook','Power', 'NS','PB'};
MetricV={'nodetovec','deepwalk','line'};

for i=1:length(netV)
    i
    
    clearvars -except f netV i MetricV 
    
    network_dataset=netV{i};
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_sampled', num2str(f)); 

    load(Fname);
    TxtName=strcat('output/',network_dataset,'_ElistX', num2str(f),'.txt'); 
%     A=graphSampled.adj_mat;
    As=graphSampled.Asample;
    E=Adj2Edg(As);
    writematrix(E,TxtName,'Delimiter','tab')
    
end
