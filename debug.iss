; BEGIN ISPPBUILTINS.ISS


; END ISPPBUILTINS.ISS

;Setup script to install the FAO Catch Assessment Survey Application

;GENERAL APPLICATION DEFINITIONS

;BASIC CONFIGURATION FOR THE INSTALLER AND THE SCRIPT
;#define MyAppSetupSrcBaseDir "E:\CASSetup"

;DIRS HOLDING FILES TO INCLUDE

;SOURCE DIRECTORIES

;DEFINITIONS  FOR THE COMPILED SETUP

;DESTINATION DIRECTORIES

;OTHER APPLICATION DEFINITIONS
;Inno Setup file for including in IS scripts.
;Creates an ini file to monitor the build numbers
; Read the previous build number. If there is none take 0 instead.
; Increment the build number by one.
; Store the number in the ini file for the next build.

;APPLICATION CONFIGURATION VARIABLES


[CustomMessages]


[InnoIDE_PostCompile]
[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppID={{4F9DE949-A8BA-4D84-8C30-F98557DB5788}
AppName=FAO Fisheries Catch Assessment Surveys Data Manager
AppVersion=1.0
AppVerName=FAO Fisheries Catch Assessment Surveys Data Manager 1.0
AppPublisher=FAO
AppPublisherURL=http://www.faomedfisis.org/
AppSupportURL=http://www.faomedfisis.org/
AppUpdatesURL=http://www.faomedfisis.org/
DefaultDirName={pf}\FAO_FI\CAS
DisableDirPage=no
DefaultGroupName=FAOFishData
AllowNoIcons=true
LicenseFile=P:\\src\FAOCASLicense.txt
OutputDir=P:\\Output
OutputBaseFilename=FAOCAS_Setup.exe
SetupIconFile=P:\\src\FAOCASIcon.ico
Compression=lzma/Max
SolidCompression=true
SetupLogging=true

[Languages]
Name: english; MessagesFile: compiler:Default.isl


[Types]
;Name: "Full"; Description: "Install the Application, the Database Server and the Database"
;Name: "ApplicationOnly"; Description: "Install only the Application (If the DataBase Engine and the database are already installed)"
;Name: "DBEngineDatabase"; Description: "Install the DataBase Engine, and attach the Database"
;Name: "DatabaseOnly"; Description: "Attach only the Database"

[Components]
;Name: "AutoOSUpdater"; Description: "DataBase Support Files"; Types: Full Network custom; Flags: fixed
;Name: "FullProgramFiles"; Description: "Single PC Or Server Files"; Types: Full; Flags: exclusive
;Name: "FullProgramFiles\Desktop"; Description: "Desktop Shortcut"; Types: Full
;Name: "FullProgramFiles\QuickLaunch"; Description: "Quick Launch Shortcut"; Types: Full
;Name: "NetworkProgramFiles"; Description: "Networked Work Station Files"; Types: Network; Flags: exclusive


[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Files]
;Application files
Source: P:\\src\CASManager.exe; DestDir: {app}; Flags: ignoreversion
Source: P:\\src\CASConfig.exe; DestDir: {app}; Flags: ignoreversion
Source: P:\\src\QtAssistant.exe; DestDir: {app}; Flags: ignoreversion
Source: P:\\src\FAOCASLicense.txt; DestDir: {code:GetPathConf}; Flags: ignoreversion
Source: P:\\src\FAOCASReadme.txt; DestDir: {code:GetPathConf}; Flags: ignoreversion isreadme

;Custom Objects for Application
Source: P:\\src\OtherDLLs\CatchInputCtrl.dll; DestDir: {app}; Flags: ignoreversion
Source: P:\\src\OtherDLLs\customtimectrl.dll; DestDir: {app}; Flags: ignoreversion
Source: P:\\src\OtherDLLs\Report.dll; DestDir: {app}; Flags: ignoreversion

;Qt DLLs
Source: "P:\\src\QtDLLs\QtCore4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtGui4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtNetwork4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtScript4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtSql4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtTest4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtWebKit4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtXml4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtXmlPatterns4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtHelp4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "P:\\src\QtDLLs\QtCLucene4.dll"; DestDir: "{app}"; Flags: ignoreversion

;Files for the Report Maker and Report Specifications
Source: "P:\\src\ReportBuilder\*"; DestDir: "{app}\Report\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "P:\\src\ReportSpecs\*"; DestDir: "{app}\Reports\"; Flags: ignoreversion recursesubdirs createallsubdirs

;Files for the Help system
Source: "P:\\src\HelpFiles\*"; DestDir: "{app}\Help\"; Flags: ignoreversion recursesubdirs createallsubdirs

;SQL Driver files
Source: "P:\\src\SQLdrivers\*"; DestDir: "{app}\sqldrivers\"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; Files for SQL Server setup (to be written to temporary directory)

Source: P:\\src\Data\FAOCASDATA.ldf; DestDir: {tmp}; Check: CheckDBAttachRequired(False); Flags: ignoreversion
Source: P:\\src\Data\FAOCASDATA.mdf; DestDir: {tmp}; Check: CheckDBAttachRequired(False); Flags: ignoreversion
Source: P:\\src\Config\FAOCAS_SQLInstallConfig.ini; DestDir: {tmp}; Check: CheckSQLServerInstanceInstallationRequired(False); Flags: ignoreversion
Source: P:\\src\SQLServer\*; DestDir: {tmp}\SQLServer; Check: CheckSQLServerInstanceInstallationRequired(False); Flags: ignoreversion recursesubdirs

[Icons]
Name: {group}\FAO Fisheries Catch Assessment Surveys Data Manager; Filename: {app}\CASManager.exe
Name: {group}\FAOFish CAS Config; Filename: {app}\CASConfig.exe
Name: {group}\{cm:ProgramOnTheWeb,FAO Fisheries Catch Assessment Surveys Data Manager}; Filename: http://www.faomedfisis.org/
Name: {group}\{cm:UninstallProgram,FAO Fisheries Catch Assessment Surveys Data Manager}; Filename: {uninstallexe}
Name: {commondesktop}\FAO Fisheries Catch Assessment Surveys Data Manager; Filename: {app}\CASManager.exe; Tasks: desktopicon
Name: {commondesktop}\FAOFish CAS Config; Filename: {app}\CASConfig.exe; Tasks: desktopicon



[Run]

[INI]

[Code]
[Code]

const
	CRLF= #13#10;
  UserChoicesSection = 'UserChoices'; //Section (in the INI file created by the
  strNewFolder = 'NewFolder';
  DataDirKey = 'DataDir'; //Key of ini file holding the data directory last selected by the user
  FExtBat = '.bat'; //Extension for .bat files
  FExtDat = '.dat'; //Extension for .dat files (usually files with commands to pass to command-line uses)
  FExtOut = '.out'; //Extension for .out files (usually files with results from commands)

var
  LoadInfFilename, SaveInfFilename: String; //Name of file where user choices are stored. This is better than storing in Registry
  UserChoices: TArrayOfString;
  HasDataDirPage, DataDirPageCreated: boolean;
  FinishedInstall: boolean;
  PathTmp: String;
  PathData: String;
  PathConfig: String;
  MsgRequirementsMissing: String;
  

function GetReadyPageDataDirText(NewLine: String): string; forward;
function GetReadyPageDBInstallationText(NewLine: String): String; forward;
function GetDBInstallationRequired(Param: string): Boolean; forward;


function ReverseString(strIn: String): String;
(*Purpose
Reverses the input string
*)
var
  strTmp: String;
  lngN, j1: longInt;
  
begin
  lngN:= Length(strIn);
  SetLength(strTmp, lngN);
  for j1:= 1 to lngN do
    begin
      strTmp[j1]:= strIn[lngN-j1+1];
    end;    
result:= strTmp;
end;


function BoolToStr(Val : Boolean): String;
(*Purpose
Convert a boolean to a string
*)
begin
if val = True then
  result := 'True'// or 'Yes' or '1'
else
  result := 'False';// or 'No' or '0'
end;


function FileDat(strFileName: String): String;
(*Purpose
Creates a file with an extension of the dat type used here, and the same base name as the one provided to it
*)
begin
  result:=ChangeFileExt(strFileName, FExtDat);
end;

function FileBat(strFileName: String): String;
(*Purpose
Creates a file with an extension of the type used for batch files here, and the same base name as the one provided to it
*)
begin
  result:=ChangeFileExt(strFileName, FExtBat);
end;

function FileOut(strFileName: String): String;
(*Purpose
Creates a file with an extension of the type used for output files here, and the same base name as the one provided to it
*)
begin
  result:=ChangeFileExt(strFileName, FExtOut);
end;

function GetMsgBoxCRLF(): String;
(*
 
    Vista and W7 perform a UI-aware formatting of the text in a MsgBox breaking up lines at unpredictable positions
    so we can not insert hard carriage return/linefeeds in the text to break lines where we want. In earlier versions
    of Windows this is OK. Therefore, on Vista or W7 we return a space and let it handle formatting and use a hard CrLf
    in all other cases.
 
*)
var
    WindowsVersion: Integer;
begin
  WindowsVersion := (GetWindowsVersion shr 24);
    if (WindowsVersion >= 6) then begin
      Result := ' ';
    end else begin
      Result := CRLF;
    end;
end;

procedure SetPathTmp(strPath: string);
(*Purpose
Sets the value of the Global Variable defining the path for the temporary directory to use when installing
*)
begin
  PathTmp:= strPath;
  Log('Path for Temporary files is ' + strPath);
end;

function GetPathTmp(Param: String): String;
(*Purpose
Gets the definition of the Temporary directory
*)

begin
  result := PathTmp; //Simply reads the global variable
 end;

procedure SetPathData(strPath: string);
(*Purpose
Sets the value of the Global Variable defining the path for the Application Data Directory
*)
begin
  PathData:= strPath;
end;

procedure SetPathDataDefault();
(*Purpose
Sets the default value of the Global Variable defining the path for the Application Data Directory
*)
begin
  SetPathData(ExpandConstant('C:\FAO_Fish_Data'));
end;
function GetPathData(Param: string): String;
(*Purpose
Gest the value of the Global Variable defining the path for the Application Data Directory
*)
begin
  result:= PathData;
end;

procedure SetPathConf(strPath: string);
(*Purpose
Sets the value of the Global Variable defining the path for the Application Configuration Directory
*)
begin
  PathConfig:= strPath;
  Log('Path for Configuration files is ' + strPath);
end;

function GetPathConf(Param: string): String;
(*Purpose
Gest the value of the Global Variable defining the path for the Application Configuration Directory
*)
begin
  result:= PathConfig;
end;

procedure SetGlobalsCommon();
(*Purpose
Sets the values of the global variables that are common to most installations, and
that relate to the code defined in the PCB_ISUtils.isi include file
*)

begin
  SetPathTmp(ExpandConstant('{tmp}')); 
  SetPathConf(ExpandConstant('{app}\Config'));
end;

function DataPathCreate(strPath: String): boolean;
(*Purpose
Checks if the Data Directory exists, and creates it if it does not
Returns TRUE if the directory already exists, or if it is created successfully
*)
var
  bolSuccess: boolean;
begin
  if DirExists(strPath) then
    begin
      bolSuccess:= True;
    end
  else
    begin
      bolSuccess:= ForceDirectories(strPath);
    end;
result:= bolSuccess;
end;

procedure SaveInfString(Section, Key, Value: String);
begin
  SetIniString(Section, Key, Value, SaveInfFilename);
end;

function ShouldLoadInf(): Boolean;
begin
  Result := (LoadInfFilename <> '');
end;

function ShouldSaveInf(): Boolean;
begin
  Result := (SaveInfFilename <> '');
end;

function LoadInfString(Section, Key, Default: String): String;
begin
  Result := GetIniString(Section, Key, Default, LoadInfFilename);
end;

procedure UpdateInfFilenames();
begin
  LoadInfFilename := ExpandFileName(ExpandConstant('{param:loadinf}'));
  SaveInfFilename := ExpandFileName(ExpandConstant('{param:saveinf}'));
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);

begin
  { Store the settings so we can restore them next time }
  if HasDataDirPage then
    begin
      SaveInfString(UserChoicesSection, DataDirKey, GetPathData(''));
    end;
end;

function stringRepeat(strIn: String; intN: integer): String;
(*Purpose
Repeat string strIn intNtimes, into a new string
*)
var
  strTmp: String;
  j1: integer;
  
  begin
    strTmp:='';
    if intN > 0 then
    begin
      for j1:= 1 to intN do
        begin
          strTmp:= strTmp + strIn
        end;  
    end;
  result:= strTmp;
  end;
  
function AppendMemo2Msg(strMsg, strNewMemo, NewLine: String; intNNewLines: integer): String;
(*Purpose
Appends a new memo (set of lines) to a message, like the one to be presented on the "Ready" page,
separating it by a fixed number of NewLine characters
*)
var
  strTmp, strSep: String;
  
begin
  strSep:=stringRepeat(NewLine, 2);
    
  if strNewMemo <> '' then
    begin
      if strMsg <> '' then
        begin
          strTmp:= strMsg + strSep + strNewMemo;
        end
      else
        begin
          strTmp:= strNewMemo;
        end;
    end
  else
    begin
      strTmp:= strMsg;
    end;
result:= strTmp;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo,
MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo,
MemoTasksInfo: String): String;
(*Purpose:
Provide the text to be presented in the last (summary of choices) Wizard page
*)
var
  strMsg: String;
  strTmp: String;
   
