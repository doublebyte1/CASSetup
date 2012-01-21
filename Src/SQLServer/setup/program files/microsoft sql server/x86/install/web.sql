-- ********************************************************************
-- WEB.SQL 
--
-- Creates mswebtasks table and the following stored procedures
-- sp_insmswebtask
-- sp_updmswebtask
--
-- Copyright Microsoft, Inc. 1996 - 2000.                              
-- All Rights Reserved.                                               
--                                                                    
-- ********************************************************************

USE msdb
go

-- Add mswebtasks table if not there
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = N'mswebtasks')
BEGIN
   CREATE TABLE mswebtasks 
	(
	procname	nvarchar(128)	NOT NULL,	-- Name of the procedure
	outputfile	nvarchar(255)	NOT NULL,	-- Physical name of output file
	taskstat	bit				NOT NULL,	-- TRUE if task scheduled, FALSE if not
	wparams		image			NULL,		-- xp_runwebtask parameters
	trigflags	smallint		NULL,		-- trigger status flags
	taskid		int				NULL		-- task id returned by sp_addtask
    )
	Exec sp_MS_marksystemobject mswebtasks
END
go

IF NOT EXISTS (SELECT * FROM sysindexes WHERE name = N'web_idxproc'
       AND id = object_id(N'mswebtasks'))
BEGIN
    CREATE UNIQUE INDEX web_idxproc ON mswebtasks(procname)
END
go

-- Add sp_insmswebtask if not there
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'dbo.sp_insmswebtask') AND type = 'P')
   DROP PROCEDURE dbo.sp_insmswebtask
go

CREATE PROCEDURE sp_insmswebtask
-- This procedure is for internal use by Web Assistant
    @procname		nvarchar(128),
    @outputfile		nvarchar(255),
    @taskstat		bit,
    @wparams		image,
    @trigflags		smallint,
    @taskid			int
AS
  	-- Make sure that it's the SA executing this.
    IF ( NOT ( is_srvrolemember('sysadmin') = 1 ) )
    BEGIN
       RAISERROR( 15003, -1, -1, 'sysadmin' )
       RETURN(1)	
    END

    INSERT INTO  dbo.mswebtasks(procname, outputfile, taskstat, wparams, trigflags, taskid)
	    VALUES(@procname, @outputfile, @taskstat, @wparams, @trigflags, @taskid)
go
Exec sp_MS_marksystemobject sp_insmswebtask
go

-- Add sp_updmswebtask if not there
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'dbo.sp_updmswebtask') AND type = 'P')
   DROP PROCEDURE dbo.sp_updmswebtask
go

CREATE PROCEDURE sp_updmswebtask
-- This procedure is for internal use by Web Assistant
    @procname		nvarchar(128),
    @wparams		image
AS
  	-- Make sure that it's the SA executing this.
    IF ( NOT ( is_srvrolemember('sysadmin') = 1 ) )
    BEGIN
       RAISERROR( 15003, -1, -1, 'sysadmin' )
       RETURN(1)	
    END

    UPDATE dbo.mswebtasks
	SET wparams = @wparams
	WHERE procname = @procname

go
Exec sp_MS_marksystemobject sp_updmswebtask
go

-- Grant privileges on mswebtasks
GRANT SELECT ON mswebtasks TO PUBLIC
go

