#lang forge

sig State {
    // to establish time dependence
    next: lone State
    // a set of nodes that have been traversed 
    seen_nodes: set Nodes
    // a set of chosen edges by a set of node to node with a wieght of int
    chosen_edges: set Node -> Node -> Int
}

sig Node {
    edges: pfunc Node -> set Node -> Int
}

sig Start {
    // one start node 
    node: one Node
}

// get the  
// constraints on the graph: connected, undirected, edge: n1 n2 distinct nodes, 



pred InitState[s: State] {
    // the first node that is initialized
    s.seen_nodes = Start.node
    // there are no edges in the initial state
    no s.chosen_edges
}


pred FinalState[s: State] {
    // when all the nodes are reachable from the first node
    all n1, n2: Node | {
        // both nodes have been traversed
        n1 in s.seen_nodes
        n2 in s.seen_nodes
        // n1 and n2 is reachable in the recursive set of edges, implying n2 is reachable from n1
        reachable[n1, n2, edges]
    }
}

pred TransitionStep[pre, post: State] {
    // connecting the pre and post states
    pre.next = post
    // if all nodes are visited
    pre.seen_nodes = Node => // how do i say the set of all nodes
        pre.seen_nodes = post.seen_nodes
        pre.chosen_edges = post.chosen_edges
    else some seenNode, newNode: Node, weight: Int | {
        // get the set of connected nodes
        // get the minimum int weight
        // keep that edge in the graph
        seenNode in pre.seen_nodes
        newNode not in pre.seen_nodes

        // set of connected edges to the node in n1
        let valid_connnected_edges = {some n1, n2: Node, w: Int | {
            n1 in pre.seen_nodes
            n2 not in pre.seen_nodes
            n1->n2->w in edges
        }}

        // set of weights from the connected edges
        let valid_weights = {some i: Int | {some n1, n2: Node | {n1->n2->i in valid_connected_edges}}}

        // getting the minimum edge
        let minimum_edge = {
            some n1, n2: Node, w: Int | {
                n1->n2->w in valid_connected_edges
                w = min[valid_weights]
            }
        }

        seenNode->newNode->weight = minimum_edge // somehow want to say this
        post.seen_nodes = pre.seen_nodes + newNode
        post.chosen_edges = pre.chosen_edges + oldNode->newNode->weight
        }

}