;Specialized script to be included in other scripts
;Creates a page for input of the application data directory, and gets the input from the user

;GENERAL APPLICATION DEFINITIONS
#define MyAppName "FAO Fisheries Catch Assessment Surveys Data Manager"
#define MyAppVersion "0.0.1 Alpha"
#define MyAppPublisher "FAO"
#define MyAppURL "http://www.faomedfisis.org/"
#define MyAppExeName "FAOFishCAS.exe"

;DIRS HOLDING FILES TO INCLUDE
#define IncludeFilesDir "D:\DataPB\PCBCodeInstallers\IncludeFiles"

;SOURCE DIRECTORIES
#define MyAppSetupSrcBaseDir "D:\DataPB\PCBCodeInstallers"
#define MyAppSetupSrcDir MyAppSetupSrcBaseDir + "\src"
;#define MyAppSetupSrcQtDLLDir MyAppSetupSrcDir + "\QtDLLs"
;#define MyAppSetupSrcOtherDLLDir MyAppSetupSrcDir + "\OtherDLLs"
;#define MyAppSetupSrcDBServerDir MyAppSetupSrcDir + "\DBServer"
;#define MyAppSetupSrcOtherFilesDir MyAppSetupSrcDir + "\OtherFiles"
;#define MyAppSetupSrcReportMakerDir MyAppSetupSrcDir + "\Report"
;#define MyAppSetupSrcReportSpecsDir MyAppSetupSrcDir + "\ReportSpecs"
;#define MyAppSetupSrcQtSQlDriversDir MyAppSetupSrcDir + "\QtSQLdrivers"
;#define MyAppSetupSrcConfigDir MyAppSetupSrcDir + "\Config"

;FOLDER FOR THE COMPILED SETUP
#define MyAppSetupOutputDir MyAppSetupSrcBaseDir + "\Output"
;DESTINATION DIRECTORIES
#define MyAppConfDir "Config"
#define MyAppDataDirDefault "C:\FAO_Fish_Data"

;OTHER APPLICATION DEFINITIONS
#include IncludeFilesDir + "\PCBBuildNumberWithINIFile.iss"


;APPLICATION CONFIGURATION VARIABLES
#define MyAppSQLInstanceName "FAO_CAS"

[InnoIDE_PostCompile]
[CustomMessages]


