########## Function Definitions ##########

########## clocking and cues ##########
# send cue needs to send its own count value?
# eg :trig_1_bar counts the total number of bars since run_code
# whats req is a simple function puts current bar in N bar loop, current beat in bar, total bars since run

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

define :clk_div do |idx,bool=true|
  ##| puts "clock look #{look}" if look % 4 == 0
  ####| division cues
  send_cue(look, :trig_64_bar, 1024)
  send_cue(look, :trig_32_bar, 512)
  send_cue(look, :trig_16_bar, 256)
  send_cue(look, :trig_8_bar, 128)
  send_cue(look, :trig_4_bar, 64)
  send_cue(look, :trig_2_bar, 32)
  send_cue(look, :trig_1_bar, 16,true)
  send_cue(look, :trig_half, 8,true)
  send_cue(look, :trig_qtr, 4,true)
  send_cue(look, :trig_8th, 2,true)
  cue :clk, count: look
  if bool = true
    ##| puts "BEAT COUNTER"
  end
end

define :send_cue do |idx, key, int, bool=false|
  if clock_divider(idx, int) == true and bool == true
    ### send on clock count of zero
    cue key, trig_count: idx, trig: true
    ##| puts "Clock division: #{key} (#{division}) | Beat number: #{idx+1}"
    
  elsif clock_divider(idx, int) == true and idx > 0
    ### default behaviour
    cue key, trig_count: idx, trig: true
    ##| puts "Clock division: #{key} (#{division}) | Beat number: #{idx+1}"
  end
end

define :clock_divider do |idx, division|
  if idx < 0
    puts "clock divider received a negative number!"
    return false
  else
    if idx % division == 0
      return true
    end
  end
end


define :snare_rules do |int =2|
  ########## percussion rules ##########
  ### 0 = off
  ### 1 = strictest
  ### 2 = strict
  ### 3 = relaxed
  ### defaults to strict
  rules = [
    [true],
    [
      false,false,false,true, true,true,false,true,
      false,true,false,true, true,true,false,true,
    ],
    [
      false,false,false,true, true,true,true,true,
      false,true,false,true, true,true,true,true,
    ],
    [
      false,false,true,true, true,true,true,true,
      false,true,true,true, true,true,true,true,
    ],
  ]
  if int >= rules.length
    int = rules.length-1
  end
  return rules[int].ring
end

define :reset_freq do |cue, rst|
  ### where used? will be obsolete when resets are based on sync
  ### resets tick based on clock count and bars
  ### rst expects int. (number of bars)
  ### expects clock of 16ths ? TEST
  idx = cue[:count]
  if idx > 0 and idx % (rst * 16) == 0
    tick_reset
  end
end

########## MISC ##########

define :humanise do |percent = 10|
  ### use with a multiplier to provide a +/- percent variation total.
  ### eg amp: 0.9 * humanise(10) varies amp by +/- 5%
  percent = (percent/100.0) / 2
  a = 1 - percent
  b = 1 + (1 * percent)
  return rrand(a, b)
end

