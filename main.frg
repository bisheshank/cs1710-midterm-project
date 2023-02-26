#lang forge

// State to signify time based traversal through the graph  
sig State {}

// Node holds the field of when it was seen during the traversal
sig Node {
    seen_nodes: pfunc State -> set State
}

// edge relation between the nodes and each each has a weight
sig Edge {
    edge: set Node -> Int
    chosen_edges: pfunc State -> set State
}

// // to check the next node is not in the seen set
pred NextIntersectingNode[e: Edge, s: State] {
    some n1, n2: Node | {
        some w: Int | {
            n1 in e.edge & seen_nodes[s] // how to include the state in this
            n2 in e.edge & (Node - seen_nodes[s])
        }
    }
}

pred Step[s1, s2: State] {
    seen_nodes.s1 = Node =>
        seen_nodes[s1] = seen_nodes[s2]
        chosen_edge[s1] = chosen_edges[s2]
    else some e: Edge | {
        NextIntersectingNode[e, s1]
        chosen_edges[s2] = chosen_edges[s1] + e
        seen_nodes[s1] = seen_nodes[s2] + s1
        }
}

// start node
// set up a time step
// final step


pred SpanningTree[e: Edge] {
    // final set of nodes must match the initial node
    // #edges = #nodes - 1
    // all nodes are reachable from every other node
}