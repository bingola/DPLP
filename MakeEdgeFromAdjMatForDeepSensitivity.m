clc
clear all
f=15;
netV={'USAir','Celegans','Ecoli','Yeast','facebook','Power', 'NS','PB'};
MetricV={'nodetovec','deepwalk','line'};

for i=4
    i
    
    clearvars -except f netV i MetricV 
    for perturbFrac=5:5:45
    network_dataset=netV{i};
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_sampled', num2str(f),'_Perturbed_', num2str(perturbFrac)); 

    load(Fname);
    TxtName=strcat('EdgelistForDeepEmbedding/',network_dataset,'_EdgeListX', num2str(f),'_Perturbed_', num2str(perturbFrac),'.txt'); 
    As=graphSampled.Asample;
    [~,E]=Adj2Edg(As);
    dlmwrite(TxtName,E,'Delimiter','\t')
    end
end
