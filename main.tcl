#!/usr/bin/env tclsh

package require Tk

set cellSize 10
set gridSpace 50

wm title . "Game of Life"

proc moore {cell} {
    #set ne nonewline
    
    global gridSpace
    
    lassign [split $cell -] _ x y
    
    set neighbours [list]

    # center cell
    .cell-$x-$y configure -style Center.TFrame
    #update

    if 1 {
        # north
        #puts -$ne "{[expr $x-1] [expr $y+0]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSpace-1 : $x_]
        lappend neighbours .cell-$x_-$y

        # northeast
        #puts -$ne "{[expr $x-1] [expr $y+1]}"
        set y_ [expr $y+1]
        set y_ [expr $y_ > $gridSpace-1 ? 0 : $y_]
        lappend neighbours .cell-$x_-$y_
        
        # east
        #puts -$ne "{[expr $x-0] [expr $y+1]}"
        lappend neighbours .cell-$x-$y_
        
        # southeast
        #puts -$ne "{[expr $x+1] [expr $y+1]}"
        set x_ [expr $x+1]
        set x_ [expr $x_ > $gridSpace-1 ? 0 : $x_]
        lappend neighbours .cell-$x_-$y_
        
        # south
        #puts -$ne "{[expr $x+1] [expr $y+0]}"
        lappend neighbours .cell-$x_-$y
        
        # southwest
        #puts -$ne "{[expr $x+1] [expr $y-1]}"
        set y_ [expr $y-1]
        set y_ [expr $y_ < 0 ? $gridSpace-1 : $y_]
        lappend neighbours .cell-$x_-$y_
        
        # west
        #puts -$ne "{[expr $x-0] [expr $y-1]}"
        lappend neighbours .cell-$x-$y_

        # northwest
        #puts "{[expr $x-1] [expr $y-1]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSpace-1 : $x_]
        lappend neighbours .cell-$x_-$y_
        
        foreach nc $neighbours {
            $nc configure -style Neighbour.TFrame
        }
        update

        after 10 

        foreach nc $neighbours {
            $nc configure -style Dead.TFrame
        }
    }
    .cell-$x-$y configure -style Dead.TFrame
    update
}

ttk::style configure Dead.TFrame -background white -borderwidth 0.5 -relief sunken
ttk::style configure Alive.TFrame -background black -borderwidth 0.5 -relief sunken

ttk::style configure Neighbour.TFrame -background red -borderwidth 0.5 -relief sunken
ttk::style configure Center.TFrame -background green -borderwidth 0.5 -relief sunken

set frameList [list]
for {set i 0} {$i < $gridSpace} {incr i} {
    lappend frameList [list] 
    for {set j 0} {$j < $gridSpace} {incr j} {
        lset frameList $i end+1 [ttk::frame .cell-$i-$j -width $cellSize -height $cellSize -style Dead.TFrame]
        
        # alternative approach to draw the Ui
        #ttk::frame .cell-$i-$j -padding 5 -relief sunken -width 10 -height 10 
        #grid .cell-$i-$j -row $i -column $j
    }
}

if 1 {
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

# the game loop
while {1} {
    foreach l $frameList {
        foreach c $l {
            moore $c
        }
    }
}

