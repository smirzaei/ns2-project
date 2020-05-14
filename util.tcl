proc gen_rand {min max} {
    set range [expr {$max - $min + 1}]
    return [expr {$min + int(rand() * $range)}]
}

proc gen_rand_interval {} {
	set rnd [gen_rand 1 10]
	return [expr $rnd * 0.1]
}

