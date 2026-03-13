##### TECH ARP EXAMPLE #####
use_bpm 125

####### chord voicings / spellings
triad = [1,3,5,8].ring
triad2 = [1,5,3,8].ring
triad3 = [8,3,5,8,1].ring
triad4 = [1,3,5,8,3].ring
seventh = [1,3,5,7]
ext_chord = [1,3,5,7,9,11,13].ring

custom = [1, 5, 3, 8, 5, 9, 5, 3, 8].ring
##| custom = [1,2,3,4,2,3,4,5,3,4,5,6,5,6,7,5,6,7,8].ring
##| custom = [1, 5, 3, 8, 5, 9, 7, 1].ring

voicing = custom

###### progressions
progression = [2,2,5,5].ring # correct ii,V prog
progression = [3,3,6,6].ring # like when it was bugged
progression = [2,3,6,6].ring # like when it was bugged

##### key / mode etc
notes = (scale :d2, :major, num_octaves: 5)

use_synth :hoover #### change to with_synth do block in loop
##| sync :trig_32_bar
bars = 1

live_loop :arp_player do
  sync :trig_1_bar
  test = tick :prog
  chord_number = progression.look :prog
  tick_reset
  (bars * 16).times do  ## changes will updates every bar
    sync :clk
    idx = voicing.tick + (chord_number-2) + inv # -2 because we're taking input from human readable form from 2 arrays
    play notes[idx], release: 0.175, amp: 0.7
  end
end