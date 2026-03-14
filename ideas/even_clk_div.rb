#### even_clk_div() definition, helper functions and notes

set :bars, 8 # globally available - assign within save file / function def file but outside of functions
set :beats, 4
### when needed locally
bars = get[:bars] ## when to reset bar counter / current_bar, req as arg to even_clock_div
beats = get[:beats]

### KEEP IN MIND LIVE CODING + RULES OF AUDIENCE UNDERSTANDING
### call like:
##| live_loop :the_clock do
##|   even_clk_div(tick)
##|   sleep 0.25
##| end

define :even_clk_div do | idx |
  
  bars = get[:bars] ## when to reset bar counter / current_bar, req as arg to even_clock_div
  beats = get[:beats]
  ### only on start
  if idx == 0
    set :total_bars, 0
    set :total_beats, 0
    
    set :current_bar, 0 # will be required in a running function / liveloop on run AND reset
    set :current_beat, 0
    set :current_sixteenth, 0 # relative to bars, not the clk
  end
  
  ### we can find out where we are with modulo or something like
  ##| if prev < current ? - too many assignments, gets confusing
  
  ### increase the count- based on what?
  set :current_sixteenth, (1 + get[:current_sixteenth]) # always
  
  #### resets here- needs to go after cues
  if current_bar > (bars-1)
    set :current_bar, 0 # will be required in a running function / liveloop on run AND reset
    set :current_beat, 0
    set :current_sixteenth, 0 # relative to bars
  end
end

define :update_count do |key_current, key_total|
  ##| puts "Clock division: #{key} (#{division}) | Beat number: #{idx+1}"
  set :total_bars, (1 + get[:current_bar]) ### update the value here? after cues are sent?
  set :current_bar, (1 + get[:current_bar])
end

define :send_cue do |idx, key, int, bool=false| #- poorly names function? sends cue and updates counters
  ### bool is optional start on zero or not
  if test_modulo(idx, int) == true and bool == true
    ### send on clock count of zero
    cue key
    update_count()
    
  elsif test_modulo(idx, int) == true and idx > 0
    ### default behaviour
    cue key
    ##| puts "Clock division: #{key} (#{division}) | Beat number: #{idx+1}"
  end
end

########
### which cues should have thier own thread? if any?
cue :trig_1_bar, val_of_current_bar: get[:current_bar] # current bar is always available so no need to send with each cue, also creates duplicte
# players do their thing - any cues they send should be first? eg, if snare is looking for open hat false?
##| sleep rate
