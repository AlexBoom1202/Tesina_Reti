# Bitcoin Trading Platform Security Enhancement Using Metropolis-Hastings Algorithm

## Project Overview

This project presents a **Proof of Concept** on how to implement the **Metropolis-Hastings algorithm** to enhance security on a Bitcoin trading platform. The goal is to simulate Bitcoin trading platforms' traffic using **Markov chains** to provide an additional layer of security by masking network traffic and creating honeypots.

The platform used for this simulation is **Bitcoin Alpha**, where users rate each other on a scale from -10 to 10. By analyzing the structure and dynamics of the network, this work aims to safeguard against potential attacks, particularly targeting high-degree nodes known as **"whales"**—users or wallets with large holdings.

## Key Concepts

### Markov Chains
A **Markov Chain** is a discrete-time system where the probability of moving to a future state depends only on the current state, not the history of previous states. This project employs a **Random Walk Markov Chain**, where the probability of transitioning from one node to another depends on the nodes' degree.

### The Metropolis-Hastings Algorithm
The **Metropolis-Hastings Algorithm** is utilized to manipulate the transition matrix of the Markov Chain, enforcing the **Detailed Balance Condition** and ensuring the chain has an irreducible and aperiodic limit distribution. This allows for adjusting the perceived network traffic by shifting the focus away from high-degree nodes (potential whales) to decoy nodes (honeypots).

## Project Goals
- Simulate traffic on a Bitcoin trading platform using Markov Chains.
- Apply the **Metropolis-Hastings Algorithm** to mask the actual traffic and protect high-degree nodes (whales).
- Create **honeypots** by modifying the transition matrix, luring attackers to low-degree, decoy nodes.

## Code Structure
The project is mainly divided into three MATLAB files:
1. **`graph_analysis.m`**: 
   - This file handles the preprocessing of the Bitcoin Alpha graph dataset. It extracts the largest connected component from the directed and weighted graph and converts it into an undirected, unweighted graph for simplicity.
   - It also performs various graph analysis tasks, such as identifying high-degree nodes and creating visualizations of the graph structure.
   
2. **`markov_tes.m`**: 
   - This script simulates a **Random Walk** on the graph using the **Probability Transition Matrix**. It generates a random starting node and tracks the movement of a patroller as it walks between nodes.
   - The output is a distribution of visits across nodes, representing the limit distribution of the Random Walk Markov Chain.

3. **`metropolis_hastings.m`**:
   - This script implements the **Metropolis-Hastings Algorithm** to alter the limit distribution of the Random Walk. The goal is to focus the random walker on a predefined **honeypot** node, making it appear as if the honeypot node is more important than it really is.
   - The new limit distribution is visualized and compared to the original, showing the effectiveness of the algorithm in masking network traffic.

## Graph Structure
The dataset consists of a network graph with **3235 nodes**. For simplicity, the **largest connected component**, which is undirected and unweighted, is analyzed. The **degree distribution** of the nodes helps identify potential whale nodes that hold the highest degree, making them prime targets for attackers.

### Results After Applying Metropolis-Hastings Algorithm
The limit distribution shifts the focus to honeypot nodes, misleading attackers into targeting these decoys rather than actual whales. This strategy provides a protective layer to the network.

## Future Improvements
- **Distributed Algorithm**: Implementation of a distributed redesign of the Markov Chain to minimize network disruption, as proposed in the paper by Oliva et al. (2022).
- **Optimization**: Reduction of the **mixing time** by bringing the eigenvalues of the Markov Chain closer to zero.
- **Dynamic Honeypots**: Introducing dynamic honeypots to further enhance network security.

## References
- Oliva, G., Setola, R., & Gasparri, A. (2022). "Distributed Markov Chain Redesign for Multiagent Decision-Making Problems." *IEEE Transactions on Automatic Control*, 68(2), 1288-1295.
