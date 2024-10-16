# Create a simulator object
set ns [new Simulator]

 # Open the nam file basic1.nam and the variable-trace file basic1.tr
set namfile [open basic1.nam w]
$ns namtrace-all $namfile

set tracefileWestwood [open "westwood_trace.tr" w]
set tracefileNewReno [open "newreno_trace.tr" w]

$ns trace-all $tracefileWestwood

# Define a 'finish' procedure
proc finish {} {
    global ns namfile tracefileWestwood tracefileNewReno
    $ns flush-trace

    close $namfile
    close $tracefileWestwood
    close $tracefileNewReno

    # Execute NAM on the trace file
    exec nam basic1.nam &
    exec awk -f Throughput.awk westwood_trace.tr &
    exit 0
}

# Create the network nodes
set A [$ns node]
set R [$ns node]
set B [$ns node]

# Create a duplex link between the nodes
$ns duplex-link $A $R 10Mb 10ms DropTail
$ns duplex-link $R $B 800Kb 50ms DropTail

# The queue size at $R is to be 7, including the packet being sent
$ns queue-limit $R $B 7

# some hints for nam
# color packets of flow 0 red
$ns color 0 Red
$ns duplex-link-op $A $R orient right-down
$ns duplex-link-op $B $R orient left-down
$ns duplex-link-op $R $B queuePos 0.5

# Create a TCP sending agent (TCP Westwood) and attach it to A
set tcpWestwood [new Agent/TCP]
$tcpWestwood set class_ 0
$tcpWestwood set window_ 100
$tcpWestwood set packetSize_ 960
$ns attach-agent $A $tcpWestwood

# Let's trace some variables
$tcpWestwood attach $tracefileWestwood
$tcpWestwood tracevar cwnd_
$tcpWestwood tracevar ssthresh_
$tcpWestwood tracevar ack_
$tcpWestwood tracevar maxseq_

# Create a TCP receive agent (a traffic sink) and attach it to B
set end0 [new Agent/TCPSink]
$ns attach-agent $B $end0

# Connect the traffic source with the traffic sink
$ns connect $tcpWestwood $end0

# Schedule the connection data flow; start sending data at T=0, stop at T=10.0
set myftp [new Application/FTP]
$myftp attach-agent $tcpWestwood
$ns at 0.0 "$myftp start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource outfile} {
    global ns
    set now [$ns now]
    set cwnd [$tcpSource set cwnd_]

    # the data is recorded in a file called congestion.xg (this can be plotted 
    # using xgraph or gnuplot. this example uses xgraph to plot the cwnd_
    puts $outfile "$now $cwnd"
    $ns at [expr $now+0.1] "plotWindow $tcpSource $outfile"
}

set outfileWestwood [open "westwood_cwnd.xg" w]
$ns at 0.0 "plotWindow $tcpWestwood $outfileWestwood"
$ns at 10.1 "exec xgraph -delay 1 -lw 2 -geometry 800x400 westwood_cwnd.xg"

# Repeat the above steps for TCP New Reno

# Create a TCP sending agent (TCP New Reno) and attach it to A
set tcpNewReno [new Agent/TCP/Newreno]
$tcpNewReno set class_ 1
$tcpNewReno set window_ 100
$tcpNewReno set packetSize_ 960
$ns attach-agent $A $tcpNewReno

# Let's trace some variables
$tcpNewReno attach $tracefileNewReno
$tcpNewReno tracevar cwnd_
$tcpNewReno tracevar ssthresh_
$tcpNewReno tracevar ack_
$tcpNewReno tracevar maxseq_

# Create a TCP receive agent (a traffic sink) and attach it to B
set end1 [new Agent/TCPSink]
$ns attach-agent $B $end1

# Connect the traffic source with the traffic sink
$ns connect $tcpNewReno $end1

# Schedule the connection data flow; start sending data at T=0, stop at T=10.0
set myftp1 [new Application/FTP]
$myftp1 attach-agent $tcpNewReno
$ns at 0.0 "$myftp1 start"
$ns at 10.0 "finish"

set outfileNewReno [open "newreno_cwnd.xg" w]
$ns at 0.0 "plotWindow $tcpNewReno $outfileNewReno"
$ns at 10.1 "exec xgraph -delay 1 -lw 2 -geometry 800x400 newreno_cwnd.xg"

# Run the simulation
$ns run
