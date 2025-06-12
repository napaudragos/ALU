vlib work

vlog top.v
vlog control_unit.v
vlog mul_fsm.v
vlog div_fsm.v
vlog add_sum_fsm.v
vlog arithmetic_unit.v
vlog shift_reg_16.v
vlog reg4bit.v
vlog reg_8.v
vlog reg1bit.v
vlog cnt.v
vlog adder.v
vlog top_tb.v

vsim work.top_level_tb

add wave *

run -all
