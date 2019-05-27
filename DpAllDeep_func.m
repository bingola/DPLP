function[]=DpAllDeep_func(network_dataset,Metric,K,e,f,seedOrNot,saveOption)
       netV={'USAir','Celegans','Ecoli','Yeast','facebook','Power', 'NS','PB'};
        i=  strcmp(netV,network_dataset);
        MetricV={'nodetovec','structtovec','PRUNE','line'};
        MI=find(strcmp(MetricV,Metric));
        
             
       if seedOrNot==0
          seed=randi([0 1000]);
       else
           load SeedForDeep 
           eval(['seed=SeedSet.',network_dataset,'.seed(',num2str(MI),');'])
       end
       
       rng(seed);
       seedV=randi([0 1000],1,10);
        
        
        
         ev=[0.001 0.01 0.1 1];
         eI=find(ev==e);
        XXV{1}={'Z','X','Z','W'};
        XXV{2}={'Z','Z','Z','Z'};
        XXV{3}={'X','Z','Z','Z'};
        XXV{4}={'X','X','W','Z'};
        
        XXV{5}={'X','W','X','Z'};
        XXV{6}={'Z','W','X','Z'};
        XXV{7}={'Z','W','W','X'};
        XXV{8}={'Y','Y','Y','Y'};
         mapValDPLR=0;    
         mapValLaplacian=0;
         mapValGaussian=0;
         mapValExponential=0;
        Del=5;

        datapath=configFile(1);
        Fname=strcat(datapath,network_dataset,'_WithScoreNonDP_Deep', num2str(f)); 

        load(Fname);
        ths=0;
        A=graphWithScoreNonDP.adj_mat;
        As=graphWithScoreNonDP.Asample;
        qlist=graphWithScoreNonDP.qlistX;
        N=graphWithScoreNonDP.N;
        lamb=N*Del/e;
        expLamb=K*N*Del/e;
        ddel=1e-12;
        stdv=2*log(1.25/ddel)*N*Del/e;
        PotEdgeV=graphWithScoreNonDP.GoldListX;
        GoldLabel=graphWithScoreNonDP.GoldLabelX;
        Score=graphWithScoreNonDP.Score;
        Xval=XXV{i}{MI};
         eval(['score=Score.Score',Xval,'.',Metric,';']);
 
        
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DPLR%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
      for instance=1:10
        upd=0;
        for l=1:length(qlist)
                s=score{l};
                sigma=e/(2*K*log(1+Del));
                PotEdge=PotEdgeV{l}(s>0);
                LL=GoldLabel{l}(s>0);
                s=s(s>0);
                good=0;
                clear trueLabel recDPLR

                KEffective=min(length(PotEdge)-1,K);
                Dummy=zeros(KEffective,1);
                trueLabel=Dummy;
                scoreSampled=Dummy;
                   vcc = RandStream('mlfg6331_64','Seed',seedV(instance)); 
                    for jj=1:KEffective
                      samp_node_id=randsample(vcc,length(PotEdge),1,true,(s+Del+1).^sigma);
                      trueLabel(jj)=LL(samp_node_id);
                      scoreSampled(jj)=s(samp_node_id);
                      s(samp_node_id)=[];
                      PotEdge(samp_node_id)=[];
                      LL(samp_node_id)=[];
                    end
                    if sum(trueLabel)>ths
                      upd=upd+1;   
                      mapValDPLR(upd)=ComputeAcc('AvePrecision', trueLabel,KEffective);
                    end
          end  
         
           MDPLR(instance)=mean(mapValDPLR); 
       end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Laplacian%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
   
