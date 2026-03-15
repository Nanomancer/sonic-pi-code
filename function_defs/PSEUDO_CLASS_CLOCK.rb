#### PSUEDO_CLASS_CLOCK
# class variables - num_bars, num_beats, total_bars, total_beats
# clk_div_even() definition, helper functions and notes
### KEEP IN MIND LIVE CODING + RULES OF AUDIENCE UNDERSTANDING
### call like:
##| live_loop :the_clock do
##|   even_clk_div(tick)
##|   sleep 0.25
##| end

set :num_bars, 8 # globally available - assign within save file / function def file but outside of functions
set :num_beats, 4
### when needed locally
num_bars = get[:num_bars] ## when to reset bar counter / current_bar, req as arg to even_clock_div
num_beats = get[:num_beats] # when to reset beat counter

##### TESTING ~~~~~

set :total_bars, 0
set :total_beats, 0

set :current_bar, 0
set :current_beat, 0
set :current_16th, 0

define :clk_div_even do | idx, display=false |
  ### only on start
  count_reset_all(idx) # done, untested
  send_cue(look, :bar64, 1024)
  send_cue(look, :bar32, 512)
  send_cue(look, :bar16, 256)
  send_cue(look, :bar8, 128)
  send_cue(look, :bar4, 64)
  send_cue(look, :bar2, 32)
  send_cue(look, :bar1, 16,true)
  send_cue(look, :bar_half, 8,true)
  send_cue(look, :beat, 4,true)
  send_cue(look, :note_8, 2,true)
  cue :clk, count: idx
  set :current_16th, (1 + get[:current_16th]) # always
  
  #### resets here- needs to go after cues?
  reset_count(:current_bar, num_bars) # if req
  reset_count(:current_beat, num_beats) # if req
  reset_count(:current_16th, num_beats) # if req
end

define :update_count do |key_current, key_total|
  set key_current, (1 + get[key_current])
  set key_total, (1 + get[key_current]) ### update the value here? after cues are sent? WATCH OUT 1+0 error!
end

define :reset_count do |key, reset_every|
  if get[key] > reset_every #(bars-1)
    set key, 0 # will be required in a running function / liveloop on run AND reset
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

update_count(:current_bar, :total_bars) # theres more than 1
update_count(:current_beat, :total_beats) # theres more than 1

define :send_cue_and_update_count do |idx, key, int, bool=false| #- poorly names function? sends cue and updates counters
  ### bool is optional start on zero or not
  if test_modulo(idx, int) == true and bool == true
    ### send on clock count of zero
    cue key
  elsif test_modulo(idx, int) == true and idx > 0
    ### default behaviour
    cue key
  end
end

define :print_bars_and_beats do |len=8, beats=4| ### len and beats should coome from getters
  puts "Current Bar : #{get[:current_bar]} / #{len} | Total: #{total_bars} bars"
  puts "Current Beat: #{current_beat} / #{beats} | Total: #{total_beats} beats"
end


########
### which cues should have thier own thread? if any?
cue :trig_1_bar, val_of_current_bar: get[:current_bar] # current bar is always available so no need to send with each cue, also creates duplicte
# players do their thing - any cues they send should be first? eg, if snare is looking for open hat false?
##| sleep rate