begin
  strMsg:='';
  strTmp:= MemoUserInfoInfo;
  strMsg:= AppendMemo2Msg(strMsg, strTmp, NewLine, 2);
      
  strTmp:= MemoDirInfo;
  strMsg:= AppendMemo2Msg(strMsg, strTmp, NewLine, 2);

  if HasDataDirPage then
    begin
      strTmp:= GetReadyPageDataDirText(NewLine);
      strMsg:= AppendMemo2Msg(strMsg, strTmp, NewLine, 2);
    end;

  if GetDBInstallationRequired('') then
    begin
      strTmp:= GetReadyPageDBInstallationText(NewLine);
      strMsg:= AppendMemo2Msg(strMsg, strTmp, NewLine, 2);
    end;
    
  strMsg:=  AppendMemo2Msg(strMsg, MemoTasksInfo, NewLine, 2);   
  result:= strMsg;
end;


function ExtractFileNameBase(FileName: String): String;
(*Purpose
Extracts the Base filename (the filename, without path and without extension) of FileName
*)

var
  strTmp: String;
  lngLen: Longint;
  
begin
  strTmp:= ExtractFileName(FileName);
  lngLen:= Length(strTmp) - Length(ExtractFileExt(strTmp));
  strTmp:= Copy(strTmp,1, lngLen);
  result:= strTmp;
end;


procedure SetFinishedInstall(bolFinished: boolean);
(*Purpose
Sets the value of the Global Variable defining whether the installation has finished
*)
begin
  FinishedInstall:= bolFinished;
end;



function FileBackup(strFile, strTimeStamp, strBakDir: string): boolean;
(*Purpose
Creates a backup of a file whose name is given.
If strBakDir is given it will copy the file to this directory, 
adding the time-stamp and the extension .bak to its name. It will leave the original file intact
If strBakDir is not given, it will rename the file, adding the time-stamp and the extension .bak
to its name.
If time-stamp is not given, it will use the time-stamp of the current time
*)

var
  bolSuccess, bolRename: boolean;
  strFileBak: String;
  strDateTime: String;
  
begin
  bolSuccess:= False;
  
  if not FileExists(strFile) then
    begin
      result:= False;
      exit;
    end;
  
  if strTimeStamp = '' then
    begin
      strDateTime:= GetDateTimeString('yyyymmddhhmmss',':',':');
    end
  else
    begin
      strDateTime:= strTimeStamp;
    end;
    
  strFileBak:= strFile + '.' + strDateTime + '.bak';
  
  if strBakDir = '' then
    begin
      bolRename:= True;
    end
  else
    begin
      if not DirExists(strBakDir) then
        begin
          bolSuccess:= ForceDirectories(strBakDir);
          if not bolSuccess then
            begin
              result:= False;
              Exit;
            end;
        end;
      bolRename:= False;
    end;
    
  if bolRename then
    begin
      bolSuccess:= RenameFile(strFile, strFileBak);
    end
  else
    begin
      strFileBak:= AddBackSlash(strBakDir) + ExtractFileName(strFileBak);
      bolSuccess:= FileCopy(strFile, strFileBak, True);
    end;
  result:= bolSuccess; 
end;
[Code]





const
RegKey_SQLServer = 'Software\Microsoft\Microsoft SQL Server';
RegKeySQLServerInstance = 'MSSQL.';
RegKeySubKeySetup = 'Setup';
RegValEdition = 'Edition';
RegValSQLExpressEdition = 'Express Edition';
RegRootKey_SQLServer = HKEY_LOCAL_MACHINE;

SQLDBExt = '.mdf'; //Extension of SQL Server Database files
SQLLogExt = '.ldf'; //Extension of SQL Server log files
SQLAttachBat = 'SQLDBAttach.bat'; //Batch file to attach the databases required to the server
SQLDetachBat = 'SQLDBDetach.bat'; //Batch file to detach the databases from the server
SQLTmpFile = 'SQLTmp.bat'; //Batch file to run temporary tasks related to SQL Server

