;Setup script to install the FAO Catch Assessment Survey Application

;GENERAL APPLICATION DEFINITIONS
#define MyAppName "FAO Fisheries Catch Assessment Surveys Data Manager"
#define MyAppName1 "FAO Fisheries Catch Assessment Surveys Data Manager"
#define MyAppName2 "FAOFish CAS Config"
#define MyAppVersion "1.0"
#define MyAppPublisher "FAO"
#define MyAppURL "http://www.faomedfisis.org/"
;#define MyAppExeName1 "CASManager.exe"
;#define MyAppExeName2 "CASConfig.exe"
#define MyAppExeName1 "app_new.exe"
#define MyAppExeName2 "conf_app.exe"
#define MyAppExeNewName1 "CASManager.exe"
#define MyAppExeNewName2 "CASConfig.exe"
#define MyAppExeName3 "QtAssistant.exe"
#define MyAppProgGroup "FAOFishData"
#define MyAppDirName "FAO_FI\CAS"

;BASIC CONFIGURATION FOR THE INSTALLER AND THE SCRIPT
#define MyAppSetupSrcBaseDir "E:"
;#define MyAppSetupSrcBaseDir "P:\"
;#define MyAppSetupSrcBaseDir "C:\projects\setups\CASSetup"

;DIRS HOLDING FILES TO INCLUDE
#define IncludeFilesDir MyAppSetupSrcBaseDir + "\IncludeFiles"

;SOURCE DIRECTORIES
#define MyAppSetupSrcDir MyAppSetupSrcBaseDir + "\src"
#define MyAppSetupSrcDataDir MyAppSetupSrcDir + "\Data"
#define MyAppSetupSrcSQLServerDir MyAppSetupSrcDir + "\SQLServer"
#define MyAppSetupSrcQtDLLDir MyAppSetupSrcDir + "\QtDLLs"
#define MyAppSetupSrcOtherDLLDir MyAppSetupSrcDir + "\OtherDLLs"
#define MyAppSetupSrcOtherFilesDir MyAppSetupSrcDir + "\OtherFiles"
#define MyAppSetupSrcReportMakerDir MyAppSetupSrcDir + "\ReportBuilder"
#define MyAppSetupSrcReportSpecsDir MyAppSetupSrcDir + "\ReportSpecs"
#define MyAppSetupSrcSQlDriversDir MyAppSetupSrcDir + "\SQLdrivers"
#define MyAppSetupSrcConfigDir MyAppSetupSrcDir + "\Config"
#define MyAppSetupSrcHelpDir MyAppSetupSrcDir + "\HelpFiles"

;DEFINITIONS  FOR THE COMPILED SETUP
#define MyAppSetupOutputDir MyAppSetupSrcBaseDir + "\Output"
#define MyAppSetupFile "FAOCAS_Setup"
#define MyAppSetupIcon MyAppSetupSrcDir + "\FAOCASIcon.ico"

;DESTINATION DIRECTORIES
#define MyAppConfDir "Config"
#define MyAppDataDir "C:\FAO_Fish_Data"
#define MyAppSQLServerInstallDir "SQLServer"
#define MyAppReportMakerDir "Report"
#define MyAppReportsTemplatesDir "Reports"
#define MyAppSQLDriverDir "SqlDrivers"
#define MyAppHelpDir "Help"

;OTHER APPLICATION DEFINITIONS
#define MyAppLicenseFile MyAppSetupSrcDir + "\FAOCASLicense.txt"
#define MyAppReadMeFile MyAppSetupSrcDir + "\FAOCASReadme.txt"
#include IncludeFilesDir + "\PCBBuildNumberWithINIFile.isi"

