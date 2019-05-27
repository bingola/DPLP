function varargout = ComputeAcc(varargin)
   [varargout{1:nargout}] = feval(varargin{:});
end

function [x]=AvePrecision(label,k)
    
    if length(label)>k
     label=label(1:k);
    end
     
    tt=length(label);
    x=0;
    for i=1:tt
        x=x+sum(label(1:i))*label(i)/i;
    end
    x=x/(sum(label)+1e-5);
end



function [auc]=AUC(score,label,k)
    
    if length(label)>k
     label=label(1:k);
     score=score(1:k);
    end
     
    tt=length(label);
    auc=0;
    numpair=0;
    if sum(label)==length(label)
        auc=1;
     
    else
    for i=1:tt
       for j=i+1:tt
           if (label(i)+label(j)==1) 
% %                label(i) 
% %                label(j)
               numpair=numpair+1;
                  if ((score(i)-score(j))*(label(i) -label(j))>0)
                      auc=auc+1;

                  end

                  if ((score(i)-score(j))==0)
                      auc=auc+1/2;
                  end
           
          
           end
        end
    end
    
    auc=auc/numpair;
    end
end
 