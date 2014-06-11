%
% Tek_simple: A wrapper routine that interfaces with a 2000 series 
% Tektronix oscilloscope. It's unknown whether or not this can be made to
% work with the 3000 series oscilloscopes, but I'm a bit doubtful. 
%
% This is a simple script to download any data off of the oscilloscopes.
% Basically, whatever is there paused will be downloaded. You'll need to
% press the single button and all that jazz.
%
% Set-up: You'll need the appropriate drivers installed for Matlab. Install
% appropriate VISA drivers (www.ivifoundation.org) as well as the
% appropriate mdd drivers (either 'tektronix_tds2024.mdd' for the 2024
% devices or the 'tektronix_tds2000B.mdd' for the 2014B units). If you have
% Agilent VISA drivers, those are probably sufficient. Put the mdd files
% somewhere in MATLAB's path (i.e. your working directory, somewhere in the
% instrument control toolbox folder, etc.). Change the icdevice
% line in this code to reflect the correct device. To get the USB device
% address (the USB0::..::INSTR name below) you can use MATLAB's tmtool and
% scan for USB devices.
%
% Afterwards, figure out the USB address of the device. You can use NIMax
% or, on Windows, the native Device Manager. Stick the device address in
% the interfaceObj lines.
%
% Ver 1.0 by Paul Anzel 6-6-14
%   From inherited lab code, some probably generated by MATLAB.
%   The old code works, but I haven't tested it yet. Testing with R2013b.
%
%

%%
close all; clear all; clc
%%
filename_base   = 'Test'; %What the filenames get named. Iterated filename_baseX.mat over X.
filefolder      = 'TestFolder';
commentstr      = 'Put something clever here'; %Any comments you want to add to the data
channelsToRead  = [1]; %Numbers for channels to read
numDataPoints   = 2500; % Should only be 2500 for the 2000 series

if exist(strcat('./', filefolder), 'dir')
    warning('Folder already exists, you may potentially overwrite files. Press a key to continue or CTRL-C to cancel')
    pause
else
    mkdir(filefolder)
end



% Initializing
numchan = numel(channelsToRead);

interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x03A2::C030311::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('NI', 'USB0::0x0699::0x03A2::C030311::0::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object.
deviceObj = icdevice('tektronix_tds2000B.mdd', interfaceObj);

% Connect device object to hardware.
connect(deviceObj);

% Query property value(s).
get1 = get(deviceObj.Acquisition(1), 'Timebase');

% Execute device object function(s).
groupObj = get(deviceObj, 'Waveform');
%%

fig100          = figure(100);

ith = 1;
%%
breakLoop = 0;


while ~breakLoop

    dataout.t = zeros(numchan, numDataPoints);
    dataout.V = zeros(numchan, numDataPoints);

    disp(ith)
    disp('Press any key to take the data');
    pause
    disp('Data acquisition in progress')

    chanind = 1;
    for readind = channelsToRead
        chanstr = ['channel', num2str(readind)];
        [Y1, X1, YUNIT, XUNIT] = invoke(groupObj, 'readwaveform', chanstr);
        
        dataout.t(chanind,:)= X1;
        dataout.V(chanind,:)= Y1;
        chanind = chanind+1;
    end

    %     subplot(211)
    plot(dataout.t'*1e3, dataout.V','linewidth',2)

    xlabel('Time [ms]')
    ylabel('Voltage [V]')
    title(['Channels ', num2str(channelsToRead)]);
    grid on
    xlim([min(X1), max(X1)]*1e3)
    
    
    response = input('Save data? If yes, press ENTER. If no, press N. If want to exit, press E','s');
    
    if isempty(response)
        disp(strcat('Saving data for testing No ', num2str(ith)))
        disp('==================================================')
    
        save(['./', filefolder,'/',filename_base,num2str(ith), '.mat'], 'dataout','commentstr')
        ith = ith + 1;
      elseif isequal(response,'E')
        save(['./', filefolder,'/',filename_base,num2str(ith), '.mat'], 'dataout','commentstr')

        breakLoop = 1;
    else
        disp('Skipping data')
    end
end
%%

% Delete objects.
delete(deviceObj);
delete(interfaceObj);
