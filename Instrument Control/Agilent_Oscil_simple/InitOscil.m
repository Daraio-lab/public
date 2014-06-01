function [OSCOBJ, errtest] = InitOscil(oscil)

% InitOscil:
%	Short routine to initialize connection with Agilent-type oscilloscope.
%
% Call [OSCOBJ, errtest] = InitOscil(oscil)
%
% Inputs:
%	oscil: Structure with fields
%		Make: Should be set to 'agilent', as 'tek' oscilloscopes have a different set of
%			commands (argh).
%		Address: USB address for oscilloscope. Unknown if this would work with a GPIB
%		InputBufferSize: Who knows, man?
% 
% Outputs:
%	OSCOBJ: Handle for oscilloscope object.
%	errtest: Someday I'll deal with error handling. Someday.
%
% Ver 1 by Paul Anzel, 1-Jun-2014.

%try

OSCOBJ = visa(oscil.Make,oscil.Address);
% Set the buffer size
OSCOBJ.InputBufferSize = oscil.InputBufferSize; % Do I need to make this bigger?
% Set the timeout value
OSCOBJ.Timeout = 10;
% Set the Byte order
OSCOBJ.ByteOrder = 'littleEndian';
% Open the connection
fopen(OSCOBJ);
fprintf(OSCOBJ,':TIMEBASE:MODE MAIN');
% Set up acquisition type and count. 
fprintf(OSCOBJ,':ACQUIRE:TYPE NORMAL');
fprintf(OSCOBJ,':ACQUIRE:COUNT 2');

errtest = 0;

%catch ME
%    ME
%    errtest = 1;
    
%end

end