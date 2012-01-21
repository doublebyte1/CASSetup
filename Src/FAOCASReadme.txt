/////////////// IMPORTANT: READ THIS BEFORE RUNNING THE APPLICATION! //////
/// 1 - Introduction
//  2 - Installation
//  3 - Uninstallation
//  4 - Configuration Steps
//  5 - Quick Start
///////////////////////////////////////////////////////////////////////
1 - Introduction /////////////////////////////////////////////////////
Medfisis 2.0.0. alpha is a very early product and it has not been tested thoroughly, so expect some problems, also in the setup.
This setup was tested on a non development machine, running Windows XP 32 bits.
If you are impatient, just go to section 5 - "Quick Start".

2 - Installation /////////////////////////////////////////////////////
Medfisis package contains a database in MS SQL Server, and therefore the SQL engine (and native client) is also shipped with this application.
The database files (and also a setup temporary file that stores the definition of SQL server) are stored in a *fixed* path!

c:\medfisis_dat

Please do not remove this directory!

Medfisis folder contains all the dynamic libraries from Qt, and two other shared libraries that were developed on purpose for this application:
CatchInputCtrl and TimeInputCtrl. The folder "report", contains the exaro libraries, and its plugins;
The folder "repors" is the folder that the application scans wlooking for reports; you should put your reports here, if you want them to be find by
Medfisis automatically (but you can also browse to them, if they are in a different location!)

3 - Uninstallation /////////////////////////////////////////////////////
Medfisis uninstall *does NOT* SQL Server 2005 from your system (neither it deattaches the database), and therefore you can choose to do it (or not)
yourself, when you remove Medfisis.

4 - Configuration Steps /////////////////////////////////////////////////////
After completing the installation (process explained on the INSTALL), you have to attach the database file (mdf) to the SQL server instance;
for this effect, you can run the script post_install.bat, stored in the application directory (it also removes a temporary file used by the setup)

Because we use the ODBC drivers to connect to SQL server, you need to add an OBDC data source to the system in order to run Medfisis;
For that, you need to go to "Windows Control Panel" -> "Administrative Tools" (according to your flavour of windows")->
"Data Sources (ODBC)";

The steps to create an ODBC Data Source Name (DSN), for SQL Server, are described here:

http://www.truthsolutions.com/sql/odbc/creating_a_new_odbc_dsn.htm

Don't forget to call it a suggestive name (for instance "sql_server")

After successfully following the previous steps, you are ready run the Medfisis App;
The first time you run it, in the login dialog, in the combo box there are no connections listed, but instead, there is an option that says "Create new connection..."
You have to choose it, in order to initialize the connection;

On the connection dialog, you can define the connection string for the application;
This is a brief explanation of the values:

Host: the SQL instance that we just installed; the value filled by the setup is .\SQLEXPRESS
Data_Source: the DSN we created through the "Control Panel"; for instance "sql_server"
username: the setup created automatically an administrator user, that we can use : sa
password: the setup created automatically the following password "test123"
Alias: a "friendly" name to remember this connection;
Driver: QODBC and QODBC3 can both be used to connect to SQL Server;

The application should store this values on the registry, so if we want, we don't need to fill them next time!
The permission system for the application is not yeat implemented, and therefore there is a unique username and password to login
(on the first dialog!)

username: dev
password: test123

5 - Quick Start /////////////////////////////////////////////////////

- Go to the installation directory and run "post_install.bat"
- add a Data source for SQL server, using the "Windows Control Panel" -> "Administrative Tools" (according to your flavour of windows")->
"Data Sources (ODBC)";
Then follow the instructions here (call it "sql_server"):

http://www.truthsolutions.com/sql/odbc/creating_a_new_odbc_dsn.htm

- Run app_new.exe on the install directory; The first time, go to the combo box on the bottom and choose
"Create new connection"
fill the boxes with these values:

Host: .\SQLEXPRESS
Data_Source: sql_server
username: sa
password: test123
Alias: albania
Driver: QODBC or QODBC3

Now you can login into the application, with the following values:

username: dev
password: test123

The next time you log in, the connection string should be stored and you can point to it through the "friendly" name on the combo box: "albania!

Thanks for reading this and enjoy using Medfisis!











