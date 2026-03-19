##| sync :drone

live_loop :clock do
  clk_div_even(tick)
  sleep 0.25
end

