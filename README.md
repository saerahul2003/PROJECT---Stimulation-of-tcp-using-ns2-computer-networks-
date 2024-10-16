# NS2 Simulation for TCP Westwood and TCP New Reno

## Problem Statement:

Evaluate the throughput performance of TCP Westwood and TCP New Reno using NS2. This simulation aims to analyze the congestion window evolution and compare the performance of these TCP variants.

## Protocol Explanation:

### 1. TCP (Transmission Control Protocol):

TCP is a core protocol in the Internet Protocol (IP) suite, providing reliable, connection-oriented communication. It ensures data integrity, order, flow control, and congestion control.

#### Key Features:
- Connection-oriented
- Reliability through acknowledgments and retransmission
- Flow control to prevent congestion
- Dynamic congestion control based on network conditions

### 2. TCP New Reno:

TCP New Reno is an enhancement of TCP Reno, focusing on fast recovery and retransmit during congestion events.

#### Key Features:
- Fast Recovery: Allows sending new data during packet loss.
- Fast Retransmit: Retransmits lost packets efficiently.
- Selective Acknowledgments (SACK): Acknowledges out-of-order packets.

### 3. TCP Westwood:

TCP Westwood is designed for wireless networks, incorporating bandwidth estimation for improved performance.

#### Key Features:
- Bandwidth Estimation: Adapts congestion window to available bandwidth.
- Non-persistent Connections: Optimized for wireless networks.
- Aggressive Retransmission: Quickly recovers from packet losses.

## Network Topology:

- Two nodes (node0 and node1) represent entities in the network.
- Duplex link with 10 Mbps bandwidth and 10 ms propagation delay.

## Queue Configuration:

- Drop-tail queue with a 50-packet limit on the link between node0 and node1.

## TCP Variants Configuration:

### TCP New Reno:
- Agent/TCP/NewReno attached to node0.
- Corresponding TCP sink attached to node1.
- FTP application initiated at 0.1 seconds.

### TCP Westwood:
- Agent/TCP/Westwood attached to node1.
- Corresponding TCP sink attached to node0.
- FTP application initiated at 0.5 seconds.

## Traffic Generation:

FTP applications generate traffic, contributing to throughput evaluation.

## Simulation Execution:

- Simulation runs until 5 seconds.
- Congestion window data saved to files (cwnd_newreno.txt and cwnd_westwood.txt).
- xgraph used to plot congestion window evolution.

## Source Code:

### Project.tcl:
- NS2 simulation script creating nodes, links, agents, and running the simulation.
- Congestion window data collection and xgraph plotting.

### Throughput.awk:
- Awk script for calculating latency and throughput from trace files.

## Output:

- Visualization of congestion window evolution.

## Learning Outcomes:

### Knowledge-Based:
- Understanding of NS2 and its role in network simulation.
- Knowledge of TCP variants, specifically TCP Westwood and TCP New Reno.
- Grasp of network simulation concepts like nodes, links, agents, and trace files.

### Skill-Based:
- Scripting skills using Tcl for network simulation.
- Simulation setup using NS2.
- Data analysis through trace files.
- Plotting congestion window evolution using tools like Xgraph.

### Application-Based:
- Performance evaluation of TCP Westwood and TCP New Reno.
- Troubleshooting skills in NS2 simulation scenarios.

### Critical Thinking and Problem-Solving:
- Interpretation of simulation results.
- Exploration and proposal of optimization strategies for TCP performance.

### Communication and Collaboration:
- Effective documentation of simulation scripts, procedures, and results.
- Collaboration through sharing insights, challenges, and solutions with peers or the community.
