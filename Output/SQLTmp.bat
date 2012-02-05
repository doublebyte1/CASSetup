@echo off
start  /B  "SQLCMD.EXE" /S VM2_XP\FAOCAS -U sa -P Test123 -i SQLTmp.dat -o SQLTmp.out
