function[result]=DeepMAPForSensitivity(network_dataset,Metric,K,f,perturbFrac)
       netV={'USAir','Celegans','Ecoli','Yeast','facebook','Power', 'NS','PB'};
        i=  strcmp(netV,network_dataset);
        MetricV={'nodetovec','structtovec','PRUNE'};
        MI=find(strcmp(MetricV,Metric));

        XXV{1}={'Z','X','Z','W'};
        XXV{2}={'Z','Z','Z','Z'};
        XXV{3}={'X','Z','Z','Z'};
        XXV{4}={'X','X','W','Z'};
        
        XXV{5}={'X','W','X','Z'};
        XXV{6}={'Z','W','X','Z'};
        XXV{7}={'Z','W','W','X'};
        XXV{8}={'Y','Y','Y','Y'};
        mapValLaplacian=0;

        datapath=configFile(1);
        Fname=strcat(datapath,network_dataset,'_WithScoreNonDP_Deep', num2str(f),'_Perturbed_', num2str(perturbFrac)); 

        load(Fname);
        ths=0;
        A=graphWithScoreNonDP.adj_mat;
        As=graphWithScoreNonDP.Asample;
        qlist=graphWithScoreNonDP.qlistX;
        N=graphWithScoreNonDP.N;
 
 
 
        PotEdgeV=graphWithScoreNonDP.GoldListX;
        GoldLabel=graphWithScoreNonDP.GoldLabelX;
        Score=graphWithScoreNonDP.Score;
        Xval=XXV{i}{MI};
        eval(['score=Score.Score',Xval,'.',Metric,';']);
 
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Laplacian%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   
%             
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
            '_Perturbed_', num2str(perturbFrac),'_kIs_',num2str(K),'_DeepFinalVV',Metric); 
           eval(['save -v7.3 ',Fname,' result']);
   
    
end
 
