#lang forge

open "mst.frg"


test suite for validEdges {
  example noEdges is validEdges for {
    Edge = none
  }

  example weirdEdge is not validEdges for {
    Node = `Node0
    Edge = `Edge0
  }

  example selfEdge is not validEdges for {
    Node = `Node0
    Edge = `Edge0
    weight = `Edge0 -> 6
    node1 = `Edge0 -> `Node0
    node2 = `Edge0 -> `Node0
  }

  example positiveEdge is validEdges for {
    Node = `Node0 + `Node1
    Edge = `Edge0
    weight = `Edge0 -> 6
    node1 = `Edge0 -> `Node0
    node2 = `Edge0 -> `Node1
  }

  example negativeEdge is not validEdges for {
    Node = `Node0 + `Node1
    Edge = `Edge0
    weight = `Edge0 -> -2
    node1 = `Edge0 -> `Node1
    node2 = `Edge0 -> `Node0
  }

  example duplicateEdge is not validEdges for {
    Node = `Node0 + `Node1
    Edge = `Edge0 + `Edge1
    weight = `Edge0 -> 3 + `Edge1 -> 3
    node1 = `Edge0 -> `Node1 + `Edge1 -> `Node0
    node2 = `Edge0 -> `Node0 + `Edge1 -> `Node1
  }

  example multipleEdges is validEdges for {
    Node = `Node0 + `Node1 + `Node2
    Edge = `Edge0 + `Edge1 + `Edge2
    weight = `Edge0 -> 3 + `Edge1 -> 2 + `Edge2 -> 6
    node1 = `Edge0 -> `Node1 + `Edge1 -> `Node2 + `Edge2 -> `Node0
    node2 = `Edge0 -> `Node0 + `Edge1 -> `Node1 + `Edge2 -> `Node2
  }
}

test suite for init {
  example noNodes is {no s: Step | init[s]} for {
    Node = none
    Edge = none
    Step = `Step0
    next = `Step0 -> none
    chosen_nodes = none -> none
    chosen_edges = none -> none
  }

  example oneNode is {some s: Step | init[s]} for {
    Node = `Node0
    Edge = none
    Step = `Step0
    next = `Step0 -> none
    chosen_nodes = `Step0 -> `Node0
    chosen_edges = none -> none
  }
  
  example sixNodes is {some s: Step | init[s]} for {
    Node = `Node0 + `Node1 + `Node2 + `Node3 + `Node4 + `Node5
    Edge = none
    Step = `Step0
    next = `Step0 -> none
    chosen_nodes = `Step0 -> `Node0
    chosen_edges = none -> none
  }

  example twoNodesChosenEdge is {no s: Step | init[s]} for {
    Node = `Node0 + `Node1
    Edge = `Edge0
    weight = `Edge0 -> 7
    node1 = `Edge0 -> `Node1
    node2 = `Edge0 -> `Node0
    Step = `Step0
    next = `Step0 -> none
    chosen_nodes = `Step0 -> `Node0
    chosen_edges = `Step0 -> `Edge0
  }
}
