clear
close all
clc
%% loading data 
ws = {'Adjacency_matrix.mat', 'autv_dom_distrib.mat', 'Degree_matrix.mat', 'Largest_conn_subgraph.mat', 'Prob_trans_matrix.mat'};
for i=1:5
    load(ws{i}); 
end

% autv_dom contiens the limit distribution (calculated with the dominant eigenvector) 
% P is the probability transition matrix 
% D is the degree matrix
% G_new is the largest connected component 
% A adjency matrix of G_new 

%% manually writing the random walk 
patroller = []; 
n = size(A,1); 

% randomly generating starting node 
ic = randi([1,n]);
patroller = cat(1,ic); 

current_node = ic; 

% exit cond 
tries = 1;
max_tries = 10*n;

while tries < max_tries 
    % uso solo la riga perchè voglio trovare il link da i a j 
    neighbors = find(A(current_node, :) == 1); 
    chosen = neighbors(randi(numel(neighbors))); 
    patroller = cat(1, patroller, chosen); 
    current_node = chosen; 
    tries = tries + 1; 
end 

% removing first 100 elements of the vector 
patroller = patroller(100 : end); 
el_in_chain = numel(patroller); 
distrib_patroller = [];

% now counting each time the i-th node was visited 
for i=1:n 
    row = sum(patroller == i); 
    distrib_patroller = cat(1, distrib_patroller, row); 
end 

% NB non sto normalizzando, sto rendendo la somma 1 così che posso considerarla una distribuzione 
% di probabilità 
distrib_patroller = distrib_patroller ./ el_in_chain;

% usando la cosine similarity vado a calcolare il coseno tra il vettore
% autv_dom e distrib_patroller --> questa metrica va da -1 a 1; 1 uguali,
% -1 versi addiritura opposti 

cs = dot(autv_dom, distrib_patroller)/(norm(autv_dom)*norm(distrib_patroller));

%% plots
distrib_patroller_short = [distrib_patroller(1:1000)]; 
figure;
bar(distrib_patroller_short);
set(gca, 'YScale', 'log')

xlabel('Nodes');
ylabel('Probability (log Scale)');
title('Markov Chain Distribution on First 1000 Nodes');
ylim([0, 1]); 

xticks(0:250:numel(distrib_patroller_short));
xticklabels(0:250:numel(distrib_patroller_short));
hold on;
plot(1, distrib_patroller_short(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
hold off;