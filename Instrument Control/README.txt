Code list:
Template
filename: File description
	- Code version required to run (Matlab 2013b, Anaconda 1.9.1)
	- Modules/libraries required
	- Operation status (needs debugging? known issues?)
	- Other notes

C++ ROUTINES:
- None -

LabVIEW ROUTINES:
- None -

MATLAB ROUTINES:
simpleDAQ.m: A simple routine for communicating with a DAQ system.
	- Written for R2013b
	- Requires Data Acquisition Toolbox and NImax to be installed
	- Not debugged
	- ?

PYTHON ROUTINES:
- None -

CODE FOLDERS (Extended projects):
Agilent_Oscil_simple: A set of routines to read data from an Agilent Oscilloscope. 
	- Written for Matlab R2013b
	- Requires Data Acquisition Toolbox and oscilloscope VISA drivers
	- Untested, but taken from operational code. Proper error handling has not been implemented.
	- Tektronix oscilloscopes have different commands for talking with the oscilloscpe. Don't use this.