SQLInstanceKey = 'INSTANCENAME';
SQLConfFileSection = 'Options';
SQLSAPasswdKey = 'SAPWD';
SQLSecurModeKey = 'SECURITYMODE';
SQLSecurMode = 'SQL';
SQLDBExists = 'DBExists';

strSQLServer_gc = 'SQL Server 2005 Express Edition';

var //Global variables
  DBInstallationRequired_g: Boolean; //Boolean: Is it necessary to install at least some parts of the Database systems needed for the application?
  DBInstallationRequiredChecked_g: Boolean; //Boolean: Has it been checked if it is necessary to install the different parts of the Database systems needed for the application?
  DBInstallationChecked_g: Boolean; //Boolean: Has it been checked if the different parts of the Database systems needed for the application are already installed?
  SQLServerInstalled_g: boolean; //Boolean: Is SQL Server already installed?
  SQLServerInstanceInstalled_g: boolean; //Boolean: Is the SQL Server Instance of the Application already installed?
  DBExists_g: boolean; //Boolean: Does the database name of the application already exist in the Server Instance intended?

  InstallSQLServer: boolean; //Boolean: Is it necessary to install SQL Server?
  InstallSQLServerInstance: boolean; //Boolean: Is it necessary to install the SQL Server Instance of the Application?
  AttachDBFile: boolean; //Boolean: Is it necessary to attach the database?
  
  SQLDBName: String; //Name of the database to install
  SQLDBFileName: String; //Name of the file to attach to the DB Engine
  SQLInstanceName: String; //Name of the SQL Server Instance to use in this program
  SQL_SAPWD: String; //Password for the SA account of an SQL Server Instance
  SQLInstallerDir: String; //Full path for the Directory where the SQL Server Installer is (when running it)
  SQLInstaller: String; //Full path for the SQL Server Installer
  SQLInstallBat: String; //Full path for the batch file that will run the SQL Server Installer
  SQLInstallDat: String; //Full path for the file with the SQL Server Installation configurations


procedure SetDBInstallationRequired(bolRequired: boolean);
(*Purpose
Sets the value of the global variable defining whether it  
is necessary to install all or parts of the Database systems needed for the application
*)
begin
  DBInstallationRequired_g:= bolRequired;
end;

function GetDBInstallationRequired(Param: string): Boolean;
(*Purpose
Gets the value of the global variable defining whether it 
is necessary to install all or parts of the Database systems needed for the application
*)
begin
  result:= DBInstallationRequired_g;
end;

procedure SetDBInstallationRequiredChecked(bolChecked: boolean);
(*Purpose
Sets the value of the global variable defining whether it has been checked 
if it is necessary to install all or parts of the Database systems needed for the application
*)
begin
  DBInstallationRequiredChecked_g:= bolChecked;
end;

function GetDBInstallationRequiredChecked(Param: string): Boolean;
(*Purpose
Gets the value of the global variable defining whether it has been checked 
if it is necessary to install all or parts of the Database systems needed for the application
*)
begin
  result:= DBInstallationRequiredChecked_g;
end;


procedure SetDBInstallationChecked(bolChecked: boolean);
(*Purpose
Sets the value of the global variable defining whether it hasb been checked 
if the different parts of the Database systems needed for the application are already installed
*)
begin
  DBInstallationChecked_g:= bolChecked;
end;

function GetDBInstallationChecked(Param: string): Boolean;
(*Purpose
Sets the value of the global variable defining whether it hasb been checked 
if the different parts of the Database systems needed for the application are already installed
*)
begin
  result:= DBInstallationChecked_g;
end;

procedure SetSQLServerInstalled(bolInstalled: boolean);
(*Purpose
Sets the value of the global variable defining whether SQL Server is already installed
*)
begin
  SQLServerInstalled_g:= bolInstalled;
end;

function GetSQLServerInstalled(Param: string): Boolean;
(*Purpose
Gets the value of the global variable defining whether SQL Server is already installed
*)
begin
  result:= SQLServerInstalled_g;
end;

procedure SetSQLServerInstanceInstalled(bolInstalled: boolean);
(*Purpose
Sets the value of the global variable defining whether the SQL Server Instance for the application is already installed
*)
begin
  SQLServerInstanceInstalled_g:= bolInstalled;
end;

function GetSQLServerInstanceInstalled(Param: string): Boolean;
(*Purpose
Gets the value of the global variable defining whether the SQL Server Instance for the application is already installed
*)
begin
  result:= SQLServerInstanceInstalled_g;
end;


procedure SetDBExists(bolExists: boolean);
(*Purpose
Sets the value of the global variable defining whether the database name of the application already exist in the Server Instance intended?
*)
begin
  DBExists_g:= bolExists;
end;

function GetDBExists(Param: string): Boolean;
(*Purpose
Gets the value of the global variable defining whether the database name of the application already exist in the Server Instance intended?
*)
begin
  result:= DBExists_g;
end;

procedure SetSQLInstance(strInstance: string);
(*Purpose
Sets the value of the global variable defining the name of the SQL Instance to use in this application
*)
begin
  SQLInstanceName:= strInstance;
end;

function GetSQLInstance(Param: string): String;
(*Purpose
Gets the value of the global variable defining the name of the SQL Instance to use in this application
*)
begin
  result:= SQLInstanceName;
end;

procedure SetSQLDBName(strDBName: string);
(*Purpose
Sets the value of the global variable defining the name of the Database to install for this application
*)
begin
  SQLDBName:= strDBName;
end;


procedure SetSQLDBFile(strDBFile: string);
(*Purpose
Sets the value of the global variable defining the name of the files of the Database to use in this application
*)
begin
  SQLDBFileName:= strDBFile;
end;

procedure SetSQLInstallDat(strFileName: String);
(*Purpose
Sets the full path to the file used to configure the installation of SQL Server
*)
  
begin
  SQLInstallDat:=  AddBackslash(PathTmp) + strFileName;
end;


function GetSQLInstallDat(Param: String): String;
(*Purpose
Returns the full path to the file used to configure the installation of SQL Server
*)
begin
  result:=  SQLInstallDat;
end;


function GetSQLTmpFileBat(Param: String): String;
(*Purpose
Returns the full path to the batch file used to run temporary tasks related to SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLTmpFile, FExtBat);
end;

function GetSQLTmpFileDat(Param: String): String;
(*Purpose
Returns the full path to the commands file used to run temporary tasks related to SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLTmpFile, FExtDat);
end;

function GetSQLTmpFileOut(Param: String): String;
(*Purpose
Returns the full path to the file used to store the results of running temporary tasks related to SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLTmpFile, FExtOut);
end;

function GetSQLAttachFileBat(Param: String): String;
(*Purpose
Returns the full path to the batch file used to attach the database to the SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLAttachBat, FExtBat);
  Log(result);
end;

function GetSQLAttachFileDat(Param: String): String;
(*Purpose
Returns the full path to the .dat file used to pass the sqlcmd commands to attach the database files to SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLAttachBat, FExtDat);
end;

function GetSQLDetachFileBat(Param: String): String;
(*Purpose
Returns the full path to the batch file used to detach the database from the SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLDetachBat, FExtBat);
end;

function GetSQLDetachFileDat(Param: String): String;
(*Purpose
Returns the full path to the .dat file used to pass the sqlcmd commands to detach the database files from SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLDetachBat, FExtDat);
end;


function SetSQLInstallBat(strFileName: String): String;
(*Purpose
Sets the full path to the batch file used to install the specific instance of SQL Server
*)
begin
  SQLInstallBat:=  AddBackslash(PathTmp) + strFileName;
end;


function GetSQLInstallBat(Param: String): String;
(*Purpose
Returns the full path to the batch file used to install the specific instance of SQL Server
*)
begin
  result:=  SQLInstallBat;
end;

function GetSQLDBName(Param: String): String;
(*Purpose
Returns the name to give to the DataBase inside SQL Server
*)
begin
  result:=  SQLDBName;
end;

function GetSQLDBFileName(Param: String): String;
(*Purpose
Returns the name of the file to attach to the SQL Server Instance given
*)
begin
  result:=  SQLDBFileName;
end;

function SetSQLDBFileName(strFileName: String): String;
(*Purpose
Sets the global variable with the name of the file to attach to the SQL Server Instance given
*)
begin
  SQLDBFileName:= strFileName;
end;

function GetSQLInstaller(Param: String): String;
(*Purpose
Returns the full path to the SQL Server installer program
*)
begin
  result:=  SQLInstaller;
