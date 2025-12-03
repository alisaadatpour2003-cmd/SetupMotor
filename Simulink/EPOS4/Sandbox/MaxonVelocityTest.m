clear all; close all; clc;
disp('--- Starting Maxon Control (Direct LoadLibrary Method) ---');
dllName = 'C:\Users\SetupMotor\Documents\SetupMotor\Simulink\EPOS4\functions\EposCmd64.dll'; 
headerName = 'EposCmd_Simple.h'; % We will create this file

if ~isfile(dllName)
    error(['CRITICAL: ', dllName, ' is missing. Please place it  in function Folder.']);
end
fid = fopen(headerName, 'w');
fprintf(fid, 'void* __stdcall VCS_OpenDevice(char* DeviceName, char* ProtocolStackName, char* InterfaceName, char* PortName, unsigned int* pErrorCode);\n');
fprintf(fid, 'int __stdcall VCS_SetOperationMode(void* KeyHandle, unsigned short NodeId, char OperationMode, unsigned int* pErrorCode);\n');
fprintf(fid, 'int __stdcall VCS_SetEnableState(void* KeyHandle, unsigned short NodeId, unsigned int* pErrorCode);\n');
fprintf(fid, 'int __stdcall VCS_SetDisableState(void* KeyHandle, unsigned short NodeId, unsigned int* pErrorCode);\n');
fprintf(fid, 'int __stdcall VCS_ClearFault(void* KeyHandle, unsigned short NodeId, unsigned int* pErrorCode);\n');
fprintf(fid, 'int __stdcall VCS_MoveWithVelocity(void* KeyHandle, unsigned short NodeId, long TargetVelocity, unsigned int* pErrorCode);\n');
fprintf(fid, 'int __stdcall VCS_CloseDevice(void* KeyHandle, unsigned int* pErrorCode);\n');
fclose(fid);

disp(['Created minimal header: ', headerName]);
if libisloaded('EposCmd')
    unloadlibrary('EposCmd');
end

try
    loadlibrary(dllName, headerName, 'alias', 'EposCmd');
    disp('SUCCESS: Library loaded!');
catch ME
    disp('ERROR Loading Library:');
    disp(ME.message);
    if contains(ME.message, 'module could not be found')
        disp('-------------------------------------------------------');
        disp('The DLL exists, but Windows cannot run it.');
        disp('SOLUTION: You MUST install "Microsoft Visual C++ Redistributable 2013 (x64)".');
        disp('This is an external Windows requirement, not a MATLAB issue.');
        disp('-------------------------------------------------------');
    end
    return;
end

NodeID = 31;
Baudrate = 1000000;
pErrorCode = libpointer('uint32Ptr', 0);


disp('Attempting to Open Device...');
keyHandle = calllib('EposCmd', 'VCS_OpenDevice', 'EPOS4', 'MAXON SERIAL V2', 'USB', 'USB0', pErrorCode);

if keyHandle == 0
    disp('Failed to open EPOS4. Retrying with EPOS2 settings...');
    keyHandle = calllib('EposCmd', 'VCS_OpenDevice', 'EPOS4', 'MAXON SERIAL V2', 'USB', 'USB0', pErrorCode);
end

if keyHandle == 0
    err = pErrorCode.Value;
    disp(['FATAL: Could not connect to device. Error Code: ', num2str(err)]);
    unloadlibrary('EposCmd');
    return;
end

disp('SUCCESS: Device Connected!');

try
    disp('Clearing Faults...');
    calllib('EposCmd', 'VCS_ClearFault', keyHandle, NodeID, pErrorCode);
    
    disp('Enabling...');
    calllib('EposCmd', 'VCS_SetEnableState', keyHandle, NodeID, pErrorCode);
    
    disp('Moving (Profile Velocity)...');
    calllib('EposCmd', 'VCS_SetOperationMode', keyHandle, NodeID, 3, pErrorCode); % 3 = Velocity
    calllib('EposCmd', 'VCS_MoveWithVelocity', keyHandle, NodeID, 1000, pErrorCode);
    
    pause(2);
    
    disp('Stopping...');
    calllib('EposCmd', 'VCS_SetDisableState', keyHandle, NodeID, pErrorCode);
    
catch ME
    disp(['Runtime Error: ', ME.message]);
end

if keyHandle ~= 0
    calllib('EposCmd', 'VCS_CloseDevice', keyHandle, pErrorCode);
end
unloadlibrary('EposCmd');
disp('Closed and Unloaded.');