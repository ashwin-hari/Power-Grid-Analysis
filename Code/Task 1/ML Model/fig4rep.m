%Author: Ashwin Hari
%Date: 03/28/17
%fig4rep.m
%   Attempts to replicate Figure 4 of original ML paper (2002).

clear;clc;

%I. Load data/set variables
load('uspowergrid');                                                    %Load data
g = graph(uspowergrid(:,1), uspowergrid(:,2));

lb = 0.0;                                                               %Upper and lower bounds for alpha
ub = 1.0;

%II. Compute data points for load-based attacks.
%Retrieve 5 nodes with the highest load.
loads = centrality(g, 'betweenness');                              
N = height(g.Nodes);
[load,vID] = sort(loads,'descend');
mostCentral = vID(1:5);

%For each node, compute damage for each alpha. Save results.
results = zeros(5,11);                                                  %Stores results of D across the 5 nodes.
for ndI = 1:5
    results(ndI, :) = arrayfun(@(a) ...
        MLmodel2(g,a, mostCentral(ndI)), linspace(0,1,11));              %Apply MLmodel2 function to all alpha values.
                                                                        %and save results.
end

%Average results over 5 nodes.
loadattacks = mean(results);

%III. Compute data points for degree-based attacks.
%Retrieve 5 nodes with the highest degree.
degrees = degree(g);                              
[deg,vID] = sort(degrees,'descend');
mostDegree = vID(1:5);

%For each node, compute damage for each alpha. Save results.
results = zeros(5,11);                                                  %Stores results of D across the 5 nodes.
for ndI = 1:5
    results(ndI, :) = arrayfun(@(a) ...
        MLmodel2(g,a, mostDegree(ndI)), linspace(0,1,11));               %Apply MLmodel2 function to all alpha values.
                                                                        %and save results.
end

%Average results over 5 nodes.
degreeattacks = mean(results);

%IV. Compute data points for random attacks.
%Retrieve 50 random nodes.
N = height(g.Nodes);                                                    %Number of nodes in g.
randomNodes = randi([1 N],[1 50]);

%For each node, compute damage for each alpha. Save results.
results = zeros(50,11);                                                 %Stores results of D across the 5 nodes.
for ndI = 1:50
    results(ndI, :) = arrayfun(@(a) ...
        MLmodel2(g,a, randomNodes(ndI)), linspace(0,1,11));              %Apply MLmodel2 function to all alpha values.
                                                                        %and save results.
end

%Average results over 50 nodes.
randomattacks = mean(results);

%V. Plot results
figure;                                                                 
plot(linspace(0,1,11), loadattacks, linspace(0,1,11), degreeattacks, ...
    linspace(0,1,11), randomattacks);
legend('Load Attacks', 'Degree Attacks', 'Random Attacks')
title('Damage versus Alpha Values')
xlabel('\alpha Value')
ylabel('Damage')