[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppID={{4F9DE949-A8BA-4D84-8C30-F98557DB5745}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\FAO_FI\CAS
DisableDirPage=no
DefaultGroupName=FAOFishData
AllowNoIcons=true
;LicenseFile={#MyAppSetupSrcDir}\license.txt
OutputDir={#MyAppSetupSrcDir}\output
OutputBaseFilename=setup_CAS_app
SetupIconFile={#MyAppSetupSrcDir}\medfisis.ico
Compression=lzma/Max
SolidCompression=true
SetupLogging=true

[Languages]
Name: english; MessagesFile: compiler:Default.isl

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Files]
Source: {#MyAppSetupSrcDir}\MedFisisCAS.exe; DestDir: {app}; Flags: ignoreversion
Source: {#MyAppSetupSrcDir}\license.txt; DestDir: {code:GetDataDir}; Flags: ignoreversion
;Source: {#MyAppSetupSrcDir}\albania.ldf; DestDir: {#MyAppDataDir}; Flags: ignoreversion
;Source: {#MyAppSetupSrcDir}\albania.mdf; DestDir: {#MyAppDataDir}; Flags: ignoreversion
;Source: {#MyAppSetupSrcDir}\MedFisisCAS.exe; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcDir}\MedFisisCAS.pdb; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcDir}\attach.dat; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcOtherDLLDir}\CatchInputCtrl.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcOtherDLLDir}\customtimectrl.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtCore4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtGui4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtNetwork4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtScript4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtSql4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtTest4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtWebKit4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtXml4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcQtDLLDir}\QtXmlPatterns4.dll; DestDir: {app}; Flags: ignoreversion
;Source: {#MyAppSetupSrcOtherDLLDir}\Report.dll; DestDir: {app}; Flags: ignoreversion

;THIS IS NOT A GOOD IDEA (WRITE-ONLY INSTALLATION DIRECTORIES)
;Source: {#MyAppSetupSrcDBServerDir}\SQLEXPR.exe; DestDir: {src}\sqlserver_setup; Flags: ignoreversion
;Source: {#MyAppSetupSrcReportMakerDir}\*; DestDir: {app}\report\; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: {#MyAppSetupSrcReportSpecsDir}\*; DestDir: {app}\reports\; Flags: ignoreversion recursesubdirs createallsubdirs
;Source: {#MyAppSetupSrcQtSQlDriversDir}\*; DestDir: {app}\sqldrivers\; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
;Source: {#MyAppSetupSrcConfigDir}\CAS_SQLServerConf.ini; DestDir: {code:GetMyAppConfigDir}
;Source: {#MyAppSetupSrcDir}\post_install.bat; DestDir: {app}
;Source: {#MyAppSetupSrcDir}\README.txt; DestDir: {app}

[Icons]
Name: {group}\{#MyAppName}; Filename: {app}\{#MyAppExeName}
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppName}}; Filename: {#MyAppURL}
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}
Name: {commondesktop}\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Tasks: desktopicon

[Run]
;Filename: sqlexpr.exe; Parameters: "/x:""."""; WorkingDir: {src}\sqlserver_setup; Description: Sql Server Drivers; StatusMsg: Extracting sql server drivers; Flags: ShellExec
;Filename: setup.exe; Parameters: /wait /qb /settings {code:GetMyAppConfigDir}\CAS_SQLServerConf.ini; WorkingDir: {src}\sqlserver_setup; Description: install sql server drivers; StatusMsg: Install sql server drivers (compulsory); Flags: ShellExec PostInstall WaitUntilIdle
; NOTES: IS MISSING THE FOLLOWING:
;CREATE THE ODBC DATA SOURCE (SEE CODE FOR THIS)
;CONFIRM THAT THE SETUP REALLY UPDATES THE INSTANCE NAME OF SQL SERVER SETUP
;VERIFY IF AN INSTANCE OF THE NAME DESIRED ALREADY EXISTS
;IF IT DOES, CONFIRM THE USER AND PASSWORD ARE THE SAME. IF NOT, DELETE INSTANCE AND RE-INSTALL
;BEFORE RE-INSTALLING, BACKUP THE DATA FILES.
;ASK THE USER IF (S)HE WANTS TO KEEP THE EXISTING DATA. IF SO, RESTORE THE DATA FILES AND RE-ATTACH THEM TO THE NEW INSTANCE CREATED
[INI]
filename: {code:GetMyAppConfigDir}\CAS_SQLServerConf.ini; section: Options; key: INSTANCENAME; string: {#MyAppSQLInstanceName}


[Code]
#include "PCB_ISUtils.isi"
#include "PCBDataDirPage.isi"
//#include "IS_SQLServerInstallFunctions.isi"



//File with code to support the installation of SQL Server Express Edition
//Take the SQLServer_InstanceName.ini file, and modify it to fit this installation
//Also, the ODBC connection is built as a file DSN. This means the file with the
//definition of the connection is first copied to the target system, then edited
//to customize to each specific installation, and finally the relevant Registry
//keys are created

//TASKS TO PERFORM
//1-Install my Instance of SQL Server IF it is not already installed
//1.1-Check if SQL Server is installed - DONE
//1.2-Check if MyInstance of SQL Server is installed - DONE
//1.3- Install SQL Server as MyInstance, configured to this application
//1.3.1-Write the appropriate options to the SQL Server configuration file
//1.3.2-Run the SQL Server Installer with the config file written before
//1.3.3-Check that MyInstance of SQL Server is properly installed
//1.4-Attach the DataBase to the Server Instance IF it is not yet attached
//1.4.1-Check if DB files exist already at the given location - DONE
//1.4.1.2- If they exist, rename the files with extension .{DateTime}.bak - DONE

//1.4.2-Check if it is already attached - NOT DONE!
//1.4.2.1-IF it is attached: - NOT DONE!
//1.4.2.1.1-Detach (Ask user first) - NOT DONE!
//1.4.3-Copy the files to the Data Directory
//1.4.4-Attach the DB again



const
//Values for working with the Registry
RegKey_SQLServer = 'Software\Microsoft\Microsoft SQL Server';
RegRootKey_SQLServer = HKEY_LOCAL_MACHINE;
RegKeySQLServerInstance = 'MSSQL.';
RegKeySubKeySetup = 'Setup';
RegValEdition = 'Edition';
RegValSQLExpressEdition = 'Express Edition';

//Strings for the installation and uninstallation routines
strSQLInstaller = 'setup.exe';
strSQLInstallBat = 'SQLInstall.bat';
SQLDBExt = 'mdf'; //Extension of SQL Server Database files
SQLLogExt = 'ldf'; //Extension of SQL Server log files
SQLAttachBat = 'SQLDBAttach.bat'; //Batch file to attach the databases required to the server

//Values for the configuration of the installation of SQL Server
SQLInstanceKey = 'INSTANCENAME';
SQLConfFileSection = 'Options';
SQLSAPasswdKey = 'SAPWD';
SQLSecurModeKey = 'SECURITYMODE';
SQLSecurMode = 'SQL';


function IsSQLExpressInstalled(): boolean;
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

function GetMyAppSQLFullInstanceName(Param: String): String;
//Purpose
//Returns the fully-qualified SQL Server 2005 instance name, needed for many commands
//Note: Do not use for specifying the instance name for local installation. This requires only the Instance name, without the server name
var
  strInstName: string;

begin
  strInstName:= ExpandConstant('{computername}\')+ Param;
  Result := strInstName;
end;

function IsSQLServerInstanceInstalled(Param: String): Boolean;
//Purpose:
//Returns TRUE if an SQL Server Instance with the name we want is already installed
var
  RegKey: String;

begin
//RegKey:= AddBackslash(RegKey_SQLServer) + Param;
//  (*
// if RegKeyExists(RegRootKey_SQLServer, RegKey) then
//	  begin
// 		  result:=True;
//	  end
//  else
//	  begin
//      result:=False;
//    end;
//  *)
end;
end;

function UpdateSQLServerINI(strInstance, strSAPasswd: String): boolean;
(*Purpose
Updates the .ini file used to configure the installation of SQL Server Express,
to make it install the appropriate instance and credentials
*)
var
  bolSucces: boolean;
  strFNameFull, strInstance: String;

begin
  strFNameFull:= GetSQLInstallConfigFile('');
  //Set Instance Name
  bolSuccess:= SetIniString(SQLConfFileSection, SQLInstanceKey, strInstance, strFNameFull);
  //Set access credentials
  bolSuccess:= bolSuccess And SetIniString(SQLConfFileSection, SQLSecurModeKey, SQLSecurMode, strFNameFull);
  bolSuccess:= bolSuccess And SetIniString(SQLConfFileSection, SQLSAPasswdKey, strSAPasswd, strFNameFull);
  result:= bolSuccess;
end;

function SQLServerAttachDB(strInstance, strPathData, strPathTmp, strFileDB, strSAPWD: String): Boolean;
(*Purpose
Attach a database to the SQL Server Instance indicated
*)
var
  strFileBat: String;
  FileDB, FileLog: String;
  bolSuccess: boolean;
  ErrorCode: integer;

begin
//Create the files with the commands for attaching
  strFileBat:= GetSQLAttachFileBat('');
  bolSuccess:= SQLServerAttachDB_CmdFiles(strInstance,
                strPathData, strPathTmp, strFileDB, strSAPWD);

  //Run the batch file
  bolSuccess:= ShellExec('', strFileBat, '', strPathTmp, SW_SHOW, ewWaitUntilTerminated, ErrorCode);
end;


function GetSQLAttachFileBat(Param: String;): String;
(*Purpose
Returns the full path to the batch file used to attach the database files to SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLAttachBat, FExtBat);
end;

function GetSQLAttachFileDat(Param: String): String;
(*Purpose
Returns the full path to the .dat file used to pass the sqlcmd commands to attach the database files to SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLAttachBat, FExtDat);
end;

function GetSQLInstallConfigFile(Param: String;): String;
(*Purpose
Returns the full path to the file used to configure the installation of SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(SQLAttachBat, FExtBat);
end;

function GetSQLInstallFileBat(Param: String;): String;
(*Purpose
Returns the full path to the batch file used to install the specific instance of SQL Server
*)
begin
  result:=  AddBackslash(PathTmp) + ChangeFileExt(strSQLInstallBat, FExtBat);
end;

function GetSQLInstaller(Param: String;): String;
(*Purpose
Returns the full path to the SQL Server installer program
*)
begin
  result:=  AddBackslash(PathTmp) + SQLInstaller;
end;

function SQLServerInstall(Param: String): boolean;
(*Purpose
Runs the installation of the adequate instance of SQL Server 2005 Express
Using a configuration file to pass the parameters for the installation
*)

var
  strCommand: TArrayOfString;
  bolExit: boolean;
  ErrorCode: Integer;
  SQLSetup: String;
  strConf: String;

begin
  setArrayLength(strCommand, 1);
  SQLSetup:= GetSQLInstaller('');
  strConf:= GetSQLInstallConfigFile('');
  strCommand:= 'Start /wait ' + SQLSetup + ' /qb /settings ' + strConf;
  strBatFile:= GetSQLInstallFileBat('');
  bolExit:= SaveStringsToFile(strBatFile, strCommand, False);
  if bolExit then
    begin
      bolExit:= ShellExec('', strBatFile, '', strDirTmp,SW_SHOW, ewWaitUntilTerminated, ErrorCode);
    end;
 result:= bolExit;
end;


function CheckAndBackupSQLDataFiles(strDataDir, strDataFile): boolean;
(*Purpose
Checks if the data files to attach to the DB already exist in the destination directory
If they do, changes the name to a backup file
NOTES: SQL Server uses files in pairs, a .mdf file (the database itself) and a .ldf file (the log file)
*)

var
  bolExists, bolSucces: boolean;
  strFileDB, strFileLog: String;
  strFileDBBak, strFileLogBak: String;
  strDateTime: String;

begin
  bolSuccess:= False;
  strDateTime:=GetDateTimeString('yyyymmddhhmmss','','');
  strFileDB:= AddBackslash(strDataDir) + ChangeFileExt(strDataFile, SQLDBExt);
  strFileLog:= AddBackslash(strDataDir) + ChangeFileExt(strDataFile, SQLLogExt);
  bolExists:= FileExists(strFileDB);
  if bolExists then
    begin
      strFileDBBak:= strFileDB + '.' + strDateTime + '.bak';
      bolSuccess:= RenameFile(strFileDB, strFileDBBak);
    end;
  bolExists:= FileExists(strFileLog);
  if bolExists then
    begin
      strFileLogBak:= strFileLog + '.' + strDateTime + '.bak';
      bolSuccess:= RenameFile(strFileLog, strFileLogBak);
    end;
result:= bolSuccess;
end;


function SQLServerAttachDB_CmdFiles(strInstance, strPathData, strPathTmp, strFileDB, strSAPWD: string): boolean;
(*Purpose
Creates the two command files necessary to use the commands for attaching a set of
database files to SQL Server. These are one .bat file with the basic sqlcmd command line,
and a .dat file with the input commands to sqlcmd
*)

var
  strFileCmd, strFileDat, strFileDB, strFileLog: String;
  strCmds: TArrayOfString;
  strSQLInstance: String;
  bolExit: boolean;

begin
  //Define the names of the files to use
  strFileCmd:= GetSQLAttachFileDat('');
  strFileDat:= AddBackslash(strPathTmp) + ChangeFileExt(SQLAttachBat, FExtDat);
  strFileDB:= AddBackslash(strPathData) + ChangeFileExt(strFileDB, SQLDBExt);
  strFileLog:= AddBackslash(strPathData) + ChangeFileExt(strFileDB, SQLLogExt);
  strSQLInstance:=GetMyAppSQLFullInstanceName(strInstance);

//Create the Batch file
  SetArrayLength(strCmds, 2);
  strCmds[0]:= '@echo off';
  strCmds[1]:= 'start  /B  sqlcmd -S ' + strSQLInstance + '-U sa -P ' + strSAPWD + ' -i '
            + strFileDat;
  bolExit:= SaveStringsToFile(strFileCmd, strCmds, False);
  if bolExit then //The batch file was successfully written. Now write the commands file to sqlcmd
    begin
      SetArrayLength(strCmds, 7);
      strCmds[0]:= 'USE [master]';
      strCmds[1]:= 'GO';
      strCmds[2]:= 'CREATE DATABASE [''' + TestDB + '''] ON ';
      strCmds[3]:= '( FILENAME = N''' + strFileDB + ''' ), ';
      strCmds[4]:= '( FILENAME = N''' + strFileLog + ''' ), ';
      strCmds[5]:= 'FOR ATTACH ;';
      strCmds[6]:= 'GO;';
      bolExit:= SaveStringsToFile(strFileDat, strCmds, False);
    end;
result:= bolExit;
end;





//FORWARD DECLARATIONS



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
      Result := #13#10;
    end;
end;


procedure InitializeUserPrompts();
{Purpose:
Create the User Prompts and store them in the corresponding variables}

var
strTmp: string;

begin
  SetArrayLength(UserPromptsDataDir, 3);
  UserPromptsDataDir[0]:= 'Select the location for the Data files';
  UserPromptsDataDir[1]:= 'Where should the data files be stored?';
  strTmp:= 'Data files will be stored in the following folder';
  strTmp:= strTmp + GetMsgBoxCRLF() + GetMsgBoxCRLF();
  strTmp:= strTmp + 'To continue, click Next. '
  strTmp:= strTmp + 'If you would like to select a different folder, click Browse.';
  UserPromptsDataDir[2]:= strTmp;

end;





//VERIFY IF THIS CODE IS OK. IT SHOULD SERVE TO VERIFY IF DOTNET IS INSTALLED!A
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
// Indicates whether .NET Framework 4.0 is installed
// Taken from www.kynosarges.de/DotNetVersion.html
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
  //Detect if all the preliminary requirements to run and install (Like dotnet etc) are installed
  //if they are not, request the user to install, or find a way to install automatically
//  if not IsDotNetDetected('v4\Full', 0) then begin
//    MsgBox('AppName requires Microsoft .NET Framework 4.0 Full Profile.'#13#13
//        'Please download this from www.zemax.com/updates,'#13
//        'and then re-run the AppName setup program.', mbInformation, MB_OK);
//    result := false;
//  end else begin
//    MsgBox('Found Microsoft .NET Framework 4.0.', mbInformation, MB_OK);
    result := true;
//  end;

end;

function IsMySQLInstanceInstalled(Param: string): Boolean;
(*Purpose:
Returns TRUE if an SQL Server Instance with the name we want is already installed
*)
(*NOTES: The name of the instance must be passed as the parameter to the function
*)

var
bolTest: boolean;
strKey: string;
intRegRoot: integer;

begin
intRegRoot:= HKEY_LOCAL_MACHINE;
strKey := ExpandConstant('SOFTWARE\Microsoft\Microsoft SQL Server\}') + Param;
bolTest := RegKeyExists(intRegRoot, strKey);
if bolTest then
  begin
    Msgbox('The key exists', mbInformation, MB_OK);
    result:=True;
  end
else
  begin
    Msgbox('The key does not exist', mbInformation, MB_OK);
    result:=False;
  end;

end;


//INSTALL THE OBDC CONNECTION
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
//Set the custom Prompts to use
  InitializeUserPrompts;
  CreatePage_DataDir(wpSelectDir); //The ID is created in the function itself
end;



function InitializeSetup(): Boolean;
begin
  UpdateInfFilenames(); //Read the names of the .Inf configuration files to use, if any

  // ...
  Result := True; //Allow Setup to continue
end;

procedure DeinitializeSetup();
var
bIni : boolean;
begin
//Put code here

end;

procedure CurStepChanged(CurStep: TSetupStep);
begin

  if CurStep = ssPostInstall then
     FinishedInstall := True;
end;

//SEVERAL UTILITY FUNCTIONS AND PROCEDURES
procedure DoPreInstall();
(*
   Pre-Installation procedure. Runs before performing any action.
*)
begin
// We are about to install. Check whatever needs to be checked
//
end;

procedure DoPostInstall();
{Purpose:
	    Post-Installation procedure. Runs after performing all installation actions.
}

begin
//Do whatever needs to be done here
end;

procedure DoSuccessInstall();
(*Purpose:
	    Successful Installation procedure. Runs after performing all actions.
*)
//	var

begin
// Do whatever is necessary after the installation (like e.g.
//checking settings of Windows or of other programs
end;

procedure DoPreUnInstall();
(*
   Pre-UnInstallation procedure. Runs before performing any action.
*)
begin
// Here we do nothing at all.
//
end;

procedure DoPostUnInstall();
(*Purpose:
  Post-UnInstallation procedure. Runs after performing all uninstallation actions.
  This procedure is designed to perform ‘garbage collection’ and remove files not managed by Inno.
*)
//var

begin
    // We have finished uninstalling so we need to remove any extra Registry Keys
    //or files from special folders
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  ResultCode: Integer;
  SQLServerExpress: boolean;

begin
  Log('NextButtonClick(' + IntToStr(CurPageID) + ') called');
  case CurPageID of
    wpSelectDir:
      begin
        MsgBox('NextButtonClick:' #13#13 'You selected: ''' + WizardDirValue + '''.', mbInformation, MB_OK);
        SQLServerExpress:= IsSQLExpressInstalled();
        if  SQLServerExpress then
          begin
           MsgBox('SQL Server Express Edition:' #13#13 'It is installed.', mbInformation, MB_OK);
           MsgBox('SQL Server Express Edition:' #13#13 'Full Instance Name is:' #13#13 + GetMyAppSQLFullInstanceName('FAO_CAS'), mbInformation, MB_OK);

          end
        else
          begin
           MsgBox('SQL Server Express Edition:' #13#13 'It is NOT installed.', mbInformation, MB_OK);
          end;
      end;
    wpSelectProgramGroup:
      begin
        MsgBox('NextButtonClick:' #13#13 'You selected: ''' + WizardGroupValue + '''.', mbInformation, MB_OK);
      end;
    wpReady:
      begin
        MsgBox('NextButtonClick:' #13#13 'The normal installation will now start.', mbInformation, MB_OK);
      end;
  end;

  Result := True;
end;

#expr SaveToFile("debug.iss")
