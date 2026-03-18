#### PSUEDO_CLASS_CLOCK
# 'public' function: :clk_div_even(), all others 'private'

### KEEP IN MIND; live coding, clean coding and audience understanding
### call like:

##| live_loop :the_clock do
##|   clk_div_even(tick)
##| sleep 0.25
##| end

##### INITIALISE KEYS #####

set :num_bars, 8
set :num_beats, 4
set :total_bars, 0
set :total_beats, 0
set :current_bar, 0
set :current_beat, 0
set :log_counter, true
set :debug_all, false

##### clk_div_even() function - public

define :clk_div_even do | idx |
  if get[:debug_all] and idx == 0 then puts "Clock divider started" end
  count_reset_all(idx)
  if idx > 0 then set_count(idx, :current_16th) end
  set_beat_counter(idx)
  set_bar_counter(idx)
  reset_count(idx, :current_bar, (get[:num_bars]))
  reset_count(idx, :current_beat, (get[:num_beats]))
  reset_count(idx, :current_16th, (16 * get[:num_beats]))
  log_slimline_counter(idx)
  ##### cues #####
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
end

##### Helpers #####

define :count_reset_all do |idx|
  if idx == 0
    set :total_bars, 0
    set :total_beats, 0
    set :current_bar, 0
    set :current_beat, 0
    set :current_16th, 0
    if get[:debug_all] then puts "count_reset_all() exec. idx: #{idx}" end
  end
end

define :send_cue do |idx, key_cue, div, bool=false|
  ### bool is optional start on zero or not
  if test_modulo(idx, div) == true and bool == true
    ### send on clock count of zero
    cue key_cue
    if get[:debug_all] then debug_send_cue(idx, key_cue) end
  elsif test_modulo(idx, div) == true and idx > 0
    ### default behaviour
    cue key_cue
    if get[:debug_all] then debug_send_cue(idx, key_cue) end
  end
end

define :set_bar_counter do |idx|
  if test_modulo(idx, 16) == true and idx > 0
    set_count(idx, :current_bar)
    set_count(idx, :total_bars)
    if get[:debug_all] then debug_bar_counter(idx) end
  end
end

define :set_beat_counter do |idx|
  if test_modulo(idx, 4) == true and idx > 0
    set_count(idx, :current_beat)
    set_count(idx, :total_beats)
    if get[:debug_all] then debug_beat_counter(idx) end
  end
end

define :test_modulo do |idx, division|
  if idx % division == 0
    return true
  end
end

define :set_count do |idx, key|
  if get[:debug_all] then prev_val = get[key] end
  set key, (1 + get[key])
  if get[:debug_all]
    set_count_statement(idx, prev_val, key)
  end
end

define :reset_count do |idx, key, reset_every|
  if get[:debug_all] then prev_val = get[key] end
  if get[key] >= reset_every
    set key, 0
    if get[:debug_all]
      reset_count_statement(idx, prev_val, key, reset_every)
    end
  end
end

##### debugging and printed output #####

define :log_slimline_counter do |idx|
  if get[:log_counter] == true and idx % 4 == 0
    puts "\
Bar: #{(1 + get[:current_bar])} / #{get[:num_bars]} | \
Beat: #{( 1 + get[:current_beat])} / #{get[:num_beats]} | \
16th: #{( 1 + get[:current_16th])}\
"
  end
end

define :debug_send_cue do |idx, key_cue|
  puts "\
send_cue() exec. at idx: #{idx} | \
beat: #{get[:current_beat]} | \
bar: #{get[:current_bar]} | key: :#{key_cue}\
"
end

define :debug_bar_counter do |idx|
  puts "\
bar_counter() exec. at idx: #{idx} | \
mod val=#{idx % get[:num_bars]}  | \
bar: #{get[:current_bar]}\
"
end

define :debug_beat_counter do |idx|
  puts "\
beat_counter() exec. at idx: #{idx}. | \
mod val=#{idx % get[:num_beats]} | \
beat=#{get[:current_beat]}"
end

define :set_count_statement do | idx, prev_val, key |
  puts "\
set_count() exec. on idx: #{idx} | \
prev val: #{prev_val} | \
new val: #{get[key]} | \
key: #{key}\
"
end

define :reset_count_statement do | idx, prev_val, key, reset_every |
  puts "\
reset_count() exec. at idx: #{idx} | \
prev val: #{prev_val} | \
new val: #{get[key]} | \
reset_every: #{reset_every} | \
key: #{key}\
"
end
