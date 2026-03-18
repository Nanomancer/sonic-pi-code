##### CLOCK TEST #######
use_bpm 105
set :log_counters, true
set :debug_all, true

live_loop :test_sync_N_bars do
  sync :bar8
  sample :ambi_lunar_land
end

live_loop :test_sync_bar do
  current_bar=get[:current_bar]
  ##| puts "bar test waiting for cue, current_bar: #{current_bar}"
  sync :bar1
  ##| puts "bar test got cue"
  sample :drum_cymbal_soft
end

live_loop :test_sync_beat do
  
  ##| puts "beat test waiting   - current_beat: #{get[:current_beat]} | total_beats: #{get[:current_beat]}"
  sync :beat
  sample :bd_haus
  ##| puts "beat test receiving - current_beat: #{get[:current_beat]} | total_beats: #{get[:current_beat]}"
end

live_loop :test_clk do
  sync :clk
  sample :hat_bdu
end

###################################################

##| live_loop :the_clock do
##|   clk_div_even(tick)
##| end
