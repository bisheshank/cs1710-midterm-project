#lang forge

open "mst2.frg"

test suite for wellFormed {
    example validState is wellFormed for {
        State = `S0
        Node = `Node0 + `Node1 + `Node2
        Start = `Start0
        edges = `Node0->`Node1->1 +
                `Node1->`Node2->2 +
                `Node0->`Node2->3
        seen = `Node0
    }
}