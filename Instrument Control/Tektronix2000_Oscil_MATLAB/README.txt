The Tek2000_simple routine is based on some old code the lab had lying around for interfacing with our Tektronix 2000 series oscilloscopes. Several of the old routines (Tek_data_Xch.m) are also included, but I'm not particularly in the mood to update them. They do still appear to work properly as of R2013b.

To run these files, you will need appropriate VISA drivers for the oscilloscopes installed (www.ivifoundation.org) and the necessary mdd files (which are included in the folder). Use 2000B for the 2014B. Include the mdd files somewhere in your MATLAB path--either in your working directory or somewhere else relevant (say in the Instrument Control Toolbox folder). You can get the USB address ('USB0::...::INSTR') by using MATLAB's tmtool to scan for USB devices, or alternately using the Measurement and Automation Explorer provided by National Instruments should work as well.

I have not tested these routines with the 3000 series oscilloscopes. I make no promises they can be properly modified. It appears that the method for communicating with the 3000 series is closer to what the Agilent 3000 series code does (though the specific commands are different*. Break out that programmers guide!).

Paul Anzel 11-6-14

*Consistency is all I ask, immortality is as we seek. Give us this day our daily week. - Rosencratz and Guildenstern are Dead