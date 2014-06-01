% simpleDAQ, a simple script routine to read data from a NI DAQ board. This
% does not write anything, just reads. Additional code for writing is
% included, just remove the comments as necessary--search for WRITECODE
%
% This requires the Data Acquistion Toolbox. This is writen in R2013b.
%
% This code is written for R2013b. It appears that the DAQ Session Based
% Interface has somewhat changed for R2014a, with syntax like
% d.functionFunction(....) changed to functionFunction(d, ...). Thanks
% Mathworks for changing things up for me. Y'all real pals.
%
% Ver 1.0 by Paul Anzel, 1-Jun-2014
%   NOTE THIS HAS NOT BEEN DEBUGGED YET! BUGS AND TYPOS ARE GOOD FOR THE
%   SOLE! [sic]
%   

daqreset
clear all

% Things to before each run, if necessary
% Folder and file to save things to
filenameset                 = 'Testing';
filenamefolder              = 'Testing';

%Semi-permanent parameters--here's where you set up the DAQ system
time_span                   = 3;  %How long do we scan for? [sec]
sample_freq                 = 5000; %Sampling rate [Hz]
timeout_val                 = 10; % How long to wait for a trigger before software throws a timeout [sec]
device_address              = 'Dev1'; %What does the computer call the DAQ? Use NImax to figure this out
readchannel                 = [0,1]; %Which channels do we read from? For multiple channels, make a list
readchannel_range           = [10,5]; %Make an array with the range of voltages you want
triggerchannel              = {'Dev1/PFI0'}; %Which channel do we trigger from? If none, leave blank
% WRITECODE
% writechannel                = [0,1]; Which channels do we write to? For multiple channels, make a list

%Data output: Here's where you make an array of data to output. One column per channel
%dataoutput = [sin(2*pi*(1:round(time_span*sample_freq)))' ones(round(time_span*sample_freq),1)];

%Check that input is good
try
    if numel(readchannel) ~= numel(readchannel_range)
       error('BADINPUT:ReadChannel', ...
           'Bad input: \nThere must be as many channels to read as range_values.') 
    end
    
    if numel(triggerchannel)>1
       error('BADINPUT:TriggerChannel',...
           'Bad input: \nOnly one trigger channel input allowed.') 
    end
    
    if exist('writechannel', 'var')&&numel(triggerchannel)>0
       warning('Warning: \nI have no idea if triggering and outputting work together. \nPress a key to continue or CTRL-C to quit.') 
       pause
    end
    
    %WRITECODE
%    sizeout = size(dataoutput);
%     if numel(writechannel)~=sizeout(2)
%         error('BADINPUT:OutputChannel',...
%             'Bad input: \nThe number of output channels and data sets for each mismatch.')
%     end
    
    
catch err    
    rethrow(err)
    
end

if ~exist(strcat('./', filenamefolder), 'dir')
    mkdir(strcat('./', filenamefolder));
end
if exist(strcat('./', filenamefolder,'/',filenameset), '.mat')
   warning('File already exists. Press a key to continue and overwrite, press CTRL-C to terminate')
   pause
end

%initialize
try
    
d = daq.createSession('ni');
for ind = 1:numel(readchannel)
    d.addAnalogInputChannel(device_address,strcat('ai',num2str(readchannel(ind))),'Voltage');
    d.Channels(ind).Range = readchannel_range(ind);
    %d.Channels(ind).TerminalConfig = 'SingleEnded'; Probably unimportant,
    %but one might need to mess with this at some point
end

d.DurationInSeconds = timespan;
d.Rate = sample_freq;

if numel(triggerchannel)
    tc = d.addTriggerConnection('external', triggerchannel, 'StartTrigger');
    d.ExternalTriggerTimeout = timeoutval;
end

%WRITECODE
% for ind = 1:numel(writechannel)
%    d.addAnalogOutputChannel(device_address,strcat('a0',num2str(writechannel(ind))),'Voltage');
% end

catch err
    disp('Initialization error')
    rethrow(err)
    
end

%run

try    
    disp('Press a key to get ready to take data')
    pause
    disp('Rock out!')
    
    %WRITECODE
    %d.queueOutputData(dataoutput'); %Note the transpose operator
    
    [data, time] = d.startForeground;
    
    disp('Data taken')
    
    plot(time, data, 'k', 'LineWidth', 2)
    xlabel('Time (s)', 'FontSize', 20)
    ylabel('Voltage (V)', 'FontSize', 20)
    drawnow
    
    filenamestr = strcat('./', filenamefolder, '/', filenameset,'.mat');
    disp('Saving data')
    if exist(dataoutput,'var')
        save(filenamestr, 'data','time','dataoutput')
    else
        save(filenamestr, 'data','time')
    end

catch err
    disp('Data collection error :(')

    rethrow(err)
end