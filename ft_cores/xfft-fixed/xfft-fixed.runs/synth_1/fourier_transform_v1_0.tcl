# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xczu9eg-ffvb1156-2-e

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.cache/wt [current_project]
set_property parent.project_path /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part xilinx.com:zcu102:part0:3.2 [current_project]
set_property ip_repo_paths /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs [current_project]
set_property ip_output_repo /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/imports/new/fourier_transform_v1_0_user_logic.vhd
  /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/new/xfft-fixed_wrapper.vhd
  /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/imports/new/fourier_transform_v1_0.vhd
}
read_ip -quiet /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/ip/fft_fixed_fft_0/fft_fixed_fft_0.xci
set_property used_in_implementation false [get_files -all /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/ip/fft_fixed_fft_0/fft_fixed_fft_0_ooc.xdc]

read_ip -quiet /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/ip/fft_fixed_fixed18_to_float_0/fft_fixed_fixed18_to_float_0.xci
set_property used_in_implementation false [get_files -all /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/ip/fft_fixed_fixed18_to_float_0/fft_fixed_fixed18_to_float_0_ooc.xdc]

read_ip -quiet /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/ip/fft_fixed_float_to_fixed18_0/fft_fixed_float_to_fixed18_0.xci
set_property used_in_implementation false [get_files -all /media/soc/Volume/master-thesis/ft_cores/xfft-fixed/xfft-fixed.srcs/sources_1/ip/fft_fixed_float_to_fixed18_0/fft_fixed_float_to_fixed18_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top fourier_transform_v1_0 -part xczu9eg-ffvb1156-2-e


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef fourier_transform_v1_0.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file fourier_transform_v1_0_utilization_synth.rpt -pb fourier_transform_v1_0_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
