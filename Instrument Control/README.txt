Code list:
Template
filename: File description
	- Code version required to run (Matlab 2013b, Anaconda 1.9.1)
	- Modules/libraries required
	- Operation status (needs debugging? known issues?)
	- Other notes

MATLAB ROUTINES:
simpleDAQ.m: A simple routine for communicating with a DAQ system.
	- Written for R2013b
	- Requires Data Acquisition Toolbox and NImax to be installed
	- Not debugged
	- ?

CODE FOLDERS:
Agilent_Oscil_simple: A set of routines to read data from an Agilent Oscilloscope. 
	- Written for Matlab R2013b
	- Requires Data Acquisition Toolbox and oscilloscope VISA drivers
	- Untested, but taken from operational code. Proper error handling has not been implemented.
	- Tektronix oscilloscopes have different commands for talking with the oscilloscpe. Don't use this.

Tektronix2000_Oscil_MATLAB: A few different routines for reading data from a 2000 series Tektronix Oscilloscope.
	- Written for Matlab R2011a
	- Requires Data Acquisition Toolbox, oscilloscope VISA drivers, and appropriate mdd files (last one included)
	- Tek2000_simple.m untested, through the one I'm working on supporting. Tek_data_chX.m have all been tested (with R2011a)
	- Unknown if these would work with the 3000 series oscilloscopes with some work.

