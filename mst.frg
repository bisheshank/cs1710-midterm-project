#lang forge

sig Node {}

sig Edge { 
  weight: one Int,
  node1: one Node,
  node2: one Node
}

sig Step {
  next: lone Step,
  chosen_nodes: set Node,
  chosen_edges: set Edge
}

pred validEdges {
  -- positive edge weights
  all e: Edge | e.weight > 0
  -- no self edges
  all e: Edge | e.node1 != e.node2
  -- no duplicate edges
  all disj e1, e2: Edge | {
    not (e1.node1 = e2.node1 and e1.node2 = e2.node2)
    not (e1.node2 = e2.node1 and e1.node1 = e2.node2)
  }
}

-- Choose one node to start with
pred init[s: Step] {
  one s.chosen_nodes
  no s.chosen_edges
}

-- In current step, edge has one node selected and one not
pred possibleNewEdge[s: Step, e: Edge] {
  (e.node1 in s.chosen_nodes and e.node2 not in s.chosen_nodes)
  or (e.node2 in s.chosen_nodes and e.node1 not in s.chosen_nodes)
}

pred nextStep[s1, s2: Step] {
  some e: Edge | {
    possibleNewEdge[s1, e]
    -- Edge should be of minimum weight
    all e2: Edge |
      possibleNewEdge[s1, e2] implies e.weight <= e2.weight
    
    -- Next step should have new edge and node
    s2.chosen_edges = s1.chosen_edges + e
    s2.chosen_nodes = s1.chosen_nodes + e.node1 + e.node2
  }
}

pred traces {
  validEdges
  
  some first_step, last_step: Step | {
    init[first_step]
    no s: Step | s.next = first_step
    no last_step.next
    
    -- All sequential steps should satisfy nextStep
    all s: Step | s != last_step implies nextStep[s, s.next]

    -- Last step should include all nodes
    -- (Implies that graph should be fully connected)
    all n: Node | n in last_step.chosen_nodes
  }
}

-- Note:
-- The number of steps needs to be exactly the number of nodes
run {traces}
for 4 Int, exactly 5 Node, exactly 5 Step, exactly 7 Edge 
for {next is linear}


/*
To do:
- Write tests?
  - Is resulting tree minimal? (Don't think this is possible in Forge but manual tests can be written I suppose)
  - Is resulting tree spanning
  - Is resulting tree fully connected?
  - Are there multiple different spanning trees
  - Weird cases?
    - No nodes?
    - More edges than there should be?
    - Less edges than there should be?
  - Cases where wellformedness does not hold between steps?
*/