##### intro pt 1 #####
use_bpm 120

### good begining, target time to complete should be less than 60 secs?
live_loop :tech_arp do
  ##| with_synth :hoover do
  sync :clk
  play :c4,
    release: 0.5,
    amp: 0.5 * [1, 0.66, 0.75].ring.look,
    cutoff: 130 if spread(1, 4).tick(offset: 2)
  ##| end
end


live_loop :intro do
  sync :bar4
  ##| with_fx :wobble, phase: 8, wave: 2, cutoff_min: 50, res: 0.2 do
  sample :ambi_drone, amp: 0.66, beat_stretch: 16
  ##| sample :arovane_beat_c, amp: 0.5, beat_stretch: 16
  ##| end
end

#### DRUMMER #####

live_loop :kick do
  sync :beat
  sample :bd_haus, amp: 0.8
  ##| stop
end

live_loop :clock do
  clk_div_even(tick)
  sleep 0.25
end
