# Drums & Percussion TEST

use_bpm 125

##| kick_pattern = [ 1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1,1,0,1,0 ].ring
kick_pattern = [ 1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0 ].ring
hat_pattern  = [ 0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0 ].ring
##| hat_pattern  = [ 1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1 ].ring
##| hat_pattern  = [ 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 ].ring
open_hat_pattern = spread 3, 16, rotate: 3
open_hat_pattern = spread 6, 16, rotate: 6
open_hat_pattern = spread 5, 16, rotate: 2
open_hat_pattern = spread 0, 16, rotate: 2

snare_rules = snare_rules(2)
snare_rules = snare_rules(1)

update_every = 8 # bars
pattern_length = 1
##| pattern_length = 2

snare_pattern = spread 5,11, rotate: 5
##| snare_pattern = spread 10,19, rotate: 5
##| snare_pattern = spread 7,17, rotate: 1
##| snare_pattern = spread 7,9, rotate: 3
##| snare_pattern = spread 3,7, rotate: 0
##| snare_pattern = spread 5,13, rotate: 9
snare_pattern = spread 5,16, rotate: 9

dynamics =  [ 1, 0.66, 0.75, 0.5, 0.9, 0.6, 0.7, 0.33, ].ring

live_loop :euclidean_snare do
  sync :trig_8_bar
  pattern_length = [ 2, 1 ].choose
  snare_pattern = spread 5,[ 13, 16 ].choose, rotate: 9
  ##| with_fx :reverb do
  (16 * update_every).times do
    rate = sync :clk
    reset_freq(rate, pattern_length) # needs work / replace with sync
    if snare_rules.tick and snare_pattern.look
      sample :elec_hi_snare, rate: 0.88, amp: 0.75 * dynamics.look
      ##| puts "snare: internal clock = #{look} Dyn: #{dynamics.look}"
    end
  end
  ##| end
end

live_loop :hatter do
  ##| sync :trig_4_bar
  ##| puts "wait for clk"
  sync :clk
  if hat_pattern.tick == 1
    if open_hat_pattern.look == true
      sample :drum_cymbal_open, finish: 0.15, amp: 0.2
    else
      sample :drum_cymbal_closed
      ##| puts "HAT: internal clock = #{look}"
    end
  end
end

live_loop :kick do
  sync :clk
  if kick_pattern.tick == 1
    ##| puts "KICK look: #{look}"
    sample :bd_haus, amp: 1.1 * [ 0.9, 0.66, 0.75, 0.6 ].ring.look
  end
end

live_loop :splash do
  sync :trig_4_bar
  sample :drum_splash_soft, amp: 0.5
end

#####################################

##| live_loop :clock do
##|   clock
##| end
live_loop :techno_clock do
  clock_div(tick)
  sleep 0.25
end