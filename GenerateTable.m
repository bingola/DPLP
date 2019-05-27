% % clc
% % clear 
function GenerateTable(deep,FILENAME)
f=15;
K=10;
eI=3;%indicates e=0.1;
netV={'USAir','Celegans','Yeast','facebook',  'NS','PB','Power','Ecoli'};
 if deep==0
    MetricV={'CN','AA','JC'};
end



if deep==1
    MetricV={'nodetovec','structtovec','PRUNE'};
end
      fileID=fopen(FILENAME,'w');
for i=1:5
      fprintf(fileID, '%s',netV{i} );
             l=0;
          for Metric=MetricV
              
             l=l+1;
             eI=3;%indicates e=0.1;
 
            network_dataset=netV{i};
            datapath=configFile(1);

            Fname=strcat(datapath,network_dataset,'_XPriv_Deep'); 
            
            if deep==0
               Fname=strcat(datapath,network_dataset,'_XPriv_NonDeep'); 
            end

            load(Fname)
            % For deep methods other than Yeast all entries other than privVsMap.mapX(l,3) are 0,
            % since they have not been plotted in the paper.
            %eI=3 corresponds to \epsilon_p=0.1 from the 3rd entry in e=[0.001 0.01 0.1 1]
            MDPLR=privVsMap.map(l,3);    
            MLaplacian=privVsMap.mapl(l,3);
            MGaussian=privVsMap.mapg(l,3);
            MExponential=privVsMap.mape(l,3);


             fprintf('Now displaying----\n');
             fprintf('%s\n',strcat(network_dataset,'_', Metric{1}));

             resx=[ (MDPLR);  (MLaplacian);   (MGaussian);   (MExponential)];
             fprintf(fileID, '\t& \\textbf{ %0.3f }  \t & \t  %0.3f   \t & \t  %0.3f  \t & \t  %0.3f   \t',resx );

             if l==3
                      fprintf(fileID,  'HLINE_LATEX \n');
              end
    
          end
     
end
end
%relplace HLINE_LATEX by \\ \hline in latex table
