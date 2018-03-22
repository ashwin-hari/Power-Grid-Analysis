function [D,DD]=Damage(G,alpha)
%{ 
  Author: Kostia Zuev
  Date: 04/04/17
  Computes D and DD for each node (considered as an initial trigger) 
  using the Motter-Lai Model implemented in MLmodel.m
  - G, network (e.g. US powergrid)
  - alpha, tolerance parameter (e.g. 0.1, 0.5, 1)
  - D and DD are damage measures defined in the Notes
%}
%---------- Load data -------------------------
% load('uspowergrid');                                                  
% G = graph(uspowergrid(:,1), uspowergrid(:,2));
%-----------------------------------------------
N= numnodes(G);  % network size
D=NaN(N,1); 
DD=NaN(N,1);
parfor i=1:N
    [D(i), DD(i)] = MLmodel(G, alpha, i);
end
