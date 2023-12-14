clear
close all
clc
%% loading data 
ws = {'Adjacency_matrix.mat', 'autv_dom_distrib.mat', 'Degree_matrix.mat', 'Largest_conn_subgraph.mat', 'Prob_trans_matrix.mat'};
for i=1:5
    load(ws{i}); 
end

n = size(A,1); 
% autv_dom contains the limit distribution before Metropolis Hastings  

%% defining honeypot 
nodes_with_less_than_five_out_links = find(sum(A, 2) < 5);

% taking the nodes closest to the first, since the first has the highest degree 
honeypot = nodes_with_less_than_five_out_links(1);

%% Metropolis-Hastings 
% now the goal is to achive a limit distribution with highest value on
% honeypot 
% f will be the target limit distribution 

crit = 0.1; 
f = zeros(n,1);
f(honeypot) = crit; 
for i=1:n
    if i ~= honeypot 
        f(i) = rand(); 
    end  
end
% multiplying by a scaling factor that makes the sum of the vector equal to
% 1-crit so that plugging in the crit value on the honeypot the sum of the
% vector will be unitary 
scale_factor = (1-crit)/sum(f); 
f = f*scale_factor; 
f(honeypot) = crit;

% building the new Matrix P 
Pn = zeros(n,n);  

for i=1:n
    for j=1:n
        if A(i,j) == 1 % j is a neighbor of i  
            Pn(i,j) = 1/D(i,i)*min(1, (f(j)*D(i,i))/(f(i)*D(j,j)));
        end
    end 

    row = sum(Pn, 2); 
    Pn(i,i) = 1 - row(i); 
    if abs(Pn(i,i)) < 1e-10
        Pn(i,i) = 0; 
    end 

end 
%% econometrics toolbox 
mc = dtmc(Pn); 
AS = mc.asymptotics' ;
cs = dot(AS, f)/(norm(AS)*norm(f)); 

%% plots
f_short = [f(1:1000)]; 

figure;
bar(f_short);
set(gca, 'YScale', 'log')

xlabel('Nodes');
ylabel('Probability');
title('Markov Chain Distribution on first 1000 Nodes After Metropolis-Hastings');
ylim([0, 1]); 

xticks(0:250:numel(f_short));
xticklabels(0:250:numel(f_short));
hold on;
plot(honeypot, f(honeypot), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
hold off;


eigplot(mc); 
title('Eigplot of the Markov Chain After Metropolis-Hastings');
[~,tMix] = asymptotics(mc); 
