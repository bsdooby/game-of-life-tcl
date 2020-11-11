#!/usr/bin/env tclsh

package require Tk

set gridSize 50 
set cellSize 10
set updateSpeed 1 

#expr {srand(42)}
set seed 180 

set generation 1

ttk::style configure Dead.TFrame -background white -borderwidth 0.5 -relief sunken
ttk::style configure Alive.TFrame -background black -borderwidth 0.5 -relief sunken

ttk::style configure Neighbour.TFrame -background red -borderwidth 0.5 -relief sunken
ttk::style configure Center.TFrame -background green -borderwidth 0.5 -relief sunken

wm title . "Game-of-Life: generation $generation"
wm geometry . +450+0

set frameList [list]

array set currentState {}
array set nextState {}

for {set i 0} {$i < $gridSize} {incr i} {
    lappend frameList [list] 
    for {set j 0} {$j < $gridSize} {incr j} {
        lset frameList $i end+1 [ttk::frame .cell-$i-$j -width $cellSize -height $cellSize -style Dead.TFrame]
        
        set currentState($i,$j) 0 
        set nextState($i,$j) 0 

        # alternative approach to draw the Ui
        #ttk::frame .cell-$i-$j -padding 5 -relief sunken -width 10 -height 10 
        #grid .cell-$i-$j -row $i -column $j
    }
}

proc moore {cell} {
    #set ne nonewline
    
    global gridSize updateSpeed frameList currentState nextState
    
    lassign [split $cell -] _ x y
    
    set neighbours [list]

    # center cell
    #.cell-$x-$y configure -style Center.TFrame
    #update

    set livingNeighbours 0
    if {1} {
        # north
        #puts -$ne "{[expr $x-1] [expr $y+0]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        lappend neighbours .cell-$x_-$y

        # northeast
        #puts -$ne "{[expr $x-1] [expr $y+1]}"
        set y_ [expr $y+1]
        set y_ [expr $y_ > $gridSize-1 ? 0 : $y_]
        lappend neighbours .cell-$x_-$y_
        
        # east
        #puts -$ne "{[expr $x-0] [expr $y+1]}"
        lappend neighbours .cell-$x-$y_
        
        # southeast
        #puts -$ne "{[expr $x+1] [expr $y+1]}"
        set x_ [expr $x+1]
        set x_ [expr $x_ > $gridSize-1 ? 0 : $x_]
        lappend neighbours .cell-$x_-$y_
        
        # south
        #puts -$ne "{[expr $x+1] [expr $y+0]}"
        lappend neighbours .cell-$x_-$y
        
        # southwest
        #puts -$ne "{[expr $x+1] [expr $y-1]}"
        set y_ [expr $y-1]
        set y_ [expr $y_ < 0 ? $gridSize-1 : $y_]
        lappend neighbours .cell-$x_-$y_
        
        # west
        #puts -$ne "{[expr $x-0] [expr $y-1]}"
        lappend neighbours .cell-$x-$y_

        # northwest
        #puts "{[expr $x-1] [expr $y-1]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        lappend neighbours .cell-$x_-$y_
        
        # count'em
        foreach nc $neighbours {
           
            lassign [split $nc -] _ x_ y_

            if {$currentState($x_,$y_) == 1} {
                incr livingNeighbours
            }
        }

        if {0} {
            foreach nc $neighbours {
                $nc configure -style Neighbour.TFrame
            }
            update

            after $updateSpeed

            foreach nc $neighbours {
                $nc configure -style Dead.TFrame
            }
            update
        }

        #puts "cell $x, $y: $cellArray($x,$y), $livingNeighbours"
    
        # rule 1:
	    # Any live cell with two or three live neighbours survives.

        if {$currentState($x,$y) == 1} {
            switch $livingNeighbours {
                2 -
                3 {
                    #.cell-$x-$y configure -style Alive.TFrame
                    set nextState($x,$y) 1
                }
                default {
                    #.cell-$x-$y configure -style Dead.TFrame
                    set nextState($x,$y) 0
                }
            }
       
       # rule 2:
	   # Any dead cell with three live neighbours becomes a live cell.
            
       } else {
            if {$livingNeighbours == 3} {
                #.cell-$x-$y configure -style Alive.TFrame
                set nextState($x,$y) 1
            }
        } 

        # rule 3:
	    # All other live cells die in the next generation. Similarly, all other dead cells stay dead.			
            
        update
    }
    #after $updateSpeed
    #.cell-$x-$y configure -style Dead.TFrame
    #update
}

proc update_ {cell} {

    global currentState nextState

    lassign [split $cell -] _ x y
    set currentState($x,$y) $nextState($x,$y)
    set nextState($x,$y) 0

    if {$currentState($x,$y) == 1} {
        .cell-$x-$y configure -style Alive.TFrame
    } else {
        .cell-$x-$y configure -style Dead.TFrame
    }
    update
}

proc main {} {

    global seed gridSize frameList currentState generation

    # seed cells
    for {set i 0} {$i < $seed} {incr i} {
        set x [expr int(rand()*$gridSize)]
        set y [expr int(rand()*$gridSize)]
        set currentState($x,$y) 1 
    }

    #set currentState(14,4) 1
    #set currentState(15,4) 1
    #set currentState(16,4) 1

    # init cell states
    if {1} {
        for {set i 0} {$i < $gridSize} {incr i} {
            for {set j 0} {$j < $gridSize} {incr j} {
                set state $currentState($i,$j)
                if {$state == 1} {
                    .cell-$i-$j configure -style Alive.TFrame
                } else {
                    .cell-$i-$j configure -style Dead.TFrame
                }
                update
            }
        }
    }

    # init the grid
    if {1} {
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
 
        wm title . "Game-of-Life: generation $generation"
        #puts "generation: $generation"
        incr generation

        foreach l $frameList {
            foreach c $l {
                update_ $c
            }
        }
    }
}

# start
main 

