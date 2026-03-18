##### Misc func. defs.

define :humanise do |percent = 10|
  ### use with a multiplier to provide a +/- percent variation total.
  ### eg amp: 0.9 * humanise(10) varies amp by +/- 5%
  percent = (percent/100.0) / 2
  a = 1 - percent
  b = 1 + (1 * percent)
  return rrand(a, b)
end


define :snare_rules do |int =1|
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

