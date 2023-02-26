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

pred TransitionStep[pre, post: State] {
    // connecting the pre and post states
    pre.next = post
    // if all nodes are visited
    pre.seen = Node => // how do i say the set of all nodes
        pre.seen = post.seen
        pre.chosen = post.chosen    
    else {some seenNode, newNode: Node, weight: Int | {
        // get the set of connected nodes
        // get the minimum int weight
        // keep that edge in the graph
        seenNode in pre.seen
        newNode not in pre.seen

        // set of connected edges to the node in n1
        let valid_connnected_edges = {some n1, n2: Node, w: Int | {
            n1 in pre.seen
            n2 not in pre.seen
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
        post.seen = pre.seen + newNode
        post.chosen = pre.chosen + oldNode->newNode->weight + newNode->oldNode->weight -- idk if the second part is needed
    }}
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

        all s: State | {
            (s != finalState and not reachable[s, finalState, next]) implies canTransition[s, s.next]
        }
    }
}

run {
    TransitionStates
} for exactly 5 States, exactly 5: Node, exactly 5 Int for {next is linear}