;APPLICATION CONFIGURATION VARIABLES
#define MyAppSQLInstance "FAOCAS"
#define MyAppDBName "FAOCASDATA"
#define MyAppDBFileName "FAOCASDATA"
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
AppID={{4F9DE949-A8BA-4D84-8C30-F98557DB5788}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppDirName}
DisableDirPage=no
DefaultGroupName={#MyAppProgGroup}
AllowNoIcons=true
LicenseFile={#MyAppLicenseFile}
OutputDir={#MyAppSetupOutputDir}
OutputBaseFilename={#MyAppSetupFile}
SetupIconFile={#MyAppSetupIcon}
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
Source: {#MyAppSetupSrcDir}\{#MyAppExeName1}; DestDir: {app}; Flags: ignoreversion; DestName: {#MyAppExeNewName1}; 
Source: {#MyAppSetupSrcDir}\{#MyAppExeName2}; DestDir: {app}; Flags: ignoreversion; DestName: {#MyAppExeNewName2}; 
Source: {#MyAppSetupSrcDir}\{#MyAppExeName3}; DestDir: {app}; Flags: ignoreversion
Source: {#MyAppLicenseFile}; DestDir: {code:GetPathConf}; Flags: ignoreversion
Source: {#MyAppReadMeFile}; DestDir: {code:GetPathConf}; Flags: ignoreversion isreadme

;Custom Objects for Application
Source: {#MyAppSetupSrcOtherDLLDir}\CatchInputCtrl.dll; DestDir: {app}; Flags: ignoreversion
Source: {#MyAppSetupSrcOtherDLLDir}\customtimectrl.dll; DestDir: {app}; Flags: ignoreversion
Source: {#MyAppSetupSrcOtherDLLDir}\Report.dll; DestDir: {app}; Flags: ignoreversion

;Qt DLLs
Source: "{#MyAppSetupSrcQtDLLDir}\QtCore4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtGui4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtNetwork4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtScript4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtSql4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtTest4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtWebKit4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtXml4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtXmlPatterns4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtHelp4.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyAppSetupSrcQtDLLDir}\QtCLucene4.dll"; DestDir: "{app}"; Flags: ignoreversion

;Files for the Report Maker and Report Specifications
Source: "{#MyAppSetupSrcReportMakerDir}\*"; DestDir: "{app}\{#MyAppReportMakerDir}\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyAppSetupSrcReportSpecsDir}\*"; DestDir: "{app}\{#MyAppReportsTemplatesDir}\"; Flags: ignoreversion recursesubdirs createallsubdirs

;Files for the Help system
Source: "{#MyAppSetupSrcHelpDir}\*"; DestDir: "{app}\{#MyAppHelpDir}\"; Flags: ignoreversion recursesubdirs createallsubdirs

;SQL Driver files
Source: "{#MyAppSetupSrcSQlDriversDir}\*"; DestDir: "{app}\sqldrivers\"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; Files for SQL Server setup (to be written to temporary directory)
Source: {#MyAppSetupSrcDataDir}\{#MyAppDBFileName}.ldf; DestDir: {tmp}; Check: CheckDBAttachRequired(False); Flags: ignoreversion
Source: {#MyAppSetupSrcDataDir}\{#MyAppDBFileName}.mdf; DestDir: {tmp}; Check: CheckDBAttachRequired(False); Flags: ignoreversion
Source: {#MyAppSetupSrcConfigDir}\{#MyAppSQLInstallConfigFile}; DestDir: {tmp}; Check: CheckSQLServerInstanceInstallationRequired(False); Flags: ignoreversion
Source: {#MyAppSetupSrcSQLServerDir}\*; DestDir: {tmp}\{#MyAppSQLServerInstallDir}; Check: CheckSQLServerInstanceInstallationRequired(False); Flags: ignoreversion recursesubdirs

[Icons]
Name: {group}\{#MyAppName1}; Filename: {app}\{#MyAppExeNewName1}
Name: {group}\{#MyAppName2}; Filename: {app}\{#MyAppExeNewName2}
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppName}}; Filename: {#MyAppURL}
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}
Name: {commondesktop}\{#MyAppName1}; Filename: {app}\{#MyAppExeNewName1}; Tasks: desktopicon
Name: {commondesktop}\{#MyAppName2}; Filename: {app}\{#MyAppExeNewName2}; Tasks: desktopicon



[Run]

[INI]

[Code]
#include IncludeFilesDir + "\IS_Utils.isi"
#include IncludeFilesDir + "\IS_SQLServerInstallFunctions.isi"
#include IncludeFilesDir + "\IS_DataDirPage.isi"


//FORWARD DECLARATIONS
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
//  MsgBox('The ID of the DataDir Page is ' + intToStr(wpDataDir), mbInformation, MB_OK);
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
  SetGlobalsInitial; //Set the initial values of the Global variables for the installation
  SetGlobalsSQLServerStart; //Set the global variables related to SQL Server installation
  SetGlobalsCheckDBInstallation; //Set the global variables informing the status of the different components of the Database system
  CheckDBInstallationRequired(True); //Set the global variables on the need to install the different components of the Database system
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
//        MsgBox('Starting the Pre-Install Process', mbInformation, MB_OK);
        DoPreInstall;
      end;
    ssPostInstall:
      begin
//        MsgBox('Starting the Post-Install Process', mbInformation, MB_OK);
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
//Set the Global Variables, using the information from the Inno Setup Variables,
//and also the information entered by the user in the wizards
  SetGlobalsDataDir;
  SetGlobalsSQLServerStart;
  SetGlobalsCommon;

  //Check the requirements for the installation
  bolRequirements:= CheckRequirements;
  if not bolRequirements then
    begin
//      MsgBox(MsgRequirementsMissing, mbInformation, MB_OK);
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
  //SetGlobalsSQLServer;
  
  //Install the SQL Server Instance, if required
  if GetSQLServerInstallationRequired('') then
    begin
      SQLServerInstallComplete('');
    end;
    
  if getAttachDbRequired('') then
    begin
      //Attach the databases
      strSQLDBName:= GetSQLDBName('');
//      MsgBox('The name of the DB to create is ' + strSQLDBName, mbInformation, MB_OK);
      strFileDB:= GetSQLDBFileName('');
//      MsgBox('The name of the DB file to attach is ' + strSQLDBName, mbInformation, MB_OK);
      SQLServerAttachDBComplete(strFileDB, strSQLDBName);
    end;
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
  bolMoveNext: Boolean;
  PageDir: TInputDirWizardPage;
  
begin//OK
  bolMoveNext:= True;
  Log('NextButtonClick(' + IntToStr(CurPageID) + ') called');
  if CurPageID = wpSelectDir then
    begin//OK
    Log('Leaving page for Selection of installation directory');
    //SQLServerExpress:= IsSQLExpressInstalled('');
    end//OK
  else
    begin//OK
      if CurPageID = wpSelectProgramGroup then
        begin//OK
          Log('Leaving page for Selection of the program group');
//        MsgBox('NextButtonClick:' #13#13 'You selected: ''' + WizardGroupValue + '''.', mbInformation, MB_OK);
          bolMoveNext:= True;
        end //OK
      else
        begin
          if CurPageID = wpReady then
            begin//OK
              Log('Leaving page of Ready to Start Installation');
//             MsgBox('NextButtonClick:' #13#13 'The normal installation will now start.', mbInformation, MB_OK);
              bolMoveNext:= True;
            end//OK
          else
            begin//OK
              if CurPageID = wpDataDir then
                begin//OK
                  Log('Leaving page for Selection of Data directory');
                  PageDir:= TInputDirWizardPage(PageFromID(wpDataDir));
                  SetPathData(PageDir.Values[0]);
//                  MsgBox('Just selected the data directory ' + PageDir.Values[0], mbInformation, MB_OK);
//                  MsgBox('The info in the global variables is ' + GetPathData(''), mbInformation, MB_OK);
                  Log('Data for application is '+ PageDir.Values[0]);
                  bolMoveNext:= True;
                end; //OK
            end;//OK       
        end;//OK
    end;//OK
result:= bolMoveNext;
end;//OK

