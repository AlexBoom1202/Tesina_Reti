clear 
close all 
clc

%% PreProcessing 
file = readtable('soc-sign-bitcoinalpha.csv');
new_var_names = {'Source', 'Target', 'Rating', 'Time'}; 
file = renamevars(file, file.Properties.VariableNames, new_var_names); 

G = digraph(file.Source, file.Target, file.Rating); 

% I'm only going to analyse the larget connected component of the graph 
% conncomp assigns each node to an id, if two nodes have the same id it
% means that they are in the same "subgraph"
count = G.conncomp();

% by finding the mode fo count I'm finding the most present value and the
% nodes associated with that value are the ones in the subgraph that I'm
% looking for 
idx = mode(count);

% now finding the indexes of the graph that are referred to id "idx" and so
% they are parte of the largest connected component 
nodes_to_keep = find(count == idx); 
nodes_to_remove = setdiff(1:G.numnodes(), nodes_to_keep); 
G_new = rmnode(G, nodes_to_remove); 

% obviously it's connected because this value is 1 
% max(G_new.conncomp)
 
%% taking the non directed graph 
A = full(G_new.adjacency()); 
A = (A+A') > 0; 
d = []; 
for i = 1:size(A,1)
    d = cat(1, d, sum(A(i,:),2)); 
end 
D = diag(d); 

%% plots 

h = plot(G_new, 'Layout','subspace'); 
% highlighting the nodes with degree > 100 
high_deg_nodes = find(d>100); 
highlight(h, high_deg_nodes, 'NodeColor', 'yellow', 'MarkerSize', 4)
title('Graph with Highlighted Nodes');

h2 = plot(G_new, 'Layout','subspace');
% highlighting the highest degree node 
highest_deg_node = find(max(d)); 
highlight(h2, highest_deg_node, 'NodeColor', 'magenta', 'MarkerSize', 4)
title('Graph with Highest Deg. Node Highlighted'); 

h3 = plot(G_new, 'Layout','subspace');
% highlighting node 259
highlight(h3, 259, 'NodeColor', 'green', 'MarkerSize', 4)
title('Graph with Honeypot Highlighted'); 


%% laplacian
L = D-A;
[V, aut] = eig(L);  

% zero aut is the index of the ONLY eigenvalue in 0 
zero_aut = find(abs(diag(aut)) < 1e-10);


%% ---------- RANDOM WALK ---------- 
% the dominante eigenvector in the probability transition matrix represents
% the limit distribution of the random walk markov chain 

% P' is the probability transition matrix 
P = D\A; 
[V_p, aut_p] = eig(P'); 

% finding the diminante eigenvector (already normalized by matlab)  
autv_dom = V_p(:,find(max(diag(aut_p))));

% making its sum unitary for it to correctly represent a probability
% distribution 
autv_dom = autv_dom/sum(autv_dom);