end;

function SetSQLInstaller(strFileName: String): String;
(*Purpose
Sets the full path to the SQL Server installer program into the global variable
*)
  
begin
  SQLInstallerDir:= AddBackslash(GetPathTmp(''));
  
  SQLInstallerDir:= AddBackslash(SQLInstallerDir) + 
                    ExpandConstant('SQLServer');
  SQLInstaller:=  AddBackslash(SQLInstallerDir) +  strFileName;
end;

function IsSQLServerInstanceNameFull(strInstance: String): boolean;
(*Purpose
Checks if a string provided corresponds to a full instance name, or to a local instance only
*)
begin
  result:= (Pos('\', strInstance)<> 0);
end;


function SQLInstanceNameLocal(strInstance: String): String;
(*Purpose
Returns the local name of an SQL Server 2005 instance name, needed for many commands
Note: This (and not the fully-qualified name)  is needed for e.g. 
specifying the instance name for local installation. 
This requires only the Instance name, without the server name
*)
var
  strLocalName: String;
  lngInd, lngStart, lngCount: LongInt;
    
begin
  if IsSQLServerInstanceNameFull(strInstance) then
    begin
      lngInd:=Pos('\', ReverseString(strInstance));
      lngCount:= lngInd -1;
      lngStart:= Length(strInstance)-(lngCount - 2);
      strLocalName:= Copy(strInstance, lngStart, lngCount);
    end
  else
    begin
     strLocalName:= strInstance; 
    end;
  result:= strLocalName;    
end;


function SQLInstanceNameFull(strInstance: String): String;
  
var
  strFullName: String;
    
begin
  if IsSQLServerInstanceNameFull(strInstance) then
    begin
      strFullName:= strInstance;
    end
  else
    begin
     strFullName:= ExpandConstant('{computername}\')+ strInstance; 
    end;
  result:= strFullName;    
end;

function GetMyAppSQLInstanceNameFull(Param: String): String;
  
begin
  result:= SQLInstanceNameFull(GetSQLInstance(''));
end;

function GetSQLSAPWD(Param: String): String;
(*Purpose
Returns the SQL Server SA (System Administrator Password
*)
begin
  result:=  SQL_SAPWD;
end;

procedure SetSQLSAPWD(strSQL_SAPwd: String);
(*Purpose
Sets the SQL Server SA (System Administrator) Password
*)
begin
  SQL_SAPWD:= strSQL_SAPwd;
end;

function GetSQLServerInstallationRequired(Param: String): boolean;
(*Purpose
Returns the boolean indicating whether to install SQL Server
*)
begin
  result:=  InstallSQLServer;
end;

procedure SetSQLServerInstallationRequired(bolInstall: boolean);
(*Purpose
Sets the boolean indicating whether to install SQL Server
*)
begin
  InstallSQLServer:= bolInstall;
end;

function GetSQLServerInstanceInstallationRequired(Param: String): boolean;
(*Purpose
Returns the boolean indicating whether to install the specific SQL Server Instance
*)
begin
  result:=  InstallSQLServerInstance;
end;

procedure SetSQLServerInstanceInstallationRequired(bolInstall: boolean);
(*Purpose
Sets the boolean indicating whether to install the specific SQL Server Instance
*)
begin
  InstallSQLServerInstance:= bolInstall;
end;

function GetAttachDBRequired(Param: String): boolean;
(*Purpose
Returns the boolean indicating whether to attach the Database file to our SQL Server Instance
*)
begin
  result:=  AttachDBFile;
end;

procedure SetAttachDBRequired(bolAttach: boolean);
(*Purpose
Sets the boolean indicating whether to attach a database to SQL Server
*)
begin
  AttachDBFile:= bolAttach;
end;

function IsSQLExpressInstalled(Param: String): boolean;
(*Purpose
Checks if SQL Express is already installed in the local machine
*)
var
  RegKeyList: TArrayOfString;
  NSubKeys, j1: integer;
  bolInstalled: boolean;
  strKeyVal: String;
  RegKey, RegKeyVal: String;
  
begin
  bolInstalled:= False;
  if RegKeyExists(RegRootKey_SQLServer, RegKey_SQLServer) then
    begin
      if RegGetSubkeyNames(RegRootKey_SQLServer, RegKey_SQLServer, RegKeyList) then
        begin
          NSubKeys:= GetArrayLength(RegKeyList)
          if NSubKeys > 0 then
            begin
              for j1:=0 to NSubKeys-1 do
                begin
                  if pos(RegKeySQLServerInstance, RegKeyList[j1])=1 then
                    begin
                      RegKey := RegKey_SQLServer + '\' + RegKeyList[j1] + '\' + RegKeySubKeySetup;
                      if RegQueryStringValue(RegRootKey_SQLServer, RegKey, RegValEdition, strKeyVal) then
                        begin
                          if strKeyVal = RegValSQLExpressEdition then
                            begin //At least one instance of Express Edition was found
                              bolInstalled := True;
                              break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
  result:= bolInstalled;    
end;



function IsSQLServerInstanceInstalled(strInstance: String): Boolean;
var
  RegKey: String;
    
begin
  RegKey:= AddBackslash(RegKey_SQLServer) + strInstance;
  result:= RegKeyExists(RegRootKey_SQLServer, RegKey);
end;

function SQLCmdFile(strInstance, strSAPWD, strFileCmd, strFileDat, strFileOut: String): boolean;
(*Purpose
Creates a batch file to run a set of sqlcmd commands that are provided by an input file
and optionally writes the output to an output file
*)
var
  strCmds: TArrayOfString;
  bolSuccess: boolean;
  strSQLInstance: String;
  
begin
Log('Starting SQLCmdFile function. The values for the parameters is:');
Log('The value of the strFileCmd parameter is ' + strFileCmd);
Log('The value of the strFileDat parameter is ' + strFileDat);
Log('The value of the strFileOut parameter is ' + strFileOut);

  strSQLInstance:= SQLInstanceNameFull(strInstance);
  SetArrayLength(strCmds, 2);
  strCmds[0]:= '@echo off';
  strCmds[1]:= 'start  /B  sqlcmd /S ' + strSQLInstance + ' -U sa -P ' + strSAPWD + ' -i ' 
            + strFileDat;
  if strFileOut <> '' then
    begin
      strCmds[1]:= strCmds[1] + ' -o ' + strFileOut;
    end;
  bolSuccess:= SaveStringsToFile(strFileCmd, strCmds, False);
  if bolSuccess then //The batch file was successfully written
    begin
      Log('sqlcmd written to batch file ' + strFileCmd + '. Command written is ' + strCmds[1]);    
    end;
result:= bolSuccess;
end;


function SQLServerInstallUpdateINI(strSQLINIFile, strInstance, strSAPasswd: String): boolean;
(*Purpose
Updates the .ini file used to configure the installation of SQL Server Express,
to make it install the appropriate instance and credentials
*)
var
  bolSuccess: boolean;
  strFNameFull: String;
  strSQLInstance: String;

begin
  strSQLInstance:= SQLInstanceNameLocal(strInstance);
  bolSuccess:= SetIniString(SQLConfFileSection, SQLInstanceKey, strSQLInstance, strSQLINIFile);
  bolSuccess:= bolSuccess And SetIniString(SQLConfFileSection, SQLSecurModeKey, SQLSecurMode, strSQLINIFile);
  bolSuccess:= bolSuccess And SetIniString(SQLConfFileSection, SQLSAPasswdKey, strSAPasswd, strSQLINIFile);
  result:= bolSuccess;
end;

function SQLServerAttachDB_CmdFiles(strInstance, strSAPWD, strSQLDBName, strPathData, strFileDB, strFileCmd: string): boolean;
(*Purpose
Creates the two command files necessary to use the commands for attaching a set of
database files to SQL Server. These are one .bat file with the basic sqlcmd command line,
and a .dat file with the input commands to sqlcmd
*)

var
  strFileBat, strFileDat, strFileDBFull, strFileLogFull: String;
  strCmds: TArrayOfString;
  strSQLInstance: String;
  bolExit: boolean;
  
begin
  strFileBat:= FileBat(strFileCmd);
  strFileDat:= FileDat(strFileCmd);  
  strFileDBFull:= AddBackslash(strPathData) + ChangeFileExt(strFileDB, SQLDBExt);
  strFileLogFull:= AddBackslash(strPathData) + ChangeFileExt(strFileDB, SQLLogExt);
  strSQLInstance:= strInstance; //This must already be the full instance name

  bolExit:= SQLCmdFile(strSQLInstance, strSAPWD, strFileBat, strFileDat, '');
  if bolExit then //The batch file was successfully written. Now write the commands file to sqlcmd
  Log('The batch file ' + strFileBat + ' was successfully written.');
    begin
      SetArrayLength(strCmds, 7);
      strCmds[0]:= 'USE [master]';
      strCmds[1]:= 'GO';
      strCmds[2]:= 'CREATE DATABASE [' + strSQLDBName + '] ON '; 
      strCmds[3]:= '( FILENAME = N''' + strFileDBFull + ''' ), ';
      strCmds[4]:= '( FILENAME = N''' + strFileLogFull + ''' )';
      strCmds[5]:= 'FOR ATTACH';
      strCmds[6]:= 'GO';
      bolExit:= SaveStringsToFile(strFileDat, strCmds, False);
    end;
result:= bolExit;          
end;

function SQLServerDetachDB_CmdFiles(strInstance, strSAPWD, strSQLDBName, strFileCmd: string): boolean;
(*Purpose
Creates the two command files necessary to use the commands for Detaching a 
database from SQL Server. These are one .bat file with the basic sqlcmd command line,
and a .dat file with the input commands to sqlcmd
*)

var
  strFileDat: String;
  strCmds: TArrayOfString;
  strSQLInstance: String;
  bolExit: boolean;
  
begin
  strFileDat:= FileDat(strFileCmd);
  strSQLInstance:= strInstance; //This must already be the full instance name

  Log('The name of the Dat file is ' + strFileDat);
  bolExit:= SQLCmdFile(strSQLInstance, strSAPWD, strFileCmd, strFileDat, '');
  if bolExit then //The batch file was successfully written. Now write the commands file to sqlcmd
    begin
      SetArrayLength(strCmds, 5);
      strCmds[0]:= 'USE [master]';
      strCmds[1]:= 'GO';
      strCmds[2]:= 'EXEC master.dbo.sp_detach_db @dbname = N''' + strSQLDBName + ''',';
      strCmds[3]:= '@keepfulltextindexfile = N''true''';
      strCmds[4]:= 'GO';
      bolExit:= SaveStringsToFile(strFileDat, strCmds, False);
    end;
result:= bolExit;          
end;


function SQLServerDBExists_CmdFiles(strInstance, strSAPWD, strSQLDBName, strFileBat, 
strFileDat, strFileOut: string): boolean;
(*Purpose
Creates the two command files necessary to use the commands for querying an SQL Instance for the 
existance of a database from SQL Server. These are one .bat file with the basic sqlcmd command line,
and a .dat file with the input commands to sqlcmd
*)
var
  strCmds: TArrayOfString;
  strSQLInstance: String;
  bolExit: boolean;
  
begin
  strSQLInstance:= SQLInstanceNameFull(strInstance);//This should already be the full instance name

  bolExit:= SQLCmdFile(strSQLInstance, strSAPWD, strFileBat, strFileDat, strFileOut);
  if bolExit then //The batch file was successfully written. Now write the commands file to sqlcmd
    begin
      SetArrayLength(strCmds, 2);
      strCmds[0]:= 'IF EXISTS (SELECT 1 FROM master.sys.databases WHERE name = N''' + strSQLDBName + ''')';
      strCmds[1]:= 'PRINT ''' + SQLDBExists + '''';
      bolExit:= SaveStringsToFile(strFileDat, strCmds, False);
    end;
  result:= bolExit;
end;

function ISSQLServerDBExists(strInstance, strSAPWD, strSQLDBName: string): boolean;
(*Purpose
Queries an SQL Server Instance for the existence (or not) of the database
with the name given attached
*)
var
  strFileBat, strFileDat, strFileOut, strPathTmp: String;
  strCheckResult: AnsiString;
  bolSuccess, bolDBExists: boolean;
  ErrorCode: Integer;
  strSQLInstance: String;
  
begin
  bolDBExists:= False;
  strFileBat:= GetSQLTmpFileBat('');
  strFileDat:= FileDat(strFileBat);
  strFileOut:= FileOut(strFileBat);
  strPathTmp:= GetPathTmp('');
  strSQLInstance:= SQLInstanceNameFull(strInstance);
  
  bolSuccess:= SQLServerDBExists_CmdFiles(strInstance, strSAPWD, strSQLDBName, strFileBat, strFileDat, strFileOut);
  if bolSuccess then
    begin
      bolSuccess:= ShellExec('', strFileBat, '', strPathTmp, SW_SHOW, ewWaitUntilTerminated, ErrorCode);
      Log('Batch file ' + strFileBat + ' was executed. Result code was' + BoolToStr(bolSuccess));
      if bolSuccess then
        begin
          bolSuccess:= LoadStringFromFile(strFileOut, strCheckResult);
          if bolSuccess then
            begin
              bolDBExists:= (strCheckResult = SQLDBExists);
            end;
        end;
    end;
result:= bolSuccess;
end;


function SQLServerDataFilesBackup(strDataFile, strPathSrc: String): boolean;
(*Purpose
Checks if the data files to attach to the DB already exist in the destination directory
If they do, changes the name to a backup file
NOTES: SQL Server uses files in pairs, a .mdf file (the database itself) and a .ldf file (the log file)
*)

var
  bolSuccess: boolean;
  strFileDB, strFileLog: String;
  strDateTime: String;
  
begin
  bolSuccess:= False;
  strDateTime:= GetDateTimeString('yyyymmddhhmmss',':',':');
  strFileDB:= AddBackslash(strPathSrc) + ChangeFileExt(strDataFile, SQLDBExt);
  strFileLog:= AddBackslash(strPathSrc) + ChangeFileExt(strDataFile, SQLLogExt);
  bolSuccess:= FileBackup(strFileDB, strDateTime, '');
  if bolSuccess then
    begin
      bolSuccess:= FileBackup(strFileLog, strDateTime, '');
    end;
result:= bolSuccess;
end;

function GetMsgDataDirNotCreated(strPathData: String): String;
(*Purpose
Creates the message to show if the Data Directory selected by the user does not exist
and cannot be created
*)
begin
  result:= 'The Data Directory ' + strPathData + 
            ' does not exist, and could not be created.' + 
            GetMsgBoxCRLF + 
            'The installation will now be interrupted.';
end;

function SQLServerDataFilesCopy(strFileDB, strPathSrc, strPathDest: String): boolean;
(*Purpose
Copies a set of SQL Server data files from the Temporary Directory to the Application Data Directory
NOTES: SQL Server uses files in pairs, a .mdf file (the database itself) and a .ldf file (the log file)
*)

var
  bolSuccess: boolean;
  strFileDBSrc, strFileLogSrc: String;
  strFileDBDest, strFileLogDest: String;
  
begin
  bolSuccess:= False;
  
  strFileDBSrc:= AddBackslash(strPathSrc) + ChangeFileExt(strFileDB, SQLDBExt);
  strFileLogSrc:= AddBackslash(strPathSrc) + ChangeFileExt(strFileDB, SQLLogExt);
  strFileDBDest:= AddBackslash(strPathDest) + ChangeFileExt(strFileDB, SQLDBExt);
  strFileLogDest:= AddBackslash(strPathDest) + ChangeFileExt(strFileDB, SQLLogExt);
  Log('Copying files ' + strFileDB + ' to ' + strPathDest);
  
  bolSuccess:= DataPathCreate(strPathDest);
  if not bolSuccess then
    begin
      MsgBox(GetMsgDataDirNotCreated(strPathDest), mbInformation, MB_OK);
      exit;
    end;
  
  bolSuccess:= SQLServerDataFilesBackup(strFileDB, strPathDest);
  
  bolSuccess:= FileCopy(strFileDBSrc, strFileDBDest, False);
  if bolSuccess then
    begin
      Log('Copying File ' + strFileDBSrc + ' to ' +  strFileDBDest + ' was successfull.')
      bolSuccess:= FileCopy(strFileLogSrc, strFileLogDest, False);
        if bolSuccess then
          begin
            Log('Copying File ' + strFileLogSrc + ' to ' +  strFileLogDest + ' was successfull.')
          end
        else
          begin
            Log('Copying File ' + strFileLogSrc + ' to ' +  strFileLogDest + ' failed.')
          end;
    end
  else
    begin
      Log('Copying File ' + strFileDBSrc + ' to ' +  strFileDBDest + ' failed.')  
    end;
    
result:= bolSuccess;
end;


function SQLServerAttachDB(strInstance, strSAPWD, strSQLDBName, strFileDB: String): Boolean;
(*Purpose
Attach a database to the SQL Server Instance indicated, copying the database files
to the Application Data Directory.
These files (a xx.mdf file and a xx.ldf file) must exist in the installation temporary
directory given by PathTmp
*)
var
  strFileBat: String;
  FileDB, FileLog: String;
  bolSuccess: boolean;
  ErrorCode: integer;
  strInstanceFull, strPathData, strPathTmp: String;

begin
  strInstanceFull:= SQLInstanceNameFull(strInstance);
  strPathData:= GetPathData('');
  strPathTmp:= GetPathTmp('');
  strFileBat:= GetSQLAttachFileBat('');
  bolSuccess:= SQLServerAttachDB_CmdFiles(strInstance, 
                strPathData, strPathTmp, strFileDB, strSAPWD, strFileBat);
  if bolSuccess then
    begin
      bolSuccess:= ShellExec('', strFileBat, '', strPathTmp, SW_SHOW, ewWaitUntilTerminated, ErrorCode);
    end;
  result:= bolSuccess;
end;


function SQLServerDetachDB(strInstance, strSAPWD, strSQLDBName: String): Boolean;
(*Purpose
Detach a database from the SQL Server Instance indicated, if they exist
*)
var
  strFileBat: String;
  bolSuccess, bolAttached: boolean;
  ErrorCode: integer;
  strInstanceFull, strPathTmp: String;

begin
  bolSuccess:= False;
  strInstanceFull:= SQLInstanceNameFull(strInstance);
  strPathTmp:= GetPathTmp('');
  strSAPWD:= GetSQLSAPWD('');
  strFileBat:= GetSQLDetachFileBat('');
  
  bolAttached:=ISSQLServerDBExists(strInstanceFull, strSAPWD, strSQLDBName);
  if not bolAttached then
    begin //No need to continue
      result:= True;
      exit;
    end;
  bolSuccess:= SQLServerDetachDB_CmdFiles(strInstance, strSAPWD, strSQLDBName, strFileBat);
  if bolSuccess then
    begin
      bolSuccess:= ShellExec('', strFileBat, '', strPathTmp, SW_SHOW, ewWaitUntilTerminated, ErrorCode);
    end;
  result:= bolSuccess;
end;


function SQLServerAttachDBComplete(strFileDB, strSQLDBName: String): Boolean;
(*Purpose
Attach a set of database files to the SQL Server Instance indicated, checking if it already exists
*)
var
  strFileBat: String;
  FileDB, FileLog: String;
  bolSuccess: boolean;
  ErrorCode: integer;
  strInstance, strPathSrc, strPathDest, strSAPWD: String;
  strPathTmp: String;

begin 
  strInstance:= GetMyAppSQLInstanceNameFull('');
  strPathDest:= GetPathData('');
  strPathSrc:= GetPathTmp('');
  strPathTmp:= GetPathTmp('');
  strSAPWD:= GetSQLSAPWD('');
  strFileBat:= GetSQLAttachFileBat('');
  Log('Working in function SQLServerAttachDBComplete.')
  Log('The InstanceName used is ' + strInstance);
  Log('The Destination path used is ' + strPathDest);
  Log('The Source path used is ' + strPathSrc);
  Log('The Tmp path used is ' + strPathTmp);
  Log('The SAPWD used is ' + strSAPWD);
  Log('The batch file used is ' + strFileBat);
  SQLServerDataFilesCopy(strFileDB, strPathSrc, strPathDest);
  
  bolSuccess:= SQLServerDetachDB(strInstance, strSAPWD, strSQLDBName);
  
  bolSuccess:= SQLServerAttachDB_CmdFiles(strInstance, strSAPWD, strSQLDBName, strPathDest, strFileDB, strFileBat);
  if bolSuccess then
    begin
      bolSuccess:= ShellExec('', strFileBat, '', strPathTmp, SW_SHOW, ewWaitUntilTerminated, ErrorCode);
    end;
  result:= bolSuccess;
end;



function SQLServerInstallMakeBat(Param: String): boolean;
(*Purpose
Creates the batch file to run the installation of the adequate instance of SQL Server 2005 Express
Using a configuration file to pass the parameters for the installation
*)

var
  strCommand: TArrayOfString;
  bolExit: boolean;
  ErrorCode: Integer;
  SQLSetup: String;
  strConf, strBatFile, strDirTmp: String;
  
begin
  setArrayLength(strCommand, 1);
  SQLSetup:= GetSQLInstaller('');
  strConf:= GetSQLInstallDat('');
  strDirTmp:= GetPathTmp('');
  strCommand[0]:= 'Start /wait ' + SQLSetup + ' /qb /settings ' + strConf;
  strBatFile:= GetSQLInstallBat('');
  bolExit:= SaveStringsToFile(strBatFile, strCommand, False);
  result:= bolExit;
end;

function SQLServerInstall(strInstance, strSAPWD: String): boolean;
(*Purpose
Configures and Runs the installation of the adequate instance of SQL Server 2005 Express
*)

var
  bolExit: boolean;
  ErrorCode: Integer;
  strBatFile, strINIFile, strDirTmp: String;
  strSQLInstance: String;
    
begin
  strBatFile:= GetSQLInstallBat('');
  strINIFile:= GetSQLInstallDat('');
  strDirTmp:= GetPathTmp('');
  strSQLInstance:= SQLInstanceNameLocal(strInstance); //Make sure this is not the full name, only the local one
    
  bolExit:= SQLServerInstallMakeBat('');
  Log('Just made the batch file for instalation. The output of the creation is ' + BoolToStr(bolExit));
  if bolExit then
    begin
      bolExit:=SQLServerInstallUpdateINI(strINIFile, strSQLInstance, strSAPWD);
      if bolExit then
        begin
          bolExit:= ShellExec('', strBatFile, '', strDirTmp ,SW_SHOW, ewWaitUntilTerminated, ErrorCode);
        end;
    end;
 result:= bolExit;
end;


function SQLServerInstallComplete(Param: String): boolean;
(*Purpose
Manages the installation of the adequate instance of SQL Server 2005 Express
It will check if it should be installed, and install it if it is required
*)

var
  bolSQLServer, bolSQLInstance, bolExit: boolean;
  strInstanceLocal, strInstanceFull: String;
  strSAPWD: String;
  
begin
  strInstanceFull:= GetMyAppSQLInstanceNameFull('');
  strInstanceLocal:= SQLInstanceNameLocal(GetSQLInstance(''));
  strSAPWD:= GetSQLSAPWD('');
  bolSQLServer:= False;
  bolSQLInstance:= False;
  bolExit:= False;

  
  bolSQLServer:= GetSQLServerInstallationRequired('');
  
  bolSQLInstance:= GetSQLServerInstanceInstallationRequired('');
  if (bolSQLServer) or (bolSQLInstance) then
    begin
      Log('Installing local Instance ' + strInstanceLocal + ' of SQL Server');
      bolExit:= SQLServerInstall(strInstanceLocal, strSAPWD);
    end;      
end;


procedure SetGlobalsSQLServerStart();
(*Purpose
Sets the values of the global variables that are used when installing or 
checking the instalation of the SQL Server and the associated databases
This procedure must be run BEFORE any checks on SQL Server installation are done
*)

begin
  SetSQLInstaller(ExpandConstant('setup.exe'));
  SetSQLInstance(ExpandConstant('FAOCAS')); 
  SetSQLDBName(ExpandConstant('FAOCASDATA'));
  SetSQLDBFile(ExpandConstant('FAOCASDATA'));
  SetSQLInstallBat(ExpandConstant('FAOCAS_SQLInstall.bat'));
  SetSQLInstallDat(ExpandConstant('FAOCAS_SQLInstallConfig.ini'));
  SetSQLSAPWD(ExpandConstant('Test123'));
  SetDBInstallationChecked(False);
  end;
  
procedure SetGlobalsCheckDBInstallation();
(*Purpose
Sets the global variables informing the installation of what parts (if any) of
the database system are already properly installed or configured
*)
var
  strInstance, strSAPWD, strDBName: String;
  
begin
SetDBInstallationChecked(False);

  strInstance:= GetMyAppSQLInstanceNameFull('');
  strSAPWD:= GetSQLSAPWD('');
  strDBName:= GetSQLDBName('');
  
  if IsSQLExpressInstalled('') then
    begin
      SetSQLServerInstalled(True);
      if ISSQLServerInstanceInstalled(strInstance) then
        begin
          SetSQLServerInstanceInstalled(True);
          if ISSQLServerDBExists(strInstance, strSAPWD, strDBName) then
            begin
              SetDBExists(True);
            end
          else
            begin
              SetDBExists(False);
            end;
        end
      else
        begin
          SetSQLServerInstanceInstalled(False);
          SetDBExists(False);
        end;
    end
  else
    begin
      SetSQLServerInstalled(False);
      SetSQLServerInstanceInstalled(False);
      SetDBExists(False);
    end;
SetDBInstallationChecked(True);
end;

function CheckDBInstallationRequired(bolForceCheck: Boolean): Boolean;
(*Purpose
Checks if the different parts of the SQL Server installation required are
already installed, and sets the appropriate global variables to indicate
whether it should be installed
*)
var
  strInstance, strDBName: String;
  bolInstallRequired: Boolean;
  
begin
  if bolForceCheck then
    begin
      SetDBInstallationRequiredChecked(False); //Ignore previous checks
    end;
  
  if GetDBInstallationRequiredChecked('') then
    begin //If it was already done, just return the value of the appropriate global variables
      result:= GetDBInstallationRequired('');
      exit; 
   end;
    
  strInstance:= GetMyAppSQLInstanceNameFull('');
  strDBName:= GetSQLDBName('');
  bolInstallRequired:= False;
  if not GetDBInstallationChecked('') then
    begin
      SetGlobalsCheckDBInstallation; //Check what is installed, and set the appropriate global variables
    end;
    
  if not GetSQLServerInstalled('') then
    begin //Nothing is installed. Set the requirements to install all
      bolInstallRequired:= True;
      SetSQLServerInstallationRequired(true);
      SetSQLServerInstanceInstallationRequired(True);
      SetAttachDBRequired(True);
      SetDBInstallationRequired(True);
      Log('SQL Server 2005 Express Edition is not yet installed. It will be installed.');
    end
  else
    begin
      Log('SQL Server 2005 Express Edition is already installed');
      if not GetSQLServerInstanceInstalled('') then
        begin //Another instance of SQL Server is installed, but not the one required by the application. Set requirements to install what is missing
          bolInstallRequired:= True;
          SetSQLServerInstanceInstallationRequired(true);
          SetAttachDBRequired(True);
          SetDBInstallationRequired(True);
          Log('Instance ' + strInstance + ' of SQL Server 2005 Express Edition is not yet installed. It will be installed');    
        end
      else
        begin
          SetSQLServerInstanceInstallationRequired(false);
          Log('Instance ' + strInstance + ' of SQL Server 2005 Express Edition is already installed');
          if not GetDBExists('') then //SQL Server and the right instance are installed, but the database does not exist
            begin
              bolInstallRequired:= True;
              SetAttachDBRequired(True);
              SetDBInstallationRequired(True);
              Log('The DataBase ' + strDBName + ' does not exist on the server. It will be created by attaching the right files'); 
            end
          else
            begin
              bolInstallRequired:= False;
              SetAttachDBRequired(False);
              SetDBInstallationRequired(False);
              Log('The DataBase ' + strDBName + ' already exists on the server.'); 
              Log('All database components are already installed. No need to install any component.')
            end;       
        end;
    end;
  SetDBInstallationRequiredChecked(True); //Record that the requirements for installation of the DB components have been checked
  result:= bolInstallRequired;
end;

function CheckSQLServerInstanceInstallationRequired(bolForceCheck: Boolean): Boolean;
(*Purpose
Checks if it is required to install the application instance of SQLServer.
If this was not yet checked, also sets the appropriate global variables to indicate
whether the different components of the Database system should be installed
*)
var
  strInstance, strDBName: String;
  bolInstallRequired: Boolean;
  
begin
  if bolForceCheck then
    begin
      SetDBInstallationRequiredChecked(False); //Ignore previous checks
    end;
  
  if GetDBInstallationRequiredChecked('') then
    begin //If it was already done, just return the value of the appropriate global variables
      result:=GetSQLServerInstallationRequired('');
      exit; 
    end;
    
  strInstance:= GetMyAppSQLInstanceNameFull('');
  strDBName:= GetSQLDBName('');
  bolInstallRequired:= False;
  if not GetDBInstallationChecked('') then
    begin
      SetGlobalsCheckDBInstallation; //Check what is installed, and set the appropriate global variables
    end;
    
  if not GetSQLServerInstalled('') then
    begin //Nothing is installed. Set the requirements to install all
      bolInstallRequired:= True;
      SetSQLServerInstallationRequired(true);
      SetSQLServerInstanceInstallationRequired(True);
      SetAttachDBRequired(True);
      SetDBInstallationRequired(True);
      Log('SQL Server 2005 Express Edition is not yet installed. It will be installed.');
    end
  else
    begin
      Log('SQL Server 2005 Express Edition is already installed');
      if not GetSQLServerInstanceInstalled('') then
        begin //Another instance of SQL Server is installed, but not the one required by the application. Set requirements to install what is missing
          bolInstallRequired:= True;
          SetSQLServerInstanceInstallationRequired(true);
          SetAttachDBRequired(True);
          SetDBInstallationRequired(True);
          Log('Instance ' + strInstance + ' of SQL Server 2005 Express Edition is not yet installed. It will be installed');    
        end
      else
        begin
          SetSQLServerInstanceInstallationRequired(false);
          bolInstallRequired:= False;
          Log('Instance ' + strInstance + ' of SQL Server 2005 Express Edition is already installed');
          if not GetDBExists('') then //SQL Server and the right instance are installed, but the database does not exist
            begin
              SetAttachDBRequired(True);
              SetDBInstallationRequired(True);
              Log('The DataBase ' + strDBName + ' does not exist on the server. It will be created by attaching the right files'); 
            end
          else
            begin
              SetAttachDBRequired(False);
              SetDBInstallationRequired(False);
              Log('The DataBase ' + strDBName + ' already exists on the server.'); 
              Log('All database components are already installed. No need to install any component.')
            end;       
        end;
    end;
  SetDBInstallationRequiredChecked(True); //Record that the requirements for installation of the DB components have been checked
  result:= bolInstallRequired;
end;

function CheckDBAttachRequired(bolForceCheck: Boolean): Boolean;
(*Purpose
Checks if it is necessary to attach the Database provided with the application to the database server,
and if this was not yet checked, sets the appropriate global variables to indicate
whether it should be installed
NOTE: It will be necessary to attach the DB if any of the components of the system is not installed, so this
      defaults to the CheckDBInstallationRequired function. In this case, this function is just a wrapper to
      CheckDBInstallationRequired
*)
begin
  result:= CheckDBInstallationRequired(bolForceCheck);
end;

function GetReadyPageDBInstallationText(NewLine: String): String;
(*Purpose
Builds the string to show in the last page before installation, summarizing what parts of the Database system will be installed
*)
var
  strTmp: String;
  
begin
  if not GetDBInstallationRequired('') then
    begin
      exit;
    end;
  
  strTmp:= 'Database components to install:'+ NewLine
  if GetSQLServerInstallationRequired('') then
    begin
      strTmp:= NewLine + strTmp + strSQLServer_gc;
    end;
    
  if GetSQLServerInstanceInstallationRequired('') then
    begin
      strTmp:= strTmp + NewLine;
      strTmp:= strTmp + strSQLServer_gc + ' Instance ' + GetSQLInstance(''); 
    end;
  
  if GetAttachDBRequired('') then
    begin
      strTmp:= strTmp + NewLine;
      strTmp:= strTmp + 'Attach file ' + ExtractFileName(GetSQLDBFileName(''));
      strTmp:= strTmp + ' as Database ' + GetSQLDBName(''); 
    end;
result:= strTmp;    
end;
[Code]

var
  UserPromptsDataDir: TArrayOfString;
  DataDir: String; //String of the directory where data files will be stored
  DataDirPage: TInputDirWizardPage; //Just the wizard page object to collect the user's choice of data directory
  wpDataDir: integer; //ID of the Data Directory Page
  MemoDataDirInfo: string;
  


procedure SetDataDirPageID(intPageID: integer);
(*Purpose
Set the value of the global variable holding the ID of the Data Directory Page
*)
begin
  wpDataDir:= intPageID;
end;

procedure SetGlobalsDataDir();
(*Purpose
Sets the values of the Global Variables related to the Data Directory Selection Wizard Page
*)
begin
end;

function GetDataDirPagePrompts(lngInd: integer): string;
(*Purpose:
Returns the Prompts to put in the Wizard page for the Data Directory
*)
var
  prompt: string;

begin
  case lngInd of
    1: //Caption
      begin
        prompt:= UserPromptsDataDir[0];
      end;
    2: //Description
      begin
        prompt:= UserPromptsDataDir[1];
      end;
    3: //SubCaption
      begin
        prompt:= UserPromptsDataDir[2];

      end;
  end;
result:=prompt;
end;

procedure DataDirPage_Activate(Sender: TWizardPage);
var
    Page: TInputDirWizardPage;
begin
    Page := TInputDirWizardPage(Sender);
end;

function DataDirPage_ShouldSkipPage(Sender: TWizardPage): Boolean;
var
    Page: TInputDirWizardPage;
begin
    Page := TInputDirWizardPage(Sender);
    Result := False;
end;

function DataDirPage_BackButtonClick(Sender: TWizardPage): Boolean;
var
    Page: TInputDirWizardPage;
begin
    Page := TInputDirWizardPage(Sender);
    Result := True;
end;

function DataDirPage_NextButtonClick(Sender: TWizardPage): Boolean;
var
    Page: TInputDirWizardPage;
begin
    Page := TInputDirWizardPage(Sender);
    DataDir:= Page.Values[0];
    Result := True;
end;


procedure DataDirPage_CancelButtonClick(Sender: TWizardPage; var Cancel,
                                               Confirm: Boolean);
var
    Page: TInputDirWizardPage;
begin
    Page := TInputDirWizardPage(Sender);
end;

function CreatePage_DataDir(PreviousPageId: Integer): Integer;
var
    Page: TInputDirWizardPage;
    Caption, SubCaption, Description: string;
    strDataDir: string;
    
begin
  Caption:=GetDataDirPagePrompts(1);
  Description:=GetDataDirPagePrompts(2);
  SubCaption:=GetDataDirPagePrompts(3);
  Page := CreateInputDirPage(PreviousPageId, Caption, Description, SubCaption,
   False, strNewFolder);

  Page.Add('');
  
SetPathDataDefault;
strDataDir:= GetPathData('');
Page.Values[0] := strDataDir;

  if ShouldLoadInf() then begin
    Page.Values[0] := LoadInfString(UserChoicesSection, DataDirKey, strDataDir);
  end;
  
  Page.OnActivate := @DataDirPage_Activate;
  Page.OnShouldSkipPage := @DataDirPage_ShouldSkipPage;
  Page.OnBackButtonClick := @DataDirPage_BackButtonClick;
  Page.OnNextButtonClick := @DataDirPage_NextButtonClick;
  Page.OnCancelButtonClick := @DataDirPage_CancelButtonClick;
  
  HasDataDirPage:= True;
  
  result := Page.ID;
  wpDataDir:= Page.ID;
end;

function GetReadyPageDataDirText(NewLine: String): string;
(*Purpose
Create the text to present in the page of ready to install
*)
var
  strTmp: string;

begin
  strTmp:= 'Application Data Folder:'
  strTmp:= strTmp + NewLine + '   ';
  strTmp:= strTmp + GetPathData('');
  result:= strTmp;
end;


procedure DoPostInstall(); forward;
procedure DoPreInstall(); forward;


procedure InitializeUserPrompts();
{Purpose:
Create the User Prompts and store them in the corresponding variables}

var
strTmp: string;

begin
  Log('Creating the User Prompts');
  SetArrayLength(UserPromptsDataDir, 3);
  UserPromptsDataDir[0]:= 'Select the location for the Data files';
  UserPromptsDataDir[1]:= 'Where should the data files be stored?';
  strTmp:= 'Data files will be stored in the following folder';
  strTmp:= strTmp + GetMsgBoxCRLF() + GetMsgBoxCRLF();
  strTmp:= strTmp + 'To continue, click Next. '
  strTmp:= strTmp + 'If you would like to select a different folder, click Browse.';
  UserPromptsDataDir[2]:= strTmp;
  Log('User Prompts for the Data Folder Selection Page Completed.');
end;





var
  DotNet11Installed: (dnUnknown, dnNotInstalled, dnInstalled);

function IsDotNet11Installed(): Boolean;
begin;
  if DotNet11Installed = dnUnknown then begin
    DotNet11Installed := dnNotInstalled;
    if RegKeyExists(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322') then
      DotNet11Installed := dnInstalled;
  end;
  Result := DotNet11Installed = dnInstalled;
end;



function IsDotNetDetected(version: string; service: cardinal): boolean;
var
  key: string;
  install, serviceCount: cardinal;
  success: boolean;
begin
  key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;
  if Pos('v4', version) = 1 then begin
    success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
  end else begin
    success := success and RegQueryDWordValue(HKLM, key, 'SP', serviceCount);
  end;
  result := success and (install = 1) and (serviceCount >= service);
end;



function CheckRequirements(): Boolean;
begin
  result := true;

end;


procedure ODBCCreate();
{Purpose:
Create the ODBC connection to link to the databases used by the application
}
begin
{Put the code here}

end;

procedure InitializeWizard;
begin
{Purpose:
Create custom pages to show during install }
  InitializeUserPrompts;
  CreatePage_DataDir(wpSelectDir); //The ID is created in the function itself
end;



function InitializeSetup(): Boolean;
(*Purpose
This function is run BEFORE the start of the setup, even before any dialog is shown
to the user.
This function will perform the following tasks:
a) Set any information on instructions passed through the command-line parameters
b) Set global variables that must be in place for the use of functions used during
  the collection of user information via the wizards
c) Check any prerequisites that need to be known for the wizards
*)
begin
Log('Starting function InitializeSetup');
  UpdateInfFilenames(); //Read the names of the .Inf configuration files to use, if any
  SetGlobalsSQLServerStart; //Set the global variables related to SQL Server installation
  SetGlobalsCheckDBInstallation; //Set the global variables informing the status of the different components of the Database system
  CheckDBInstallationRequired(True); //Set the global variables on the need to install the different components of the Database system
  Result := True; //Allow Setup to continue
end;

procedure DeinitializeSetup();
var
  bIni : boolean;
begin
 
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  case CurStep of
    ssInstall:
      begin
        DoPreInstall;
      end;
    ssPostInstall:
      begin
        SetFinishedInstall(True);
        DoPostInstall;
      end;
      
  end;
end;

procedure DoPreInstall();
(*
   Pre-Installation procedure. Runs before performing any action.
*)

var
  bolRequirements: boolean;
 
begin
  SetGlobalsCommon; //Set the initial values of the Global variables for the installation
  SetGlobalsDataDir;
  SetGlobalsSQLServerStart;

  bolRequirements:= CheckRequirements;
  if not bolRequirements then
    begin
      Exit;
    end;
  
end;

procedure DoPostInstall();
{Purpose:
	    Post-Installation procedure. Runs after performing all installation actions.
}
var
  strFileDB: String;
  strSQLDBName: String;
  
begin
  Log('Starting the DoPostInstall routine');
  MsgBox('The value of the InstallSQLServer variable is ' + BoolToStr(InstallSQLServer), mbInformation, MB_OK);
MsgBox('The value of the AttachDBFile variable is ' + BoolToStr(AttachDBFile), mbInformation, MB_OK);  
  if InstallSQLServer then
    begin
      SQLServerInstallComplete('');
    end;
  if AttachDBFile then
    begin
      strSQLDBName:= GetSQLDBName('');
      MsgBox('The name of the DB to create is ' + strSQLDBName, mbInformation, MB_OK);
      strFileDB:= GetSQLDBFileName('');
      MsgBox('The name of the DB file to attach is ' + strSQLDBName, mbInformation, MB_OK);
      SQLServerAttachDBComplete(strFileDB, strSQLDBName);
    end;
  
   
end;

procedure DoSuccessInstall();
(*Purpose:
	    Successful Installation procedure. Runs after performing all actions.
*)

begin
end;

procedure DoPreUnInstall();
(*
   Pre-UnInstallation procedure. Runs before performing any action.
*)
begin
end;

procedure DoPostUnInstall();
(*Purpose:
  Post-UnInstallation procedure. Runs after performing all uninstallation actions.
  This procedure is designed to perform ‘garbage collection’ and remove files not managed by Inno.
*)

begin
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  ResultCode: Integer;
  bolMoveNext: Boolean;
  PageDir: TInputDirWizardPage;
  
begin//OK
  bolMoveNext:= True;
  Log('NextButtonClick(' + IntToStr(CurPageID) + ') called');
  if CurPageID = wpSelectDir then
    begin//OK
    Log('Leaving page for Selection of installation directory');
    end//OK
  else
    begin//OK
      if CurPageID = wpSelectProgramGroup then
        begin//OK
          Log('Leaving page for Selection of the program group');
          bolMoveNext:= True;
        end //OK
      else
        begin
          if CurPageID = wpReady then
            begin//OK
              Log('Leaving page of Ready to Start Installation');
              bolMoveNext:= True;
            end//OK
          else
            begin//OK
              if CurPageID = wpDataDir then
                begin//OK
                  Log('Leaving page for Selection of Data directory');
                  PageDir:= TInputDirWizardPage(PageFromID(wpDataDir));
                  SetPathData(PageDir.Values[0]);
                  Log('Data for application is '+ PageDir.Values[0]);
                  bolMoveNext:= True;
                end; //OK
            end;//OK       
        end;//OK
    end;//OK
result:= bolMoveNext;
end;//OK



