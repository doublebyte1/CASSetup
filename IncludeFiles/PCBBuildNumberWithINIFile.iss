;Inno Setup file for including in IS scripts.
;Creates an ini file to monitor the build numbers
; Read the previous build number. If there is none take 0 instead.
#define BuildNum Int(ReadIni(SourcePath	+ "\\BuildInfo.ini","Info","Build","0"))
; Increment the build number by one.
#expr BuildNum = BuildNum + 1
; Store the number in the ini file for the next build.
#expr WriteIni(SourcePath + "\\BuildInfo.ini","Info","Build", BuildNum)
