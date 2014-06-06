%%
close all; clear all; clc
%%

%TEST2 M-Code for communicating with an instrument.
%
%   This is the machine generated representation of an instrument control
%   session using a device object. The instrument control session comprises
%   all the steps you are likely to take when communicating with your
%   instrument. These steps are:NN
numRepeat       = 200;
% numTest         = numRepeat*1000;
%%
% Create a VISA-USB object.
% interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x036A::C033087::0::INSTR', 'Tag', '');

% Create a VISA-USB object.
interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x036A::C020451::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('NI', 'USB0::0x0699::0x036A::C020451::0::INSTR');
    %     interfaceObj = visa('TEK', 'USB0::0x0699::0x036A::C033087::0::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object.
deviceObj = icdevice('tektronix_tds2024.mdd', interfaceObj);

% Connect device object to hardware.
connect(deviceObj);

% Query property value(s).
get1 = get(deviceObj.Acquisition(1), 'Timebase');

% Execute device object function(s).
groupObj = get(deviceObj, 'Waveform');
%%
% Create a VISA-USB object.
% interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x036A::C033087::0::INSTR', 'Tag', '');

% Create a VISA-USB object.
interfaceObj2 = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x036A::C033087::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj2)
    interfaceObj2 = visa('NI', 'USB0::0x0699::0x036A::C033087::0::INSTR');
else
    fclose(interfaceObj2);
    interfaceObj2 = interfaceObj2(1);
end

% Create a device object.
deviceObj2 = icdevice('tektronix_tds2024.mdd', interfaceObj2);

% Connect device object to hardware.
connect(deviceObj2);

% Query property value(s).
get1 = get(deviceObj2.Acquisition(1), 'Timebase');

% Execute device object function(s).
groupObj2 = get(deviceObj2, 'Waveform');
%%

fig100          = figure(100);
para.screenSize = get(0, 'ScreenSize');
set(fig100, 'Position', [0 0 para.screenSize(3)/2 para.screenSize(4) ] );

inSigV.ch1 = [];
inSigT.ch1 = [];

inSigV.ch2 = [];
inSigT.ch2 = [];

inSigV.ch3 = [];
inSigT.ch3 = [];

inSigV.ch4 = [];
inSigT.ch4 = [];

inSigV.ch5 = [];
inSigT.ch5 = [];

inSigV.ch6 = [];
inSigT.ch6 = [];

inSigV.ch7 = [];
inSigT.ch7 = [];

ith = 1;
%%
breakLoop   = 0;



ith = 1;

