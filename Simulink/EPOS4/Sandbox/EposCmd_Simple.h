void* __stdcall VCS_OpenDevice(char* DeviceName, char* ProtocolStackName, char* InterfaceName, char* PortName, unsigned int* pErrorCode);
int __stdcall VCS_SetOperationMode(void* KeyHandle, unsigned short NodeId, char OperationMode, unsigned int* pErrorCode);
int __stdcall VCS_SetEnableState(void* KeyHandle, unsigned short NodeId, unsigned int* pErrorCode);
int __stdcall VCS_SetDisableState(void* KeyHandle, unsigned short NodeId, unsigned int* pErrorCode);
int __stdcall VCS_ClearFault(void* KeyHandle, unsigned short NodeId, unsigned int* pErrorCode);
int __stdcall VCS_MoveWithVelocity(void* KeyHandle, unsigned short NodeId, long TargetVelocity, unsigned int* pErrorCode);
int __stdcall VCS_CloseDevice(void* KeyHandle, unsigned int* pErrorCode);
