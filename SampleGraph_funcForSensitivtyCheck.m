
function[]=SampleGraph_funcForSensitivtyCheck(f,perturbFrac,network_dataset)
%     network_dataset=netV{i};
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_Perturbed_', num2str(perturbFrac)); 
    load(Fname);
    
    A=graphData.adj_mat;
    N=graphData.N;
    qlist=graphData.qlist;
    loe=graphData.edgeNonedgelist;
    
    Asample=A;
    
    GoldList{length(qlist)}=[];
    
    for id=1:length(qlist)
        u=find(loe(id,:));
        u1=find(1-loe(id,:));
        v_e=randsample(u,floor(f*length(u)/100));
        v_ne=randsample(u1,floor(f*length(u1)/100));

        potential_edge=sort([v_e v_ne]);
        GoldList{id}=potential_edge;
        GoldLabel{id}=A(qlist(id),potential_edge);
        Asample(qlist(id),v_e)=0;

    end
    
    graphSampled=graphData;
    graphSampled.GoldList=GoldList;
    graphSampled.GoldLabel=GoldLabel;
    graphSampled.Asample=Asample;
    
    
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_sampled', num2str(f),'_Perturbed_', num2str(perturbFrac)); 
    eval(['save -v7.3 ',Fname,' graphSampled']);
    
end