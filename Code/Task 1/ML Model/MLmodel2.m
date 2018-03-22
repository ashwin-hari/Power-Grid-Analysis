%Author: Ashwin Hari
%Date: 03/23/17
%Motter Lai Model Implementation
%Sources:
%   (S.1): https://www.mathworks.com/matlabcentral/fileexchange/
%          30926-largest-component

function D = MLmodel2(G, alpha, vF)
    %I. Variables
    failed = vF;                                                        %Nodes that have failed in the most 
                                                                        %recent iteration. 
                                                                        %Initialized to vF.

    G.Nodes.loads = centrality(G, 'betweenness');                       %Add a loads attribute to graph G. 
                                                                        %Calculated using (1) of Notes; initialized to (1) 
                                                                        %where t = 0.
                                                                                                                    
    G.Nodes.capacities = (1 + alpha) * G.Nodes.loads;                   %Add a capacities attribute to graph G.
                                                                        %Calculated using (2) of Notes.
                                                                        %Immutabe w.r.t time.        
                                                                        
   
         
    n_c = length(largestcomponent(adjacency(G)));                       %Calculate n_c (before cascade)
                                                                        %largestcomponent is an open source function
                                                                        %found in (S.1.
                                                                        %Used to compute D.
    
    %II. Motter-Lai Model (Defined in Section B of Notes) 
    G = rmnode(G, failed);                                              %t = 0: Remove failed = vF from G.

    numFailed = -1;                                                     %number of failed nodes in the most recent 
                                                                        %timestep that is not t = 0 - initialized to 
                                                                        %nonzero quantity.
                                                                        
    while numFailed ~= 0                                                %Stopping Condition: No nodes failed in the most
                                                                        %recent iteration. 
                                                                        %More precisely: L(i) <= C(i) for any node i in 
                                                                        %most recent iteration.
                                                                          
        G.Nodes.loads = centrality(G, 'betweenness');                   %Update the loads of all nodes in G.     
        
        failed = find(G.Nodes.loads > G.Nodes.capacities);              %Identify failed nodes in the current iteration.
        
        numFailed = length(failed);                                     %Count number of failed nodes.
        
        G = rmnode(G,failed);                                           %Remove failed nodes from G.
        
    end
    
    %III. Damage Calculations
    %Calculation of D (Motter-Lai Damage)
    n_c_prime = length(largestcomponent(adjacency(G)));                 %Calculate size of largest component after cascade.
    
    D = (n_c_prime/n_c);                                                                                                   