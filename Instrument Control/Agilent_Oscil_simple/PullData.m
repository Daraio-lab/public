function [dataout, errdata] = PullData(oscilobj,oscil)
% PullData: 
%   Waits for oscilloscope to be triggered. Then pulls the data to the computer. These commands
%   only work with Agilent-type oscilloscopes.
%
%   Call [dataout, errdata] = PullData(oscilobj,oscil)
%
%   Inputs:
%       - oscilobj: The object handle reference for the oscilloscope (from InitOscil or other)
%       - oscil: Structure with Oscilloscope parameters. Important subvalues are
%              ChannelsToRead: Array of numbers with the Oscilloscope channels to be read
%              ReadPoints: How many datapoints will be downloaded from the oscilloscope
%
%   Outputs:
%       - dataout: Array of output data. Structure of  dataout.t and dataout.V, which are times
%           (all the same)  and voltages, respectively.
%       - errdata: Some day I'll actually get error handling to work properly.
%         
% Ver 1.0 by Paul Anzel, 1-Jun-2014. Much of this code was taken from the Mathworks website, I don't
%   remember the original source.
%

errdata = 0;

triggered = 1;
while triggered == 0
    triggered = str2double(query(oscilobj, ':TER?'));
end

numchan = length(oscil.ChannelsToRead);
numdata = oscil.ReadPoints;

dataout.t = zeros(numchan,numdata);
dataout.V = zeros(numchan,numdata);

ii = 1;

for chanindex = oscil.ChannelsToRead

    inputstring = [':WAVEFORM:SOURCE CHAN', num2str(chanindex)];    
    fprintf(oscilobj,inputstring)

    fprintf(oscilobj,':WAV:POINTS:MODE RAW');
    inputstring = [':WAV:POINTS ', num2str(numdata)];
    fprintf(oscilobj,inputstring);

    % Get the data back as a WORD (i.e., INT16), other options are ASCII and BYTE
    fprintf(oscilobj,':WAVEFORM:FORMAT WORD');
    % Set the byte order on the instrument as well
    fprintf(oscilobj,':WAVEFORM:BYTEORDER LSBFirst');
    % Get the preamble block
    preambleBlock = query(oscilobj,':WAVEFORM:PREAMBLE?');
    % The preamble block contains all of the current WAVEFORM settings.  
    % It is returned in the form <preamble_block><NL> where <preamble_block> is:
    %    FORMAT        : int16 - 0 = BYTE, 1 = WORD, 2 = ASCII.
    %    TYPE          : int16 - 0 = NORMAL, 1 = PEAK DETECT, 2 = AVERAGE
    %    POINTS        : int32 - number of data points transferred.
    %    COUNT         : int32 - 1 and is always 1.
    %    XINCREMENT    : float64 - time difference between data points.
    %    XORIGIN       : float64 - always the first data point in memory.
    %    XREFERENCE    : int32 - specifies the data point associated with
    %                            x-origin.
    %    YINCREMENT    : float32 - voltage diff between data points.
    %    YORIGIN       : float32 - value is the voltage at center screen.
    %    YREFERENCE    : int32 - specifies the data point where y-origin
    %                            occurs.
    % Now send commmand to read data
    fprintf(oscilobj,':WAV:DATA?');
    % read back the BINBLOCK with the data in specified format and store it in
    % the waveform structure. FREAD removes the extra terminator in the buffer
    waveform.RawData = binblockread(oscilobj,'uint16'); fread(oscilobj,1);
    % Read back the error queue on the instrument
    instrumentError = query(oscilobj,':SYSTEM:ERR?');
    while ~isequal(instrumentError,['+0,"No error"' char(10)])
        disp(['Instrument Error: ' instrumentError]);
        instrumentError = query(oscilobj,':SYSTEM:ERR?');
    
        errdata = 1;
    
    end

% Extract the X, Y data and plot it 

% Maximum value storable in a INT16
    maxVal = 2^16; 

%  split the preambleBlock into individual pieces of info
    preambleBlock = regexp(preambleBlock,',','split');

% store all this information into a waveform structure for later use
    waveform.Format = str2double(preambleBlock{1});     % This should be 1, since we're specifying INT16 output
    waveform.Type = str2double(preambleBlock{2});
    waveform.Points = str2double(preambleBlock{3});
    waveform.Count = str2double(preambleBlock{4});      % This is always 1
    waveform.XIncrement = str2double(preambleBlock{5}); % in seconds
    waveform.XOrigin = str2double(preambleBlock{6});    % in seconds
    waveform.XReference = str2double(preambleBlock{7});
    waveform.YIncrement = str2double(preambleBlock{8}); % V
    waveform.YOrigin = str2double(preambleBlock{9});
    waveform.YReference = str2double(preambleBlock{10});
    waveform.VoltsPerDiv = (maxVal * waveform.YIncrement / 8);      % V
    waveform.Offset = ((maxVal/2 - waveform.YReference) * waveform.YIncrement + waveform.YOrigin);         % V
    waveform.SecPerDiv = waveform.Points * waveform.XIncrement/10 ; % seconds
    waveform.Delay = ((waveform.Points/2 - waveform.XReference) * waveform.XIncrement + waveform.XOrigin); % seconds

% Generate X & Y Data
    waveform.XData = (waveform.XIncrement.*(1:length(waveform.RawData))) - waveform.XIncrement;
    waveform.YData = (waveform.YIncrement.*(waveform.RawData - waveform.YReference)) + waveform.YOrigin; 

    dataout.t(ii,:) = waveform.XData;
    dataout.V(ii,:) = waveform.YData;
    ii = ii + 1;

end
    
end

