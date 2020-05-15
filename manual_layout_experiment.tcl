set ns [new Simulator]

set f [open out.tr w]
$ns trace-all $f

set nf [open out.nam w]
$ns namtrace-all $nf

set row_y {
	0 300
	1 280
	2 250
	3 220
	4 170
	5 140
	6 110
	7 90
	8 80
	
}

set node_layout {
	0 {row 0 x 10 color red shape circle name "server 0-0"}
	1 {row 0 x 60 color red shape circle name "server 0-1"}
	
	2 {row 0 x 140 color red shape circle name "server 1-0"}
	3 {row 0 x 190 color red shape circle name "server 1-1"}

	4 {row 0 x 270 color red shape circle name "server 2-0"}
	5 {row 0 x 320 color red shape circle name "server 2-1"}

	6 {row 0 x 400 color red shape circle name "server 3-0"}
	7 {row 0 x 450 color red shape circle name "server 3-1"}
	
	
	8 {row 1 x 35 color red shape square name "access-switch 0"}
	9 {row 1 x 165 color red shape square name "access-switch 1"}
	
	10 {row 1 x 295 color red shape square name "access-switch 2"}
	11 {row 1 x 425 color red shape square name "access-switch 3"}
	
	12 {row 2 x 100 color purple shape hexagon name "aggregation 0"}
	13 {row 2 x 360 color purple shape hexagon name "aggregation 1"}
	
	14 {row 3 x 230 color purple shape hexagon name "core 0"}
	
	15 {row 4 x 230 color black shape circle name "markaz ostan"}
	
	16 {row 5 x 115 color black shape circle name "moavenat asli"}
	17 {row 5 x 345 color black shape circle name "markaz takhasosi"}
	
	18 {row 7 x 95 color blue shape square name "end 0"}
	19 {row 6 x 210 color blue shape square name "end 1"}
	20 {row 6 x 250 color blue shape square name "end 2"}
	21 {row 7 x 365 color blue shape square name "end 3"}
}


dict for {node_id node_info} $node_layout {
	set row_id [dict get $node_info row]
	set node_x [dict get $node_info x]
	set node_y [dict get $row_y $row_id]
	set color [dict get $node_info color]
	set shape [dict get $node_info shape]
	
	puts "Creating a node @ ($node_x, $node_y) - color: $color - shape: $shape"
	
	set node [$ns node]
	$node color $color
	$node shape $shape
	
	$node set X_ $node_x
	$node set Y_ $node_y
	
	set n($node_id) $node
}

proc make_connection {main_node other_nodes bw delay} {
	global ns n
	foreach h $other_nodes {
		$ns duplex-link $n($h) $n($main_node) $bw $delay DropTail
	}
}

#$ns duplex-link $n(18) $n(16) 10Mb 10ms DropTail
$ns duplex-link $n(16) $n(14) 10Mb 10ms DropTail
$ns duplex-link-op $n(16) $n(14) orient right-up
#$ns duplex-link-op $n(18) $n(16) orient right-up

#set _ [make_connection 16 {18} 10Mb 10ms]
set _ [make_connection 15 {19 20} 10Mb 10ms]
set _ [make_connection 17 {21} 10Mb 10ms]



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

