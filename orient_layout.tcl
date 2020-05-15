set ns [new Simulator]

set f [open out.tr w]
$ns trace-all $f

set nf [open out.nam w]
$ns namtrace-all $nf

set n_servers_per_rack 2
set n_racks 4
set n_access_layer_nodes 2
set n_core_layer_nodes 1
set n_middle_layer_nodes 3
set n_end_switches 4
set n_host_per_end_switch 3

set node_layout {
	0 {color red shape circle name "server 0-0"}
	1 {color red shape circle name "server 0-1"}
	
	2 {color red shape circle name "server 1-0"}
	3 {color red shape circle name "server 1-1"}

	4 {color red shape circle name "server 2-0"}
	5 {color red shape circle name "server 2-1"}

	6 {color red shape circle name "server 3-0"}
	7 {color red shape circle name "server 3-1"}
	
	
	8 {color red shape square name "access-switch 0"}
	9 {color red shape square name "access-switch 1"}
	
	10 {color red shape square name "access-switch 2"}
	11 {color red shape square name "access-switch 3"}
	
	12 {color purple shape hexagon name "aggregation 0"}
	13 {color purple shape hexagon name "aggregation 1"}
	
	14 {color purple shape hexagon name "core 0"}
	
	15 {color black shape circle name "markaz ostan"}
	
	16 {color black shape circle name "moavenat asli"}
	17 {color black shape circle name "markaz takhasosi"}
	
	18 {color blue shape square name "end 0"}
	19 {color blue shape square name "end 1"}
	20 {color blue shape square name "end 2"}
	21 {color blue shape square name "end 3"}
	
	22 {color blue shape circle name "end 0-0"}
	23 {color blue shape circle name "end 0-1"}
	24 {color blue shape circle name "end 0-2"}
	
	25 {color blue shape circle name "end 1-0"}
	26 {color blue shape circle name "end 1-1"}
	27 {color blue shape circle name "end 1-2"}
	
	28 {color blue shape circle name "end 2-0"}
	29 {color blue shape circle name "end 2-1"}
	30 {color blue shape circle name "end 2-2"}

	31 {color blue shape circle name "end 3-0"}
	32 {color blue shape circle name "end 3-1"}
	33 {color blue shape circle name "end 3-2"}

}

set connection_layout {
	0 {from 0 to 8 orient left-up}
	1 {from 1 to 8 orient right-up}
	
	2 {from 2 to 9 orient left-up}
	3 {from 3 to 9 orient right-up}
	
	4 {from 4 to 10 orient left-up}
	5 {from 5 to 10 orient right-up}
	
	6 {from 6 to 11 orient left-up}
	7 {from 7 to 11 orient right-up}
	
	8 {from 8 to 12 orient left-up}
	9 {from 9 to 12 orient right-up}
	10 {from 10 to 13 orient left-up}
	11 {from 11 to 13 orient right-up}
	12 {from 12 to 14 orient left-up}
	13 {from 13 to 14 orient right-up}
	14 {from 13 to 12 orient right}
	15 {from 14 to 15 orient right-up}
	16 {from 14 to 16 orient up}
	17 {from 14 to 17 orient left-up}
	18 {from 15 to 22 orient right-up}
	19 {from 15 to 23 orient up}
	20 {from 15 to 24 orient left-up}
	21 {from 19 to 25 orient right-up}
	22 {from 19 to 26 orient up}
	23 {from 19 to 27 orient left-up}
	24 {from 20 to 28 orient right-up}
	25 {from 20 to 29 orient up}
	26 {from 20 to 30 orient left-up}
	27 {from 21 to 31 orient right-up}
	28 {from 21 to 32 orient up}
	29 {from 21 to 33 orient left-up}
}

dict for {node_id node_info} $node_layout {
	set color [dict get $node_info color]
	set shape [dict get $node_info shape]
	
	puts "Creating a node color: $color - shape: $shape"
	
	set node [$ns node]
	$node color $color
	$node shape $shape
	
	set n($node_id) $node
}

dict for {index con} $connection_layout {
	set from [dict get $con from]
	set to [dict get $con to]
	set orient [dict get $con orient]
	
	puts "Connecting $from-$to @ $orient"
	
	$ns duplex-link $n($to) $n($from) 10Mb 10ms DropTail
	$ns duplex-link-op $n($to) $n($from) orient $orient
}

#$ns duplex-link $n(2) $n(0) 10Mb 10ms DropTail
#$ns duplex-link-op $n(2) $n(0) orient left-up

#$ns duplex-link $n(2) $n(1) 10Mb 10ms DropTail
#$ns duplex-link-op $n(2) $n(1) orient right-up


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

$ns at 1 "finish"

$ns run

