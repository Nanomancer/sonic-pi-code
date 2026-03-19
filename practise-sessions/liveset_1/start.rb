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
  16.times do
    sync :clk
    if spread(1, 4).tick(offset: 2)
      play :c4,
        amp: 0.5,
        release: 0.5
    end
  end
end

live_loop :bass_drum do
  sync :bar1
  4.times do
    sync :beat
    sample :bd_haus, amp: 0.8
  end
end

live_loop :overheads do
  sync :bar1
  sample :drum_cymbal_soft
end

