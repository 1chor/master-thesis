open_project soc_project.xpr

if {[file exists reports] == 0 } {
	file mkdir reports
	puts "Create Folder"
} else {
	file delete -force -- {*}[glob reports/*]
	puts "Clean Folder"
}

puts "\n++++++++++++++++++++++++++++++"
puts "++ Create report for ZCU102 ++"
puts "++++++++++++++++++++++++++++++\n"

set filename zcu102

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

puts "\n++++++++++++++++++++++++++++"
puts "++ Create report for XFFT ++"
puts "++++++++++++++++++++++++++++\n"

set filename xfft

# Load checkpoint
open_checkpoint ./soc_project.runs/impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_xfft_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

puts "\n++++++++++++++++++++++++++++++++++"
puts "++ Create report for XFFT-fixed ++"
puts "++++++++++++++++++++++++++++++++++\n"

set filename xfft-fixed

# Load checkpoint
open_checkpoint ./soc_project.runs/child_0_impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_xfft-fixed_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

puts "\n+++++++++++++++++++++++++++"
puts "++ Create report for DFT ++"
puts "+++++++++++++++++++++++++++\n"

set filename xdft

# Load checkpoint
open_checkpoint ./soc_project.runs/child_1_impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_xdft_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

puts "\n+++++++++++++++++++++++++++++++"
puts "++ Create report for INTFFTK ++"
puts "+++++++++++++++++++++++++++++++\n"

set filename intfftk

# Load checkpoint
open_checkpoint ./soc_project.runs/child_2_impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_intfftk_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

puts "\n+++++++++++++++++++++++++++++++++++"
puts "++ Create report for INTFFT_SPDF ++"
puts "+++++++++++++++++++++++++++++++++++\n"

set filename intfft_spdf

# Load checkpoint
open_checkpoint ./soc_project.runs/child_3_impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_intfft_spdf_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

puts "\n+++++++++++++++++++++++++++++++++"
puts "++ Create report for DBLCLKFFT ++"
puts "+++++++++++++++++++++++++++++++++\n"

set filename dblclkfft

# Load checkpoint
open_checkpoint ./soc_project.runs/child_4_impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_dblclkfft_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

puts "\n+++++++++++++++++++++++++++++++"
puts "++ Create report for GREYBOX ++"
puts "+++++++++++++++++++++++++++++++\n"

set filename greybox

# Load checkpoint
open_checkpoint ./soc_project.runs/child_5_impl_1/fourier_transform_0_user_logic_inst_ft_wrapper_0_routed.dcp

# Create virtual clock (needed for power report)
create_clock -period 10.001 -name virtclk

# Create utilization report
report_utilization -file ./reports/${filename}_utilization.txt -name utilization_1

# Create power report
report_power -file {./reports/${filename}_power.pwr} -xpe {./reports/${filename}_power.xpe} -name {power_1}

# Close Checkpoint
close_design

close_project
