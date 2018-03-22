%Author: Ashwin Hari
%Date: 03/30/17
%ml_timelaspe.m
%   Uses the Motter-Lai model to create a time lapse of how failure
%   cascades propogate through the US Power Grid network.

clear;clc;

%I. Load data/set variables
load('uspowergrid');                                                    %Load data
g = graph(uspowergrid(:,1), uspowergrid(:,2));
N = height(g.Nodes);                                                    %Number of nodes in g.

alpha = 0.3;
random = randi([1 N],[1 20]);                                           %20 random nodes.

loads = centrality(g, 'betweenness');                              
[load,vID] = sort(loads,'descend');
mostCentral = transpose(vID(1:20));                                     %20 most central nodes.

vF = mostCentral;                                                       %Set it to either random or mostCentral

%II. Call MLmodel_t.m
[fNodes, D, DD] = MLmodel_t(g, alpha, vF);                              %Returns additional value fNodes
                                                                        %fNodes is a matrix of failed nodes at
                                                                        %each timestep. A row correspond to the nodes
                                                                        %that fail at one timestep.

%Now, we plot the time lapse.
numPlots = size(fNodes, 1) + 1;                                         %Each row of fNodes corresponds to 1 timestep,
                                                                        %which has a dedicated plot. We add 1, because 
                                                                        %we want to have a plot for t = 0.

numCol = 3; 
numRows = ceil(numPlots/numCol);                                        %We plot 3 plots per row. numRows is number of
                                                                        %rows in the final timelapse figure.
figure;  
subplot(numRows, numCol ,1);
h = plot(g, 'NodeColor', 'b');
currFailed = vF;
highlight(h, currFailed, 'NodeColor', 'r')
title('US Powergrid: t = 0')

for pltIdx = 2:numPlots
    p = pltIdx - 1;
    modVal = mod(pltIdx,numCol);                                               
    if modVal == 0 
        column = 3;
    else column = modVal;
    end
    row = ceil(pltIdx/3);
    subplot(numRows, numCol ,(row - 1)*numCol + column);
    h = plot(g, 'NodeColor', 'b')
    titleStr = sprintf('US Powergrid: t = %d', pltIdx - 1);
    title(titleStr)
    if p > 1
        hlt = reshape(fNodes(1:p-1,:),1, (p-1)*N);
        hlt = [hlt vF];
        hlt = hlt(hlt ~= 0);
        currFailed = fNodes(p, :);
        currFailed = currFailed(currFailed ~= 0);
        highlight(h, currFailed, 'NodeColor', 'r')
        highlight(h, hlt, 'NodeColor', 'y')
    else
        currFailed = fNodes(p, :);
        currFailed = currFailed(currFailed ~= 0);
        highlight(h, currFailed, 'NodeColor', 'r')
        highlight(h, vF, 'NodeColor', 'y')
    end   
end