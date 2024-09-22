.data
character:  .byte 0,0
characterStart: .byte 0,0
box:        .byte 0,0
boxStart:   .byte 0,0
target:     .byte 0,0
targetStart: .byte 0,0
timerPerGame: .word 0
promptInput: .string "Enter number of players\n"
promptInputTime: .string "Enter time per game \n"
playerNum: .string "Player "
newline: .string "\n"
winMsg: .string "You Won! :D\n"
loseMsg: .string "You LOST! D:\n"
turns: .string ": turns = "
fail: .string ": FAIL D:"
wallHit: .string "you hit your head on a wall. It did not feel nice\n"
boxHit: .string "you hit your head on a box. It felt nice\n"

.globl main
.text

main:
    # erase everything but walls incase user restarts
    li a0 0 #black
    li a1 1
    li a2 1
    li a3 7
    DRAWLOOP:
        call setLED
        addi a1 a1 1
        bne a1 a3 DRAWLOOP
        #increase y and reset x
        addi a2 a2 1
        li a1 1
        bne a2 a3 DRAWLOOP

        
        
    
    
    #get input for nubmer of ints
    li a7, 4
	la a0, promptInput
	ecall
    call readInt
	mv s11, a0 #s11 = N, number of players

    #get input for time
    li a7, 4
	la a0, promptInputTime
	ecall
    call readInt
    mv s0 a0 # s0 = timer per game

    addi s11 s11 1
    li s7 14000 #cycles per timer tick
    #lw s8 timerPerGame

    li s10 1 #s10 = current player num
    # s9, num of turns

    # TODO: Before we deal with the LEDs, generate random locations for
    # the character, box, and target. static locations have been provided
    # for the (x,y) coordinates for each of these elements within the 8x8
    # grid. 
    # There is a rand function, but note that it isn't very good! You 
    # should at least make sure that none of the items are on top of each
    # other.


    #get char address 
    la a5 character
    
    # get random x 
    li a0 5
    call rand
    addi a0 a0 1
    
    #set character x
    sb a0 0(a5)
    
    # get random y 
    li a0 5
    call rand
    addi a0 a0 1
    
    #set character y
    sb a0, 1(a5)
    
    # keep generating box x,y until no overlap with character
    BOXLOOP:
        
        #get box address 
        la a6 box
    
        # get random x 
        li a0 5
        call rand
        addi a0 a0 1
        
        #set box x
        sb a0, 0(a6)
        
        # get random y 
        li a0 5
        call rand
        addi a0 a0 1
    
        #set box y
        sb a0, 1(a6)
        
        # check each corner
        # topleft
        li t1 1
        lb a0 0(a6)
        bne t1 a0 TOPLEFTGOOD
        lb a0 1(a6)
        bne t1 a0 TOPLEFTGOOD
        j BOXLOOP
        TOPLEFTGOOD:
            
        # bottom right
        li t1 6
        lb a0 0(a6)
        bne t1 a0 BOTTOMRIGHTGOOD
        lb a0 1(a6)
        bne t1 a0 BOTTOMRIGHTGOOD
        j BOXLOOP
        BOTTOMRIGHTGOOD:
            
        # bottom left
        li t1 1
        li t2 6
        lb a0 0(a6)
        bne t1 a0 BOTTOMLEFTGOOD
        lb a0 1(a6)
        bne t2 a0 BOTTOMLEFTGOOD
        j BOXLOOP
        BOTTOMLEFTGOOD:
            
        # top right
        li t1 6
        li t2 1
        lb a0 0(a6)
        bne t1 a0 TOPRIGHTGOOD
        lb a0 1(a6)
        bne t2 a0 TOPRIGHTGOOD
        j BOXLOOP
        TOPRIGHTGOOD:
        
        # if x different from char, move on
        lb t1 0(a5)
        lb t2 0(a6)
        bne t1, t2, TARGETLOOP
        
        # if y different from char, move on
        lb t1 1(a5)
        lb t2 1(a6)
        bne t1, t2, TARGETLOOP
        
        # if both same, loop again
        j BOXLOOP
        
        
    TARGETLOOP:
         #get target address 
        la a4 target
        
        
        # check if box is on wall
        # top wall
        li t1 1
        lb a0 1(a6)
        bne a0 t1 NOTTOPWALL #skip if not on topwall
        # generate target on top wall
        li a0 5
        call rand
        addi a0 a0 1
        # restart if on box
        lb t1 0(a6)
        beq a0 t1 TARGETLOOP
        # else save and compare to char
        sb a0 0(a4)
        li a0 1
        sb a0 1(a4)
        j BOXTOCHARCOMP
        
        NOTTOPWALL:
        # left wall
        li t1 1
        lb a0 0(a6)
        bne a0 t1 NOTLEFTWALL #skip if not on leftwall
        # generate target on left wall
        li a0 5
        call rand
        addi a0 a0 1
        # restart if on box
        lb t1 1(a6)
        beq a0 t1 NOTTOPWALL
        # else save and compare to char
        sb a0 1(a4)
        li a0 1
        sb a0 0(a4)
        j BOXTOCHARCOMP
        
        NOTLEFTWALL:
         # right wall
        li t1 6
        lb a0 0(a6)
        bne a0 t1 NOTRIGHTWALL #skip if not on rightwall
        # generate target on right wall
        li a0 5
        call rand
        addi a0 a0 1
        # restart if on box
        lb t1 1(a6)
        beq a0 t1 NOTLEFTWALL
        # else save and compare to char
        sb a0 1(a4)
        li a0 6
        sb a0 0(a4)
        j BOXTOCHARCOMP
        
        NOTRIGHTWALL:
        # bottom wall
        li t1 6
        lb a0 1(a6)
        bne a0 t1 NOTBOTTOMWALL #skip if not on bottomwall
        # generate target on bottom wall
        li a0 5
        call rand
        addi a0 a0 1
        # restart if on box
        lb t1 0(a6)
        beq a0 t1 NOTRIGHTWALL
        # else save and compare to char
        sb a0 0(a4)
        li a0 6
        sb a0 1(a4)
        j BOXTOCHARCOMP
        
        NOTBOTTOMWALL:
        
            
        # get random x 
        li a0 5
        call rand
        addi a0 a0 1
    
        #set target x
        sb a0, 0(a4)
        
        # get random y 
        li a0 5
        call rand
        addi a0 a0 1
    
        #set target y
        sw a0, 1(a4)
        
        BOXTOCHARCOMP:
        # if x different from box, check char
        lb t1 0(a4)
        lb t2 0(a6)
        bne t1, t2, CHARCOMPARE
        
        # if y different box, check char
        lb t1 1(a4)
        lb t2 1(a6)
        bne t1, t2, CHARCOMPARE
        
        # if both same, loop again
        j TARGETLOOP
        
        
    CHARCOMPARE:
        
        # if x different from char, move on 
        lb t1 0(a4)
        lb t2 0(a5)
        bne t1, t2, DONE
        
        # if y different box, check char
        lb t1 1(a4)
        lb t2 1(a5)
        bne t1, t2, DONE
        
        # if both same, loop again
        j TARGETLOOP
    DONE:
   
    # chosen. (Yes, you choose, and you should document your choice.)
    
    # save positions
    la s4 targetStart
    la s5 characterStart
    la s6 boxStart
    lb a0 0(a4)
    sb a0 0(s4)
    lb a0 1(a4)
    sb a0 1(s4)
    lb a0 0(a5)
    sb a0 0(s5)
    lb a0 1(a5)
    sb a0 1(s5)
    lb a0 0(a6)
    sb a0 0(s6)
    lb a0 1(a6)
    sb a0 1(s6)
    
    # increase all coors by 1
    #set character color
    li a0 65535 #cyan
    #get x and add 1
    lb a1 0(a5)
    #addi a1 a1 1
    # get y and add 1
    lb a2 1(a5)
    #addi a2 a2 1
    # set color 
    call setLED
    
    #set box color
    li a0 16753920 #orange
    #get x and add 1
    lb a1 0(a6)
   # addi a1 a1 1
    # get y and add 1
    lb a2 1(a6)
   # addi a2 a2 1
    # set color 
    call setLED
    
    #set target color
    li a0 16711680 #red
    #get x and add 1
    lb a1 0(a4)
   # addi a1 a1 1
    # get y and add 1
    lb a2 1(a4)
   # addi a2 a2 1
    # set color 
    call setLED
        
    
    
    #walls
    li a0 16711935
    li a3, 7 # stop loop
    # make left wall
    li a1 0
    li a2 0
    LLOOP:
        call setLED
        # increase y by 1
        addi a2 a2 1
        
        beq a2 a3 BLOOP
        j LLOOP    
    BLOOP:
         call setLED
        # increase x by 1
        addi a1 a1 1
        
        beq a1 a3 BLOOPDONE
        j BLOOP
    BLOOPDONE:
    li a3 0
    RLOOP:
         call setLED
        # decrease y by 1
        addi a2 a2 -1
        
        beq a2 a3 RLOOPDONE
        j RLOOP
    RLOOPDONE:
    call setLED
        # decrease x by 1
        addi a1 a1 -1
        
        beq a1 a3 TLOOPDONE
        j RLOOPDONE
    TLOOPDONE:
  
    # TODO: Enter a loop and wait for user input. Whenever user input is
    # received, update the grid with the new location of the player and
    # if applicable, box and target. You will also need to restart the
    # game if the user requests it and indicate when the box is located
    # in the same position as the target.
    
    GAMELOOP:
        #print player num
        li a7 4
        la a0 playerNum
        ecall
        li a7 1
        mv a0 s10
        ecall
        mv s10 a0
        li a7 4
        la a0 newline
        ecall
        #reset timer
        la a0 timerPerGame
        addi s8 s0 0
        
    
    MOVELOOP:
        # increase move count
        addi s9 s9 1
        # get input
        call pollDpad

        
        lb s1 0(a5) #get player x
        lb s3 0(a6) #get box x
       
        lb s2 1(a5) #get player y
        lb s4 1(a6) #get box y
       
    
        #t0, branch comparison
        
        li t0 0
        beq a0 t0 MOVEUP
        li t0 1
        beq a0 t0 MOVEDOWN
        li t0 2
        beq a0 t0 MOVELEFT
        
        #else move right
            addi s1 s1 1
            addi s3 s3 1
            j PLAYERWALL
        MOVEUP:
            addi s2 s2 -1
            addi s4 s4 -1
            j PLAYERWALL
        MOVEDOWN:
            addi s2 s2 1
            addi s4 s4 1
            j PLAYERWALL
        MOVELEFT:
            addi s1 s1 -1
            addi s3 s3 -1
            j PLAYERWALL
       
       PLAYERWALL:
            # go back to input if in wall (and print)
            li t0 0
            beq s1 t0 HITWALL    
            beq s2 t0 HITWALL
            li t0 7
            beq s1 t0 HITWALL    
            beq s2 t0 HITWALL
            j NOHITWALL
            HITWALL:
                li a7 4
                la a0 wallHit
                ecall
                j MOVELOOP
            NOHITWALL:
            
            # reset game if player on target
            lb t0 0(a4)
            lb t1 1(a4)
            bne s1 t0 NORESET
            bne s2 t1 NORESET
            j GAMERESET
            
            NORESET:
            
            #check for box collision, skip if x or y diff
            lb a0 0(a6)
            bne s1 a0 BOXDONE
            lb a0 1(a6)
            bne s2 a0 BOXDONE
            
            #if collision, go back to input if box in wall
            li t0 0
            beq s3 t0 HITBOX    
            beq s4 t0 HITBOX
            li t0 7
            beq s3 t0 HITBOX    
            beq s4 t0 HITBOX
            j NOHITBOX
            
            HITBOX:
                li a7 4
                la a0 boxHit
                ecall
                j MOVELOOP
            NOHITBOX:
            
            # erase box
            li a0 0 #black
            lb a1 0(a6)
            lb a2 1(a6)
            call setLED
     
            #update box coor
            sb s3 0(a6)
            sb s4 1(a6)
            
            # color box
            li a0 16753920 #orange
            lb a1 0(a6)
            lb a2 1(a6)
            call setLED
            
            # end game if target overlap
            lb t0 0(a4)
            lb t1 1(a4)
            bne a1 t0 BOXDONE
            bne a2 t1 BOXDONE
            j GAMEDONE
            
        BOXDONE:
            # erase player
            li a0 0 #black
            lb a1 0(a5)
            lb a2 1(a5)
            call setLED
            
            # update player coor
            sb s1 0(a5)
            sb s2 1(a5)

            # color target
            li a0 16711680 #red
            lb a1 0(a4)
            lb a2 1(a4)
            call setLED
            
            # color player
            li a0 65535 #cyan
            lb a1 0(a5)
            lb a2 1(a5)
            call setLED
            
        
            j MOVELOOP #get next move
    GAMEDONE:
        # congratulate player or call them a scrub
        li a0 0
        bne s9 a0 WIN
        li a7 4
        la a0 loseMsg
        ecall
        j NOWIN
        
        WIN:
        li a7 4
        la a0 winMsg
        ecall
        NOWIN:
  
        
        # increase player num
        addi s10 s10 1
        # store num of turns on stack
        addi sp, sp, -4 
        sw s9, 0(sp) 
        # store playernum on stack
        addi sp, sp, -4 
        sw s10, 0(sp) 
        GAMERESET:
        # reset turns
        mv s9 x0
        
        #reset positions
        # erase 
        li a0 0 #black
        #box
        lb a1 0(a6)
        lb a2 1(a6)
        call setLED 
        #character
        lb a1 0(a5)
        lb a2 1(a5)
        call setLED 
        
        # update coor
 
        lb a0 0(s5)
        sb a0 0(a5)
        lb a0 1(s5)
        sb a0 1(a5)
        lb a0 0(s6)
        sb a0 0(a6)
        lb a0 1(s6)
        sb a0 1(a6)
        
        # recolor
        #box
        li a0 16753920 #orange
        lb a1 0(a6)
        lb a2 1(a6)
        call setLED 
        #target
        li a0 16711680 #red
        lb a1 0(a4)
        lb a2 1(a4) 
        call setLED
        #character
        li a0 65535 #cyan
        lb a1 0(a5)
        lb a2 1(a5)
        call setLED
        
        
        # end round if all players played
        beq s10 s11 ROUNDDONE
        
        # else play next player
        j GAMELOOP


    ROUNDDONE:
        addi s11 sp 0 #store top of stack
        # sort scores on stack
        # for each player, go through the stack once, 
        # moving up if less
        # get bottom of stack by subtracting 8
        # for each player
        addi s0 sp 0
        li t1 8
        mul t2 t1 s10
        addi t2 t2 -8
        add s0 s0 t2 #s0: bottom of stack
        
        STACKLOOP:
            lw s2, 0(sp) 
            addi sp, sp, 4 
            lw s1, 0(sp) 
            addi sp, sp, 4 
            lw s4, 0(sp) 
            addi sp, sp, 4 
            lw s3, 0(sp) 
            addi sp, sp, 4 
            
           
            # s1: turns of curr player
            # s2: num of curr player
            # s3: turns of below player
            # s4: num of below player
            
            # don't switch if below player failed
            beq s3 x0 SWITCHSKIP
            #always switch if cur player failed
            beq s1 x0 SWITCH
            
            
            # if below player more or eq turns, skip
            # else, switch
            bge s3 s1 SWITCHSKIP
            
            SWITCH:
            addi a0 s1 0
            addi s1 s3 0
            addi s3 a0 0
            
            addi a0 s2 0
            addi s2 s4 0
            addi s4 a0 0
            
            # update values on stack
            addi sp, sp, -4 
            sw s3, 0(sp) 
            addi sp, sp, -4 
            sw s4, 0(sp) 
            addi sp, sp, -4 
            sw s1, 0(sp) 
            addi sp, sp, -4 
            sw s2, 0(sp) 
            j TOPRESTORESKIP
        
            SWITCHSKIP:
            addi sp, sp -16 #if no switch, put back to 'top'
            TOPRESTORESKIP:
            # reduce by 8, if not bottom, and compare again
            addi sp sp 8
            bne sp s0 STACKLOOP
            
            #after hit bottom, move bottom up by 8
            # move sp back to top, unless bottom = top
            addi s0 s0 -8 #move bottom
            addi sp s11 0 # put sp at top
            bne s0 s11 STACKLOOP # do again if bottom != top
            
        # print score of each player
        #addi sp sp 8
        PRINTLOOP:
            
            #get player num
            lw s1, 0(sp) # load the word at the top of the stack
            addi sp, sp, 4 # decrease the size of the stack
            
            #get turns
            lw s0, 0(sp) # load the word at the top of the stack
            addi sp, sp, 4 # decrease the size of the stack
            
            # print "player:"
            li a7 4
            la a0 playerNum
            ecall
            
            # print player num
            li a7 1
            addi a0 s1 0
            addi a0 a0 -1
            ecall
            
            #skip fail print if turns > 0
            bne s0 x0 PRINTTURNS
            
            #print fail
            li a7 4
            la a0 fail
            ecall
            j PRINTDONE
            
            PRINTTURNS:
            li a7 4
            la a0 turns
            ecall
            li a7 1
            #get turns
            addi a0 s0 0 
            ecall
            
            PRINTDONE:
            
            li a7 4
            la a0 newline
            ecall
            
            #decrease player num by 1
            addi s10 s10 -1
            #print next player if any left
            
            li a0 1
            bne s10 a0 PRINTLOOP
 
 
