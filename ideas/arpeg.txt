##### TECHNO ARPEG #####

use_bpm 125
####### chord voicings / spellings
ext_chord = [1,3,5,7,9,11,13].ring
triad = [1,3,5,8].ring
triad2 = [1,5,3,8].ring
triad3 = [8,3,5,8,1].ring
seventh = [1,3,5,7]

custom = [1, 5, 3, 8, 5, 9, 5, 3, 8].ring
##| custom = [5,6,7,8,2,3,4].ring
##| custom = [1, 5, 3, 8, 5, 9, 7, 1].ring

voicing = custom
###### progressions
progression = [2,2,5,5].ring # correct ii,V prog
progression = [3,3,6,6].ring # like when it was bugged
##| progression = [2,3,6,6].ring # like when it was bugged

notes = (scale :d2, :major, num_octaves: 5)
##| notes = (scale :d3, :major, num_octaves: 5)

use_synth :hoover
##| sync :trig_32_bar

live_loop :arp_player do
  sync :trig_1_bar ## changes will updates every bar
  test = tick :prog
  chord_number = progression.look :prog
  tick_reset
  if test > 0 and test % progression.length == 0
    ##| tick_reset :prog
    puts "tick :prog #{test}"
  end
  16.times do
    if one_in 10 and look % 3 == 0 then inv = 7
    else inv = 0
    end
    sync :clk
    idx = voicing.tick + (chord_number-2) + inv
    ##| idx = voicing.tick + (chord_number-2)
    play notes[idx], release: 0.175, amp: 0.7 * humanise, cutoff: 130 * [1, 0.8, 0.9, ].ring.look
    ##| puts "Chord #{chord_number} | Degree #{voicing.look}"
  end
end