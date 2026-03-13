##### BASS #####

fake_sidechain = [
  false,true,true,true,
  false,true,true,true,
  false,true,true,true,
  false,true,true,true,
].ring

update_freq = 16
use_synth :subpulse
##| use_synth :tech_saws

##| pattern = (scale :Eb1, :super_locrian)
##| pattern = (scale :Eb1, :scriabin)

pattern1 = [ :Eb1, :Eb1, :Eb2, :Eb1, :Eb1, :Eb2, :Eb1, :Eb1 ].ring
pattern2 = [ :Eb1, :Eb1, :Eb2, :Eb1, :Eb1, :Eb1, :Eb2, :Eb3, ].ring
pattern3 = [ :Eb1, :Eb1, :Eb2, :Eb2, :Eb1, :Eb1, :Eb3, :Eb3, ].ring
pattern4 = [ :Eb1, :Eb2, :Eb1, :Eb1, :Eb2, :Eb1, :Eb2, :Eb2, ].ring
pattern5 = [ :Eb1, :Eb1, :Eb2, :Eb1, :Eb1, :Eb3, :Eb1, :Eb2, ].ring

patterns = [ pattern1, pattern2, pattern3, pattern4, pattern5 ].ring

live_loop :attack_bass do
  
  pattern = patterns.tick :pattern
  sync :trig_16_bar
  puts "BASS STARTS HERE #{look}"
  (update_freq*16).times do
    tick
    sync :clk
    with_fx :distortion, amp: 0.5, distort: 0.9 do
      if fake_sidechain.look
        play pattern.look, release: [0.1 ,0.075, 0.085 ].ring.look,
          amp: 0.45 * [ 0.9, 0.66, 0.75, 0.5 ].ring.look * humanise(6)
      end
    end
  end
  puts "BASS stops at: #{look}"
  ##| stop
end