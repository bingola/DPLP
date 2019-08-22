function[]=preprocess_networks_func_sensitivity(network_dataset,perturbFrac)
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
    fx=0;
    for id=1:N
        u1=find(1-A(id,:));
        u=find(A(id,:));
        if fx==0
         v_ne=randsample(u1,floor(perturbFrac*length(u)/100));
         fx=1;
        else 
         v_ne=randsample(u1,ceil(perturbFrac*length(u)/100));
         fx=0;
        end
        A(id,v_ne)=1;
    end
    
    
    listOfEdgeNonEdge=A(qlist,:);
    graphData.adj_mat=A;
    graphData.N=N;
    graphData.qlist=qlist;
    graphData.edgeNonedgelist=listOfEdgeNonEdge;
    Fname=strcat(outpath,network_dataset,'_Perturbed_', num2str(perturbFrac)); 

 
   eval(['save -v7.3 ',Fname,' graphData']);
    

end