while breakLoop == 0,
    disp(ith)
    disp('Press Enter to take the data');
    pause
    disp('Data acquisition in progress')
    [Y1, X1, YUNIT, XUNIT] = invoke(groupObj, 'readwaveform', 'channel1');
    [Y2, X2, YUNIT, XUNIT] = invoke(groupObj, 'readwaveform', 'channel2');
    [Y3, X3, YUNIT, XUNIT] = invoke(groupObj, 'readwaveform', 'channel3');
    [Y4, X4, YUNIT, XUNIT] = invoke(groupObj, 'readwaveform', 'channel4');
    [Y5, X5, YUNIT, XUNIT] = invoke(groupObj2, 'readwaveform', 'channel1');
    [Y6, X6, YUNIT, XUNIT] = invoke(groupObj2, 'readwaveform', 'channel2');
    [Y7, X7, YUNIT, XUNIT] = invoke(groupObj2, 'readwaveform', 'channel3');
    
    %     subplot(211)
    plot(X1*1e3,Y1,X2*1e3,Y2,X3*1e3,Y3,X4*1e3,Y4,X5*1e3,Y5,X6*1e3,Y6,X7*1e3,Y7,'linewidth',2);hold on
    legend('Channel1')
    xlabel('time [ms]')
    ylabel('voltage [V]')
    title('Channel 1-7');
    grid on
    xlim([min(X1), max(X1)]*1e3)
    hold on
    
    %     subplot(212)
    %     plot(X2*1e3,Y2, 'linewidth',2)
    %     legend('Channel2')
    %     xlabel('time [ms]')
    %     ylabel('voltage [V]')
    %     title('Channel 2');
    %     grid on
    %     xlim([min(X2), max(X2)]*1e3)
    %     hold on
    
    jth = mod(ith,numRepeat);
    if jth == 0
        subplot(211)
        plot(inSigT.ch1(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch1(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        plot(inSigT.ch2(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch2(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        plot(inSigT.ch3(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch3(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        plot(inSigT.ch4(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch4(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        plot(inSigT.ch5(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch5(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        plot(inSigT.ch6(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch6(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        plot(inSigT.ch7(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch7(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5);hold on
        title('Channel 1-7');
        hold off
        %         subplot(212)
        %         plot(inSigT.ch2(ith-numRepeat+1:ith-1,:)'*1e3,inSigV.ch2(ith-numRepeat+1:ith-1,:)', '--r', 'linewidth',0.5)
        %         title('Channel 2');
        %         hold off
    elseif jth ~= 1
        %         subplot(211)
        plot(inSigT.ch1(ith-jth+1:ith-1,:)'*1e3,inSigV.ch1(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        plot(inSigT.ch2(ith-jth+1:ith-1,:)'*1e3,inSigV.ch2(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        plot(inSigT.ch3(ith-jth+1:ith-1,:)'*1e3,inSigV.ch3(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        plot(inSigT.ch4(ith-jth+1:ith-1,:)'*1e3,inSigV.ch4(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        plot(inSigT.ch5(ith-jth+1:ith-1,:)'*1e3,inSigV.ch5(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        plot(inSigT.ch6(ith-jth+1:ith-1,:)'*1e3,inSigV.ch6(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        plot(inSigT.ch7(ith-jth+1:ith-1,:)'*1e3,inSigV.ch7(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5); hold on
        hold off
        title('Channel 1-7');
        %         subplot(212)
        %         plot(inSigT.ch2(ith-jth+1:ith-1,:)'*1e3,inSigV.ch2(ith-jth+1:ith-1,:)', '--r', 'linewidth',0.5)
        %         title('Channel 2');
        %         hold off
    else
        %         subplot(211)
        title('Channel 1-7');
        hold off
        %         subplot(212)
        %         title('Channel 2');
        %         hold off
    end
    
    
    response = input('Save data? If yes, press ENTER. If no, press N. If want to exit, press E','s');
    
    if isempty(response)
        disp(strcat('Saving data for testing No ', num2str(ith)))
        disp('==================================================')
        ith        = ith + 1;
        inSigV.ch1 = [inSigV.ch1;Y1];
        inSigT.ch1 = [inSigT.ch1;X1];
        inSigV.ch2 = [inSigV.ch2;Y2];
        inSigT.ch2 = [inSigT.ch2;X2];
        inSigV.ch3 = [inSigV.ch3;Y3];
        inSigT.ch3 = [inSigT.ch3;X3];
        inSigV.ch4 = [inSigV.ch4;Y4];
        inSigT.ch4 = [inSigT.ch4;X4];
        inSigV.ch5 = [inSigV.ch5;Y5];
        inSigT.ch5 = [inSigT.ch5;X5];
        inSigV.ch6 = [inSigV.ch6;Y6];
        inSigT.ch6 = [inSigT.ch6;X6];
        inSigV.ch7 = [inSigV.ch7;Y7];
        inSigT.ch7 = [inSigT.ch7;X7];
    elseif isequal(response,'E')
        inSigV.ch1 = [inSigV.ch1;Y1];
        inSigT.ch1 = [inSigT.ch1;X1];
        inSigV.ch2 = [inSigV.ch2;Y2];
        inSigT.ch2 = [inSigT.ch2;X2];
        inSigV.ch3 = [inSigV.ch3;Y3];
        inSigT.ch3 = [inSigT.ch3;X3];
        inSigV.ch4 = [inSigV.ch4;Y4];
        inSigT.ch4 = [inSigT.ch4;X4];
        inSigV.ch5 = [inSigV.ch5;Y5];
        inSigT.ch5 = [inSigT.ch5;X5];
        inSigV.ch6 = [inSigV.ch6;Y6];
        inSigT.ch6 = [inSigT.ch6;X6];
        inSigV.ch7 = [inSigV.ch7;Y7];
        inSigT.ch7 = [inSigT.ch7;X7];
        breakLoop = 1;
    else
        disp('Skipping data')
    end
end
%%

% Delete objects.
delete([deviceObj interfaceObj]);
delete([deviceObj2 interfaceObj2]);
