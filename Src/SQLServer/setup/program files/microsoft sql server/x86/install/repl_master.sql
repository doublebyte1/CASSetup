-- ***************************************************************************
-- Copyright (c) 1997 - 2003 Microsoft Corporation.
-- All Rights Reserved
--
-- @File: repl_master.tpt
--
-- Purpose:
--  Procedures/XPs/functions that are owned by replication and are created on master database
--  
-- Notes: Created 2001/02/07 10:28 (RMak)
--
-- History:
--
--     @Version: Yukon
--
-- @EndHeader@
--
exec sys.sp_configure 'update',1
reconfigure with override

set ANSI_NULLS off

use master
go

-- Make sure that we remove procedures that got accidentally installed in 
-- master by an 80 sp2 QFE
if object_id('dbo.sp_MSreplremoveuncdir', 'P') > 0
    drop procedure dbo.sp_MSreplremoveuncdir

if object_id('dbo.sp_MSdeletefoldercontents', 'P') > 0
    drop procedure dbo.sp_MSdeletefoldercontents

-- drop extended procedures that were created in master

if object_id('xp_mergexpusage', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_mergexpusage'

if object_id('xp_mergelineages', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_mergelineages'

if object_id('xp_mapdown_bitmap', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_mapdown_bitmap'

if object_id('xp_ORbitmap', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_ORbitmap'

if object_id('xp_firstonly_bitmap', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_firstonly_bitmap'

if object_id('xp_varbintohexstr', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_varbintohexstr'

if object_id('xp_intersectbitmaps', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_intersectbitmaps'

if object_id('xp_displayparamstmt', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_displayparamstmt'

if object_id('xp_printstatements', 'local') is not null
    execute sys.sp_dropextendedproc 'xp_printstatements'

if object_id('xp_makecab', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_makecab'

if object_id('xp_unpackcab', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_unpackcab'

if object_id('sp_repldone', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_repldone'

if object_id('sp_repltrans', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_repltrans'

if object_id('sp_replcounters', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replcounters'

if object_id('sp_replhelp', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replhelp'

if object_id('sp_replddlparser', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replddlparser'

if object_id('sp_replcmds', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replcmds'

if object_id('sp_replflush', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replflush'

if object_id('sp_replpostcmd', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replpostcmd'

if object_id('sp_replincrementlsn_internal', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replincrementlsn_internal'

if object_id('sp_replupdateschema', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replupdateschema'

if object_id('sp_replsetoriginator_internal', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replsetoriginator_internal'

if object_id('sp_replsetsyncstatus', 'local') is not null
    exec sys.sp_dropextendedproc 'sp_replsetsyncstatus'

if object_id('sp_replpostsyncstatus_int', 'local') is not null
        exec sys.sp_dropextendedproc 'sp_replpostsyncstatus_int'

if object_id('xp_dsninfo', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_dsninfo'

if object_id('xp_enumdsn', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_enumdsn'

if object_id('xp_oledbinfo', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_oledbinfo'

if object_id('xp_repl_encrypt', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_repl_encrypt'

if object_id('xp_repl_convert_encrypt', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_repl_convert_encrypt'

if object_id('xp_repl_help_connect', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_repl_help_connect'

if object_id('xp_replproberemsrv', 'local') is not null
    exec sys.sp_dropextendedproc 'xp_replproberemsrv'

go

--
-- Create table dbo.MSreplication_options in master if needed
--
if object_id(N'dbo.MSreplication_options', 'local') is null
BEGIN
    -- table does not exist
    raiserror('Creating table MSreplication_options',0,1)

    CREATE TABLE dbo.MSreplication_options 
    (
        optname sysname NOT NULL,
        value bit NOT NULL,
        major_version int NOT NULL,
        minor_version int NOT NULL,
        revision int NOT NULL,
        install_failures int NOT NULL
    )

    exec dbo.sp_MS_marksystemobject N'dbo.MSreplication_options'
END
ELSE
BEGIN
    -- table exists 
    -- drop index if needed (this index was used in Sphinx)
    if exists (select * from sys.indexes where object_id = object_id(N'dbo.MSreplication_options')
                        and name = N'ucMSreplication_options')
    begin
        drop index dbo.MSreplication_options.ucMSreplication_options
    end
END
GO

IF NOT EXISTS (SELECT * FROM MSreplication_options WHERE optname = 'transactional')
	INSERT INTO MSreplication_options VALUES
		('transactional',0,0,0,0,0)
IF NOT EXISTS (SELECT * FROM MSreplication_options WHERE optname = 'merge')
	INSERT INTO MSreplication_options VALUES
		('merge',0,0,0,0,0)
IF NOT EXISTS (SELECT * FROM MSreplication_options WHERE optname = 'security_model')
BEGIN
	DECLARE @major_version 	int,
			@minor_version 	int,
			@revision		int

	-- @@microsoftversion is set as 0xMMmmRR[RR] wher M=Major, m=minor and R=revision
	--	SELECT @major_version 	= CONVERT(int, SUBSTRING(CONVERT(varbinary(4), @@microsoftversion), 1, 1)), 
	--		@minor_version 	= CONVERT(int, SUBSTRING(CONVERT(varbinary(4), @@microsoftversion), 2, 1)),
	--		@revision		= CONVERT(int, SUBSTRING(CONVERT(varbinary(4), @@microsoftversion), 3, 2))
	SELECT @major_version 	= 90,
			@minor_version 	= 0,
			@revision		= 0
	
	INSERT INTO MSreplication_options (optname, value, major_version, minor_version, revision, install_failures) 
		VALUES ('security_model', 1, @major_version, @minor_version, @revision, 0)
END

UPDATE MSreplication_options
	SET major_version = 90
GO

-- Startup procs have to be created in master
if object_id('sp_MSrepl_startup', 'local') is not null
    drop procedure sp_MSrepl_startup  

raiserror('Creating procedure sp_MSrepl_startup', 0,1)
go

create procedure dbo.sp_MSrepl_startup
as
    exec sys.sp_MSrepl_startup_internal
go

exec master.dbo.sp_MS_marksystemobject sp_MSrepl_startup

-- If a distributor is installed, mark the sp as a startup sp. 
if exists (select * FROM master..sysservers WHERE  srvstatus & 8 <> 0)
    exec dbo.sp_procoption 'sp_MSrepl_startup', 'startup', 'true' 
go

if object_id('sp_MScleanupmergepublisher', 'local') is not null
    drop procedure sp_MScleanupmergepublisher
go

SET ANSI_NULLS ON
SET ANSI_WARNINGS ON

raiserror('Creating procedure sp_MScleanupmergepublisher', 0,1)
go
create procedure dbo.sp_MScleanupmergepublisher
as
    exec sys.sp_MScleanupmergepublisher_internal
go

-- If there are any merge published databases installed on this server, 
-- mark sp_MScleanupmergepublisher as a startup proc

if exists (select * from master..sysdatabases where (category & 4) <> 0)
    exec dbo.sp_procoption 'sp_MScleanupmergepublisher', 'startup', 'true'

--
-- Functions that used to be created in master and have now moved to resource
-- use exec to drop, otherwise "drop function" gives syntax error on SQL 7, which did not have UDFs yet
--

if object_id('fn_varbintohexstr', 'local') is not null
     exec('drop function dbo.fn_varbintohexstr')

if object_id('fn_varbintohexsubstring', 'local') is not null
     exec('drop function dbo.fn_varbintohexsubstring')

go

--
-- procedures that used to be created in master and are obsolete now
-- drop the local procedures in master
--
if object_id(N'dbo.sp_addpublisher', 'local') is not null
    drop procedure dbo.sp_addpublisher

if object_id(N'dbo.sp_fetchshowcmdsinput', 'local') is not null
    drop procedure dbo.sp_fetchshowcmdsinput

if object_id(N'dbo.sp_getagentoffloadinfo', 'local') is not null
    drop procedure dbo.sp_getagentoffloadinfo

if object_id(N'dbo.sp_gettypestring', 'local') is not null
    drop procedure dbo.sp_gettypestring

if object_id(N'dbo.sp_helpmergecleanupwait', 'local') is not null
    drop procedure dbo.sp_helpmergecleanupwait

if object_id(N'dbo.sp_helpsubscriptionjobname', 'local') is not null
    drop procedure dbo.sp_helpsubscriptionjobname

if object_id(N'dbo.sp_mergecompletecleanup', 'local') is not null
    drop procedure dbo.sp_mergecompletecleanup

if object_id(N'dbo.sp_mergepreparecleanup', 'local') is not null
    drop procedure dbo.sp_mergepreparecleanup

if object_id(N'dbo.sp_MSaddpubtocontents', 'local') is not null
    drop procedure dbo.sp_MSaddpubtocontents

if object_id(N'dbo.sp_MSareallcolumnscomputed', 'local') is not null
    drop procedure dbo.sp_MSareallcolumnscomputed

if object_id(N'dbo.sp_MSchunkgeneration', 'local') is not null
    drop procedure dbo.sp_MSchunkgeneration

if object_id(N'dbo.sp_MScleanup_metadata', 'local') is not null
    drop procedure dbo.sp_MScleanup_metadata

if object_id(N'dbo.sp_MScleanuptask', 'local') is not null
    drop procedure dbo.sp_MScleanuptask

if object_id(N'dbo.sp_MScompletecleanup', 'local') is not null
    drop procedure dbo.sp_MScompletecleanup

if object_id(N'dbo.sp_MScomputearticlescreationorder', 'local') is not null
    drop procedure dbo.sp_MScomputearticlescreationorder

if object_id(N'dbo.sp_MScomputeunresolvedrefs', 'local') is not null
    drop procedure dbo.sp_MScomputeunresolvedrefs

if object_id(N'dbo.sp_MSdelete_specifiedcontents', 'local') is not null
    drop procedure dbo.sp_MSdelete_specifiedcontents

if object_id(N'dbo.sp_MSdeletecontents', 'local') is not null
    drop procedure dbo.sp_MSdeletecontents

if object_id(N'dbo.sp_MSdeletepushagent', 'local') is not null
    drop procedure dbo.sp_MSdeletepushagent

if object_id(N'dbo.sp_MSenumchanges_direct', 'local') is not null
    drop procedure dbo.sp_MSenumchanges_direct

if object_id(N'dbo.sp_MSenumchanges_pal', 'local') is not null
    drop procedure dbo.sp_MSenumchanges_pal

if object_id(N'dbo.sp_MSenumpartialchanges_direct', 'local') is not null
    drop procedure dbo.sp_MSenumpartialchanges_direct

if object_id(N'dbo.sp_MSenumpartialchanges_pal', 'local') is not null
    drop procedure dbo.sp_MSenumpartialchanges_pal

if object_id(N'dbo.sp_MSexternalfkreferences', 'local') is not null
    drop procedure dbo.sp_MSexternalfkreferences

if object_id(N'dbo.sp_MSget_subtypedatasrc', 'local') is not null
    drop procedure dbo.sp_MSget_subtypedatasrc

if object_id(N'dbo.sp_MSgettypestringudt', 'local') is not null
    drop procedure dbo.sp_MSgettypestringudt

if object_id(N'dbo.sp_MShelpsubscriptionjobname', 'local') is not null
    drop procedure dbo.sp_MShelpsubscriptionjobname

if object_id(N'dbo.sp_MSinsertcontents', 'local') is not null
    drop procedure dbo.sp_MSinsertcontents

if object_id(N'dbo.sp_MSis_col_replicated', 'local') is not null
    drop procedure dbo.sp_MSis_col_replicated

if object_id(N'dbo.sp_MSload_replication_status', 'local') is not null
    drop procedure dbo.sp_MSload_replication_status

if object_id(N'dbo.sp_MSmakedynsnapshotvws_longdef', 'local') is not null
    drop procedure dbo.sp_MSmakedynsnapshotvws_longdef

if object_id(N'dbo.sp_MSpreparecleanup', 'local') is not null
    drop procedure dbo.sp_MSpreparecleanup

if object_id(N'dbo.sp_MSquiescecheck', 'local') is not null
    drop procedure dbo.sp_MSquiescecheck

if object_id(N'dbo.sp_MSquiesceforcleanup', 'local') is not null
    drop procedure dbo.sp_MSquiesceforcleanup

if object_id(N'dbo.sp_MSquiescetriggersoff', 'local') is not null
    drop procedure dbo.sp_MSquiescetriggersoff

if object_id(N'dbo.sp_MSquiescetriggerson', 'local') is not null
    drop procedure dbo.sp_MSquiescetriggerson

if object_id(N'dbo.sp_MSreplcheck_connection', 'local') is not null
    drop procedure dbo.sp_MSreplcheck_connection

if object_id(N'dbo.sp_MSscript_security', 'local') is not null
    drop procedure dbo.sp_MSscript_security

if object_id(N'dbo.sp_MSscript_validate_subscription', 'local') is not null
    drop procedure dbo.sp_MSscript_validate_subscription

if object_id(N'dbo.sp_MSscriptmvastable', 'local') is not null
    drop procedure dbo.sp_MSscriptmvastable

if object_id(N'dbo.sp_MSscriptmvastableidx', 'local') is not null
    drop procedure dbo.sp_MSscriptmvastableidx

if object_id(N'dbo.sp_MSscriptmvastablenci', 'local') is not null
    drop procedure dbo.sp_MSscriptmvastablenci

if object_id(N'dbo.sp_MSscriptmvastablepkc', 'local') is not null
    drop procedure dbo.sp_MSscriptmvastablepkc

if object_id(N'dbo.sp_MSsubst_filter_name', 'local') is not null
    drop procedure dbo.sp_MSsubst_filter_name

if object_id(N'dbo.sp_MSupdate_replication_status', 'local') is not null
    drop procedure dbo.sp_MSupdate_replication_status

if object_id(N'dbo.sp_MSupdatecontents', 'local') is not null
    drop procedure dbo.sp_MSupdatecontents

if object_id(N'dbo.sp_replicationoption', 'local') is not null
    drop procedure dbo.sp_replicationoption

if object_id(N'dbo.sp_replproberemoteserver', 'local') is not null
    drop procedure dbo.sp_replproberemoteserver

if object_id(N'dbo.sp_replsetoriginator_pal', 'local') is not null
    drop procedure dbo.sp_replsetoriginator_pal

if object_id(N'dbo.sp_verify_publication', 'local') is not null
    drop procedure dbo.sp_verify_publication

if object_id(N'dbo.sp_MSarticletextcol', 'local') is not null
    drop procedure dbo.sp_MSarticletextcol

if object_id(N'dbo.sp_MSexists_file', 'local') is not null
    drop procedure dbo.sp_MSexists_file

if object_id(N'dbo.sp_MSfixlineagemismatch', 'local') is not null
    drop procedure dbo.sp_MSfixlineagemismatch

if object_id(N'dbo.sp_MStextcolstatus', 'local') is not null
    drop procedure dbo.sp_MStextcolstatus

if object_id(N'dbo.sp_MSread_resolver_clsid', 'local') is not null
    drop procedure dbo.sp_MSread_resolver_clsid

if object_id(N'dbo.sp_MSsubscriptions', 'local') is not null
    drop procedure dbo.sp_MSsubscriptions

go

