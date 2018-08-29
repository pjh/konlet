$scriptDir = "C:\Users\pjh\powershell"
$taskScript = "start-konlet-container.ps1"
$scriptPath = "$scriptDir\$taskScript"

# TODO: add "-WindowStyle Hidden" to cause terminal to disappear when
#   command/task is executed?
$actionCmd = "powershell.exe"
$actionArgs = "-NoProfile -command `"& {$scriptPath}`""
# TODO: use the -WorkingDirectory arg to run the task from a particular
#   directory?
# TODO: let action run privileged? Didn't see this in N-STA options.
$action = New-ScheduledTaskAction -Execute "$actionCmd" -Argument `
    "$actionArgs"

$trigger = New-ScheduledTaskTrigger -AtStartup

# -Force to override existing task with this name if it already exists.
Register-ScheduledTask -Force -Action $action -Trigger $trigger `
    -User System `
    -TaskName "start-konlet-container" `
    -Description "Starts konlet container."
