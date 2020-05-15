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
    	puts "index: $index x: $rowX y: $rowY"
        $n($index) set X_ $rowX
        $n($index) set Y_ $rowY
        set rowX [expr {$rowX + $colsize}]
    }
    set rowY [expr {$rowY + $rowsize}]
}

