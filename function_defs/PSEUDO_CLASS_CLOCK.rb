#### PSUEDO_CLASS_CLOCK

### KEEP IN MIND LIVE CODING + RULES OF AUDIENCE UNDERSTANDING
### call like:

##| live_loop :the_clock do
##|   even_clk_div(tick)
##|   sleep 0.25
##| end

##### INITIALISE KEYS #####
set :num_bars, 8
set :num_beats, 4
set :total_bars, 0
set :total_beats, 0
set :current_bar, 0
set :current_beat, 0
set :current_16th, 0

##### 'MAIN()' function

define :clk_div_even do | idx, display=false |
  count_reset_all(idx) # done, untested
  send_cue_and_update_count(look, :bar64, 1024) # done, untested
  send_cue_and_update_count(look, :bar32, 512)
  send_cue_and_update_count(look, :bar16, 256)
  send_cue_and_update_count(look, :bar8, 128)
  send_cue_and_update_count(look, :bar4, 64)
  send_cue_and_update_count(look, :bar2, 32)
  send_cue_and_update_count(look, :bar1, 16,true)
  send_cue_and_update_count(look, :bar_half, 8,true)
  send_cue_and_update_count(look, :beat, 4,true)
  send_cue_and_update_count(look, :note_8th, 2,true)
  cue :clk, count: idx
  set :current_16th, (1 + get[:current_16th]) # always
  
  #### resets here- needs to go after cues?
  reset_count(:current_bar, get[:num_bars]) # done, untested
  reset_count(:current_beat, get[:num_beats])
  reset_count(:current_16th, get[:num_beats])
end

define :update_count do |key_current, key_total|
  set key_current, (1 + get[key_current])
  set key_total, (1 + get[key_current]) ### update the value here? after cues are sent? WATCH OUT 1+0 error!?
end

define :reset_count do |key, reset_every|
  if get[key] > reset_every #(bars-1)
    set key, 0
  end
end

define :count_reset_all do |idx|
  if idx == 0
    set :total_bars, 0
    set :total_beats, 0
    
    set :current_bar, 0
    set :current_beat, 0
    set :current_16th, 0
  end
end

define :send_cue_and_update_count do |idx, key_cue, key_current, key_total, div, bool=false|
  ### bool is optional start on zero or not
  if test_modulo(idx, div) == true and bool == true
    ### send on clock count of zero
    display_bars_and_beats(get[:num_bars], get[:num_beats])
    cue key_cue
    update_count(key_current, key_total)
  elsif test_modulo(idx, int) == true and idx > 0
    ### default behaviour
    display_bars_and_beats(get[:num_bars], get[:num_beats])
    cue key_cue
    update_count(key_current, key_total)
  end
end

define :display_bars_and_beats do |num_bars, num_beats|
  puts "Current Bar : #{get[:current_bar]} / #{get[:num_bars]} | Total: #{get[:total_bars]} bars"
  puts "Current Beat: #{get[:current_beat]}] / #{get[:num_beats]} | Total: #{get[:total_beats]} beats"
end

define :test_modulo do |idx, division|
  if idx % division == 0
    return true
  end
end
