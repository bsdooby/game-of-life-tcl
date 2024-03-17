#!/usr/bin/env wish

package require Tk

set gridSize 70
set cellSize 5 

tk::canvas .canvas -width [expr $gridSize * $cellSize - 1] -height [expr $gridSize * $cellSize -1]  -background white
pack .canvas

set k 0
set l 0
for {set i 0} {$i < [expr $gridSize * $cellSize]} {incr i $cellSize} {
    for {set j 0} {$j < [expr $gridSize * $cellSize]} {incr j $cellSize} {
        .canvas create rectangle [expr $i + 0] [expr $j + 0] [expr $i + $cellSize] [expr $j + $cellSize] \
            -fill white -outline black -tags "x:$k;y:$l"
        incr l
    }
    set l 0
    incr k
}

# 
.canvas itemconfigure "x:69;y:69" -fill black

# EOF