%             
       for instance=1:10
        upd=0;
        for l=1:length(qlist)
            s=score{l};
            sigma=e/(2*K*log(1+Del));
            PotEdge=PotEdgeV{l}(s>0);
            LL=GoldLabel{l}(s>0);
            s=s(s>0);
            good=0;
            clear trueLabel recDPLR
            sx=s;
            KEffective=min(length(PotEdge)-1,K);
            Dummy=zeros(KEffective,1);
            seed=seedV(instance);
            df=laplace_rand(seed,0,1/lamb,1,length(sx));
            
            s=sx+df;
            [scoreSampled,sampVec]=sort(s,'descend');
            trueLabel=LL(sampVec);
            scoreSampled=scoreSampled(1:KEffective);
            trueLabel=trueLabel(1:KEffective);

            if sum(trueLabel)>ths
              upd=upd+1;   
              mapValLaplacian(upd)=ComputeAcc('AvePrecision', trueLabel,KEffective);
            end

        end

           MLaplacian(instance)=mean(mapValLaplacian); 
 
       end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Gaussian%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      for instance=1:10
        upd=0;
        for l=1:length(qlist)
            s=score{l};
            sigma=e/(2*K*log(1+Del));
            PotEdge=PotEdgeV{l}(s>0);
            LL=GoldLabel{l}(s>0);
            s=s(s>0);
            good=0;
            clear trueLabel recDPLR
            sx=s;
            KEffective=min(length(PotEdge)-1,K);
            Dummy=zeros(KEffective,1);
            
            rng(seedV(instance));
            s=sx+normrnd(0,stdv,1,length(sx));
            
            [scoreSampled,sampVec]=sort(s,'descend');
            trueLabel=LL(sampVec);
            scoreSampled=scoreSampled(1:KEffective);
            trueLabel=trueLabel(1:KEffective);
            if sum(trueLabel)>ths
              upd=upd+1;   
              mapValGaussian(upd)=ComputeAcc('AvePrecision', trueLabel,KEffective);
             end

        end

       MGaussian(instance)=mean(mapValGaussian); 
 
     end 

       
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exponential%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
      for instance=1:10
        upd=0;
        for l=1:length(qlist)
            s=score{l};
            sigma=e/(2*K*log(1+Del));
            PotEdge=PotEdgeV{l}(s>0);
            LL=GoldLabel{l}(s>0);
            s=s(s>0);
            good=0;
            clear trueLabel  
            KEffective=min(length(PotEdge)-1,K);
            Dummy=zeros(KEffective,1);
            trueLabel=Dummy;
            scoreSampled=Dummy;
            
            for jj=1:KEffective
              vcc = RandStream('mlfg6331_64','Seed',seedV(instance));   
              samp_node_id=randsample(vcc,length(PotEdge),1,true,exp(s/expLamb));
              trueLabel(jj)=LL(samp_node_id);
              scoreSampled(jj)=s(samp_node_id);
              s(samp_node_id)=[];
              PotEdge(samp_node_id)=[];
              LL(samp_node_id)=[];
            end
           
             if sum(trueLabel)>ths
              upd=upd+1;   
              mapValExponential(upd)=ComputeAcc('AvePrecision', trueLabel,KEffective);
             end
            
        end
       MExponential(instance)=mean(mapValExponential); 
       end
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Result %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
        strcat(network_dataset,' ', Metric)
       meanVal=[e mean(MDPLR) mean(MLaplacian) mean(MGaussian) mean(MExponential)]
       StdVal=[e std(MDPLR) std(MLaplacian) std(MGaussian) std(MExponential)]


 
       if saveOption==1

           result.mapValDPLR=mapValDPLR;    
           result.mapValLaplacian=mapValLaplacian;
           result.mapValGaussian=mapValGaussian;
           result.mapValExponential=mapValExponential;




           result.MDPLR=MDPLR;    
           result.MLaplacian=MLaplacian;
           result.MGaussian=MGaussian;
           result.MExponential=MExponential;
           result.seedV=seedV;
           result.XXV=Xval;
           result.Xval=XXV;
           result.Delta=Del;
           result.epsilon=e;
           Fname=strcat(datapath,network_dataset,'_result_fIs_', num2str(f),...
            '_eIs_',num2str(eI),'_kIs_',num2str(K),'_DeepFinalVV',Metric); 
           eval(['save -v7.3 ',Fname,' result']);
       end
    
end
 
