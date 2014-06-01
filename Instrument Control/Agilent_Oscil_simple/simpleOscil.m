% simpleOscil:
% A simple set of routines for establishing communication with an Agilent
% oscilloscope. This routine deletes all current objects, initializes the
% connection with the Agilent Oscilloscope (InitOscil), prepares it to take
% a single sample (ArmOscil), and then recovers the data after the
% oscilloscope has been triggered (PullData). Afterwards, it clears things up.
%
% Output dataout is a structure with two subfields, t and V. Time and Voltage
% respectively. Each row in both represents a different data channel.
%
% Note that the Tektronix oscilloscopes have different programming commands.
% 
% This requires the Instrument Control Toolbox and whatever VISA drivers are
% necessary to communicate with an oscilloscope. This is written in R2013b.
%
% Note that while I technically give myself methods to deal with assorted errors,
% the error handling here is pretty minimal. I'll deal with this later.
%
% Ver 1.0 by Paul Anzel, 1-Jun-2014
%	Taken from other bits of code I had lying around. This should work properly.
%

% kill old objects
newobjs = instrfind;
if(~isempty(newobjs))
    fclose(newobjs);
    delete(newobjs);
end
clear newobjs;

%Agilent 3014
oscil.Make = 'agilent';
oscil.Address = 'USB0::0x0957::0x17A8::MY51360495::INSTR'; % You'll need to figure out the USB address for your own device
oscil.InputBufferSize = 100000;
oscil.ByteOrder = 'littleEndian';
oscil.ReadPoints = 50000; % How many data points we read out from the oscilloscope

%Initialize
[oscilobj, erroscil] = InitOscil(oscil);
if erroscil
	disp('Oscil initialization error')
end

%Arm
errarm = ArmOscil(oscilobj); 
if errarm
	disp('Oscil initialization error')
end

%Pull
[dataout, errdata] = PullData(oscilobj,oscil);
if errdata
	disp('Data collection error')
end

%Clear
fclose(oscilobj);
delete(oscilobj);