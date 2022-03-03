# Stop-Acronis_Active_Protection
Change registry to make acronis active protection service stoppable and status changes

1. Run "StoppableActiveProtectionService.reg" to change the protection level. It changes the protection flag of the service from "ANTIMALWARE_LIGHT" (prevents any change to the service) to "NONE".
https://docs.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_launch_protected_info

2. Restart PC

3. Execute "StoppableActiveProtectionService.bat"
