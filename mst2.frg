#lang forge

sig State {
    next: lone State, -- next state
    seen: set Node, -- set of all traversed nodes
    chosen: set Node->Node->Int -- set of all chosen edges
}

one sig Start {
    start: one Node -- one start node
}

sig Node {
    edges: set Node->Int -- set of node->int that is connected to the current node, int is weight of the edge
}

pred connected { -- make sure every node is reachable from every other node
    all disj n1, n2: Node | {
        reachable[n1, n2, edges.Int]
    }
}

pred undirected {
    all n1, n2 : Node | {
        -- making sure that the graph is undirected
        {i: Int | n1->n2->i in edges} = {i: Int | n2->n1->i in edges}
    }
}

pred noSelfNeighbour { -- no node should be a neighbour of itself
    all n: Node | {
        n not in {neighbour: Node | some weight: Int | n->neighbour->weight in edges}
    }
}

pred oneConnection { -- each node should have only one neighbour
    all n1, n2: Node |
        lone weight: Int | n1->n2->weight in edges
}

pred positiveWeights { -- all node weights are positive 
    all integers: {i: Int | some n1, n2: Node | n1->n2->i in edges} {
        integers > 0
    }
}

pred wellFormed { -- predicates for wellfromed
    connected
    undirected
    noSelfNeighbour
    oneConnection
    positiveWeights
}

pred initState[s: State] { -- initial state conditions
    s.seen = Start.start
    no s.chosen
}

pred finalState[s: State] { -- final state conditions
    -- if reachable node then it is in s.seen

    all n: Node {
        reachable[n, Start.start, edges.Int] implies (n in s.seen) -- reachable implies seen
    }
}

pred transitionSteps[pre, post: State] {
    pre.next = post -- establish the relations between pre and post
    pre.seen = {Node} => { -- if every node is seen then nothing should change
        pre.seen = post.seen
        pre.chosen = post.chosen
    } else {
        -- intersecting nodes between seen and unseen nodes
        let connectedEdges = {n1, n2: Node, weight: Int | { 
            n1 in pre.seen
            n2 not in pre.seen
            n1->n2->weight in edges
        }} |  

        -- get the min of the set of all weights between the n1 and n2 in connected_edges
        let minimumWeight = min[{i: Int | {some n1, n2: Node | n1->n2->i in connectedEdges}}] |

        -- get the minimum edge
        let minimumEdge = {n1, n2: Node, weight: Int | {
                n1->n2->weight in connectedEdges
                weight = minimumWeight
            }
        } | some oldNode, newNode: Node | {
            // old node should be the node connected to the minimum weight and in seen
            // new node should be the node connected to the minimum weight and not in seen
            // update seen and chosen to include the new node and edge respectively
            oldNode->newNode->minimumWeight in minimumEdge
            post.seen = pre.seen + newNode
            post.chosen = pre.chosen + oldNode->newNode->minimumWeight
        }
    }
}

pred transitionStates {
    some start, final: State {
        initState[start] -- start is the initial state
        finalState[final] -- final is the final state

        -- establishing the middle steps from initial to final
        all s: State | {
            s.next != start
            no final.next
            s != start implies reachable[s, start, next]
            s != final implies transitionSteps[s, s.next]
        }
    }
}

run {
    wellFormed
    transitionStates
} for exactly 5 Node, exactly 5 State, exactly 1 Start for {next is linear}