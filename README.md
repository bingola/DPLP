
## Mainfile

The file is self explanatory

```
 MainRunFile.m 
```


## Generate Query Set Q

Compute the query set that contains atleast one triangle

```
preprocess_networks_func('dataset')
```


## Sample graphs

Sample (100-f) percent of the neighbors and non-neighbors of each query in Q.
f=15 means, 85% neighbors and non-neighbors per query will be used for training.

```
 SampleGraph_func(f,'dataset')
```


## Compute scores

For all triad based LP algos--- 'CN', 'AA', 'JC', 'CRW'

```
ComputeScoresNonDeep_func(f,'dataset')
```

For all embedding based LP algos--- 'node2vec', 'struct2vec', 'PRUNE', 'line'

```
ComputeScoresNonDeep_func(f,'dataset')
```


## Execute differentially private algorithms (DPLP, Lapl., Gauss., and Exp.)

For triad based LP algorithms.

```
DpAllTriad_func('dataset',Metric,K,e,f,IfSeed,saveOption)

--- Metric: LP algorithm e.g. 'CN', 'AA', etc.
--- K: the number of recommended nodes, default: K=10.
--- e: epsilon_p the maximum privacy leakage in a epslion_p D.P. algorithm.
--- f: as defined above, used only to specifiy a file.
--- IfSeed: 1 if you re-use the seed which was used to generate the results in the paper.
--- saveOption: 1 if you want to save data in a file. 
```


For deep embedding based algorithms 

```
DpAllDeep_func('dataset',Metric, K, e,f,IfSeed, saveOption) 

--- Metric:'nodetovec','structtovec','PRUNE','line'.
```


