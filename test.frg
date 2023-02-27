#lang forge

sig State {
    next: lone State, -- next time state
    seen: set Node, -- the set of seen nodes
    chosen: set Node -> Node -> Int -- the set of chosen edges
}

sig Node {
    edges: set Node -> Int -- the set of edges connected to that Node with weight of Int
}

sig Start {
    node: one Node -- one start Node
}


// get the  
// constraints on the graph: connected, undirected, edge: n1 n2 distinct nodes, 

pred Connected {
    all n1, n2: Node | {
        reachable[n1, n2, edges.int] -- all nodes are reachable through the relational join of edges.int
    }
}

pred Undirected {
    all n1, n2: Node | {lone w: Int | {
        n1->n2->w in edges implies n2->n1->w in edges -- undirected graph n1->n2 implies there is n2->n1
    }}
}

pred Wellformed[s: State] {
    all n1, n2: Node | {lone w: Int | {n1->n2->w in edges}}
}


pred InitState[s: State] {
    s.seen = Start.node -- the first Node that is traversed
    no s.chosen -- no chosen edges in the initial state
}

pred FinalState[s: State] {
    // when all the nodes are reachable from the first node
    all n1, n2: Node | {
        // both nodes have been traversed
        n1 in s.seen
        // n1 and n2 is reachable in the recursive set of edges, implying n2 is reachable from n1
        reachable[n1, n2, edges]
    }
}

pred DoNothing[pre, post: State] {
    pre.seen = post.seen
    pre.chosen = post.chosen
}

pred TransitionStep[pre, post: State] {
    // connecting the pre and post states
    pre.next = post
    // if all nodes are visited
    let valid_connected_edges = {n1, n2: Node, w: Int | {
            n1 in pre.seen
            n2 not in pre.seen
            n1->n2->w in edges
        }
    }

    let set_weights = {n1, n2: Node, w: Int | {
            n1->n2->w in valid_connected_edges
        }
    }

    let edge_with_min_weight = {n1, n2: Node, w: Int | {
            w = min[set_weights]
            n1->n2->w in valid_connected_edges
        }
    }

}

pred TransitionStates {
    some init, final: State | {
        InitialState[init] 
        FinalState[final]

        all s1, s2: State | {
            s1.next = s2
            s1 != final
            reachable[s2, s1, next]
        }

        // all s: State | {
        //     (s = final)
        // }

        all s: State | {
            (s != final and not reachable[s, final, next]) implies canTransition[s, s.next]
        }
    }
}

run {
    TransitionStates
} for exactly 5 States, exactly 5: Node, exactly 5 Int for {next is linear}

// forge is a formal methods language similar to alloy, correct this above program which models prims algorithm