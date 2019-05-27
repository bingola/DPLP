clc
clear all
f=15;
 netV={'USAir','Celegans','Yeast','facebook','NS'};
ev=[0.001 0.01 0.1 1];
deep=0;
MetricV={'nodetovec','structtovec','PRUNE','line'};
if deep==0
    MetricV={'CN','AA','JC','CRW'};
end
for i=1:length(netV)
        clearvars -except f netV i e ev K Kv Metric eI kI MetricV fileID lx deep
    for eI=1:4
        e=ev(eI);
        lx=0;
      for Metric=MetricV
            lx=lx+1;
            network_dataset=netV{i};
            datapath=configFile(1);
            K=10;

           
                 Fname=strcat(datapath,network_dataset,'_result_fIs_', num2str(f),...
                     '_eIs_',num2str(eI),'_kIs_',num2str(K),'_DeepFinalVV',Metric{1}); 

              if deep==0    
                Fname=strcat(datapath,network_dataset,'_result_fIs_', num2str(f),...
                      '_eIs_',num2str(eI),'_kIs_',num2str(K),'_XNonDeepFinalVV',Metric{1}); 
              end

                load(Fname)


                map(lx,eI)=mean(result.MDPLR);
                stdmap(lx,eI)=std(result.MDPLR);

                mapl(lx,eI)=mean(result.MLaplacian);
                stdmapl(lx,eI)=std(result.MLaplacian);

                mapg(lx,eI)=mean(result.MGaussian);
                stdmapg(lx,eI)=std(result.MGaussian);

                mape(lx,eI)=mean(result.MExponential);
                stdmape(lx,eI)=std(result.MExponential);


                privVsMap.map=map;
                privVsMap.stdmap=stdmap;

                privVsMap.mapg=mapg;
                privVsMap.stdmapg=stdmapg;


                privVsMap.mapl=mapl;
                privVsMap.stdmapl=stdmapl;


                privVsMap.mape=mape;
                privVsMap.stdmape=stdmape;

            
            
 
       end
%           
                Fname=strcat(datapath,network_dataset,'_XPriv_Deep'); 
                
                if deep==0
                  Fname=strcat(datapath,network_dataset,'_XPriv_NonDeep'); 
                end

                eval(['save -v7.3 ',Fname,' privVsMap']);
        
        
    end
end

