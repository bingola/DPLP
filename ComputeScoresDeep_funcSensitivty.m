function[]=ComputeScoresDeep_funcSensitivty(f,perturbFrac,network_dataset)
    MetricV={'nodetovec','structtovec','PRUNE'};

    DIM=5;
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_sampled', ...
        num2str(f),'_Perturbed_', num2str(perturbFrac), '_Instance_',num2str(instance)); 
    load(Fname)
        
    A=graphSampled.adj_mat;
    As=graphSampled.Asample;
    N=graphSampled.N;
    qlist=graphSampled.qlist;
    PotEdgeV=graphSampled.GoldList;
    GoldLabel=graphSampled.GoldLabel;
    if  N>800
        qlist=qlist(1:300);
        PotEdgeV=graphSampled.GoldList(1:300);
        GoldLabel=graphSampled.GoldLabel(1:300);
    end
    
    
  
             for l=1:max(size(qlist))
                 PotEdge=PotEdgeV{l};
                for y=1:length(PotEdge)
                  Nxy=As(qlist(l),:).*As(PotEdge(y),:);
                 scoredd{l}(y)=sign(sum(Nxy));
                end
             end

    for MM=MetricV
            Metric=MM{1};
            TT=strcat('EmbeddingFileSensitivity/',network_dataset,Metric,'_Embedding15','_Perturbed_',num2str(perturbFrac), '_Instance_',num2str(instance),'.txt'); 
            embed=dlmread(TT);
            embedx=zeros(graphSampled.N,DIM);
            if (strcmp(Metric,'nodetovec'))|| (strcmp(Metric,'structtovec')) || (strcmp(Metric,'line'))
                embed(1,:)=[];
                for k=1:size(embed,1)
                embedx(embed(k,1),:)=embed(k,2:end);
                end
            end


            if (strcmp(Metric,'PRUNE'))
               embed(1,:)=[]; 
               embedx=embed;
            end

       

        score=zeros(length(qlist)*N,DIM);   
         v=0;
        for i=1:length(qlist)
            for j=1:N
                v=v+1;
                a= embedx(qlist(i),:).*embedx(j,:);
                score(v,:)=a;
            end
        end
        Label=A(qlist,:);
        training_label_vector=reshape(Label',[],1);
        training_instance_matrix=score;
        
        model = train(training_label_vector, ...
            sparse(training_instance_matrix),'-s 2');
        score_1=(embedx.*repmat(model.w,N,1))*embedx';
        scoreq=score_1(qlist,:);
        scoreqx=1./(1+exp(-scoreq));
        

        %%Different monontonic function
        for ll=1:length(qlist)
         scorev{ll}=scoreqx(ll,graphSampled.GoldList{ll}).*scoredd{ll};
         scorevPure{ll}=scoreqx(ll,graphSampled.GoldList{ll});
         scorevSS{ll}=scoreq(ll,graphSampled.GoldList{ll});
         scorevSWS{ll}=scoreq(ll,graphSampled.GoldList{ll}).*scoredd{ll};
        end
        
        eval(['Score.ScoreX.',Metric,'=scorev;']);
        eval(['Score.ScoreY.',Metric,'=scorevPure;']);
        eval(['Score.ScoreZ.',Metric,'=scorevSS;']);
        eval(['Score.ScoreW.',Metric,'=scorevSWS;']);

    end
 
    
    graphWithScoreNonDP=graphSampled;    
    graphWithScoreNonDP.Score=Score;
    graphWithScoreNonDP.qlistX=qlist;
    graphWithScoreNonDP.GoldListX=PotEdgeV;
    graphWithScoreNonDP.GoldLabelX=GoldLabel;
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_WithScoreNonDP_Deep', num2str(f),'_Perturbed_', num2str(perturbFrac), '_Instance_',num2str(instance)); 
    eval(['save -v7.3 ',Fname,' graphWithScoreNonDP']);
end
 
