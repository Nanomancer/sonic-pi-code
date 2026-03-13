#### even_clk_div() notes

set :current_bar, 0 # will be required in a running function / liveloop on run AND reset
set :current_beat, 0
set :total_bars, 0
set :total_beats, 0

bars = 8 ## when to reset, req as arg to even_clock_div
beats = 4 ## wnen to reset current_beat
rate = 0.25 # arg to even_clock_div

########
### which cues should have thier own thread? if any?
cue :trig_1_bar, val_of_current_bar: get[:current_bar]
# players do their thing - any cues they send should be first? eg, if snare is looking for open hat false?
sleep rate

set :total_bars, (1 + get[:current_bar])
set :current_bar, (1 + get[:current_bar]) ### update the value here? after clock has slept?



# test
puts get[:current_bar]


###### RANDOM IDEA
# puts "boom" every kick, "ts" / "tsss" / "chick" every hat, "thwack!" for snare etc