exit:
    li a7, 10
    ecall
    
    
# --- HELPER FUNCTIONS ---
# Feel free to use (or modify) them however you see fit
     
# Takes in a number in a0, and returns a (sort of) (okay no really) random 
# number from 0 to this number (exclusive)
rand:
    mv t0, a0
    li a7, 30
    ecall
    remu a0, a0, t0
    jr ra
    
# Takes in an RGB color in a0, an x-coordinate in a1, and a y-coordinate
# in a2. Then it sets the led at (x, y) to the given color.
setLED:
    li t1, 0x8 #width
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE #base
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
    
# Polls the d-pad input until a button is pressed, then returns a number
# representing the button that was pressed in a0.
# The possible return values are:
# 0: UP
# 1: DOWN
# 2: LEFT
# 3: RIGHT
pollDpad:
    mv a0, zero
    li t1, 4
pollLoop:
    # add one tick
    addi t6 t6 1
    ble t6 s7 DONTPRINT
    
    #print time if second passed
    li a7 1
    mv t6 a0
    addi a0 s8 0
    ecall
    li a7 4
    la a0 newline
    ecall
    addi s8 s8 -1
    mv a0 t6
    mv t6 x0
    
    # fail player if no time
    ble x0 s8 DONTPRINT
    # set turns to 0
    li s9 0
    j GAMEDONE
    
    DONTPRINT:
    bge a0, t1, pollLoopEnd
    li t2, D_PAD_0_BASE
    slli t3, a0, 2
    add t2, t2, t3
    lw t3, (0)t2
    bnez t3, pollRelease
    addi a0, a0, 1
    j pollLoop
pollLoopEnd:
    j pollDpad
pollRelease:
    lw t3, (0)t2
    bnez t3, pollRelease
pollExit:
    jr ra
    
readInt:
    addi sp, sp, -12
    li a0, 0
    mv a1, sp
    li a2, 12
    li a7, 63
    ecall
    li a1, 1
    add a2, sp, a0
    addi a2, a2, -2
    mv a0, zero
parse:
    blt a2, sp, parseEnd
    lb a7, 0(a2)
    addi a7, a7, -48
    li a3, 9
    bltu a3, a7, error
    mul a7, a7, a1
    add a0, a0, a7
    li a3, 10
    mul a1, a1, a3
    addi a2, a2, -1
    j parse
parseEnd:
    addi sp, sp, 12
    ret

error:
    li a7, 93
    li a0, 1
    ecall
