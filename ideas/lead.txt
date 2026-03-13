##### LEAD #####

update_freq=8
pattern_len=1

##| pattern = [:Eb4,:Eb5,:Eb5].ring
pattern = (scale :Eb4, :whole_tone)
##| pattern = (scale :Eb3, :whole_tone, num_octaves: 2)
##| pattern = (scale :Eb4, :prometheus)
##| pattern = (scale :Eb4, :hirajoshi)
##| pattern = (scale :Eb3, :hirajoshi, num_octaves: 2)

rtm_pattern1 = spread 5, 13, rotate: 6
rtm_pattern2 = spread 5, 13, rotate: 7
rtm_pattern3 = spread 6, 14, rotate: 5
rtm_pattern4 = spread 6, 14, rotate: 9
rtm_pattern5 = spread 5, 13, rotate: 10

##| rtm_pattern = spread 11, 25, rotate: 5 # 2 bar, 2 oct
##| rtm_pattern = spread 5, 13, rotate: 10
##| rtm_pattern = spread 5, 13, rotate: 7
##| rtm_pattern = spread 6, 14, rotate: 5
rtm_pattern = spread 6, 14, rotate: 9
##| rtm_pattern = spread 6, 14, rotate: [5,9].choose

rtm_patterns = [ rtm_pattern1, rtm_pattern2, rtm_pattern3, rtm_pattern4, rtm_pattern5 ].ring
sync :trig_8_bar
puts "START LEAD"
live_loop :lead do
  
  use_synth :supersaw
  rtm_pattern = rtm_patterns.choose #tick(:rtm)
  update_freq.times do
    tick_reset
    (pattern_len*16).times do
      sync :clk
      tick
      ##| with_fx :reverb do
      if rtm_pattern.look == true
        play pattern.look,
          release: 1.4 * [0.2, 0.1, 0.125,0.1,0.15].ring.look,
          amp: 0.45, [ 0.9, 0.66, 0.75, 0.5 ].ring.look,
          cutoff: 130
      end
      ##| end
    end
  end
  ##| stop
end