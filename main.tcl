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


######################
set end_users {0 1 2 3 4 5 6 7 8 9 10 11}
set servers {26 27 28 29 30 31 32 33}

set indexLayout {
    {0 1 2 3 4 5 6 7 8 9 10 11}
    {12 13 14 15}
    {34 16 17 18}
    {19}
    {20 21}
    {22 23 24 25}
    {26 27 28 29 30 31 32 33}
}

set counter 0
foreach row $indexLayout {
	foreach col $row {
		set n($counter) [$ns node]
		incr counter
	}
}

proc make_connection {main_node other_nodes bw delay} {
	global ns n
	foreach h $other_nodes {
		$ns duplex-link $n($h) $n($main_node) $bw $delay DropTail
	}
}

set switches {12 13 14 15 22 23 24 25}
foreach sw $switches {
	$n($sw) shape square
}

set blue_nodes {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
foreach bn $blue_nodes {
	$n($bn) color blue
}

set red_nodes {19 20 21}
foreach rn $red_nodes {
	$n($rn) color red
}

set purple_nodes {22 23 24 25 26 27 28 29 30 31 32 33}
foreach pn $purple_nodes {
	$n($pn) color purple
}

set _ [make_connection 12 {0 1 2} 1Mb 10ms]
set _ [make_connection 13 {3 4 5} 1Mb 10ms]
set _ [make_connection 14 {6 7 8} 1Mb 10ms]
set _ [make_connection 15 {9 10 11} 1Mb 10ms]

set _ [make_connection 34 {12} 1Mb 10ms]
set _ [make_connection 17 {13 14} 1Mb 10ms]
set _ [make_connection 18 {15} 1Mb 10ms]

set _ [make_connection 19 {34 17 18 20 21} 1Mb 10ms]
set _ [make_connection 19 {34 17 18} 1Mb 10ms]

set _ [make_connection 20 {21 22 23} 1Mb 10ms]
set _ [make_connection 21 {24 25} 1Mb 10ms]

set _ [make_connection 22 {26 27} 1Mb 10ms]
set _ [make_connection 23 {28 29} 1Mb 10ms]
set _ [make_connection 24 {30 31} 1Mb 10ms]
set _ [make_connection 25 {32 33} 1Mb 10ms]

# Bottom switches to mid router

# Describe the space we're going to lay them out over; you might need to tune this
set originX 0
set originY 0
set width   300
set height  400

# Do the layout
set nRows [llength $indexLayout]
set rowsize [expr {$height / $nRows}]
set rowY [expr {$originY + $rowsize / 2}]
foreach row $indexLayout {
    set nCols [llength $row]
    set colsize [expr {$width / $nCols}]
    set rowX [expr {$originX + $colsize / 2}]
    foreach index $row {
        $n($index) set X_ $rowX
        $n($index) set Y_ $rowY
        set rowX [expr {$rowX + $colsize}]
    }
    set rowY [expr {$rowY + $rowsize}]
}

##################################

##################################
### Traffic
##################################
#array set udp_origin {0 3 6 9}
#set udp_dest {27 29 31 33}
#set i 0

#puts $udp_origin(2)

array set udp_connections {
	0 33
	3 31
	8 28
	11 26
}

array set tcp_connections {
	1 26
	2 27
	4 28
	5 29
	7 30
	8 31
	10 32
	11 33
}

set i 0
foreach udp_origin [array names udp_connections] {
	set udp_dest $udp_connections($udp_origin)
	
	puts "Connecting UDP node: $udp_origin to node: $udp_dest"
	
	set _udp [new Agent/UDP]
	$_udp set fid_ 1
	set udp($i) $_udp
	$ns attach-agent $n($udp_origin) $_udp
	
	set _null [new Agent/Null]
	set null($i) $_null
	$ns attach-agent $n($udp_dest) $_null
	
	set _cbr [new Application/Traffic/CBR]
	set cbr($i) $_cbr
	
	$_cbr set packet_size_ 64
	$_cbr set interval_ 0.05
	$_cbr attach-agent $_udp

	$ns connect $_udp $_null
	
	incr i
}
set n_cbr_connections $i

set i 0
foreach tcp_origin [array names tcp_connections] {
	set tcp_dest $tcp_connections($tcp_origin)
	
	puts "Connecting TCP node: $tcp_origin to node: $tcp_dest"
	
	set _tcp [new Agent/TCP]
	$_tcp set fid_ 2
	set tcp($i) $_tcp
	$ns attach-agent $n($tcp_origin) $_tcp
	
	set _sink [new Agent/TCPSink]
	set sink($i) $_sink
	$ns attach-agent $n($tcp_dest) $_sink
	
	set _ftp [new Application/FTP]
	set ftp($i) $_ftp
	
#	$_ftp set packet_size_ 256
#	$_ftp set interval_ 0.01
	$_ftp attach-agent $_tcp
	$_ftp set type_ FTP

	$ns connect $_tcp $_sink
	
	incr i
}
set n_ftp_connections $i

proc start_traffic {} {
	global n_ftp_connections n_cbr_connections cbr ftp
	
	for {set i 0} {$i < $n_cbr_connections} {incr i} {
		puts "start CBR traffic: $i"
		$cbr($i) start
	}

	for {set i 0} {$i < $n_ftp_connections} {incr i} {
		puts "start FTP traffic: $i"
		$ftp($i) start
	}
}



proc stop_traffic {} {
	global n_ftp_connections n_cbr_connections cbr ftp
	
	for {set i 0} {$i < $n_cbr_connections} {incr i} {
		puts "stop CBR traffic: $i"
		$cbr($i) stop
	}
	
		for {set i 0} {$i < $n_ftp_connections} {incr i} {
		puts "stop FTP traffic: $i"
		$ftp($i) stop
	}
}

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
$ns at 9.0 "stop_traffic"
$ns at 10.0 "finish"

$ns run
