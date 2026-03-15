##### Misc func. defs.

define :humanise do |percent = 10|
  ### use with a multiplier to provide a +/- percent variation total.
  ### eg amp: 0.9 * humanise(10) varies amp by +/- 5%
  percent = (percent/100.0) / 2
  a = 1 - percent
  b = 1 + (1 * percent)
  return rrand(a, b)
end