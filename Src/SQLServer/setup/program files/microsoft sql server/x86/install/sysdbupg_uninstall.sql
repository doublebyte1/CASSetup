/*------------------------------------------------------------------------------

SYSDBUPG_UNINSTALL.SQL

This script reverts changes to system database stored procs previously applied
by the SYSDBUPG.SQL script.  It is currently only used in hotfix uninstalls
and needs to be cleared out each time a new QFE tree is forked following a SP.
It is used only for system databases which are upgraded in post-RTM servicing.

Databases which may be updated by this script:
	master
	model
	msdb

Databases not updated by this script:
	mssqlsystemresource
	distmdl
	adventureworks
	adventureworksdw
	user databases

Any changes to the following scripts are made here instead:
	U_TABLES.SQL
	PROCSYST.SQL
	XPSTAR.SQL
	INSTMSDB.SQL
	REPL_MASTER.SQL

Note:
  This script does not apply any sysmessages changes.
  Such changes are delivered via an updated SQLEVN70.RLL instead.


** Copyright (c) Microsoft Corporation.  All rights reserved.

------------------------------------------------------------------------------*/


--------------------------------------------------------------------------------
--	U_TABLES.SQL
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--	PROCSYST.SQL
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--	XPSTAR.SQL
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--	INSTMSDB.SQL
--------------------------------------------------------------------------------

use msdb
go
/**************************************************************/
/* drop certificate signature from Agent signed sps           */
/**************************************************************/
BEGIN TRANSACTION
declare @sp sysname
declare @exec_str nvarchar(1024)
declare ms_crs_sps cursor global for select object_name(crypts.major_id) 
   from sys.crypt_properties crypts, sys.certificates certs
   where crypts.thumbprint = certs.thumbprint
   and crypts.class = 1
   and certs.name = '##MS_AgentSigningCertificate##'
open ms_crs_sps
fetch next from ms_crs_sps into @sp
while @@fetch_status = 0
begin
   if exists(select * from sys.objects where name = @sp)
   begin
      print 'Dropping signature from: ' + @sp
      set @exec_str = N'drop signature from ' + quotename(@sp) + N' by certificate [##MS_AgentSigningCertificate##]'
      Execute(@exec_str)
      if (@@error <> 0)
      begin
         declare @err_str nvarchar(1024)
         set @err_str = 'Cannot drop signature from ' + quotename(@sp) + '. Terminating.'
         RAISERROR(@err_str, 20, 127) WITH LOG
         ROLLBACK TRANSACTION
         return
      end
   end
   fetch next from ms_crs_sps into @sp
end
close ms_crs_sps
deallocate ms_crs_sps
COMMIT TRANSACTION
GO

use msdb
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[sp_RunMailQuery]
   @query                    NVARCHAR(max),
   @attach_results             BIT,
    @query_attachment_filename  NVARCHAR(260) = NULL,
   @no_output                  BIT,
   @query_result_header        BIT,
   @separator                  VARCHAR(1),
   @echo_error                 BIT,
   @dbuse                      sysname,
   @width                   INT,
    @temp_table_uid             uniqueidentifier,
   @query_no_truncate          BIT
