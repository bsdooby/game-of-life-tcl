#!/usr/bin/env tclsh

package require Tk

set gridSize 100 
set cellSize 5

#expr {srand(42)}
set seed 450

set generation 1

wm title . "Game-of-Life: generation $generation"
wm geometry . +450+0

tk::canvas .grid -width [expr $gridSize * $cellSize] -height [expr $gridSize * $cellSize] -background white

array set currentState {}
array set nextState {}

array set cellCache {}
set nhCache [dict create]

# build grid
set k 0
set l 0
for {set i 0} {$i < [expr $gridSize * $cellSize]} {incr i $cellSize} {
    for {set j 0} {$j < [expr $gridSize * $cellSize]} {incr j $cellSize} {
        
        set cell [.grid create rectangle $i $j [expr $i + $cellSize] [expr $j + $cellSize] \
            -fill white -outline black -tags "x:$l;y:$k"] ;# follows column-major -> swap
        
        set cellCache($k,$l) $cell
        set currentState($k,$l) 0
        set nextState($k,$l) 0 
        incr l
    }
    set l 0
    incr k
}

proc moore {x y} {

    #set ne nonewline
    
    global gridSize updateSpeed currentState nextState cellCache
    
    #set neighbours [list]

    # center cell
    #.grid itemconfigure "x:$x;y:$y" -fill red
    #update
    #after $updateSpeed
    #.grid itemconfigure "x:$x;y:$y" -fill white
    #update
    
    set livingNeighbours 0
    if {1} {
        # north
        #puts -$ne "{[expr $x-1] [expr $y+0]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        lappend neighbours "$x_ $y"
        set livingNeighbours $currentState($x_,$y)

        # northeast
        #puts -$ne "{[expr $x-1] [expr $y+1]}"
        set y_ [expr $y+1]
        set y_ [expr $y_ > $gridSize-1 ? 0 : $y_]
        lappend neighbours "$x_ $y_"
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # east
        #puts -$ne "{[expr $x-0] [expr $y+1]}"
        lappend neighbours "$x $y_"
        set livingNeighbours [expr $livingNeighbours + $currentState($x,$y_)]
        
        # southeast
        #puts -$ne "{[expr $x+1] [expr $y+1]}"
        set x_ [expr $x+1]
        set x_ [expr $x_ > $gridSize-1 ? 0 : $x_]
        lappend neighbours "$x_ $y_"
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # south
        #puts -$ne "{[expr $x+1] [expr $y+0]}"
        lappend neighbours "$x_ $y"
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y)]
        
        # southwest
        #puts -$ne "{[expr $x+1] [expr $y-1]}"
        set y_ [expr $y-1]
        set y_ [expr $y_ < 0 ? $gridSize-1 : $y_]
        lappend neighbours "$x_ $y_"
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # west
        #puts -$ne "{[expr $x-0] [expr $y-1]}"
        lappend neighbours "$x $y_"
        set livingNeighbours [expr $livingNeighbours + $currentState($x,$y_)]

        # northwest
        #puts "{[expr $x-1] [expr $y-1]}"
        set x_ [expr $x-1]
        set x_ [expr $x_ < 0 ? $gridSize-1 : $x_]
        lappend neighbours "$x_ $y_"
        set livingNeighbours [expr $livingNeighbours + $currentState($x_,$y_)]
        
        # show sliding window
        if {0} {
            foreach nc $neighbours {
                lassign [split $nc " "] x_ y_
                #.grid itemconfigure "x:$x_;y:$y_" -fill green
                .grid itemconfigure $cellCache($x_,$y_) -fill green
            }
            #update

            after $updateSpeed

            foreach nc $neighbours {
                lassign [split $nc " "] x_ y_
                #.grid itemconfigure "x:$x_;y:$y_" -fill white
                .grid itemconfigure $cellCache($x_,$y_) -fill white
            }
            #update
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

proc update_ {x y} {
 
    global currentState nextState

    set state $currentState($x,$y)
    set currentState($x,$y) $nextState($x,$y)
    set nextState($x,$y) 0

    if {$state == 1} {
        .grid itemconfigure "x:$x;y:$y" -fill black
    } else {
        .grid itemconfigure "x:$x;y:$y" -fill white
    }
    #update
}

proc main {} {

    global gridSize cellSize currentState seed generation cellCache

    pack .grid

    # set seed cells
    for {set i 0} {$i < $seed} {incr i} {
        set x [expr int(rand()*$gridSize)]
        set y [expr int(rand()*$gridSize)]
        set currentState($x,$y) 1 
        .grid itemconfigure $cellCache($x,$y) -fill red
    }
    update

    puts init    

    #set currentState(0,2) 1
    #set currentState(1,0) 1
    #set currentState(1,2) 1
    #set currentState(2,1) 1
    #set currentState(2,2) 1
 
    after 1 [list eventLoop]
    vwait forever

#    # enter the game loop
#    while {1} {
#        for {set i 0} {$i < $gridSize} {incr i} {
#            for {set j 0} {$j < $gridSize} {incr j} {
#                moore $i $j
#            }
#        }
# 
#        wm title . "Game-of-Life: generation $generation"
#        incr generation
#
#        for {set i 0} {$i < $gridSize} {incr i} {
#            for {set j 0} {$j < $gridSize} {incr j} {
#                update_ $i $j
#            }
#        }
#    }
}

proc eventLoop {} {

    global gridSize generation

    for {set i 0} {$i < $gridSize} {incr i} {
        for {set j 0} {$j < $gridSize} {incr j} {
            moore $i $j
        }
    }

    wm title . "Game-of-Life: generation $generation"
    incr generation

    for {set i 0} {$i < $gridSize} {incr i} {
        for {set j 0} {$j < $gridSize} {incr j} {
            update_ $i $j
        }
    }

    after 1 [list eventLoop]
}

# start
main

