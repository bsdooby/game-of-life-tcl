#!/usr/bin/env tclsh

package require Tk

set gridSize 60 
set cellSize 5 

set gridState 0

#expr {srand(42)}
set seed 450

set generation 1

ttk::style configure Dead.TFrame -background white -borderwidth 0.5 -relief sunken
ttk::style configure Alive.TFrame -background black -borderwidth 0.5 -relief sunken

ttk::style configure Neighbour.TFrame -background red -borderwidth 0.5 -relief sunken
ttk::style configure Center.TFrame -background green -borderwidth 0.5 -relief sunken
ttk::style configure Seed.TFrame -background blue -borderwidth 0.5 -relief sunken

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
    
    global gridSize frameList currentState nextState
    
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
        #lappend neighbours .cell-$x_-$y
        set livingNeighbours $currentState($x_,$y)

        # northeast
        #puts -$ne "{[expr $x-1] [expr $y+1]}"
        set y_ [expr $y+1]
        set y_ [expr $y_ > $gridSize-1 ? 0 : $y_]
        #lappend neighbours .cell-$x_-$y_
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # east
        #puts -$ne "{[expr $x-0] [expr $y+1]}"
        #lappend neighbours .cell-$x-$y_
        set livingNeighbours [expr $livingNeighbours + $currentState($x,$y_)]
        
        # southeast
        #puts -$ne "{[expr $x+1] [expr $y+1]}"
        set x_ [expr $x+1]
        set x_ [expr $x_ > $gridSize-1 ? 0 : $x_]
        #lappend neighbours .cell-$x_-$y_
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # south
        #puts -$ne "{[expr $x+1] [expr $y+0]}"
        #lappend neighbours .cell-$x_-$y
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y)]
        
        # southwest
        #puts -$ne "{[expr $x+1] [expr $y-1]}"
        set y_ [expr $y-1]
        set y_ [expr $y_ < 0 ? $gridSize-1 : $y_]
        #lappend neighbours .cell-$x_-$y_
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # west
        #puts -$ne "{[expr $x-0] [expr $y-1]}"
        #lappend neighbours .cell-$x-$y_
        set livingNeighbours [expr $livingNeighbours + $currentState($x,$y_)]

        # northwest
        #puts "{[expr $x-1] [expr $y-1]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        #lappend neighbours .cell-$x_-$y_
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        #puts "livingNeighbours: $livingNeighbours"

        # count'em
        if {0} {
            set livingNeighbours 0
            foreach nc $neighbours {
           
                lassign [split $nc -] _ x_ y_

                if {$currentState($x_,$y_) == 1} {
                    incr livingNeighbours
                }
            }
            #puts "livingNeighbours (loop): $livingNeighbours"
        }

        # show sliding window
        if {0} {
            foreach nc $neighbours {
                $nc configure -style Neighbour.TFrame
            }
            #update

            foreach nc $neighbours {
                $nc configure -style Dead.TFrame
            }
            #update
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
            
        #update
    }
    #.cell-$x-$y configure -style Dead.TFrame
    #update
}

proc update_ {cell} {

    global currentState nextState gridState

    lassign [split $cell -] _ x y
    
    set currentState($x,$y) $nextState($x,$y)
    set nextState($x,$y) 0

    if {$currentState($x,$y) == 1} {
        .cell-$x-$y configure -style Alive.TFrame
    } else {
        .cell-$x-$y configure -style Dead.TFrame
    }
    #update
}

proc main {} {

    global seed gridSize frameList currentState generation gridState

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

    # init seed cells
    if {1} {
        for {set i 0} {$i < $seed} {incr i} {
            set x [expr int(rand()*$gridSize)]
            set y [expr int(rand()*$gridSize)]
            set currentState($x,$y) 1 
            .cell-$x-$y configure -style Seed.TFrame
        }
        update
    }

    # test cases
    
    # glider
    set currentState(0,2) 1
    set currentState(1,0) 1
    set currentState(1,2) 1
    set currentState(2,1) 1
    set currentState(2,2) 1

    set currentState(7,5) 1
    set currentState(7,6) 1
    set currentState(8,5) 1
    set currentState(8,6) 1

    if {0} {
        set currentState(10,5) 1
        set currentState(10,6) 1
        set currentState(10,7) 1
        set currentState(11,6) 1
        set currentState(11,7) 1
        set currentState(11,8) 1
    }

    # set seed cells
    if {0} {
        for {set i 0} {$i < $gridSize} {incr i} {
            for {set j 0} {$j < $gridSize} {incr j} {
                set state $currentState($i,$j)
                if {$state == 1} {
                    .cell-$i-$j configure -style Seed.TFrame
                } else {
                    .cell-$i-$j configure -style Dead.TFrame
                }
                #update
            }
        }
    }

    after 1 [list eventLoop]
    vwait forever

    # the game loop
    #while {1} {
    #    foreach l $frameList {
    #       foreach c $l {
    #           moore $c
    #        }
    #    }
    #
    #    wm title . "Game-of-Life: generation $generation"
    #    incr generation
    #
    #    foreach l $frameList {
    #        foreach c $l {
    #            update_ $c
    #        }
    #    }
    #}
}

proc eventLoop {} {
 
    global frameList generation

    foreach l $frameList {
        foreach c $l {
            moore $c
        }
    }
 
    wm title . "Game-of-Life: generation $generation"
    incr generation

    foreach l $frameList {
        foreach c $l {
            update_ $c
        }
    }

    after 20 [list eventLoop]
}

# start
main

