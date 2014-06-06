Code list:
Template
Folder name: File description
	- Code version required to run (Matlab 2013b, Anaconda 1.9.1)
	- Modules/libraries required
	- Operation status (needs debugging? known issues?)
	- Other notes


CODE FOLDERS:
Agilent3000_Oscil_MATLAB: A set of routines to read data from an Agilent Oscilloscope. 
	- Written for Matlab R2013b
	- Requires Data Acquisition Toolbox and oscilloscope VISA drivers
	- Untested, but taken from operational code. Proper error handling has not been implemented.
	- Used for the lab's Agilent DSO-3014 oscilloscopes.
	- Unknown how adaptable the code is to other Agilent oscilloscopes (likely?)
	- Tektronix oscilloscopes have different commands for talking with the oscilloscpe, so don't use this as a base for them.

NI_DAQ_MATLAB: simpleDAQ.m is a simple routine for communicating with a DAQ system.
	- Written for R2013b
	- Requires Data Acquisition Toolbox and NImax to be installed
	- Not debugged
	- ?

Tektronix2000_Oscil_MATLAB: A few different routines for reading data from a 2000 series Tektronix Oscilloscope.
	- Written for Matlab R2011a
	- Requires Data Acquisition Toolbox, oscilloscope VISA drivers, and appropriate mdd files (last one included)
	- Tek2000_simple.m untested, through the one I'm working on supporting. Tek_data_chX.m have all been tested (with R2011a)
	- Unknown if these would work with the 3000 series oscilloscopes with some work.

