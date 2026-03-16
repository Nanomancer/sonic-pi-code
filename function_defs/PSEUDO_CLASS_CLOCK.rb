#### PSUEDO_CLASS_CLOCK

### KEEP IN MIND LIVE CODING + RULES OF AUDIENCE UNDERSTANDING
### call like:

##| live_loop :the_clock do
##|   clk_div_even(tick)
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
set :log_counters, true

##### 'MAIN()' function

define :clk_div_even do | idx, display=false |
  count_reset_all(idx)
  print_all_values(idx)
  send_cue(idx, :bar64, 1024)
  send_cue(idx, :bar32, 512)
  send_cue(idx, :bar16, 256)
  send_cue(idx, :bar8, 128)
  send_cue(idx, :bar4, 64)
  send_cue(idx, :bar2, 32)
  
  send_cue(idx, :bar1, 16, true)
  send_cue(idx, :bar_half, 8,true)
  send_cue(idx, :beat, 4,true)
  send_cue(idx, :note_8th, 2,true)
  cue :clk, count: idx
  update_bar_counter(idx, 16)
  update_beat_counter(idx, 4)
  update_count(:current_16th)
  
  reset_count(:current_bar, (get[:num_bars]))
  reset_count(:current_beat, (get[:num_beats]))
  reset_count(:current_16th, (16 * get[:num_beats]))
end

##### Helpers #####

define :count_reset_all do |idx|
  if idx == 0
    set :total_bars, 0
    set :total_beats, 0
    
    set :current_bar, 0
    set :current_beat, 0
    set :current_16th, 0
  end
end

define :log_bar_counter do |num_bars, num_beats|
  puts "Current Bar : #{ (1 + get[:current_bar]) } / #{get[:num_bars]} | Total: #{ (1 + get[:total_bars]) } bars"
  ##| puts "Current Bar : #{ get[:current_bar] } / #{get[:num_bars]} | Total: #{ get[:total_bars] } bars"
end

define :log_beat_counter do |num_bars, num_beats|
  puts "Current Beat: #{ (1 + get[:current_beat]) } / #{get[:num_beats]} | Total: #{ (1 + get[:total_beats]) } beats"
  ##| puts "Current Beat: #{ get[:current_beat] } / #{get[:num_beats]} | Total: #{ get[:total_beats] } beats"
end

define :log_16th_counter do |num_bars, num_beats, idx|
  ##| puts "Current 16th: #{ (1 + get[:current_16th]) } / #{(16 * get[:num_beats])}| Total: #{ (1 + idx) }"
  puts "Current 16th: #{ get[:current_16th] } / #{ (16 * get[:num_beats]) }| Total: #{ idx }"
end

define :send_cue do |idx, key_cue, div, bool=false|
  ### bool is optional start on zero or not
  if test_modulo(idx, div) == true and bool == true
    ### send on clock count of zero
    cue key_cue
  elsif test_modulo(idx, div) == true and idx > 0
    ### default behaviour
    cue key_cue
  end
end

define :update_bar_counter do |idx, div|
  if test_modulo(idx, div) == true and idx > 0
    update_count(:current_bar)
    update_count(:total_bars)
  end
end

define :update_beat_counter do |idx, div|
  if test_modulo(idx, div) == true and idx > 0
    update_count(:current_beat)
    update_count(:total_beats)
  end
end

define :test_modulo do |idx, division|
  if idx % division == 0
    return true
  end
end

define :update_count do |key|
  set key, (1 + get[key])
end

define :reset_count do |key, reset_every|
  if get[key] >= reset_every #(bars-1)
    set key, 0
  end
end

define :print_all_values do |idx|
  if get[:log_counters] == true and idx % 4 == 0
    log_bar_counter(get[:num_bars], get[:num_beats])
    log_beat_counter(get[:num_bars], get[:num_beats])
    ##| log_16th_counter(get[:num_bars], get[:num_beats], idx)
  end
end
