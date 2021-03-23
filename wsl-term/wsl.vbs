Function CheckCommandIsRunning(ProcessName)
	sComputerName = "."
	Set objWMIService = GetObject("winmgmts:\\" & sComputerName & "\root\cimv2")
	sQuery = "SELECT * FROM Win32_Process WHERE CommandLine LIKE '%" + ProcessName + "%'"
	Set objItems = objWMIService.ExecQuery(sQuery)
	If objItems.Count > 0 Then
		CheckCommandIsRunning = True
	Else
		CheckCommandIsRunning = False
	End If
	Set objWMIService = Nothing
	Set objItems = Nothing
End Function

Function SilentlyStartCommand(Command)
	Set WshShell = CreateObject("WScript.Shell" )
	WshShell.Run Command, 0 
	Set WshShell = Nothing 
End Function

If Not CheckCommandIsRunning("vcxsrv.exe") Then
	SilentlyStartCommand """C:\Program Files\VcXsrv\vcxsrv.exe"" :0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl"
	WScript.Sleep 1000
End If

SilentlyStartCommand "C:\Windows\System32\Bash.exe -ic 'sudo service dbus start'"
SilentlyStartCommand "C:\Windows\System32\Bash.exe -ic ""cd /root; DISPLAY=$(ip route show|grep ^default|awk '{print $3}'):0 dbus-launch gnome-terminal"""