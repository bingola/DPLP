% MainFile
clc
clear all
%Tested on MATLAB2017b
%{'nodetovec','structtovec','PRUNE','line'} are the Deep Embedding based LP
%{'CN','AA','JC','CRW'} are Triad Based LPs;
%%network_dataset={'USAir','Celegans','Yeast','facebook','NS','PB','Power','Ecoli'};

network_dataset='Yeast';
 
%%%%%%%Store the graph and select the query nodes%%%
%%preprocess_networks_func(network_dataset)


%%%%%Sample_Graph with 85% neighbor and non-neighbor per query
frac=85;
f=100-frac;
%SampleGraph_func(f,network_dataset); 

 for perturbFrac=[5 10 15 20 25 30 35 40 45]
 for instance=1:5
%    preprocess_networks_func_sensitivity(network_dataset,perturbFrac,instance)
%    SampleGraph_funcForSensitivtyCheck(f,perturbFrac,instance,network_dataset)
%   ComputeScoresNonDeep_funcForSensitivityCheck(f,perturbFrac,instance,network_dataset)
 end
end
%%


% % preprocess_networks_func and  SampleGraph_func are not needed to run
% % since we have provided the sampled graphs in the dataset. 
% % Once you run, it will create a different sampled graph

%%%%%Compute NON-DP Score from NonDeep/Triad-Based Heuristics {'CN','AA','JC','CRW'}
% for perturbFrac=[5 10 15 20 25 30 35 40 45]
% ComputeScoresNonDeep_funcForSensitivityCheck(f,perturbFrac,network_dataset);
% end


% for perturbFrac=[5 10 15 20 25 30 35 40 45]
% ComputeScoresDeep_funcSensitivty(f,perturbFrac,network_dataset);
% end

% % 
% K=10;
% Metric={'CN','AA','JC'};
% p=0;
% for perturbFrac=[5 10 15 20 25 30 35 40 45]
%     p=p+1;
%     l=0;
% for metric=Metric 
%     l=l+1;
%  result=NonDeepMAPForSensitivity(network_dataset,metric{1},K,f,perturbFrac);
%  nmapv(l,p)=result.map;
% end
% end
% 
% Metric={'nodetovec','structtovec','PRUNE'};
% p=0;
% for perturbFrac=[5 10 15 20 25 30 35 40 45]
%     p=p+1;
%     l=0;
% for metric=Metric    
%     l=l+1;
%  result=DeepMAPForSensitivity(network_dataset,metric{1},K,f,perturbFrac);
%  mapv(l,p)=result.map;
% end
% end

% load nmapv
% load mapv
%%
% nn=nmapv';
% dd=mapv';
% 
% % dds=dd-repmat(dd(1,:),[9,3]);
% % nns=nn-[nn(1,:);nn(1:end-1,:)];
% 
% for i=1:3
% 
% 
% 
% dd(:,i)=(dd(:,i)-[dd(1,i);dd(1:end-1,i)]);
% nn(:,i)=(nn(:,i)-[nn(1,i);nn(1:end-1,i)]);
% 
% dd(:,i)=movmean(dd(:,i),5);
% nn(:,i)=movmean(nn(:,i),5);
% 
% end
% close all
% plot(abs(dd));
% figure;
% plot(abs(nn));
% close all
% plot(dd(1:2:9,:))
% figure
% plot(nn(1:2:9,:))


%%%%%Compute NON-DP Score from NonDeep/Triad-Based Heuristics {'nodetovec','structtovec','PRUNE','line'}
%%%% Takes embeddings stored in EmbeddingFile/ . These files are output of
%%%% different Graph embedding technqiues that are already available in github
%%% We could not include those package for space-issues. But, they are uploaded with respective hyperparam values
%%% in dropbox link "rebrand.ly/dplp".  The hyperparams are also mentioned the in the paper. 
% flag=0;
% if flag==1
%  K=10;
% 
% e=0.1;
% 
% % saveOption=1, means it will save the data, else you will just see the the output.
% saveOption=0;
% 
% IfSeed=1; %set seed to get the results in the paper.
% 
% Metric='CN'; %%%one from 'CN','AA','JC','CRW'
% 
% DpAllTriad_func(network_dataset,Metric,K,e,f,IfSeed,saveOption)
% 
% Metric='nodetovec'; %%one from 'nodetovec','structtovec','PRUNE','line'
% DpAllDeep_func(network_dataset,Metric,K,e,f,IfSeed,saveOption)
% 
% %%%%%% CAUTION: % Run CreatePrivacyVsMAP _ONLY_AFTER_SAVING_ALL_REULTS_FOR_ALL_DATASETS_AND
% %%%%%% ALL_ALGO else will show show error
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %run CreatePrivacyVsMAP
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Now generate table 1 using stored final data (provided already).
% 
% % for deep LP: set deep=1
% deep=1;
% GenerateTable(deep,'table_deep.txt');
% 
% % for triad-based LP: set deep=0
% deep=0;
% GenerateTable(deep,'table_triad.txt');
% 
% % Plot Figure1 and Figure 2
% plotFigure1_func(network_dataset)
% figure;
% 
% plotFigure2_func(Metric)
% 
% end
% 
% 



