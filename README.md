# Curiosity Modelling: Prim's Algorithm

We are modeling Prim's algorithm, a greedy algorithm for finding the minimum spanning tree of a connected, undirected graph. The algorithm starts with a single node and repeatedly adds the edge with the smallest weight that connects a node in the current tree to a node outside the tree, until all nodes are included in the tree. The goal is to learn how the algorithm works and why it produces a minimum spanning tree along with modelling a real world algorithm in Forge.

Modelling Prim's turned out to be more difficult than we thought because of how recent we were to using set operations and full Forge. But, this project was a good learning opportunity to modelling actual algorithms in Forge.

Our discussions let us to thinking about the model in two separate ways, and we ended up making attempts at both of them.

---

## Files

- `mst.frg`: Forge file containing the first implementation of the model
- `mst2.frg`: Forge file containing the second implementation of the model
- `mst.test.frg`: Forge file containing the tests for the second implementation of the model
- `mst2.test.frg`: Forge file containing the tests for the second implementation of the model
- `README.md`: This file, containing the project description and design choices
- `collaborators`: A file listing the anonymous IDs of those we collaborated with (one ID per line)

---

## Model Design: First Model

---

## Model Design: Second Model

In our second implementation, we have implemented the graph as the set of sig `Node`, which has a set of `edges: set Node->Int` with a set of nodes with a weight associated with it. This model is a time-dependent stepwise traversal of the initial graph with each step updating the `seen` field, which holds the set of nodes traversed, and `chosen`, which holds a set of the edges chosen.

In this model, we have created an instance of the `wellFormed` signature which holds the properties of a well-formed graph. We then repeatedly choose the cheapest edge and add it to the MST until all nodes are included. We have verified that the resulting `MST` is indeed a minimum spanning tree by checking that it has the one less number of edges than the number of nodes and all nodes are reachable from any other node in the tree. The test suit includes tests for all the preds and `transitionSteps`.

We have not created a custom visualization for this project, but the instance produced by the Sterling visualizer should show the original graph, the minimum spanning tree, and the total weight of the tree.

---

## Collaboration

We collaborated on this project by pair programming and discussing our design decisions. We received help from our TAs during office hours. (thank you Megan!!)
