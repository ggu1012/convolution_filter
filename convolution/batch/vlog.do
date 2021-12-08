vlog /data3/Class/SID/2021_2/2021_2_sidXX/project/convolution/input/conv1.v
vlog /data3/Class/SID/2021_2/2021_2_sidXX/project/convolution/input/conv2.v 
vlog /data3/Class/SID/2021_2/2021_2_sidXX/project/convolution/input/conv3.v 

vlog /data3/Class/SID/2021_2/2021_2_sidXX/project/convolution/input/do_conv.v

vsim -c do_conv -wlf /data3/Class/SID/2021_2/2021_2_sidXX/project/convolution/batch/wav_do_conv.wlf

log -r *

run -all

quit

