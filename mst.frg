#lang forge

sig Step {
  next: lone Step,
  chosen_nodes: set Node,
  chosen_edges: set Edge
}

sig Node {}

sig Edge { 
  weight: one Int,
  node1: one Node,
  node2: one Node
}

pred validEdge {
  -- positive edge weights
  all e: Edge | e.weight >= 0
  -- no self nodes
  all e: Edge | e.node1 != e.node2
  -- no duplicate nodes
  all disj e1, e2: Edge | {
    not (e1.node1 = e2.node1 and e1.node2 = e2.node2)
    not (e1.node2 = e2.node1 and e1.node1 = e2.node2)
  }
}

pred init[s: Step] {
  one s.chosen_nodes
  no s.chosen_edges
}

pred nextStep[s1, s2: Step] {
  some n: Node | {
    n not in s2.chosen_nodes
    s2.chosen_nodes = (s1.chosen_nodes + n)
  }
}

pred traces {
  validEdge
  
  some first_step, last_step: Step | {
    init[first_step]
    no s: Step | s.next = first_step
    no last_step.next
    no last_step.chosen_nodes
    no last_step.chosen_edges
    
    // all s: Step | s != last_step implies {
    //   nextStep[s, s.next]
    // }
  }
  
  // all s1, s2: Step | {
  //   s1.next = s2 implies nextStep[s1, s2]
  // }
}

run {traces} for {next is linear}
