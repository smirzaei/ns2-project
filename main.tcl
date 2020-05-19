# http://nile.wpi.edu/NS/simple_ns.html

set ns [new Simulator]

set f [open out.tr w]
$ns trace-all $f

set nf [open out.nam w]
$ns namtrace-all $nf

$ns color 1 Red
$ns color 2 Blue
$ns color 3 Yellow
$ns color 4 Purple

source "util.tcl"
source "greencloud_layout.tcl"
source "connection.tcl"
source "traffic.tcl"

proc finish {} {
    puts "Finishing..."
    global ns f nf
    $ns flush-trace
    close $f
    close $nf
    
    puts "Opening NAM"
    exec nam out.nam &
    exit 0
}

$ns at 0.1 "start_traffic"
$ns at 0.55 "start_delayed_traffic"
$ns at 9.0 "stop_traffic"
$ns at 10.0 "finish"

$ns run
