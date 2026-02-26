Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.AppActivate "flutter"
WScript.Sleep 500
WshShell.SendKeys "r"
