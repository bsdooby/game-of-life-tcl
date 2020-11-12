#!/usr/bin/env tclsh

package require Tk

set gridSize 80
set cellSize 5
set updateSpeed 1

set gridState 0

#expr {srand(42)}
set seed 350

set generation 1

ttk::style configure Dead.TFrame -background white -borderwidth 0.5 -relief sunken
ttk::style configure Alive.TFrame -background black -borderwidth 0.5 -relief sunken

ttk::style configure Neighbour.TFrame -background red -borderwidth 0.5 -relief sunken
ttk::style configure Center.TFrame -background green -borderwidth 0.5 -relief sunken

tk::canvas .universe -width [expr $gridSize * $cellSize] -height [expr $gridSize * $cellSize] -background white

wm title . "Game-of-Life: generation $generation"
wm geometry . +450+0

set frameList [list]

array set currentState {}
array set nextState {}

set k 0
set l 0
for {set i 0} {$i < [expr $gridSize * $cellSize]} {incr i $cellSize} {
    for {set j 0} {$j < [expr $gridSize * $cellSize]} {incr j $cellSize} {
        .universe create rectangle $i $j [expr $i + $cellSize] [expr $j + $cellSize] \
            -fill white -outline black -tags "x:$l;y:$k" ;# follows column-major -> swap 
        set currentState($k,$l) 0
        incr l
    }
    set l 0
    incr k
}

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

proc moore' {x y} {

    #set ne nonewline
    
    global gridSize updateSpeed currentState nextState
    
    set neighbours [list]

    # center cell
    #.universe itemconfigure "x:$x;y:$y" -fill red
    #update
    #after $updateSpeed
    #.universe itemconfigure "x:$x;y:$y" -fill white
    #update
    
    set livingNeighbours 0
    if {1} {
        # north
        #puts -$ne "{[expr $x-1] [expr $y+0]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        lappend neighbours "$x_ $y"

        # northeast
        #puts -$ne "{[expr $x-1] [expr $y+1]}"
        set y_ [expr $y+1]
        set y_ [expr $y_ > $gridSize-1 ? 0 : $y_]
        lappend neighbours "$x_ $y_"
        
        # east
        #puts -$ne "{[expr $x-0] [expr $y+1]}"
        lappend neighbours "$x $y_"
        
        # southeast
        #puts -$ne "{[expr $x+1] [expr $y+1]}"
        set x_ [expr $x+1]
        set x_ [expr $x_ > $gridSize-1 ? 0 : $x_]
        lappend neighbours "$x_ $y_"
        
        # south
        #puts -$ne "{[expr $x+1] [expr $y+0]}"
        lappend neighbours "$x_ $y"
        
        # southwest
        #puts -$ne "{[expr $x+1] [expr $y-1]}"
        set y_ [expr $y-1]
        set y_ [expr $y_ < 0 ? $gridSize-1 : $y_]
        lappend neighbours "$x_ $y_"
        
        # west
        #puts -$ne "{[expr $x-0] [expr $y-1]}"
        lappend neighbours "$x $y_"

        # northwest
        #puts "{[expr $x-1] [expr $y-1]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        lappend neighbours "$x_ $y_"
        
        # count'em
        foreach nc $neighbours {
           
            lassign [split $nc " "] x_ y_
            if {$currentState($x_,$y_) == 1} {
                incr livingNeighbours
            }
        }

        # show sliding window
        if {0} {
            foreach nc $neighbours {
                lassign [split $nc " "] x_ y_
                .universe itemconfigure "x:$x_;y:$y_" -fill green
            }
            update

            after $updateSpeed

            foreach nc $neighbours {
                lassign [split $nc " "] x_ y_
                .universe itemconfigure "x:$x_;y:$y_" -fill white
            }
            update
        }

        # rule engine

        # rule 1:
	    # any live cell with two or three live neighbours survives

        if {$currentState($x,$y) == 1} {
            switch $livingNeighbours {
                2 -
                3 {
                    set nextState($x,$y) 1
                }
                default {
                    set nextState($x,$y) 0
                }
            }
       
       # rule 2:
	   # any dead cell with three live neighbours becomes a live cell
            
       } else {
            if {$livingNeighbours == 3} {
                set nextState($x,$y) 1
            }
        } 

        # rule 3:
	    # all other live cells die in the next generation. Similarly, all other dead cells stay dead.			
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

        # show sliding window
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
            
        #update
    }
    #after $updateSpeed
    #.cell-$x-$y configure -style Dead.TFrame
    update
}

proc update_' {x y} {
 
    global currentState nextState gridState

    set currentState($x,$y) $nextState($x,$y)
    set nextState($x,$y) 0

    if {$currentState($x,$y) == 1} {
        .universe itemconfigure "x:$x;y:$y" -fill black
    } else {
        .universe itemconfigure "x:$x;y:$y" -fill white
    }
    update
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
    update
}

proc main' {} {

    global gridSize cellSize currentState seed generation

    pack .universe

    # init seed cells
    for {set i 0} {$i < $seed} {incr i} {
        set x [expr int(rand()*$gridSize)]
        set y [expr int(rand()*$gridSize)]
        set currentState($x,$y) 1 
    }

    # set seed cells
    for {set i 0} {$i < $gridSize} {incr i} {
        for {set j 0} {$j < $gridSize} {incr j} {
            set state $currentState($i,$j)
            if {$state == 1} {
                .universe itemconfigure "x:$i;y:$j" -fill black
            }
            update
        }
    }

    # enter the game loop
    while {1} {
        for {set i 0} {$i < $gridSize} {incr i} {
            for {set j 0} {$j < $gridSize} {incr j} {
                moore' $i $j
            }
        }
 
        wm title . "Game-of-Life: generation $generation"
        incr generation

        for {set i 0} {$i < $gridSize} {incr i} {
            for {set j 0} {$j < $gridSize} {incr j} {
                update_' $i $j
            }
        }
    }
}

proc main {} {

    global seed gridSize frameList currentState generation gridState

    # init seed cells
    for {set i 0} {$i < $seed} {incr i} {
        set x [expr int(rand()*$gridSize)]
        set y [expr int(rand()*$gridSize)]
        set currentState($x,$y) 1 
    }

    # test cases
    #set currentState(14,4) 1
    #set currentState(15,5) 1
    #set currentState(16,6) 1

    #set currentState(14,6) 1
    #set currentState(15,5) 1
    #set currentState(16,5) 1

    # set seed cells
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

