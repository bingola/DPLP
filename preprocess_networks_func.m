function[]=preprocess_networks_func(network_dataset)
   %%%%%%%%%%%%%%generate networks%%%%%%%%%%%%%%%
    datapath=configFile(0);
    netdata=strcat(datapath,network_dataset);

    outpath=configFile(1);
    Fname=strcat(outpath,network_dataset);
    
    load(netdata);

    A=full(net);
    N=size(A,1);
    % count the number of triangles around all nodes i, i.e. 
    Ax=diag(A^3);
    [triangles,perm]=sort(Ax,'descend');
    qlist=perm(triangles>0);
    
    listOfEdgeNonEdge=A(qlist,:);

    graphData.adj_mat=A;
    graphData.N=N;
    graphData.qlist=qlist;
    graphData.edgeNonedgelist=listOfEdgeNonEdge;
    
 
   eval(['save -v7.3 ',Fname,' graphData']);
    

end