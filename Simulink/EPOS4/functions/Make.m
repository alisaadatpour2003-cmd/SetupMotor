clc
clear

disp('Welcome to EPOS4 library')
str = computer;
win64 = strcmp(str, 'PCWIN64');
win32 = strcmp(str, 'PCWIN32');
lin64 = strcmp(str, 'GLNXA64');
lin32 = strcmp(str, 'GLNXA32');


% all the code to compile
sourcecode = { ' OpenCommunication.cpp', ' CloseCommunication.cpp', ...
    ' GetErrorState.cpp', ' ClearErrorState.cpp', ...
    ' SetOperationMode.cpp', ' GetOperationMode.cpp', ' EnableNode.cpp', ...
    ' DisableNode.cpp', ' QuickStop.cpp', ' GetPosition.cpp', ' GetVelocity.cpp', ...
    ' GetCurrent.cpp', ' SetPosition.cpp', ' SetVelocity.cpp', ' SetCurrent.cpp', ...
    ' IsTargetReached.cpp', ' WaitForTargetReached.cpp', ' MoveToPosition.cpp', ...
    ' SetProfilePositionData.cpp', ' MoveWithVelocity.cpp', ' FindHome.cpp' ...
    ' SetProfileVelocityData.cpp', ' sfun_maxon.cpp', ' SetObject.cpp', ' GetObject.cpp' };

% for Linux computer
if ( lin32 || lin64  )
    disp('.. Compiling for a Linux computer')
    % directory to include files
    includedir = './Epos2Linux';
    % library name
    libeposname = 'EposCmd';
    % definitions for right compilation
    definitions = '_LINUX_';
end
% for Windows computer
if ( win32  || win64  )
    disp('.. Compiling for a Windows computer')
    % directory to include files
    includedir = '.\Epos2Windows';
    % library name
    if (win32==1)
        libeposname = 'EposCmd';
    else
        libeposname = 'EposCmd64';
    end
    % definitions
    definitions = 'WINDOWS';
end

% compile each file
for i=1:size(sourcecode, 2)
    strcmd = strcat('mex', sourcecode(:,i), ' -D', definitions, ' -I', ...
        includedir, ' -L', includedir, ' -l', libeposname); 
    eval( char(strcmd) )
end
disp('.. finishing compiling')

% add directory to path
disp('.. adding directory to path')
dirtopath = cd;
addpath( dirtopath );
disp('.. done, you can now use this library')

% some help
disp('Please, use the command: >> savepath')
disp('if you want to permanently add the source code directory to Matlab')
