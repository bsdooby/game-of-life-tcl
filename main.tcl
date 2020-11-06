#!/usr/bin/env tclsh

package require Tk

proc moore {cell} {
  
    lassign [split $cell -] _ x y
    puts "{$x $y} ->"

    set ne nonewline

    # north
    puts -$ne "{[expr $x-1] [expr $y+0]}"

    # northeast
    puts -$ne "{[expr $x-1] [expr $y+1]}"
    
    # east
    puts -$ne "{[expr $x-0] [expr $y+1]}"

    # southeast
    puts -$ne "{[expr $x+1] [expr $y+1]}"
    
    # south
    puts -$ne "{[expr $x+1] [expr $y+0]}"
    
    # southwest
    puts -$ne "{[expr $x+1] [expr $y-1]}"
    
    # west
    puts -$ne "{[expr $x-0] [expr $y-1]}"
    
    # northwest
    puts "{[expr $x-1] [expr $y-1]}"
}

ttk::style configure Dead.TFrame -background white -borderwidth 0.5 -relief sunken
ttk::style configure Alive.TFrame -background black -borderwidth 0.5 -relief sunken
ttk::style configure Moore.TFrame -background blue -borderwidth 0.5 -relief sunken

set cellSize 5
set gridSpace 50

set frameList [list]
for {set i 0} {$i < $gridSpace} {incr i} {
    lappend frameList [list] 
    for {set j 0} {$j < $gridSpace} {incr j} {
        lset frameList $i end+1 [ttk::frame .cell-$i-$j -width $cellSize -height $cellSize -style Dead.TFrame]
        
        #ttk::frame .cell-$i-$j -padding 5 -relief sunken -width 10 -height 10 
        #grid .cell-$i-$j -row $i -column $j
    }
}


if 0 {
    set i 0
    set j 0
    foreach l $frameList {
        foreach c $l {
            grid $c -row $i -column $j
            incr j
        }
        incr i
        set j 0
    }
}

foreach l $frameList {
    foreach c $l {
        moore $c
    }
}

#set cell [lindex $frameList 0 3]]
#$cell configure -style Alive.TFrame

