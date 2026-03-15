########## Function Definitions ##########

########## clocking and cues ##########
# send cue needs to send its own count value?
# eg :trig_1_bar counts the total number of bars since run_code
# whats req is a simple function puts current bar in N bar loop, current beat in bar, total bars since run

define :clk_div do |idx,bool=true|
  ##| puts "clock look #{look}" if look % 4 == 0
  ####| division cues
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
  cue :clk, count: look
  if bool = true
    ##| puts "BEAT COUNTER"
  end
end

define :send_cue do |idx, key, int, bool=false|
  if clock_divider(idx, int) == true and bool == true
    ### send on clock count of zero
    cue key, clk_count: idx
    ##| puts "Clock division: #{key} (#{division}) | Beat number: #{idx+1}"
    
  elsif clock_divider(idx, int) == true and idx > 0
    ### default behaviour
    cue key, clk_count: idx
    ##| puts "Clock division: #{key} (#{division}) | Beat number: #{idx+1}"
  end
end

define :clock_divider do |idx, division|
  if idx % division == 0
    return true
  end
end


define :bar_counter do |len=8, beats=4|
  sync :trig_1_bar
  total_beats = 0
  total_bars = 0
  loop do
    current_bar = 0
    len.times do
      current_beat = 0
      current_bar += 1
      total_bars += 1
      beats.times do
        sync :trig_qtr
        total_beats += 1
        current_beat += 1
        puts "Current Bar : #{current_bar} / #{len} | Total: #{total_bars} bars"
        puts "Current Beat: #{current_beat} / #{beats} | Total: #{total_beats} beats"
      end
    end
  end
end
