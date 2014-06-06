clear all
close all
clc

numRepeat       = 20;
numTest         = numRepeat*1000;

% Create a VISA-USB object.
interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x036A::C033087::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('NI', 'USB0::0x0699::0x036A::C033087::0::INSTR');
%     interfaceObj = visa('TEK', 'USB0::0x0699::0x036A::C033087::0::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object. 
deviceObj = icdevice('tektronix_tds2024.mdd', interfaceObj);


% Connect device object to hardware.
connect(deviceObj);


% Execute device object function(s).
groupObj = get(deviceObj, 'Waveform');


fig100          = figure(100);
para.screenSize = get(0, 'ScreenSize');
set(fig100, 'Position', [0 0 para.screenSize(3)/2 para.screenSize(4) ] );

inSigV.ch1 = [];
inSigT.ch1 = [];

ith = 1;

breakLoop   = 0;

while breakLoop == 0,
  
    disp('Press Enter to take the data');    pause
    disp('Data acquisition in progress')
    [Y1, X1, YUNIT, XUNIT] = invoke(groupObj, 'readwaveform', 'channel1');
    subplot(211)
    plot(X1*1e3,Y1, 'linewidth',2)
    %legend('Channel1')
    xlabel('time [ms]')
    ylabel('voltage [V]')
    grid on
    xlim([min(X1), max(X1)]*1e3)
    hold on

    
    jth = mod(ith,numRepeat);
    if jth == 0
        subplot(211)
        plot(inSigT.ch1(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch1(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5)
        hold off      
    elseif jth ~= 1
        subplot(211)
        plot(inSigT.ch1(ith-jth+1:ith-1,:)'*1e3,inSigV.ch1(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5)
        hold off        
    else
        subplot(211)
        hold off        
    end
    
    
    response = input('Save data? If yes, press ENTER. If no, press N. If want to exit, press E','s');
    
    if isempty(response)
        disp(strcat('Saving data for testing No ', num2str(ith)))
        disp('==================================================')
        ith        = ith + 1;
        inSigV.ch1 = [inSigV.ch1;Y1];
        inSigT.ch1 = [inSigT.ch1;X1];
    elseif isequal(response,'E')
        inSigV.ch1 = [inSigV.ch1;Y1];
        inSigT.ch1 = [inSigT.ch1;X1];
        breakLoop = 1;
    else
        disp('Skipping data')
    end
end

% Delete objects.
delete([deviceObj interfaceObj]);
