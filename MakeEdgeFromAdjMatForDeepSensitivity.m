clc
clear all
f=15;
netV={'USAir','Celegans','Ecoli','Yeast','facebook','Power', 'NS','PB'};
MetricV={'nodetovec','deepwalk','line'};

for i=4
    i
    
    clearvars -except f netV i MetricV 
    for perturbFrac=5:5:45
            for instance=1:5
                network_dataset=netV{i};
                datapath=configFile(1);
             Fname=strcat(datapath,network_dataset,'_sampled', num2str(f),'_Perturbed_', num2str(perturbFrac), '_Instance_',num2str(instance)); 

                load(Fname);
                As=graphSampled.Asample;
                [E,Ex]=Adj2Edg(As);
                TxtName=strcat('EdgelistForDeepEmbedding/',network_dataset,'_EdgeList', num2str(f),'_Perturbed_', num2str(perturbFrac), '_Instance_',num2str(instance),'.txt'); 
                dlmwrite(TxtName,E,'Delimiter','\t');
                TxtName=strcat('EdgelistForDeepEmbedding/',network_dataset,'_EdgeListX', num2str(f),'_Perturbed_', num2str(perturbFrac),  '_Instance_',num2str(instance),'.txt'); 
                dlmwrite(TxtName,Ex,'Delimiter','\t');
            end
    end
end
