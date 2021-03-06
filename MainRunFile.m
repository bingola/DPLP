% MainFile
clc
clear
%Tested on MATLAB2017b
%{'nodetovec','structtovec','PRUNE','line'} are the Deep Embedding based LP
%{'CN','AA','JC','CRW'} are Triad Based LPs;
%%network_dataset={'USAir','Celegans','Yeast','facebook','NS','PB','Power','Ecoli'};

network_dataset='USAir';
 
%%%%%%%Store the graph and select the query nodes%%%
%%preprocess_networks_func(network_dataset)


%%%%%Sample_Graph with 85% neighbor and non-neighbor per query
frac=85;
f=100-frac;
%SampleGraph_func(f,network_dataset); 

% % preprocess_networks_func and  SampleGraph_func are not needed to run
% % since we have provided the sampled graphs in the dataset. 
% % Once you run, it will create a different sampled graph

%%%%%Compute NON-DP Score from NonDeep/Triad-Based Heuristics {'CN','AA','JC','CRW'}
ComputeScoresNonDeep_func(f,network_dataset);

%%%%%Compute NON-DP Score from NonDeep/Triad-Based Heuristics {'nodetovec','structtovec','PRUNE','line'}
%%%% Takes embeddings stored in EmbeddingFile/ . These files are output of
%%%% different Graph embedding technqiues that are already available in github
%%% We could not include those package for space-issues. But, they are uploaded with respective hyperparam values
%%% in dropbox link "rebrand.ly/dplp".  The hyperparams are also mentioned the in the paper. 

% % % ComputeScoresDeep_func(f,network_dataset)

%%%Run DPLP and baselines

%%top-K recommendation
 K=10;

%%%e=epslion_p=[0.001,0.01,0.1,1];
e=0.1;

% saveOption=1, means it will save the data, else you will just see the the output.
saveOption=0;

%%% the display of the following DpAllTriad_func and DpAllDeep_func would be of the form:
% meanVal=[e mena(dplp) mean(lapl) mean(gauss) mean(exp)] and similiarly
% Std. Deviation. For example:
% meanVal =
% 
%     0.1000    0.3210    0.2875    0.2368    0.2824
% 
% 
% StdVal =
% 
%     0.1000    0.0979    0.0565    0.0837    0.0787


IfSeed=1; %set seed to get the results in the paper.

Metric='CN'; %%%one from 'CN','AA','JC','CRW'

DpAllTriad_func(network_dataset,Metric,K,e,f,IfSeed,saveOption)

Metric='nodetovec'; %%one from 'nodetovec','structtovec','PRUNE','line'
DpAllDeep_func(network_dataset,Metric,K,e,f,IfSeed,saveOption)

%%%%%% CAUTION: % Run CreatePrivacyVsMAP _ONLY_AFTER_SAVING_ALL_REULTS_FOR_ALL_DATASETS_AND
%%%%%% ALL_ALGO else will show show error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%run CreatePrivacyVsMAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now generate table 1 using stored final data (provided already).

% for deep LP: set deep=1
deep=1;
GenerateTable(deep,'table_deep.txt');

% for triad-based LP: set deep=0
deep=0;
GenerateTable(deep,'table_triad.txt');

% Plot Figure1 and Figure 2
plotFigure1_func(network_dataset)
figure;

plotFigure2_func(Metric)







