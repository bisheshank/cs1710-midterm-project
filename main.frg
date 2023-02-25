#lang forge

// State to signify time based traversal through the graph  
sig State {}

// Node holds the field of when it was seen during the traversal
sig Node {
    seen_nodes: pfunc Node -> set State
}

// edge relation between the nodes and each each has a weight
sig Edge {
    edge: pfunc Node -> Int
    chosen_edges: pfunc Node -> set State
}

// // to check the next node is not in the seen set
// pred NextIntersectingNode[e: Edge, s: State] {
//     some n1, n2: Node | {
//         some w: Int | {
//             n1 in Node.seen_nodes.s
//             n2 in (Node - Node.seen_nodes.s)
//             edge[n1] = edge[n2]
//         }
//     }
// }

// pred step[s1, s2: State] {
//     // if all nodes covered
//     seen_nodes.s1 = Node =>
//         // all nodes and edges should be equal in s1 and s2
//         Node.seen_nodes.s1 = Node.seen_nodes.s2 and Edge.chosen_edge.s1 = Edge.chosen_edge.s2
//     else some e1, e2: Edge {
//         // choose the next edge
//         // edge should be the next intersecting node 
//         NextIntersectingNode[e1, s1]
//         Edge.chosen_edges = Edge.chosen_edges + e1
//         Node.seen_nodes = e1.
//     }

// }
