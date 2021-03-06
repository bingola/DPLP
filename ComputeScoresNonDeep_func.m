
function[]=ComputeScoresNonDeep_func(f,network_dataset)
    
% %     network_dataset=netV{i};
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_sampled', num2str(f)); 

    load(Fname);
    
    A=graphSampled.adj_mat;
    As=graphSampled.Asample;
    N=graphSampled.N;
    qlist=graphSampled.qlist;
    
    PotEdgeV=graphSampled.GoldList;
    GoldLabel=graphSampled.GoldLabel;

    %%%%%AA%%%%
    NN=sum(A');

     clear score
    for l=1:max(size(qlist))
        PotEdge=PotEdgeV{l};
        for y=1:length(PotEdge)
         Nxy=As(qlist(l),:).*As(PotEdge(y),:);
         %%%to make sure 0/0 do not give NaN
         score{l}(y)=sum(Nxy./log(NN+0.0005));
        end
    end
    
    Score.AA=score;
    
    %%%%%CN%%%%%
    clear score
     for l=1:max(size(qlist))
         PotEdge=PotEdgeV{l};
        for y=1:length(PotEdge)
          Nxy=As(qlist(l),:).*As(PotEdge(y),:);
         score{l}(y)=sum(Nxy);
        end
    end
    
    Score.CN=score;
    
    
    %%%%%JC%%%%%
    clear score
    for l=1:max(size(qlist))
        PotEdge=PotEdgeV{l};
        for y=1:length(PotEdge)
         Nxy=As(qlist(l),:).*As(PotEdge(y),:);
         score{l}(y)=sum(Nxy)/(sum(As(qlist(l),:)) + sum(As(PotEdge(y),:)) - sum(Nxy) );
        end
    end
    Score.JC=score;
    %%%%%CRW%%%%%
    
    XX=inv(eye(N)-0.01*As);
    clear score
    for l=1:length(qlist)
      score{l}=XX(qlist(l),PotEdgeV{l});
    end
    
    Score.CRW=score;
    
    graphWithScoreNonDP=graphSampled;    
    graphWithScoreNonDP.Score=Score;
    datapath=configFile(1);
    Fname=strcat(datapath,network_dataset,'_WithScoreNonDP', num2str(f)); 
    eval(['save -v7.3 ',Fname,' graphWithScoreNonDP']);
end

