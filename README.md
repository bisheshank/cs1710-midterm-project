# Curiosity Modeling: Prim's Algorithm

We are modeling Prim's algorithm, a greedy algorithm for finding the minimum spanning tree of a connected, undirected graph with non-negative edges. The algorithm starts with a single node and repeatedly adds the edge with the smallest weight that connects a node in the current tree to a node outside the tree, until all nodes are included in the tree. The goal is to learn how the algorithm works and why it produces a minimum spanning tree along with modeling a real world algorithm in Forge.

Modeling Prim's turned out to be more difficult than we thought because of how recently using set operations and full Forge was taught. However, this project was a good learning opportunity in learning to model actual algorithms in Forge.

Our discussions let us to thinking about the model in two separate ways, and we ended up making attempts at both of them.

## Files

- `mst.frg`: Forge file containing the first implementation of the model
- `mst2.frg`: Forge file containing the second implementation of the model
- `mst.test.frg`: Forge file containing the tests for the second implementation of the model
- `mst2.test.frg`: Forge file containing the tests for the second implementation of the model
- `README.md`: This file, containing the project description and design choices
- `collaborators`: A file listing the anonymous IDs of those we collaborated with (one ID per line)

## Model Design: First Model

In our first implementation, we implemented the graph as a set of weighted `sig Edge`s which connect `sig Node`s. The model implements Prim's algorithm step by step, representing information about `chosen_edges` and `chosen_nodes` in a separate `sig Step`. Upon the first step, a random node is chosen with no chosen edges. Each subsequent step adds a minimal edge which intersects betweens the set of chosen nodes and not yet chosen nodes (in the `possibleNewEdge` pred) until the graph is fully connected.

Upon running the model, the Table view shows the model correctly choosing minimal non-cyclic edges to create an MST.

## Model Design: Second Model

In our second implementation, we have implemented the graph as the set of `sig Node`, which has a set of `edges: set Node->Int` with a set of nodes with a weight associated with it. This model is a time-dependent stepwise traversal of the initial graph with each step updating the `seen` field, which holds the set of nodes traversed, and `chosen`, which holds a set of the edges chosen.

In this model, we have created an instance of the `wellFormed` signature which holds the properties of a well-formed graph. We then repeatedly choose the cheapest edge and add it to the MST until all nodes are included. We have verified that the resulting MST is indeed a minimum spanning tree by checking that it has the one less number of edges than the number of nodes and all nodes are reachable from any other node in the tree. The test suite includes tests for all the preds of `wellFormed`, `initState`, `finalState` and `transitionSteps`.

## Summary of Differences between Implementations

Since we ended up with two attempts at modeling, we learned a lot about Forge set comprehension, and how scaling affects models based on their sig representations. In the first model, edges were represented using a separate sig `sig Edge`, whereas the second model represented this as part of a relation in the `Node` sig.

While this made the first model easier to intuitively understand and code, it also introduces difficulties with scaling. While the first model works for models with small number of nodes and edges, issues arise when scaling to bigger implementations. This is because as the number of nodes increases, the maximum number of edges also scales up quadratically by `N * (N - 1)`, where `N` is the number of nodes in the graph. Having a separate `Edge` sig means that every extra edge is an extra sig, which has performance costs when comparing it to the second model, where every extra edge is just an extra relation.

## Visualization Issues

In our first implementation, the default sterling visualizer has not captured the steps required to find the chosen edge and chosen nodes. In our second implementation, the visualizer works, but due to the undirected graph pred it does not correctly show in the Graph view. Both however, have the correct MST in the Table view of the Sterling visualizer. If we had more time, we would add a separate predicate that could solve some of the visualizer issues.

## Collaboration

We collaborated on this project by pair programming and discussing our design decisions. We received help from our TAs during office hours. (thank you Megan and Tim!!)
