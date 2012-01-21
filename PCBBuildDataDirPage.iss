;Specialized script to be included in other scripts
;Creates a page for input of the application data directory, and gets the input from the user

;GENERAL APPLICATION DEFINITIONS
#define MyAppName "FAO Fisheries Catch Assessment Surveys Data Manager"
#define MyAppVersion "0.0.1 Alpha"
#define MyAppPublisher "FAO"
#define MyAppURL "http://www.faomedfisis.org/"
#define MyAppExeName "FAOFishCAS.exe"

;DIRS HOLDING FILES TO INCLUDE
#define IncludeFilesDir "E:\CASSetup\IncludeFiles"

;SOURCE DIRECTORIES
#define MyAppSetupSrcBaseDir "E:\CASSetup"
#define MyAppSetupSrcDir MyAppSetupSrcBaseDir + "\src"
#define MyAppSetupSrcSQLServerDir MyAppSetupSrcDir + "\SQLServer"

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
#define MyAppDataDir "C:\FAO_Fish_Data"
#define MyAppSQLServerInstallDir "SQLServer"

;OTHER APPLICATION DEFINITIONS
#include IncludeFilesDir + "\PCBBuildNumberWithINIFile.iss"


;APPLICATION CONFIGURATION VARIABLES
#define MyAppSQLInstance "FAO_CAS"
#define MyAppDBName "FAOCASDemo"
#define MyAppDBFileName "FAOCAS_Demo"
#define MyAppSQLInstaller "setup.exe"
#define MyAppSQLInstallConfigFile "FAOCAS_SQLInstallConfig.ini"
#define MyAppSQLInstallBat "FAOCAS_SQLInstall.bat"
#define MyAppSAPWD "Test123"


[CustomMessages]


[InnoIDE_PostCompile]
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
Source: {#MyAppSetupSrcDir}\license.txt; DestDir: {code:GetPathData}; Flags: ignoreversion
Source: {#MyAppSetupSrcDir}\{#MyAppDBName}.ldf; DestDir: {tmp}; Flags: ignoreversion
Source: {#MyAppSetupSrcDir}\{#MyAppDBName}.mdf; DestDir: {tmp}; Flags: ignoreversion
Source: {#MyAppSetupSrcDir}\{#MyAppSQLInstallConfigFile}; DestDir: {tmp}; Flags: ignoreversion
Source: {#MyAppSetupSrcSQLServerDir}\*.*; DestDir: {tmp}\{#MyAppSQLServerInstallDir}; Flags: ignoreversion recursesubdirs


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
;filename: {code:GetMyAppConfigDir}\CAS_SQLServerConf.ini; section: Options; key: INSTANCENAME; string: {#MyAppSQLInstanceName}


[Code]
#include "PCB_ISUtils.isi"
#include "IS_SQLServerInstallFunctions.isi"
#include "PCBDataDirPage.isi"

[Code]

//FORWARD DECLARATIONS
procedure DoPostInstall(); forward;
procedure DoPreInstall(); forward;

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
  case CurStep of
    ssInstall:
      begin
        MsgBox('Starting the Pre-Install Process', mbInformation, MB_OK);
        DoPreInstall;
      end;
    ssPostInstall:
      begin
        MsgBox('Starting the Post-Install Process', mbInformation, MB_OK);
        SetFinishedInstall(True);
        DoPostInstall;
      end;
      
  end;
end;

//SEVERAL UTILITY FUNCTIONS AND PROCEDURES
procedure DoPreInstall();
(*
   Pre-Installation procedure. Runs before performing any action.
*)

var
  bolRequirements: boolean;
  
begin
  //Set the common global variables
  SetGlobalsCommon;
  
  //Check the requirements for the installation
  bolRequirements:= CheckRequirements;
  if not bolRequirements then
    begin
      MsgBox(MsgRequirementsMissing, mbInformation, MB_OK);
      Exit;
      
    end;
//Set the Global Variables, using the information from the Inno Setup Variables,
//and also the information entered by the user in the wizards
  SetGlobalsCommon;
  SetGlobalsDataDir;
  

end;

procedure DoPostInstall();
{Purpose:
	    Post-Installation procedure. Runs after performing all installation actions.
}
var
  strFileDB: String;
  strSQLDBName: String;
  
begin
  //Install the SQL Server 
  SetGlobalsSQLServer;
  SQLServerInstallComplete('');
  
  //Attach the Demo databases
  strSQLDBName:= GetSQLDBName('');
MsgBox('The name of the DB to create is ' + strSQLDBName, mbInformation, MB_OK);
  strFileDB:= GetSQLDBFileName('');
MsgBox('The name of the DB file to attach is ' + strSQLDBName, mbInformation, MB_OK);
  SQLServerAttachDBComplete(strFileDB, strSQLDBName);
  
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
        SQLServerExpress:= IsSQLExpressInstalled('');
      end;
    wpSelectProgramGroup:
      begin
//        MsgBox('NextButtonClick:' #13#13 'You selected: ''' + WizardGroupValue + '''.', mbInformation, MB_OK);
      end;
    wpReady:
      begin
//        MsgBox('NextButtonClick:' #13#13 'The normal installation will now start.', mbInformation, MB_OK);
      end;
  end;

  Result := True;
end;

#expr SaveToFile("debug.iss")
