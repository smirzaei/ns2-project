array set udp_connections {
	0 33
	1 32
	2 31
	3 30
	4 29
	5 28
	6 27
	7 26
	8 26
	9 27
	10 28
	11 31
}

set i 0
foreach udp_origin [array names udp_connections] {
	set udp_dest $udp_connections($udp_origin)
	
	set interval [gen_rand_interval]
	puts "Connecting UDP node: $udp_origin to node: $udp_dest interval: $interval"
	
	set _udp [new Agent/UDP]
	$_udp set fid_ 1
	set udp($i) $_udp
	$ns attach-agent $n($udp_origin) $_udp
	
	set _null [new Agent/Null]
	set null($i) $_null
	$ns attach-agent $n($udp_dest) $_null
	
	set _cbr [new Application/Traffic/CBR]
	set cbr($i) $_cbr
	
	$_cbr set packet_size_ 2048
	$_cbr set interval_ 0.2
	$_cbr attach-agent $_udp

	$ns connect $_udp $_null
	
	incr i
}
set n_cbr_connections $i

array set tcp_connections {
	0 33
	1 26
	2 27
	3 31
	4 28
	5 29
	6 28
	7 30
	8 31
	9 26
	10 32
	11 33
}

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

array set delayed_tcp_connections {
	20 30
	20 31
	20 32
	20 33
	21 26
	21 27
	21 28
	21 29
}
set i 0
foreach tcp_origin [array names delayed_tcp_connections] {
	set tcp_dest $delayed_tcp_connections($tcp_origin)
	
	puts "Connecting TCP (delayed) node: $tcp_origin to node: $tcp_dest"
	
	set _tcp [new Agent/TCP]
	$_tcp set fid_ 2
	set tcp_delayed($i) $_tcp
	$ns attach-agent $n($tcp_origin) $_tcp
	
	set _sink [new Agent/TCPSink]
	set sink_delayed($i) $_sink
	$ns attach-agent $n($tcp_dest) $_sink
	
	set _ftp [new Application/FTP]
	set ftp_delayed($i) $_ftp

	$_ftp attach-agent $_tcp
	$_ftp set type_ FTP

	$ns connect $_tcp $_sink
	
	incr i
}
set n_ftp_delayed_connections $i

array set delayed_udp_connections {
	20 30
	20 31
	20 32
	20 33
	21 26
	21 27
	21 28
	21 29
}
set i 0
foreach udp_origin [array names delayed_udp_connections] {
	set udp_dest $delayed_udp_connections($udp_origin)
	
	set interval [gen_rand_interval]
	puts "Connecting UDP (delayed) node: $udp_origin to node: $udp_dest interval: $interval"
	
	set _udp [new Agent/UDP]
	$_udp set fid_ 1
	set udp_delayed($i) $_udp
	$ns attach-agent $n($udp_origin) $_udp
	
	set _null [new Agent/Null]
	set null_delayed($i) $_null
	$ns attach-agent $n($udp_dest) $_null
	
	set _cbr [new Application/Traffic/CBR]
	set cbr_delayed($i) $_cbr
	
	$_cbr set packet_size_ 4096
	$_cbr set interval_ 0.1
	$_cbr attach-agent $_udp

	$ns connect $_udp $_null
	
	incr i
}
set n_delayed_cbr_connections $i

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

proc start_delayed_traffic {} {
	global ftp_delayed cbr_delayed n_ftp_delayed_connections n_delayed_cbr_connections

	for {set i 0} {$i < $n_delayed_cbr_connections} {incr i} {
		puts "start CBR (delayed) traffic: $i"
		$cbr_delayed($i) start
	}

	for {set i 0} {$i < $n_ftp_delayed_connections} {incr i} {
		puts "start FTP (delayed) traffic: $i"
		$ftp_delayed($i) start
	}
}

proc stop_traffic {} {
	global n_ftp_connections n_cbr_connections n_ftp_delayed_connections cbr ftp ftp_delayed cbr_delayed n_delayed_cbr_connections
	
	for {set i 0} {$i < $n_cbr_connections} {incr i} {
		puts "stop CBR traffic: $i"
		$cbr($i) stop
	}
	
	for {set i 0} {$i < $n_ftp_connections} {incr i} {
		puts "stop FTP traffic: $i"
		$ftp($i) stop
	}
	
	for {set i 0} {$i < $n_ftp_delayed_connections} {incr i} {
		puts "stop FTP (delayed) traffic: $i"
		$ftp_delayed($i) stop
	}
	
	for {set i 0} {$i < $n_delayed_cbr_connections} {incr i} {
		puts "stop CBR (delayed) traffic: $i"
		$cbr_delayed($i) stop
	}
}

