#lang forge

open "mst2.frg"

pred isSpanning[s: State] {
  s.seen = {Node} -- all nodes are in seen
  #{s.chosen} = #{Node} - 1 -- #edges = #nodes - 1
  all n1, n2: Node | -- any two nodes are reachable in any two nodes
    reachable[n1, n2, edges.Int]
}

test expect {
  -- checking if transition holds
  canTransition: {
    some pre, post: State | {
      pre.next = post
      transitionSteps[pre, post]
    } 
  } is sat

  -- checking if final graph is spanning
  finalStep: {
    some pre, post: State | {
      pre.next = post
      transitionSteps[pre, post]
      finalState[post]
      isSpanning[post]
    }
  } is sat

  --vacuity check
  vacuous: {wellFormed} is sat

  -- transitionStates check
  transitionStatesCheck: {
    wellFormed
    transitionStates
  } is sat
}

test suite for wellFormed {
  -- one node graph
  example validOneNode is {wellFormed} for {
    -- only one node
    State = `S0
    Node = `Node0
    Start = `Start0
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0
  }

  example validState is {wellFormed} for {
    -- well connected graph of 3 nodes
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1
  }

  example negativeWeight is not {wellFormed} for {
    -- negative weight
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> -1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1
  }

  example selfNeighbour is not {wellFormed} for {
    -- self neighbour
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node0 -> 4 +
        `Node0 -> `Node1 -> 1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1
  }

  example unConnected is not {wellFormed} for {
    -- not well connected graph of 3 nodes
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node1 -> `Node0 -> 1
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1
  }

  example unDirected is not {wellFormed} for {
    -- not an undirected graph, only one edge
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1
  }
}

test suite for transitionSteps {
  example validTransitionSteps is {some s1, s2: State | transitionSteps[s1, s2]} for {
    -- an example of a valid transition step taken
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1
  }

  example invalidTransitionSteps is not {some s1, s2: State | transitionSteps[s1, s2]} for {
    -- does not choose the minimum edge
    State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node2
    chosen = `S1 -> `Node0 -> `Node2 -> 2
  }
}

test suite for initState {
  example validInitState is {some s: State | initState[s]} for {
    -- valid Initial State for an undirected wellconnected graph
     State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0
  }
}

test suite for finalState {
  example validFinalState is {some s: State | finalState[s]} for {
    -- valid final step for an MST
    State = `S0 + `S1
    Node = `Node0 + `Node1
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node1 -> `Node0 -> 1
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0 + `S1 -> `Node0 + `S1 -> `Node1
    chosen = `S1 -> `Node0 -> `Node1 -> 1   
  }

  example invalidFinalState is not {some s: State | finalState[s]} for {
     State = `S0 + `S1
    Node = `Node0 + `Node1 + `Node2
    Start = `Start0
    next = `S0 -> `S1
    edges = `Node0 -> `Node1 -> 1 +
        `Node0 -> `Node2 -> 2 +
        `Node1 -> `Node0 -> 1 +
        `Node1 -> `Node2 -> 3 +
        `Node2 -> `Node0 -> 2 +
        `Node2 -> `Node1 -> 3
    start = `Start0 -> `Node0
    seen = `S0 -> `Node0
  }
}
