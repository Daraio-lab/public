function [errtest] = ArmOscil(oscilobj)
% InitOscil:
%	Short routine to arm Agilent-type oscilloscope. (Pressing "Single" button)
%
% Call [errtest] = ArmOscil(oscilobj, oscil)
% Inputs:
%	oscilobj: Objcet handle for oscilloscope.
% 
% Outputs:
%	errarm: Someday I'll deal with error handling. Someday.
%
% Ver 1 by Paul Anzel, 1-Jun-2014.

try
    fprintf(oscilobj,':SINGLE');
    errtest = 0;
catch ME
    ME
    errtest = 1;
end


end

