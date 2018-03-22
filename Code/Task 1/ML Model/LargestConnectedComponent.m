function nodeIDs=LargestConnectedComponent(G)
%{ 
  Author: Kostia Zuev
  Date: 04/11/17
  - G, network (e.g. US powergrid)
  - nodeIDs, list of nodes that belong to the largest connected component
%}
bins=conncomp(G);
M=max(bins);     % number of connected components
n=zeros(1,M);    
for i=1:M
    n(i)=sum(bins==i); %number of nodes in the ith component
end
[N,j]=max(n);    % j is the number of the largest component
                 % N is the number of nodes in the largest component
nodeIDs=1:length(bins); 
nodeIDs=nodeIDs(bins==j);