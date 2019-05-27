function[]=plotFigure1_func(network_dataset)
% netV={'USAir','Celegans','Yeast','facebook','NS'};

            datapath=configFile(1);
            Fname=strcat(datapath,network_dataset,'_XPriv_NonDeep'); 
            load(Fname)
 
            meanval=privVsMap.map;
            stdval=privVsMap.stdmap ;
            
 
             color =[0 0 0; 1 0 0; 0 0 1];

            lw=6;
            ev=[0.001 0.01 0.1 1 ];
            xl=1:length(ev);
            %xl=1:4 means index of ev
             close all
            for  method=1:3
             errorbar(xl,meanval(method,xl), stdval(method,1:4),['-' 'd'],'Color', color(method,:),'LineWidth',3)
              hold on;
            end
end