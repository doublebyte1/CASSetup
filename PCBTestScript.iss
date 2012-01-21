;This is a test script
#define MySourceDir "D:\Temp\InnoTestSrc"
#define MyDestDir "D:\Temp\InnoTest"

[Setup]
DefaultDirName={#MyDestDir}
DisableDirPage=no
AppName="MyTestApp"
AppVersion=1

[Code]
function GetMyConstant(Param: String): String;
{Purpose:
Return the value of a constant at run-time}

var
	strConst: string;

begin
	strConst := '{#' + Param + '}';
	MsgBox(strConst, mbInformation, MB_OK);
	Result := expandconstant(strConst);
end;

function GetDataDir(Param: String): String;
begin
  { Return the selected DataDir }
  Result := 'DummyString';
end;

[Files]
Source: {#MySourceDir}\TestFile.pdf; DestDir: "{code:GetMyConstant|}"

[Run]

