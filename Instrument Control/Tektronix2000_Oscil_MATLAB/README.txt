The Tek2000_simple routine is based on some old code the lab had lying around for interfacing with our Tektronix 2000 series oscilloscopes. Several of the old routines (Tek_data_Xch.m) are also included, but I'm not particularly in the mood to update them.

To run these files, you will need appropriate VISA drivers for the oscilloscopes installed (www.ivifoundation.org) and the necessary mdd files (which are included in the folder). Use 2000B for the 2014B. Include the mdd files somewhere in your MATLAB path--either in your working directory or somewhere else relevant (say in the Instrument Control Toolbox folder).

Last I tried to use these programs was R2011a or so. Things may have changed now that we've moved to 64-bit systems.

I have not tested these routines with the 3000 series oscilloscopes. I make no promises.

Paul Anzel 6-6-14