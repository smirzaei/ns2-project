proc make_connection {main_node other_nodes bw delay} {
	global ns n
	foreach h $other_nodes {
		$ns duplex-link $n($h) $n($main_node) $bw $delay DropTail
	}
}

set _ [make_connection 12 {0 1 2} 10Mb 10ms]
set _ [make_connection 13 {3 4 5} 10Mb 10ms]
set _ [make_connection 14 {6 7 8} 10Mb 10ms]
set _ [make_connection 15 {9 10 11} 10Mb 10ms]

set _ [make_connection 34 {12} 10Mb 10ms]
set _ [make_connection 17 {13 14} 10Mb 10ms]
set _ [make_connection 18 {15} 10Mb 10ms]

set _ [make_connection 19 {34 17 18} 10Mb 10ms]
set _ [make_connection 19 {20 21} 10Mb 10ms]

set _ [make_connection 20 {21 22 23} 10Mb 10ms]
set _ [make_connection 21 {24 25} 10Mb 10ms]

set _ [make_connection 22 {26 27} 10Mb 10ms]
set _ [make_connection 23 {28 29} 10Mb 10ms]
set _ [make_connection 24 {30 31} 10Mb 10ms]
set _ [make_connection 25 {32 33} 10Mb 10ms]

