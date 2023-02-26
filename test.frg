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
    else some n: Node | {
        // get the set of connected nodes
        // get the minimum int weight
        // keep that edge in the graph

        let valid_connnected_nodes = pre.edges[n] | {some n1, n2: Node, w: Int | {
            n1 in pre.seen_nodes
            n2 not in pre.seen_nodes
            n1 -> n2 -> w in edges
        }}

        let minimum_edge = 

        let minimum_node = valid_connected_nodes | {
            some n1, n2: Node, w: Int | {
                n1->n2->w
                w = min[valid_connected_nodes | {
                    some i: Int | {

                    }
                }]
            }
        }



        post.seen_nodes = pre.seen_nodes + n2
        post.chosen_edges = pre.chosen_edges + n1->n2->w
        }

}