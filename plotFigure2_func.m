function[]=plotFigure2_func(Metric)


MetricV={'CN','AA','JC','nodetovec','structtovec','PRUNE','line'};
mID=find(strcmp(MetricV,Metric));
% ii=3;
    % % % %  netV={'USAir','Celegans','Yeast','facebook','NS'};

             network_dataset='Yeast';
             datapath=configFile(1);

             Fname=strcat(datapath,network_dataset,'_XPriv_NonDeep'); 
             method=mID;
            if mID>3
                method=mID-3;
                Fname=strcat(datapath,network_dataset,'_XPriv_Deep'); 
            end
            load(Fname)
 %            numberOfRandomization=10
            meanval(1,:)=privVsMap.map(method,:);
            stdval(1,:)=privVsMap.stdmap(method,:);
 
            meanval(2,:)=privVsMap.mapl(method,:);
            stdval(2,:)=privVsMap.stdmapl(method,:);
            
            
            meanval(3,:)=privVsMap.mapg(method,:);
            stdval(3,:)=privVsMap.stdmapg(method,:);
            
            
            meanval(4,:)=privVsMap.mape(method,:);
            stdval(4,:)=privVsMap.stdmape(method,:);
 
            color =[0 0 0; 1 0 0; 0 0 1; 0 1 0];

            lw=6;
            ev=[0.001 0.01 0.1 1 ];
            xl=1:length(ev);
            %xl=1:4 means index of ev
 for  baseline=1:4
 errorbar(1:4,meanval(baseline,1:4), stdval(baseline,1:4),['-' 'd'],'Color', color(baseline,:),'LineWidth',3)
  hold on;
 end
end