##### START #####

live_loop :clock do #### where is best for clock? issues with vars not resetting unless at top
  clk_div_even(tick)
  sleep 0.25
end


live_loop :drone do
  sync :bar4
  sample :ambi_drone, amp: 0.6, beat_stretch: 16
end

### tech arp phase 1
##| sync :bar1

##| live_loop :tech_arp do
##|   sync :clk
##|   play :c4, amp: 0.5, release: 0.5 if spread(1,4).tick(offset: 2)
##| end

### tech arp phase 1 refactored ready for phase 2
live_loop :tech_arp do
  sync :bar1
  tick_reset # in case we go out of sync if thread dies
  16.times do # sync waits for next do / end loop,
    sync :clk
    if spread(1, 4).tick(offset: 2)
      play :c4,
        amp: 0.5,
        release: 0.5
    end
  end
  ##| stop
end

### bass drum phase 1

live_loop :bass_drum do
  sync :beat
  sample :bd_haus, amp: 0.8
end

### bass drum phase 2 & 3

live_loop :bass_drum do
  sync :bar1
  bar = get[:c_bar] # phase 3
  tick_reset # phase 2
  4.times do
    sync :beat
    if bar < 15 # phase 3
      sample :bd_haus,
        amp: 0.9 * [1, 0.8, 0.9, 0.75].ring.tick # phase 2
    end
  end
end

live_loop :overheads do
  sync :bar8
  sample :drum_cymbal_soft
end

