MLmodel.m: Implementation of ML algorithm
MLPlots.m: Various plots using MLmodel
fig4rep.m: Replicates fig 4 from ML paper
MLmodel2.m: A slight tweak of MLmodel.m - used by fig4rep.m only.
largestcomponent.m: An open source matlab file necessary for MLmodel.m, MLmodel2.m to run.
Plots Folder: Plots generated from MLPlots.m and fig4rep.m
Damage.m: Given G and alpha, for each node, considered as an initial trigger, computes damage (measured by D and DD) using the ML model impemented in MLmodel.m.
LargestConnectedComponent: Given G, returns the list of nodes in the largest connected component. 