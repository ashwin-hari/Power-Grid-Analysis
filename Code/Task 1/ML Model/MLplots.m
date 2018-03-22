%Author: Ashwin Hari
%Date: 03/23/17
%Motter Lai Model Plots

clear;clc;

%% I. Damage versus Alpha Values - First 30 nodes taken as Initial Failure Nodes
%       - Alpha values (0.0, 0.1, ..., 1.0) are plotted with their 
%         corresponding Damage values (D and DD).
%       - The US Power Grid is used.
%       - First 30 nodes are removed as the initial trigger.

load('uspowergrid');                                                    %Load data
g = graph(uspowergrid(:,1), uspowergrid(:,2));

lb = 0.0;                                                               %Upper and lower bounds for alpha
ub = 1.0;

[D, DD] = arrayfun(@(a) ...                                             %Apply MLmodel to alpha values.
    MLmodel(g,a, 1:10), linspace(lb,ub,11));

figure;                                                                 %Plot Damage versus alpha.
plot(linspace(lb,ub,11), D, linspace(lb,ub,11), DD)
legend('D', 'D^{\prime}')
title('I. Damage versus \alpha Values (First 50 Node Failure)')
xlabel('\alpha Value')
ylabel('Damage')

%% II. Damage versus Alpha Values - 30 Nodes that are Uniformly Random
%       - Alpha values (0.0, 0.1, ..., 1.0) are plotted with their 
%         corresponding Damage values (D and DD).
%       - The US Power Grid is used.
%       - 30 nodes are removed for the initial trigger. These 30 nodes
%       - are uniformly sampled. The damage values are averages across
%       - 5 different uniform sampling realizations.
%       - The same random nodes are used for each alpha.

Dresults = [];                                                          %Stores results of D across the 5 random
                                                                        %realizations.
DDresults = [];                                                         %Stores results of DD across the 5 random
                                                                        %realizations.
for trial = 1:5
    g = graph(uspowergrid(:,1), uspowergrid(:,2));                      %Form g from data
    N = height(g.Nodes);                                                %Number of nodes in g.
    [D, DD] = arrayfun(@(a) ...
        MLmodel(g,a, randi([1 N],[1 50])), linspace(0,1,11));           %Apply MLmodel function to all alpha values.
    Dresults = [Dresults; D];                                           %Save results.
    DDresults = [DDresults; DD];
end

figure;                                                                 %Plot results.
plot(linspace(0,1,11), mean(Dresults), linspace(0,1,11),mean(DDresults))
legend('D', 'D^{\prime}')
title('Damage versus Alpha Values (Randomly Sampled, 50 Node Trigger)')
xlabel('\alpha Value')
ylabel('Damage')

%% III. Unintentional versus Intentional Damage
%       - We compare D and DD quantities that arise from uniformly randomly
%         sampling initial failure nodes (Unintentional) and picking
%         nodes with the highest betweenness (Intentional).
%       - The US Power Grid is used.
%       - Alpha of 0.3 is used.
%       - We compare D and DD for 3 different initial trigger sizes:
%         [10, 100, 1000] 

alpha = 0.3;                                                            %Alpha value
numFail = [10 100 1000];                                                %Initial trigger sizes
                                                                             
resultsRand = zeros(3,2);                                               %Results for Unintentional
                                                                        %Row 1: D, Row 2: DD
                                                                        %Columns: Trigger size (10, 100, 1000)
resultsNRand = zeros(3,2);                                              %Results for Intentional 
                                                                        %Same format as resultsRand.

for n = 1:3                                                             %For each trigger size - I will denote as s 
                                                                        %in comments
    
    g = graph(uspowergrid(:,1), uspowergrid(:,2));                      %Form graph from data.
    
    loads = centrality(g, 'betweenness');                               %Find the s most central nodes (betweenness).
    N = height(g.Nodes);
    [load,vID] = sort(loads,'descend');
    mostCentral = vID(1:numFail(n)); 
    
    [resultsNRand(n,1),resultsNRand(n,2)] = MLmodel(g, alpha, ...       %Compute and Save results.
        mostCentral);
    [resultsRand(n,1),resultsRand(n,2)] =  MLmodel(g, alpha, ... 
        randi([1 N],[1 numFail(n)]));
end

%Plot results for D (Motter-Lai Definition)
%   - bar plot that compares Intentional and Unintentional Attacks for each
%     trigger size.

figure;
c = {'10 Nodes','100 Nodes', ... 
    '1000 Nodes'};
y = [resultsRand(1,1) resultsNRand(1,1); resultsRand(2,1) resultsNRand(2,1) ; ... 
        resultsRand(3,1) resultsNRand(3,1) ];
b = barh(y);
b(1).FaceColor = 'blue';
b(2).FaceColor = 'red';
title('Intentional versus Unintentional Network Damage D')
xlabel('Damage D')
set(gca,'yticklabel',c)
legend('Unintentional', 'Intentional')

%Plot results for D' (Custom Definition)
%   - bar plot that compares Intentional and Unintentional Attacks for each
%     trigger size.

figure;
c = {'10 Nodes','100 Nodes', ... 
    '1000 Nodes'};
y = [resultsRand(1,2) resultsNRand(1,2); resultsRand(2,2) resultsNRand(2,2) ; ... 
        resultsRand(3,2) resultsNRand(3,2) ];
b = barh(y)
title('Intentional versus Unintentional Network Damage D^{\prime}  ')
xlabel('Damage D^{\prime} ')
set(gca,'yticklabel',c)
legend('Unintentional', 'Intentional', 'Location', 'southeast')