AS
BEGIN
    SET NOCOUNT ON
    SET QUOTED_IDENTIFIER ON

    DECLARE @rc             INT,
            @prohibitedExts NVARCHAR(1000),
            @fileSizeStr    NVARCHAR(256),
            @fileSize       INT,
            @attach_res_int INT,
            @no_output_int  INT,
            @no_header_int  INT,
            @echo_error_int INT,
         @query_no_truncate_int INT,
            @mailDbName     sysname,
            @uid            uniqueidentifier,
            @uidStr         VARCHAR(36)

    --
    --Get config settings and verify parameters
    --
    SET @query_attachment_filename = LTRIM(RTRIM(@query_attachment_filename))

    --Get the maximum file size allowed for attachments from sysmailconfig.
    EXEC msdb.dbo.sysmail_help_configure_value_sp @parameter_name = N'MaxFileSize', 
                                                @parameter_value = @fileSizeStr OUTPUT
    --ConvertToInt will return the default if @fileSizeStr is null
    SET @fileSize = dbo.ConvertToInt(@fileSizeStr, 0x7fffffff, 100000)

    IF (@attach_results = 1)
    BEGIN
        --Need this if attaching the query
        EXEC msdb.dbo.sysmail_help_configure_value_sp @parameter_name = N'ProhibitedExtensions', 
                                                    @parameter_value = @prohibitedExts OUTPUT

        -- If attaching query results to a file and a filename isn't given create one
        IF ((@query_attachment_filename IS NOT NULL) AND (LEN(@query_attachment_filename) > 0))
        BEGIN 
          EXEC @rc = sp_isprohibited @query_attachment_filename, @prohibitedExts
          IF (@rc <> 0)
          BEGIN
              RAISERROR(14630, 16, 1, @query_attachment_filename, @prohibitedExts)
              RETURN 2
          END
        END
        ELSE
        BEGIN
            --If queryfilename is not specified, generate a random name (doesn't have to be unique)
           SET @query_attachment_filename = 'QueryResults' + CONVERT(varchar, ROUND(RAND() * 1000000, 0)) + '.txt'
        END
    END

    --Init variables used in the query execution
    SET @mailDbName = db_name()
    SET @uidStr = convert(varchar(36), @temp_table_uid)

    SET @attach_res_int        = CONVERT(int, @attach_results)
    SET @no_output_int         = CONVERT(int, @no_output)
    IF(@query_result_header = 0) SET @no_header_int  = 1 ELSE SET @no_header_int  = 0
    SET @echo_error_int        = CONVERT(int, @echo_error)
    SET @query_no_truncate_int = CONVERT(int, @query_no_truncate)

    EXEC @rc = master..xp_sysmail_format_query  
                @query        = @query,
                @message      = @mailDbName,
                    @subject     = @uidStr,
                    @dbuse       = @dbuse, 
                    @attachments = @query_attachment_filename,
                    @attach_results = @attach_res_int,
                    -- format params
                    @separator      = @separator,
                    @no_header      = @no_header_int,
                    @no_output      = @no_output_int,
                    @echo_error     = @echo_error_int,
                @max_attachment_size = @fileSize,
                    @width       = @width, 
                    @query_no_truncate = @query_no_truncate_int
   RETURN @rc
END
GO

use msdb
GO
DROP PROCEDURE [dbo].[sp_send_dbmail]
GO
/****** Object:  StoredProcedure [dbo].[sp_send_dbmail]    Script Date: 06/06/2006 12:24:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- sp_sendemail : Sends a mail from Yukon outbox.
--
CREATE PROCEDURE [dbo].[sp_send_dbmail]
   @profile_name               sysname    = NULL,        
   @recipients                 VARCHAR(MAX)  = NULL, 
   @copy_recipients            VARCHAR(MAX)  = NULL,
   @blind_copy_recipients      VARCHAR(MAX)  = NULL,
   @subject                    NVARCHAR(255) = NULL,
   @body                       NVARCHAR(MAX) = NULL, 
   @body_format                VARCHAR(20)      = NULL, 
   @importance                 VARCHAR(6)    = 'NORMAL',
   @sensitivity                VARCHAR(12)      = 'NORMAL',
   @file_attachments           NVARCHAR(MAX) = NULL,  
   @query                      NVARCHAR(MAX) = NULL,
   @execute_query_database     sysname    = NULL,  
   @attach_query_result_as_file BIT    = 0,
        @query_attachment_filename  NVARCHAR(260)  = NULL,  
        @query_result_header        BIT         = 1,
   @query_result_width         INT        = 256,            
   @query_result_separator     CHAR(1)    = ' ',
   @exclude_query_output       BIT        = 0,
   @append_query_error         BIT        = 0,
   @query_no_truncate          BIT        = 0,
   @mailitem_id               INT         = NULL OUTPUT
  WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON

    -- And make sure ARITHABORT is on. This is the default for yukon DB's
    SET ARITHABORT ON

    --Declare variables used by the procedure internally
    DECLARE @profile_id         INT,
            @temp_table_uid     uniqueidentifier,
            @sendmailxml        VARCHAR(max),
            @CR_str             NVARCHAR(2),
            @localmessage       NVARCHAR(255),
            @QueryResultsExist  INT,
            @AttachmentsExist   INT,
            @RetErrorMsg        NVARCHAR(4000), --Impose a limit on the error message length to avoid memory abuse 
            @rc                 INT,
            @procName           sysname,
       @trancountSave      INT,
       @tranStartedBool    INT,
            @is_sysadmin        BIT,
            @send_request_user  sysname,
            @database_user_id   INT

    -- Initialize 
    SELECT  @rc                 = 0,
            @QueryResultsExist  = 0,
            @AttachmentsExist   = 0,
            @temp_table_uid     = NEWID(),
            @procName           = OBJECT_NAME(@@PROCID),
            @tranStartedBool  = 0,
       @trancountSave      = @@TRANCOUNT

    EXECUTE AS CALLER
       SELECT @is_sysadmin       = IS_SRVROLEMEMBER('sysadmin'),
              @send_request_user = SUSER_SNAME(),
              @database_user_id  = USER_ID()
    REVERT

    --Check if SSB is enabled in this database
    IF (ISNULL(DATABASEPROPERTYEX(DB_NAME(), N'IsBrokerEnabled'), 0) <> 1)
    BEGIN
       RAISERROR(14650, 16, 1)
       RETURN 1
    END

    --Report error if the mail queue has been stopped. 
    --sysmail_stop_sp/sysmail_start_sp changes the receive status of the SSB queue
    IF NOT EXISTS (SELECT * FROM sys.service_queues WHERE name = N'ExternalMailQueue' AND is_receive_enabled = 1)
    BEGIN
       RAISERROR(14641, 16, 1)
       RETURN 1
    END

    -- Get the relevant profile_id 
    --
    IF (@profile_name IS NULL)
    BEGIN
        -- Use the global or users default if profile name is not supplied
        SELECT TOP (1) @profile_id = pp.profile_id
        FROM msdb.dbo.sysmail_principalprofile as pp
        WHERE (pp.is_default = 1) AND
            (dbo.get_principal_id(pp.principal_sid) = @database_user_id OR pp.principal_sid = 0x00)
        ORDER BY dbo.get_principal_id(pp.principal_sid) DESC

        --Was a profile found
        IF(@profile_id IS NULL)
        BEGIN
           RAISERROR(14636, 16, 1)
           RETURN 1
        END
    END
    ELSE
    BEGIN
        --Get primary account if profile name is supplied
        EXEC @rc = msdb.dbo.sysmail_verify_profile_sp @profile_id = NULL, 
                         @profile_name = @profile_name, 
                         @allow_both_nulls = 0, 
                         @allow_id_name_mismatch = 0,
                         @profileid = @profile_id OUTPUT
        IF (@rc <> 0)
            RETURN @rc

        --Make sure this user has access to the specified profile.
        --sysadmins can send on any profiles
        IF ( @is_sysadmin <> 1)
        BEGIN
            --Not a sysadmin so check users access to profile
            iF NOT EXISTS(SELECT * 
                        FROM msdb.dbo.sysmail_principalprofile 
                        WHERE ((profile_id = @profile_id) AND
                                (dbo.get_principal_id(principal_sid) = @database_user_id OR principal_sid = 0x00)))
            BEGIN
               RAISERROR(14607, -1, -1, 'profile')
               RETURN 1
            END
        END
    END

    --Attach results must be specified
    IF @attach_query_result_as_file IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, 'attach_query_result_as_file')
       RETURN 2
    END

    --No output must be specified
    IF @exclude_query_output IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, 'exclude_query_output')
       RETURN 3
    END

    --No header must be specified
    IF @query_result_header IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, 'query_result_header')
       RETURN 4
    END

    -- Check if query_result_separator is specifed
    IF @query_result_separator IS NULL OR DATALENGTH(@query_result_separator) = 0
    BEGIN
       RAISERROR(14618, 16, 1, 'query_result_separator')
       RETURN 5
    END

    --Echo error must be specified
    IF @append_query_error IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, 'append_query_error')
       RETURN 6
    END

    --@body_format can be TEXT (default) or HTML
    IF (@body_format IS NULL)
    BEGIN
       SET @body_format = 'TEXT'
    END
    ELSE
    BEGIN
       SET @body_format = UPPER(@body_format)

       IF @body_format NOT IN ('TEXT', 'HTML') 
       BEGIN
          RAISERROR(14626, 16, 1, @body_format)
          RETURN 13
       END
    END

    --Importance must be specified
    IF @importance IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, 'importance')
       RETURN 15
    END

    SET @importance = UPPER(@importance)

    --Importance must be one of the predefined values
    IF @importance NOT IN ('LOW', 'NORMAL', 'HIGH')
    BEGIN
       RAISERROR(14622, 16, 1, @importance)
       RETURN 16
    END

    --Sensitivity must be specified
    IF @sensitivity IS NULL
    BEGIN
       RAISERROR(14618, 16, 1, 'sensitivity')
       RETURN 17
    END

    SET @sensitivity = UPPER(@sensitivity)

    --Sensitivity must be one of predefined values
    IF @sensitivity NOT IN ('NORMAL', 'PERSONAL', 'PRIVATE', 'CONFIDENTIAL')
    BEGIN
       RAISERROR(14623, 16, 1, @sensitivity)
       RETURN 18
    END

    --Message body cannot be null. Atleast one of message, subject, query,
    --attachments must be specified.
    IF( (@body IS NULL AND @query IS NULL AND @file_attachments IS NULL AND @subject IS NULL)
       OR
    ( (LEN(@body) IS NULL OR LEN(@body) <= 0)  
       AND (LEN(@query) IS NULL  OR  LEN(@query) <= 0)
       AND (LEN(@file_attachments) IS NULL OR LEN(@file_attachments) <= 0)
       AND (LEN(@subject) IS NULL OR LEN(@subject) <= 0)
    )
    )
    BEGIN
       RAISERROR(14624, 16, 1, '@body, @query, @file_attachments, @subject')
       RETURN 19
    END   
    ELSE
       IF @subject IS NULL OR LEN(@subject) <= 0
          SET @subject='SQL Server Message'

    --Recipients cannot be empty. Atleast one of the To, Cc, Bcc must be specified
    IF ( (@recipients IS NULL AND @copy_recipients IS NULL AND 
       @blind_copy_recipients IS NULL
        )     
       OR
        ( (LEN(@recipients) IS NULL OR LEN(@recipients) <= 0)
       AND (LEN(@copy_recipients) IS NULL OR LEN(@copy_recipients) <= 0)
       AND (LEN(@blind_copy_recipients) IS NULL OR LEN(@blind_copy_recipients) <= 0)
        )
    )
    BEGIN
       RAISERROR(14624, 16, 1, '@recipients, @copy_recipients, @blind_copy_recipients')
       RETURN 20
    END

    --If query is not specified, attach results and no header cannot be true.
    IF ( (@query IS NULL OR LEN(@query) <= 0) AND @attach_query_result_as_file = 1)
    BEGIN
       RAISERROR(14625, 16, 1)
       RETURN 21
    END

    --
    -- Execute Query if query is specified
    IF ((@query IS NOT NULL) AND (LEN(@query) > 0))
    BEGIN
        EXECUTE AS CALLER
        EXEC @rc = sp_RunMailQuery 
                    @query                     = @query,
               @attach_results            = @attach_query_result_as_file,
                    @query_attachment_filename = @query_attachment_filename,
               @no_output                 = @exclude_query_output,
               @query_result_header       = @query_result_header,
               @separator                 = @query_result_separator,
               @echo_error                = @append_query_error,
               @dbuse                     = @execute_query_database,
               @width                     = @query_result_width,
                @temp_table_uid            = @temp_table_uid,
            @query_no_truncate         = @query_no_truncate
      -- This error indicates that query results size was over the configured MaxFileSize.
      -- Note, an error has already beed raised in this case
      IF(@rc = 101)
         GOTO ErrorHandler;
         REVERT
 
         -- Always check the transfer tables for data. They may also contain error messages
         -- Only one of the tables receives data in the call to sp_RunMailQuery
         IF(@attach_query_result_as_file = 1)
         BEGIN
             IF EXISTS(SELECT * FROM sysmail_attachments_transfer WHERE uid = @temp_table_uid)
            SET @AttachmentsExist = 1
         END
         ELSE
         BEGIN
             IF EXISTS(SELECT * FROM sysmail_query_transfer WHERE uid = @temp_table_uid AND uid IS NOT NULL)
            SET @QueryResultsExist = 1
         END

         -- Exit if there was an error and caller doesn't want the error appended to the mail
         IF (@rc <> 0 AND @append_query_error = 0)
         BEGIN
            --Error msg with be in either the attachment table or the query table 
            --depending on the setting of @attach_query_result_as_file
            IF(@attach_query_result_as_file = 1)
            BEGIN
               --Copy query results from the attachments table to mail body
               SELECT @RetErrorMsg = CONVERT(NVARCHAR(4000), attachment)
               FROM sysmail_attachments_transfer 
               WHERE uid = @temp_table_uid
            END
            ELSE
            BEGIN
               --Copy query results from the query table to mail body
               SELECT @RetErrorMsg = text_data 
               FROM sysmail_query_transfer 
               WHERE uid = @temp_table_uid
            END

            GOTO ErrorHandler;
         END
         SET @AttachmentsExist = @attach_query_result_as_file
    END
    ELSE
    BEGIN
        --If query is not specified, attach results cannot be true.
        IF (@attach_query_result_as_file = 1)
        BEGIN
           RAISERROR(14625, 16, 1)
           RETURN 21
        END
    END

    --Get the prohibited extensions for attachments from sysmailconfig.
    IF ((@file_attachments IS NOT NULL) AND (LEN(@file_attachments) > 0)) 
    BEGIN
        EXECUTE AS CALLER
        EXEC @rc = sp_GetAttachmentData 
                        @attachments = @file_attachments, 
                        @temp_table_uid = @temp_table_uid,
                        @exclude_query_output = @exclude_query_output
        REVERT
        IF (@rc <> 0)
            GOTO ErrorHandler;
        
        IF EXISTS(SELECT * FROM sysmail_attachments_transfer WHERE uid = @temp_table_uid)
            SET @AttachmentsExist = 1
    END

    -- Start a transaction if not already in one. 
    -- Note: For rest of proc use GOTO ErrorHandler for falures  
    if (@trancountSave = 0) 
       BEGIN TRAN @procName

    SET @tranStartedBool = 1

    -- Store complete mail message for history/status purposes  
    INSERT sysmail_mailitems
    (
       profile_id,   
       recipients,
       copy_recipients,
       blind_copy_recipients,
       subject,
       body, 
       body_format, 
       importance,
       sensitivity,
       file_attachments,  
       attachment_encoding,
       query,
       execute_query_database,
       attach_query_result_as_file,
       query_result_header,
       query_result_width,          
       query_result_separator,
       exclude_query_output,
       append_query_error,
            send_request_user
    )
    VALUES
    (
       @profile_id,        
       @recipients, 
       @copy_recipients,
       @blind_copy_recipients,
       @subject,
       @body, 
       @body_format, 
       @importance,
       @sensitivity,
       @file_attachments,  
       'MIME',
       @query,
       @execute_query_database,  
       @attach_query_result_as_file,
       @query_result_header,
       @query_result_width,            
       @query_result_separator,
       @exclude_query_output,
       @append_query_error,
            @send_request_user
    )

    SELECT @rc          = @@ERROR,
           @mailitem_id = @@IDENTITY

    IF(@rc <> 0)
        GOTO ErrorHandler;

    --Copy query into the message body
    IF(@QueryResultsExist = 1)
    BEGIN
      -- if the body is null initialize it
        UPDATE sysmail_mailitems
        SET body = N''
        WHERE mailitem_id = @mailitem_id
        AND body is null

        --Add CR    
        SET @CR_str = CHAR(13) + CHAR(10)
        UPDATE sysmail_mailitems
        SET body.WRITE(@CR_str, NULL, NULL)
        WHERE mailitem_id = @mailitem_id

   --Copy query results to mail body
        UPDATE sysmail_mailitems
        SET body.WRITE( (SELECT text_data from sysmail_query_transfer WHERE uid = @temp_table_uid), NULL, NULL )
        WHERE mailitem_id = @mailitem_id

    END

    --Copy into the attachments table
    IF(@AttachmentsExist = 1)
    BEGIN
        --Copy temp attachments to sysmail_attachments      
        INSERT INTO sysmail_attachments(mailitem_id, filename, filesize, attachment)
        SELECT @mailitem_id, filename, filesize, attachment
        FROM sysmail_attachments_transfer
        WHERE uid = @temp_table_uid
    END

    -- Create the primary SSB xml maessage
    SET @sendmailxml = '<requests:SendMail xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.microsoft.com/databasemail/requests RequestTypes.xsd" xmlns:requests="http://schemas.microsoft.com/databasemail/requests"><MailItemId>'
                        + CONVERT(NVARCHAR(20), @mailitem_id) + N'</MailItemId></requests:SendMail>'

    -- Send the send request on queue.
    EXEC @rc = sp_SendMailQueues @sendmailxml
    IF @rc <> 0
    BEGIN
       RAISERROR(14627, 16, 1, @rc, 'send mail')
       GOTO ErrorHandler;
    END

    -- Print success message if required
    IF (@exclude_query_output = 0)
    BEGIN
       SET @localmessage = FORMATMESSAGE(14635)
       PRINT @localmessage
    END  

    --
    -- See if the transaction needs to be commited
    --
    IF (@trancountSave = 0 and @tranStartedBool = 1)
       COMMIT TRAN @procName

    -- All done OK
    goto ExitProc;

    -----------------
    -- Error Handler
    -----------------
ErrorHandler:
    IF (@tranStartedBool = 1) 
       ROLLBACK TRAN @procName

    ------------------
    -- Exit Procedure
    ------------------
ExitProc:
   
    --Always delete query and attactment transfer records. 
   --Note: Query results can also be returned in the sysmail_attachments_transfer table
    DELETE sysmail_attachments_transfer WHERE uid = @temp_table_uid
    DELETE sysmail_query_transfer WHERE uid = @temp_table_uid

   --Raise an error it the query execution fails
   -- This will only be the case when @append_query_error is set to 0 (false)
   IF( (@RetErrorMsg IS NOT NULL) AND (@exclude_query_output=0) )
   BEGIN
      RAISERROR(14661, -1, -1, @RetErrorMsg)
   END

    RETURN (@rc)
END

GO

exec sp_MS_marksystemobject N'sp_send_dbmail' 
GO
exec sp_AddFunctionalUnitToComponent N'Database Mail XPs', N'sp_send_dbmail' 
GRANT EXECUTE   ON [dbo].[sp_send_dbmail]                TO DatabaseMailUserRole 
GO

ALTER PROCEDURE [dbo].[sp_ExternalMailQueueListener]
AS
BEGIN
    DECLARE 
        @idoc               INT,
        @mailitem_id        INT,
        @sent_status        INT,
        @sent_account_id    INT,
        @rc                 INT,
        @processId          INT,
        @sent_date          DATETIME,
        @localmessage       NVARCHAR(max),
        @conv_handle        uniqueidentifier,
       @message_type_name  NVARCHAR(256),
       @xml_message_body   VARCHAR(max),
        @LogMessage         NVARCHAR(max)

    -- Table to store message information.
    DECLARE @msgs TABLE
    (
        [conversation_handle]   uniqueidentifier,
       [message_type_name]     nvarchar(256),
       [message_body]          varbinary(max)
    )

    --RECEIVE messages from the exernal queue. 
    --MailItem status messages are sent from the external sql mail process along with other SSB notifications and errors
    ;RECEIVE conversation_handle, message_type_name, message_body FROM InternalMailQueue INTO @msgs
    -- Check if there was some error in reading from queue
    SET @rc = @@ERROR
    IF (@rc <> 0)
    BEGIN
        --Log error and continue. Don't want to block the following messages on the queue
        SET @localmessage = FORMATMESSAGE(@@ERROR)
        exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@localmessage

        GOTO ErrorHandler;
    END
   
    -----------------------------------
    --Process sendmail status messages
    SELECT 
        @conv_handle        = conversation_handle,
        @message_type_name  = message_type_name, 
        @xml_message_body   = CAST(message_body AS VARCHAR(MAX))
    FROM @msgs 
    WHERE [message_type_name] = N'{//www.microsoft.com/databasemail/messages}SendMailStatus'

    IF(@message_type_name IS NOT NULL)
    BEGIN
        --
        --Expecting the xml body to be n the following form:
        --
        --<?xml version="1.0" encoding="utf-8"?>
        --<responses:SendMail xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.microsoft.com/databasemail/responses ResponseTypes.xsd" xmlns:responses="http://schemas.microsoft.com/databasemail/responses">
        --<Information>
        --    <Failure Message="THe error message...."/>
        --</Information>
        --<MailItemId Id="1" />
        --<SentStatus Status="3" />
        --<SentAccountId Id="0" />
        --<SentDate Date="2005-03-30T14:55:13" />
        --<CallingProcess Id="3012" />
        --</responses:SendMail>

        -- Get the handle to the xml document
        EXEC @rc = sp_xml_preparedocument 
                        @idoc OUTPUT, 
                        @xml_message_body, 
                        N'<ns xmlns:responses="http://schemas.microsoft.com/databasemail/responses" />'
        IF(@rc <> 0)
        BEGIN
            --Log error and continue. Don't want to block the following messages on the queue
            SET @localmessage = FORMATMESSAGE(14655, CONVERT(NVARCHAR(50), @conv_handle), @message_type_name, @xml_message_body)
            exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@localmessage

            GOTO ErrorHandler;
        END

        -- Execute a SELECT statement that uses the OPENXML rowset provider to get the MailItemId and sent status.
        SELECT @mailitem_id     = MailItemId, 
               @sent_status     = SentStatus,
               @sent_account_id = SentAccountId,
               @sent_date       = SentDate,
               @processId       = CallingProcess,
               @LogMessage      = LogMessage
        FROM OPENXML (@idoc, '/responses:SendMail', 1)
            WITH (MailItemId    INT      './MailItemId/@Id', 
                  SentStatus    INT      './SentStatus/@Status',
                  SentAccountId INT      './SentAccountId/@Id',
                  SentDate      DATETIME './SentDate/@Date', --The date was formated using ISO8601
                  CallingProcess INT     './CallingProcess/@Id', 
                  LogMessage     NVARCHAR(max) './Information/Failure/@Message')

        --Close the handle to the xml document
        EXEC sp_xml_removedocument @idoc

        IF(@mailitem_id IS NULL)
        BEGIN  
            --Log error and continue. Don't want to block the following messages on the queue by rolling back the tran
            SET @localmessage = FORMATMESSAGE(14652, CONVERT(NVARCHAR(50), @conv_handle), @message_type_name, @xml_message_body)
            exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@localmessage
        END      
        ELSE
        BEGIN
            -- check sent_status is valid : 0(PendingSend), 1(SendSuccessful), 2(SendFailed), 3(AttemptingSendRetry)
            IF(@sent_status NOT IN (1, 2, 3))
            BEGIN
                SET @localmessage = FORMATMESSAGE(14653, N'SentStatus', CONVERT(NVARCHAR(50), @conv_handle), @message_type_name, @xml_message_body)
                exec msdb.dbo.sysmail_logmailevent_sp @event_type=2, @description=@localmessage

                --Set value to SendFailed
                SET @sent_status = 2
            END

            --Make the @sent_account_id NULL if it is 0. 
            IF(@sent_account_id IS NOT NULL AND @sent_account_id = 0)
                SET @sent_account_id = NULL

            --
            -- Update the mail status if not a retry. Nothing else needs to be done in this case
            UPDATE sysmail_mailitems
            SET sent_status     = CAST (@sent_status as TINYINT),
                sent_account_id = @sent_account_id,
                sent_date       = @sent_date
            WHERE mailitem_id = @mailitem_id
        
            -- Report a failure if no record is found in the sysmail_mailitems table
            IF (@@ROWCOUNT = 0)
            BEGIN
                SET @localmessage = FORMATMESSAGE(14653, N'MailItemId', CONVERT(NVARCHAR(50), @conv_handle), @message_type_name, @xml_message_body)
                exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@localmessage
            END

            IF (@LogMessage IS NOT NULL)
            BEGIN
                exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@LogMessage, @process_id=@processId, @mailitem_id=@mailitem_id, @account_id=@sent_account_id
            END
        END
    END

    -------------------------------------------------------
    --Process all other messages by logging to sysmail_log
    SET @conv_handle = NULL;
    
    --Always end the conversion if this message is received
    SELECT @conv_handle = conversation_handle
    FROM @msgs 
    WHERE [message_type_name] = N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog'
    
    IF(@conv_handle IS NOT NULL)
    BEGIN
        END CONVERSATION @conv_handle;
    END

    DECLARE @queuemessage nvarchar(max)
    DECLARE queue_messages_cursor CURSOR LOCAL 
    FOR
        SELECT FORMATMESSAGE(14654, CONVERT(NVARCHAR(50), conversation_handle), message_type_name, message_body)
        FROM @msgs 
        WHERE [message_type_name] 
              NOT IN (N'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog',
                      N'{//www.microsoft.com/databasemail/messages}SendMailStatus')
  
    OPEN queue_messages_cursor 
    FETCH NEXT FROM queue_messages_cursor INTO @queuemessage
    WHILE (@@fetch_status = 0)
    BEGIN
        exec msdb.dbo.sysmail_logmailevent_sp @event_type=2, @description=@queuemessage
        FETCH NEXT FROM queue_messages_cursor INTO @queuemessage
    END
    CLOSE queue_messages_cursor 
    DEALLOCATE queue_messages_cursor 

    -- All done OK
    goto ExitProc;

    -----------------
    -- Error Handler
    -----------------
ErrorHandler:

    ------------------
    -- Exit Procedure
    ------------------
ExitProc:
    RETURN (@rc)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- Processes responses from dbmail 
--
ALTER PROCEDURE [dbo].[sp_ProcessResponse]
    @conv_handle        uniqueidentifier,
    @message_type_name  NVARCHAR(256),
    @xml_message_body   VARCHAR(max)
AS
BEGIN
    DECLARE 
        @idoc               INT,
        @mailitem_id        INT,
        @sent_status        INT,
        @rc                 INT,
        @index              INT,
        @processId          INT,
        @sent_date          DATETIME,
        @localmessage       NVARCHAR(max),
        @LogMessage         NVARCHAR(max),
        @retry_hconv        uniqueidentifier,
        @paramStr           NVARCHAR(256),
        @accRetryDelay      INT

    --------------------------
    --Always send the response 
    ;SEND ON CONVERSATION @conv_handle MESSAGE TYPE @message_type_name (@xml_message_body)


    --
    -- Need to handle the case where a sent retry is requested. 
    -- This is done by setting a conversation timer, The timer with go off in the external queue

    -- Get the handle to the xml document
    EXEC @rc = sp_xml_preparedocument 
                    @idoc OUTPUT, 
                    @xml_message_body, 
                    N'<ns xmlns:responses="http://schemas.microsoft.com/databasemail/responses" />'
    IF(@rc <> 0)
    BEGIN
        --Log the error. The response has already sent to the Internal queue. 
        -- This will update the mail with the latest staus
        SET @localmessage = FORMATMESSAGE(14655, CONVERT(NVARCHAR(50), @conv_handle), @message_type_name, @xml_message_body)
        exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@localmessage

        GOTO ErrorHandler;
    END

    -- Execute a SELECT statement that uses the OPENXML rowset provider to get the MailItemId and sent status.
    SELECT @mailitem_id     = MailItemId, 
           @sent_status     = SentStatus
    FROM OPENXML (@idoc, '/responses:SendMail', 1)
        WITH (MailItemId    INT      './MailItemId/@Id', 
              SentStatus    INT      './SentStatus/@Status')

    --Close the handle to the xml document
    EXEC sp_xml_removedocument @idoc

    IF(@mailitem_id IS NULL OR @sent_status IS NULL)
    BEGIN  
        --Log error and continue.
        SET @localmessage = FORMATMESSAGE(14652, CONVERT(NVARCHAR(50), @conv_handle), @message_type_name, @xml_message_body)
        exec msdb.dbo.sysmail_logmailevent_sp @event_type=3, @description=@localmessage

        GOTO ErrorHandler;
    END      

    --
    -- A send retry has been requested. Set a conversation timer
    IF(@sent_status = 3)
    BEGIN
        -- Get the associated mail item data for the given @conversation_handle (if it exists)
       SELECT @retry_hconv = conversation_handle
       FROM sysmail_send_retries as sr
            RIGHT JOIN sysmail_mailitems as mi
            ON sr.mailitem_id = mi.mailitem_id
       WHERE mi.mailitem_id = @mailitem_id

        --Must be the first retry attempt. Create a sysmail_send_retries record to track retries
        IF(@retry_hconv IS NULL)
        BEGIN
            INSERT sysmail_send_retries(conversation_handle, mailitem_id) --last_send_attempt_date
            VALUES(@conv_handle, @mailitem_id)
        END
        ELSE
        BEGIN
            --Update existing retry record
            UPDATE sysmail_send_retries
            SET last_send_attempt_date = GETDATE(),
                send_attempts = send_attempts + 1
            WHERE mailitem_id = @mailitem_id

        END

        --Get the global retry delay time
        EXEC msdb.dbo.sysmail_help_configure_value_sp @parameter_name = N'AccountRetryDelay', 
                                                    @parameter_value = @paramStr OUTPUT
        --ConvertToInt will return the default if @paramStr is null
        SET @accRetryDelay = dbo.ConvertToInt(@paramStr, 0x7fffffff, 300) -- 5 min default


        --Now set the dialog timer. This triggers the send retry
        ;BEGIN CONVERSATION TIMER (@conv_handle) TIMEOUT = @accRetryDelay 

    END
    ELSE
    BEGIN
        --Only end theconversation if a retry isn't being attempted
        END CONVERSATION @conv_handle
    END


    -- All done OK
    goto ExitProc;

    -----------------
    -- Error Handler
    -----------------
ErrorHandler:

    ------------------
    -- Exit Procedure
    ------------------
ExitProc:
    RETURN (@rc);

END
GO

/**************************************************************/
/* Sign agent sps and add them to OBD component               */
/*                                                            */
/* Also sign SPs for other components located in MSDB         */
/**************************************************************/
PRINT 'Signing sps ...'
-- Create certificate to sign Agent sps
--
if exists (select * from sys.certificates where name = '##MS_AgentSigningCertificate##')
   drop certificate [##MS_AgentSigningCertificate##]

declare @certError int
dbcc traceon(4606,-1)
create certificate [##MS_AgentSigningCertificate##] 
   encryption by password = 'Yukon90_'
   with subject = 'MS_AgentSigningCertificate'
select @certError = @@error
dbcc traceoff(4606,-1)

IF (@certError <> 0)
   RAISERROR('Cannot create ##MS_AgentSigningCertificate## in msdb.', 20, 127) WITH LOG

go

-- List all of the stored procedures we need to sign
create table #sp_table (name sysname, sign int, comp int)
go
insert into #sp_table values(N'sp_sqlagent_is_srvrolemember',               1, 0)
insert into #sp_table values(N'sp_verify_category_identifiers',               1, 0)
insert into #sp_table values(N'sp_verify_proxy_identifiers',               1, 0)
insert into #sp_table values(N'sp_verify_credential_identifiers',          1, 0)
insert into #sp_table values(N'sp_verify_subsystem_identifiers',           1, 0)
insert into #sp_table values(N'sp_verify_login_identifiers',               1, 0)
insert into #sp_table values(N'sp_verify_proxy',                  1, 0)
insert into #sp_table values(N'sp_add_proxy',                     1, 0)
insert into #sp_table values(N'sp_delete_proxy',                  1, 0)
insert into #sp_table values(N'sp_update_proxy',                  1, 0)
insert into #sp_table values(N'sp_sqlagent_is_member',                  1, 0)
insert into #sp_table values(N'sp_verify_proxy_permissions',               1, 0)
insert into #sp_table values(N'sp_help_proxy',                    1, 0)
insert into #sp_table values(N'sp_grant_proxy_to_subsystem',               1, 0)
insert into #sp_table values(N'sp_grant_login_to_proxy',             1, 0)
insert into #sp_table values(N'sp_revoke_login_from_proxy',             1, 0)
insert into #sp_table values(N'sp_revoke_proxy_from_subsystem',               1, 0)
insert into #sp_table values(N'sp_enum_proxy_for_subsystem',               1, 0)
insert into #sp_table values(N'sp_enum_login_for_proxy',             1, 0)
insert into #sp_table values(N'sp_sqlagent_get_startup_info',              1, 1)
insert into #sp_table values(N'sp_sqlagent_has_server_access',             1, 1)
insert into #sp_table values(N'sp_sem_add_message',                  1, 0)
insert into #sp_table values(N'sp_sem_drop_message',                 1, 0)
insert into #sp_table values(N'sp_get_message_description',             1, 0)
insert into #sp_table values(N'sp_sqlagent_get_perf_counters',             1, 0)
insert into #sp_table values(N'sp_sqlagent_notify',                  1, 1)
insert into #sp_table values(N'sp_is_sqlagent_starting',             1, 1)
insert into #sp_table values(N'sp_verify_job_identifiers',              1, 0)
insert into #sp_table values(N'sp_verify_schedule_identifiers',               1, 0)
insert into #sp_table values(N'sp_verify_jobproc_caller',               1, 0)
insert into #sp_table values(N'sp_downloaded_row_limiter',              1, 1)
insert into #sp_table values(N'sp_post_msx_operation',                  1, 1)
insert into #sp_table values(N'sp_verify_performance_condition',           1, 0)
insert into #sp_table values(N'sp_verify_job_date',                  1, 0)
insert into #sp_table values(N'sp_verify_job_time',                  1, 0)
insert into #sp_table values(N'sp_verify_alert',                  1, 1)
insert into #sp_table values(N'sp_update_alert',                  1, 0)
insert into #sp_table values(N'sp_delete_job_references',               1, 0)
insert into #sp_table values(N'sp_delete_all_msx_jobs',                 1, 0)
insert into #sp_table values(N'sp_generate_target_server_job_assignment_sql',       1, 0)
insert into #sp_table values(N'sp_generate_server_description',               1, 1)
insert into #sp_table values(N'sp_msx_set_account',                  1, 1)
insert into #sp_table values(N'sp_msx_get_account',                  1, 1)
insert into #sp_table values(N'sp_delete_operator',                  1, 0)
insert into #sp_table values(N'sp_msx_defect',                    1, 1)
insert into #sp_table values(N'sp_msx_enlist',                    1, 1)
insert into #sp_table values(N'sp_delete_targetserver',                 1, 0)
insert into #sp_table values(N'sp_get_sqlagent_properties',             1, 1)
insert into #sp_table values(N'sp_set_sqlagent_properties',             1, 1)
insert into #sp_table values(N'sp_add_targetservergroup',               1, 0)
insert into #sp_table values(N'sp_update_targetservergroup',               1, 0)
insert into #sp_table values(N'sp_delete_targetservergroup',               1, 0)
insert into #sp_table values(N'sp_help_targetservergroup',              1, 0)
insert into #sp_table values(N'sp_add_targetsvrgrp_member',             1, 0)
insert into #sp_table values(N'sp_delete_targetsvrgrp_member',             1, 0)
insert into #sp_table values(N'sp_verify_category',                  1, 0)
insert into #sp_table values(N'sp_add_category',                  1, 0)
insert into #sp_table values(N'sp_update_category',                  1, 0)
insert into #sp_table values(N'sp_delete_category',                  1, 0)
insert into #sp_table values(N'sp_help_category',                 1, 0)
insert into #sp_table values(N'sp_help_targetserver',                1, 0)
insert into #sp_table values(N'sp_resync_targetserver',                 1, 0)
insert into #sp_table values(N'sp_purge_jobhistory',                 1, 0)
insert into #sp_table values(N'sp_help_jobhistory',                  1, 0)
insert into #sp_table values(N'sp_add_jobserver',                 1, 0)
insert into #sp_table values(N'sp_delete_jobserver',                 1, 0)
insert into #sp_table values(N'sp_help_jobserver',                1, 0)
insert into #sp_table values(N'sp_help_downloadlist',                1, 0)
insert into #sp_table values(N'sp_enum_sqlagent_subsystems',               1, 0)
insert into #sp_table values(N'sp_enum_sqlagent_subsystems_internal', 1, 0)
insert into #sp_table values(N'sp_verify_subsystem',                 1, 1)
insert into #sp_table values(N'sp_verify_subsystems',                 1, 0)
insert into #sp_table values(N'sp_verify_schedule',                  1, 0)
insert into #sp_table values(N'sp_add_schedule',                  1, 0)
insert into #sp_table values(N'sp_attach_schedule',                  1, 0)
insert into #sp_table values(N'sp_detach_schedule',                  1, 0)
insert into #sp_table values(N'sp_update_schedule',                  1, 0)
insert into #sp_table values(N'sp_delete_schedule',                  1, 0)
insert into #sp_table values(N'sp_get_jobstep_db_username',             1, 0)
insert into #sp_table values(N'sp_verify_jobstep',                1, 0)
insert into #sp_table values(N'sp_add_jobstep_internal',             1, 0)
insert into #sp_table values(N'sp_add_jobstep',                   1, 0)
insert into #sp_table values(N'sp_update_jobstep',                1, 0)
insert into #sp_table values(N'sp_delete_jobstep',                1, 0)
insert into #sp_table values(N'sp_help_jobstep',                  1, 0)
insert into #sp_table values(N'sp_write_sysjobstep_log',             1, 0)
insert into #sp_table values(N'sp_help_jobsteplog',                  1, 0)
insert into #sp_table values(N'sp_delete_jobsteplog',                1, 0)
insert into #sp_table values(N'sp_get_schedule_description',               1, 1)
insert into #sp_table values(N'sp_add_jobschedule',                  1, 0)
insert into #sp_table values(N'sp_update_replication_job_parameter',          1, 0)
insert into #sp_table values(N'sp_update_jobschedule',                  1, 0)
insert into #sp_table values(N'sp_delete_jobschedule',                  1, 0)
insert into #sp_table values(N'sp_help_schedule',                 1, 0)
insert into #sp_table values(N'sp_help_jobschedule',                 1, 0)
insert into #sp_table values(N'sp_verify_job',                    1, 1)
insert into #sp_table values(N'sp_add_job',                    1, 0)
insert into #sp_table values(N'sp_update_job',                    1, 0)
insert into #sp_table values(N'sp_delete_job',                    1, 0)
insert into #sp_table values(N'sp_get_composite_job_info',              1, 1)
insert into #sp_table values(N'sp_help_job',                   1, 0)
insert into #sp_table values(N'sp_help_jobcount ',                1, 0)
insert into #sp_table values(N'sp_help_jobs_in_schedule',               1, 0)
insert into #sp_table values(N'sp_manage_jobs_by_login',             1, 0)
insert into #sp_table values(N'sp_apply_job_to_targets',             1, 0)
insert into #sp_table values(N'sp_remove_job_from_targets',             1, 0)
insert into #sp_table values(N'sp_get_job_alerts',                1, 0)
insert into #sp_table values(N'sp_convert_jobid_to_char',               1, 0)
insert into #sp_table values(N'sp_start_job',                     1, 0)
insert into #sp_table values(N'sp_stop_job',                   1, 0)
insert into #sp_table values(N'sp_cycle_agent_errorlog',             1, 0)
insert into #sp_table values(N'sp_get_chunked_jobstep_params',             1, 0)
insert into #sp_table values(N'sp_check_for_owned_jobs',             1, 0)
insert into #sp_table values(N'sp_check_for_owned_jobsteps',               1, 0)
insert into #sp_table values(N'sp_sqlagent_refresh_job',             1, 0)
insert into #sp_table values(N'sp_jobhistory_row_limiter',              1, 1)
insert into #sp_table values(N'sp_sqlagent_log_jobhistory',             1, 0)
insert into #sp_table values(N'sp_sqlagent_check_msx_version',             1, 0)
insert into #sp_table values(N'sp_sqlagent_probe_msx',                  1, 0)
insert into #sp_table values(N'sp_set_local_time',                1, 1)
insert into #sp_table values(N'sp_multi_server_job_summary',               1, 0)
insert into #sp_table values(N'sp_target_server_summary',               1, 0)
insert into #sp_table values(N'sp_uniquetaskname',                1, 0)
insert into #sp_table values(N'sp_addtask',                    1, 0)
insert into #sp_table values(N'sp_droptask',                   1, 0)
insert into #sp_table values(N'sp_add_alert_internal',                  1, 0)
insert into #sp_table values(N'sp_add_alert',                     1, 0)
insert into #sp_table values(N'sp_delete_alert',                  1, 0)
insert into #sp_table values(N'sp_help_alert',                    1, 0)
insert into #sp_table values(N'sp_verify_operator',                  1, 0)
insert into #sp_table values(N'sp_add_operator',                  1, 0)
insert into #sp_table values(N'sp_update_operator',                  1, 1)
insert into #sp_table values(N'sp_help_operator',                 1, 0)
insert into #sp_table values(N'sp_help_operator_jobs',                  1, 0)
insert into #sp_table values(N'sp_verify_operator_identifiers',               1, 0)
insert into #sp_table values(N'sp_notify_operator',                  1, 0)
insert into #sp_table values(N'sp_verify_notification',                 1, 0)
insert into #sp_table values(N'sp_add_notification',                 1, 0)
insert into #sp_table values(N'sp_update_notification',                 1, 0)
insert into #sp_table values(N'sp_delete_notification',                 1, 0)
insert into #sp_table values(N'sp_help_notification',                1, 0)
insert into #sp_table values(N'sp_help_jobactivity',                 1, 0)
insert into #sp_table values(N'sp_enlist_tsx',                    1, 1)
insert into #sp_table values(N'trig_targetserver_insert',               1, 0)

-- Database Mail configuration procs
insert into #sp_table values(N'sysmail_verify_accountparams_sp',           1, 0)
insert into #sp_table values(N'sysmail_verify_principal_sp',               1, 0)
insert into #sp_table values(N'sysmail_verify_profile_sp',              1, 0)
insert into #sp_table values(N'sysmail_verify_account_sp',              1, 0)
insert into #sp_table values(N'sysmail_add_profile_sp',                 1, 0)
insert into #sp_table values(N'sysmail_update_profile_sp',              1, 0)
insert into #sp_table values(N'sysmail_delete_profile_sp',              1, 0)
insert into #sp_table values(N'sysmail_help_profile_sp',             1, 0)
insert into #sp_table values(N'sysmail_create_user_credential_sp',            1, 0)
insert into #sp_table values(N'sysmail_alter_user_credential_sp',          1, 0)
insert into #sp_table values(N'sysmail_drop_user_credential_sp',           1, 0)
insert into #sp_table values(N'sysmail_add_account_sp',                 1, 0)
insert into #sp_table values(N'sysmail_update_account_sp',              1, 0)
insert into #sp_table values(N'sysmail_delete_account_sp',              1, 0)
insert into #sp_table values(N'sysmail_help_account_sp',             1, 0)
insert into #sp_table values(N'sysmail_help_admin_account_sp',             1, 0)
insert into #sp_table values(N'sysmail_add_profileaccount_sp',             1, 0)
insert into #sp_table values(N'sysmail_update_profileaccount_sp',          1, 0)
insert into #sp_table values(N'sysmail_delete_profileaccount_sp',          1, 0)
insert into #sp_table values(N'sysmail_help_profileaccount_sp',               1, 0)
insert into #sp_table values(N'sysmail_configure_sp',                1, 0)
insert into #sp_table values(N'sysmail_help_configure_sp',              1, 0)
insert into #sp_table values(N'sysmail_help_configure_value_sp',           1, 0)
insert into #sp_table values(N'sysmail_add_principalprofile_sp',           1, 0)
insert into #sp_table values(N'sysmail_update_principalprofile_sp',           1, 0)
insert into #sp_table values(N'sysmail_delete_principalprofile_sp',           1, 0)
insert into #sp_table values(N'sysmail_help_principalprofile_sp',          1, 0)

-- Database Mail: mail host database specific procs
insert into #sp_table values(N'sysmail_start_sp',             1, 2)
insert into #sp_table values(N'sysmail_stop_sp',              1, 2)
insert into #sp_table values(N'sysmail_logmailevent_sp',      1, 0)
insert into #sp_table values(N'sp_SendMailMessage',           1, 0)
insert into #sp_table values(N'sp_isprohibited',              1, 0)
insert into #sp_table values(N'sp_SendMailQueues',            1, 0)
insert into #sp_table values(N'sp_ProcessResponse',           1, 0)
insert into #sp_table values(N'sp_MailItemResultSets',        1, 0)
insert into #sp_table values(N'sp_process_DialogTimer',       1, 0)
insert into #sp_table values(N'sp_readrequest',               1, 0)
insert into #sp_table values(N'sp_GetAttachmentData',         1, 0)
insert into #sp_table values(N'sp_RunMailQuery',              1, 0)
insert into #sp_table values(N'sysmail_help_queue_sp',        1, 0)
insert into #sp_table values(N'sysmail_help_status_sp',       1, 2)
insert into #sp_table values(N'sysmail_delete_mailitems_sp',  1, 0)
insert into #sp_table values(N'sysmail_delete_log_sp',        1, 0)
insert into #sp_table values(N'sp_send_dbmail',               1, 2)
insert into #sp_table values(N'sp_ExternalMailQueueListener', 1, 0)
insert into #sp_table values(N'sp_sysmail_activate',          1, 0)
insert into #sp_table values(N'sp_get_script',                1, 0)

-- Maintenance Plans
insert into #sp_table values(N'sp_maintplan_delete_log',             1, 0)
insert into #sp_table values(N'sp_maintplan_delete_subplan',               1, 0)
insert into #sp_table values(N'sp_maintplan_open_logentry',             1, 0)
insert into #sp_table values(N'sp_maintplan_close_logentry',               1, 0)
insert into #sp_table values(N'sp_maintplan_update_log',             1, 0)
insert into #sp_table values(N'sp_maintplan_update_subplan',               1, 0)
insert into #sp_table values(N'sp_maintplan_delete_plan',               1, 0)
insert into #sp_table values(N'sp_maintplan_start',                  1, 0)
insert into #sp_table values(N'sp_clear_dbmaintplan_by_db',             1, 0)
insert into #sp_table values(N'sp_add_maintenance_plan',             1, 0)
insert into #sp_table values(N'sp_delete_maintenance_plan',             1, 0)
insert into #sp_table values(N'sp_add_maintenance_plan_db',             1, 0)
insert into #sp_table values(N'sp_delete_maintenance_plan_db',             1, 0)
insert into #sp_table values(N'sp_add_maintenance_plan_job',               1, 1)
insert into #sp_table values(N'sp_delete_maintenance_plan_job',               1, 0)
insert into #sp_table values(N'sp_help_maintenance_plan',               1, 0)

-- Log Shipping
insert into #sp_table values(N'sp_add_log_shipping_monitor_jobs',          1, 0)
insert into #sp_table values(N'sp_add_log_shipping_primary',               1, 0)
insert into #sp_table values(N'sp_add_log_shipping_secondary',             1, 0)
insert into #sp_table values(N'sp_delete_log_shipping_monitor_jobs',          1, 0)
insert into #sp_table values(N'sp_delete_log_shipping_primary',               1, 0)
insert into #sp_table values(N'sp_delete_log_shipping_secondary ',            1, 0)
insert into #sp_table values(N'sp_log_shipping_in_sync',             1, 0)
insert into #sp_table values(N'sp_log_shipping_get_date_from_file ',          1, 0)
insert into #sp_table values(N'sp_get_log_shipping_monitor_info',          1, 0)
insert into #sp_table values(N'sp_update_log_shipping_monitor_info',          1, 0)
insert into #sp_table values(N'sp_delete_log_shipping_monitor_info',          1, 0)
insert into #sp_table values(N'sp_remove_log_shipping_monitor_account',          1, 0)
insert into #sp_table values(N'sp_log_shipping_monitor_backup',               1, 0)
insert into #sp_table values(N'sp_log_shipping_monitor_restore',           1, 0)
insert into #sp_table values(N'sp_change_monitor_role',                 1, 0)
insert into #sp_table values(N'sp_create_log_shipping_monitor_account',          1, 0)

-- DTS
insert into #sp_table values(N'sp_get_dtsversion',                1, 0)
insert into #sp_table values(N'sp_make_dtspackagename',                 1, 0)
insert into #sp_table values(N'sp_add_dtspackage',                1, 0)
insert into #sp_table values(N'sp_drop_dtspackage',                  1, 0)
insert into #sp_table values(N'sp_reassign_dtspackageowner',               1, 0)
insert into #sp_table values(N'sp_get_dtspackage',                1, 0)
insert into #sp_table values(N'sp_reassign_dtspackagecategory',               1, 0)
insert into #sp_table values(N'sp_enum_dtspackages',                 1, 0)
insert into #sp_table values(N'sp_add_dtscategory',                  1, 0)
insert into #sp_table values(N'sp_drop_dtscategory',                 1, 0)
insert into #sp_table values(N'sp_modify_dtscategory',                  1, 0)
insert into #sp_table values(N'sp_enum_dtscategories',                  1, 0)
insert into #sp_table values(N'sp_log_dtspackage_begin',             1, 0)
insert into #sp_table values(N'sp_log_dtspackage_end',                  1, 0)
insert into #sp_table values(N'sp_log_dtsstep_begin',                1, 0)
insert into #sp_table values(N'sp_log_dtsstep_end',                  1, 0)
insert into #sp_table values(N'sp_log_dtstask',                   1, 0)
insert into #sp_table values(N'sp_enum_dtspackagelog',                  1, 0)
insert into #sp_table values(N'sp_enum_dtssteplog',                  1, 0)
insert into #sp_table values(N'sp_enum_dtstasklog',                  1, 0)
insert into #sp_table values(N'sp_dump_dtslog_all',                  1, 0)
insert into #sp_table values(N'sp_dump_dtspackagelog',                  1, 0)
insert into #sp_table values(N'sp_dump_dtssteplog',                  1, 0)
insert into #sp_table values(N'sp_dump_dtstasklog',                  1, 0)
insert into #sp_table values(N'sp_dts_addlogentry',                  1, 0)
insert into #sp_table values(N'sp_dts_listpackages',                 1, 0)
insert into #sp_table values(N'sp_dts_listfolders',                  1, 0)
insert into #sp_table values(N'sp_dts_deletepackage',                1, 0)
insert into #sp_table values(N'sp_dts_deletefolder',                 1, 0)
insert into #sp_table values(N'sp_dts_getpackage',                1, 0)
insert into #sp_table values(N'sp_dts_getfolder',                 1, 0)
insert into #sp_table values(N'sp_dts_putpackage',                1, 0)
insert into #sp_table values(N'sp_dts_addfolder',                 1, 0)
insert into #sp_table values(N'sp_dts_renamefolder',                 1, 0)
insert into #sp_table values(N'sp_dts_setpackageroles',                 1, 0)
insert into #sp_table values(N'sp_dts_getpackageroles',                 1, 0)
go

BEGIN TRANSACTION
declare @sp sysname
declare @exec_str nvarchar(1024)
declare @sign int
declare @comp int
declare ms_crs_sps cursor global for select name, sign, comp from #sp_table 
open ms_crs_sps
fetch next from ms_crs_sps into @sp, @sign, @comp  
while @@fetch_status = 0
begin
   if exists(select * from sys.objects where name = @sp)
   begin
      print 'processing sp: ' + @sp
      if (@sign = 1)
      begin
         set @exec_str = N'add signature to ' + @sp + N' by certificate [##MS_AgentSigningCertificate##] with password = ''Yukon90_'''
         Execute(@exec_str)
         if (@@error <> 0)
         begin
            declare @err_str nvarchar(1024)
            set @err_str = 'Cannot sign stored procedure ' + @sp + '. Terminating.'
            RAISERROR(@err_str, 20, 127) WITH LOG
            ROLLBACK TRANSACTION
            return
         end
      end

   end
   fetch next from ms_crs_sps into @sp, @sign, @comp  
end
close ms_crs_sps
deallocate ms_crs_sps
COMMIT TRANSACTION
go
drop table #sp_table
go
-- drop certificate private key
alter certificate [##MS_AgentSigningCertificate##] remove private key

IF (@@error <> 0)
   RAISERROR('Cannot create ##MS_AgentSigningCertificate## in msdb. INSTMSDB.SQL terminating.', 20, 127) WITH LOG
go
--create a temporary database in order to get the path to the 'Data' folder
--because upon upgrade existing database are in temporary folder
IF (EXISTS (SELECT name
                FROM master.dbo.sysdatabases
                WHERE (name = N'temp_MS_AgentSigningCertificate_database')))
BEGIN
  DROP DATABASE temp_MS_AgentSigningCertificate_database
END
go
CREATE DATABASE temp_MS_AgentSigningCertificate_database
go
-- export certificate to master
-- use current directory to persist the file
--
DECLARE @certificate_name NVARCHAR(520)

SELECT @certificate_name = SUBSTRING(filename, 1, CHARINDEX(N'temp_MS_AgentSigningCertificate_database.mdf', filename) - 1) + 
                           CONVERT(NVARCHAR(520), NEWID()) + N'.cer'
  FROM master.dbo.sysaltfiles
  WHERE (name = N'temp_MS_AgentSigningCertificate_database')
  
EXECUTE(N'dump certificate [##MS_AgentSigningCertificate##] to file = ''' + @certificate_name + '''')

IF (@@error <> 0)
   RAISERROR('Cannot dump ##MS_AgentSigningCertificate##. INSTMSDB.SQL terminating.', 20, 127) WITH LOG

use master

if exists (select * from sys.database_principals where name = '##MS_AgentSigningCertificate##')
   drop user [##MS_AgentSigningCertificate##]

if exists (select * from sys.server_principals where name = '##MS_AgentSigningCertificate##')
   drop login [##MS_AgentSigningCertificate##]

if exists (select * from sys.certificates where name = '##MS_AgentSigningCertificate##')
   drop certificate [##MS_AgentSigningCertificate##]

execute(N'create certificate [##MS_AgentSigningCertificate##] from file = ''' + @certificate_name + '''')
IF (@@error <> 0)
   RAISERROR('Cannot create ##MS_AgentSigningCertificate## certificate in master. INSTMSDB.SQL terminating.', 20, 127) WITH LOG

-- create login
--
create login [##MS_AgentSigningCertificate##] from certificate [##MS_AgentSigningCertificate##]
IF (@@error <> 0)
   RAISERROR('Cannot create ##MS_AgentSigningCertificate## login. INSTMSDB.SQL terminating.', 20, 127) WITH LOG

-- create certificate based user for execution granting
--
create user [##MS_AgentSigningCertificate##] for certificate [##MS_AgentSigningCertificate##]
IF (@@error <> 0)
   RAISERROR('Cannot create ##MS_AgentSigningCertificate## user. INSTMSDB.SQL terminating.', 20, 127) WITH LOG

-- enable certificate for OBD
--
exec sys.sp_SetOBDCertificate N'##MS_AgentSigningCertificate##',N'ON'

grant execute to [##MS_AgentSigningCertificate##]

use msdb
go
-- drop temporary database
IF (EXISTS (SELECT name
                FROM master.dbo.sysdatabases
                WHERE (name = N'temp_MS_AgentSigningCertificate_database')))
BEGIN
  DROP DATABASE temp_MS_AgentSigningCertificate_database
END
go

PRINT 'Succesfully signed sps'
--
-- End of signing sps
GO

--------------------------------------------------------------------------------
--	REPL_MASTER.SQL
--------------------------------------------------------------------------------
