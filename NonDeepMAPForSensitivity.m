function[result]=NonDeepMAPForSensitivity(network_dataset,Metric,K,f,perturbFrac)
% % 
% % netV={'USAir','Celegans','Yeast','facebook','NS','PB','Power','Ecoli'};
% % i=find(netV==network_dataset); 
        datapath=configFile(1);
        Fname=strcat(datapath,network_dataset,'_WithScoreNonDP', num2str(f),'_Perturbed_', num2str(perturbFrac)); 
        load(Fname);
        N=graphWithScoreNonDP.N;
        ths=0;
        
        if length(graphWithScoreNonDP.qlist)>300
          Mx=300;
        else
          Mx=length(graphWithScoreNonDP.qlist);
        end
          qlist=graphWithScoreNonDP.qlist(1:Mx);

        PotEdgeV=graphWithScoreNonDP.GoldList(1:Mx);
        GoldLabel=graphWithScoreNonDP.GoldLabel(1:Mx);
        Score=graphWithScoreNonDP.Score;

        eval(['score=Score.',Metric,'(1:Mx);']);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DPLR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Laplacian%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
        upd=0;
        for l=1:length(qlist)
            s=score{l};
            
            PotEdge=PotEdgeV{l}(s>0);
            LL=GoldLabel{l}(s>0);
            %
            s=s(s>0);
            clear trueLabel
            sx=s;
            KEffective=min(length(PotEdge)-1,K);
            s=sx;
            [~,sampVec]=sort(s,'descend');
            trueLabel=LL(sampVec);
            trueLabel=trueLabel(1:KEffective);

%             if sum(trueLabel)>ths
              upd=upd+1;   
              Avgpr(upd)=ComputeAcc('AvePrecision', trueLabel,KEffective);
%             end

        end

           mapval=mean(Avgpr); 

           result.Avgpr=Avgpr;
           result.map=mapval;
           Fname=strcat(datapath,network_dataset,'_result_fIs_', num2str(f),...
            '_Perturbed_', num2str(perturbFrac),'_kIs_',num2str(K),'_XNonDeepFinalVV',Metric); 
           eval(['save -v7.3 ',Fname,' result']);
end
