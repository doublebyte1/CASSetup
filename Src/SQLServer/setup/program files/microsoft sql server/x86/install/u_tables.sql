
/*
** U_Tables.CQL    --- 1996/09/16 12:22
** Copyright Microsoft, Inc. 1994 - 2000
** All Rights Reserved.
*/

go
use master
go
set nocount on
go


declare @vdt varchar(99)
select  @vdt = convert(varchar,getdate(),113)
raiserror('Starting u_Tables.SQL at  %s',0,1,@vdt) with nowait
raiserror('This file creates all the ''SPT_'' tables.',0,1)
go

if object_id('spt_monitor','U') IS NOT NULL
	begin
	print 'drop table spt_monitor ....'
	drop table spt_monitor
	end

if object_id('spt_values','U') IS NOT NULL
	begin
	print 'drop table spt_values ....'
	drop table spt_values
	end

------------------------------------------------------------------
------------------------------------------------------------------

raiserror('Creating ''%s''.', -1,-1,'spt_monitor')
go

create table spt_monitor
(
	lastrun		datetime	NOT NULL,
	cpu_busy	int		NOT NULL,
	io_busy		int		NOT NULL,
	idle		int		NOT NULL,
	pack_received	int		NOT NULL,
	pack_sent	int		NOT NULL,
	connections	int		NOT NULL,
	pack_errors	int		NOT NULL,
	total_read	int		NOT NULL,
	total_write 	int		NOT NULL,
	total_errors 	int		NOT NULL
)
go

EXEC sp_MS_marksystemobject 'spt_monitor'
go

---------------------------------------

raiserror('Creating ''%s''.',-1,-1,'spt_values')
go
create table spt_values
(
name	nvarchar(35)	    NULL,
number	int		NOT NULL,
type	nchar(3)		NOT NULL, --Make these unique to aid GREP (e.g. SOP, not SET or S).
low	int		    NULL,
high	int		    NULL,
status	int		    NULL  DEFAULT 0
)
go

EXEC sp_MS_marksystemobject 'spt_values'
go

print 'create indexes on spt_values ....'
go

-- 'J','S','P' (maybe 'Z' too?)  challenge uniqueness.
create Unique Clustered index spt_valuesclust on spt_values(type ,number ,name)
go

create Nonclustered index ix2_spt_values_nu_nc on spt_values(number, type)
go


------------------------------------------------------------------
------------------------------------------------------------------

raiserror('Grant Select on spt_ ....',0,1)
go

grant select on spt_values  to public
grant select on spt_monitor to public

go


------------------------------------------------------------------
------------------------------------------------------------------


raiserror('Insert into spt_monitor ....',0,1)
go

insert into spt_monitor
	select
	lastrun = getdate(),
	cpu_busy = @@cpu_busy,
	io_busy = @@io_busy,
	idle = @@idle,
	pack_received = @@pack_received,
	pack_sent = @@pack_sent,
	connections = @@connections,
	pack_errors = @@packet_errors,
	total_read = @@total_read,
	total_write = @@total_write,
	total_errors = @@total_errors
go



-- Caution, 'Z  ' is used by sp_helpsort, though no 'Z  ' rows are inserted by this file.

print 'Insert into spt_values ....'
go

raiserror('Insert spt_values.type=''A  '' ....',0,1)
go
insert into spt_values (name, number, type)
	values ('rpc', 1, 'A')
insert into spt_values (name, number, type)
	values ('pub', 2, 'A')
insert into spt_values (name, number, type)
	values ('sub', 4, 'A')
insert into spt_values (name, number, type)
	values ('dist', 8, 'A')
insert into spt_values (name, number, type)
	values ('dpub', 16, 'A')
insert into spt_values (name, number, type)
	values ('rpc out', 64, 'A')
insert into spt_values (name, number, type)
	values ('data access', 128, 'A')
insert into spt_values (name, number, type)
	values ('collation compatible', 256, 'A')
insert into spt_values (name, number, type)
	values ('system', 512, 'A')
insert into spt_values (name, number, type)
	values ('use remote collation', 1024, 'A')
insert into spt_values (name, number, type)
	values ('lazy schema validation', 2048, 'A')
-- NOTE: PLEASE UPDATE ntdbms\include\systabre.h WHEN USING
--  ADDITIONAL SYSSERVER STATUS BITS! (enum ESrvStatusBits)
go


raiserror('Insert spt_values.type=''B  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('YES OR NO', -1, 'B')
insert spt_values (name, number, type)
	values ('no', 0, 'B')
insert spt_values (name, number, type)
	values ('yes', 1, 'B')
insert spt_values (name, number, type)
	values ('none', 2, 'B')
go

-- types 'D'(sysdatabase.status) and 'DC'(sysdatabase.category)
-- and 'D2'(sysdatabases.status2) are options settable by sp_dboption

raiserror('Insert spt_values.type=''D  '' ....',0,1)
go
---- If you add a bit here make sure you add the value to the value of the ALL SETTABLE DB status option if it is settable with sp_dboption.

insert spt_values (name, number, type)
	values ('DATABASE STATUS', 0, 'D')
--These bits come from sysdatabases.status.
insert spt_values (name, number, type)
	values ('autoclose', 1, 'D')
insert spt_values (name, number, type)
	values ('select into/bulkcopy', 4, 'D')
insert spt_values (name, number, type)
	values ('trunc. log on chkpt.', 8, 'D')
insert spt_values (name, number, type)
	values ('torn page detection', 16, 'D')
insert spt_values (name, number, type)
	values ('loading', 32, 'D')  -- Had been "don't recover".
insert spt_values (name, number, type)
	values ('pre recovery', 64, 'D') -- not settable
insert spt_values (name, number, type)
	values ('recovering', 128, 'D') -- not settable
insert spt_values (name, number, type)
	values ('not recovered', 256, 'D')  -- suspect - not settable
insert into spt_values(name, number, type, low, high)
	values ('offline', 512, 'D', 0, 1)
insert spt_values (name, number, type)
	values ('read only', 1024, 'D')
insert spt_values (name, number, type)
	values ('dbo use only', 2048, 'D')
insert spt_values (name, number, type)
	values ('single user', 4096, 'D')
insert spt_values (name, number, type)
	values ('emergency mode', 32768, 'D') -- not settable
insert spt_values (name, number, type)
	values ('autoshrink',  4194304, 'D')
insert spt_values (name, number, type) -- not settable
	values ('missing files',  0x40000, 'D')
insert spt_values (name, number, type) -- not settable
	values ('cleanly shutdown',  0x40000000, 'D')
insert spt_values (name, number, type)
	values ('ALL SETTABLE OPTIONS', 4202013, 'D')
go


insert spt_values (name, number, type)
	values ('DATABASE OPTIONS', 0, 'D2')
--These bits come from sysdatabases.status2.
insert spt_values (name, number, type)
	values ('db chaining', 0x400, 'D2')
insert spt_values (name, number, type)
	values ('numeric roundabort', 0x800, 'D2')
insert spt_values (name, number, type)
	values ('arithabort', 0x1000, 'D2')
insert spt_values (name, number, type)
	values ('ANSI padding', 0x2000, 'D2')
insert spt_values (name, number, type)
	values ('ANSI null default', 0x4000, 'D2')
insert spt_values (name, number, type)
	values ('concat null yields null', 0x10000, 'D2')
insert spt_values (name, number, type)
	values ('recursive triggers', 0x20000, 'D2')
insert spt_values (name, number, type)
	values ('default to local cursor',  0x100000, 'D2')
insert spt_values (name, number, type)
	values ('quoted identifier', 0x800000, 'D2')
insert spt_values (name, number, type)
	values ('auto create statistics', 0x1000000, 'D2')
insert spt_values (name, number, type)
	values ('cursor close on commit', 0x2000000, 'D2')
insert spt_values (name, number, type)
	values ('ANSI nulls', 0x4000000, 'D2')
insert spt_values (name, number, type)
	values ('ANSI warnings', 0x10000000, 'D2')
insert spt_values (name, number, type) -- not user settable
	values ('full text enabled', 0x20000000, 'D2')
insert spt_values (name, number, type)
	values ('auto update statistics', 0x40000000, 'D2')



-- Sum of bits of all settable DB status options,
-- update when adding such options or modifying existing options to be settable.
insert spt_values (name, number, type)
	values ('ALL SETTABLE OPTIONS', 1469267968|0x800|0x1000|0x2000|0x400, 'D2')
go

raiserror('Insert spt_values.type=''DC '' ....',0,1)
go
---- If you add a bit here make sure you add the value to the value of the ALL SETTABLE DB category option if it is settable with sp_dboption.

insert spt_values (name, number, type)
	values ('DATABASE CATEGORY', 0, 'DC')

--These bits come from sysdatabases.category.
insert spt_values (name, number, type)
	values ('published', 1, 'DC')
insert spt_values (name, number, type)
	values ('subscribed', 2, 'DC')
insert spt_values (name, number, type)
	values ('merge publish', 4, 'DC')

--These are not settable by sp_dboption
insert spt_values (name, number, type)
	values ('Distributed', 16, 'DC')

--Sum of bits of all settable options, update when adding such options or modifying existing options to be settable.
insert spt_values (name, number, type)
	values ('ALL SETTABLE OPTIONS', 7, 'DC')
go

--UNDONE: Are these obsolete?
--raiserror('Insert spt_values.type=''DBV'' ....',0,1)
--go
--insert into spt_values (name ,number ,type,low,high)
--	values ('SYSDATABASES.VERSION', 0, 'DBV',-1,-1) --- dbcc getvalue('current_version') into @@error
--insert into spt_values (name ,number ,type,low,high)
--	values ('4.2' ,199307 ,'DBV',1,1)  --WinNT version
--insert into spt_values (name ,number ,type,low,high)
--	values ('6.0' ,199506 ,'DBV',400,406) --Betas thru Release range was 400-406.
--insert into spt_values (name ,number ,type,low,high)
--	values ('6.5' ,199604 ,'DBV',407,408) --First beta already had 408.

--declare @dbver int
--dbcc getvalue('current_version')
--select @dbver = @@error
--insert into spt_values (name ,number ,type,low,high)
--	values ('7.0' ,199707 ,'DBV',409 ,@dbver)
--go



raiserror('Insert spt_values.type=''E  '' ....',0,1)
go
--Set the machine type
--spt_values.low is the number of bytes in a page for the particular machine.
insert spt_values (name, number, type, low)
	values ('SQLSERVER HOST TYPE', 0, 'E', 0)
go
--Set the platform specific entries.
--spt_values.low is the number of bytes in a page.
insert into spt_values (name, number, type, low)
	values ('WINDOWS/NT', 1, 'E', 8192)

/* Value to set and clear the high bit for int datatypes for os/2.
** Would like to enter -2,147,483,648 to avoid byte order issues, but
** the server won't take it, even in exponential notation.
*/
insert into spt_values (name, number, type, low)
	values ('int high bit', 2, 'E', 0x80000000)

/* Value which gives the byte position of the high byte for int datatypes for
** os/2.  This value was changed from 4 (the usual Intel 80x86 order) to 1
** when binary convert routines were changed to reverse the byte order.  So
** this value is accurate ONLY when ints are converted to binary datatype.
*/
insert into spt_values (name, number, type, low)
	values ('int4 high byte', 3, 'E', 1)
go


raiserror('Insert spt_values.type=''F  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('SYSREMOTELOGINS TYPES', -1, 'F')
insert spt_values (name, number, type)
	values ('', 0, 'F')
insert spt_values (name, number, type)
	values ('trusted', 1, 'F')
go
insert spt_values (name, number, type)
	values ('SYSREMOTELOGINS TYPES (UPDATE)', -1, 'F_U')
insert spt_values (name, number, type)
	values ('', 0, 'F_U')
insert spt_values (name, number, type)
	values ('trusted', 16, 'F_U')
go



raiserror('Insert spt_values.type=''G  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('GENERAL MISC. STRINGS', 0, 'G')
insert spt_values (name, number, type)
	values ('SQL Server Internal Table', 0, 'G')
go


raiserror('Insert spt_values.type=''I  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('INDEX TYPES', 0, 'I')
insert spt_values (name, number, type)
	values ('nonclustered', 0, 'I')
insert spt_values (name, number, type)
	values ('ignore duplicate keys', 1, 'I')
insert spt_values (name, number, type)
	values ('unique', 2, 'I')
insert spt_values (name, number, type)
	values ('ignore duplicate rows', 4, 'I')
insert spt_values (name, number, type)
	values ('clustered', 16, 'I')
insert spt_values (name, number, type)
	values ('hypothetical', 32, 'I')
insert spt_values (name, number, type)
	values ('statistics', 64, 'I')
insert spt_values (name, number, type)
	values ('auto create', 8388608, 'I')
insert spt_values (name, number, type)
        values ('stats no recompute', 16777216, 'I')

--ref integ
insert into spt_values (name, number, type, low, high)
	values ('primary key', 2048, 'I', 0, 1)
insert into spt_values (name, number, type, low, high)
	values ('unique key', 4096, 'I', 0, 1)
go


--Adding listing of physical types that are compatible.
raiserror('Insert spt_values.type=''J  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('COMPATIBLE TYPES', 0, 'J')
insert spt_values (name, number, low, type)
	values ('binary', 1, 45, 'J')
insert spt_values (name, number, low, type)
	values ('varbinary', 1, 37, 'J')
insert spt_values (name, number, low, type)
	values ('bit', 2, 50, 'J')
insert spt_values (name, number, low, type)
	values ('char', 3, 47, 'J')
insert spt_values (name, number, low, type)
	values ('varchar', 3, 39, 'J')
insert spt_values (name, number, low, type)
	values ('datetime', 4, 61, 'J')
insert spt_values (name, number, low, type)
	values ('datetimn', 4, 111, 'J')
insert spt_values (name, number, low, type)
	values ('smalldatetime', 4, 58, 'J')
insert spt_values (name, number, low, type)
	values ('float', 5, 62, 'J')
insert spt_values (name, number, low, type)
	values ('floatn', 5, 109, 'J')
insert spt_values (name, number, low, type)
	values ('real', 5, 59, 'J')
insert spt_values (name, number, low, type)
	values ('int', 6, 56, 'J')
insert spt_values (name, number, low, type)
	values ('intn', 6, 38, 'J')
insert spt_values (name, number, low, type)
	values ('smallint', 6, 52, 'J')
insert spt_values (name, number, low, type)
	values ('tinyint', 6, 48, 'J')
insert spt_values (name, number, low, type)
	values ('money', 7, 60, 'J')
insert spt_values (name, number, low, type)
	values ('moneyn', 7, 110, 'J')
insert spt_values (name, number, low, type)
	values ('smallmoney', 7, 122, 'J')
go


--?!?! obsolete, old syskeys table.
raiserror('Insert spt_values.type=''K  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('SYSKEYS TYPES', 0, 'K')
insert spt_values (name, number, type)
	values ('primary', 1, 'K')
insert spt_values (name, number, type)
	values ('foreign', 2, 'K')
insert spt_values (name, number, type)
	values ('common', 3, 'K')
go


raiserror('Insert spt_values.type=''L  '' ....',0,1)
-- See also 'SFL' type.
go
insert spt_values(name, number, type)
  values ('LOCK TYPES', 0, 'L')
insert spt_values(name, number, type)
  values ('NULL', 1, 'L')
insert spt_values(name, number, type)
  values ('Sch-S', 2, 'L')
insert spt_values(name, number, type)
  values ('Sch-M', 3, 'L')
insert spt_values(name, number, type)
  values ('S', 4, 'L')
insert spt_values(name, number, type)
  values ('U', 5, 'L')
insert spt_values(name, number, type)
  values ('X', 6, 'L')
insert spt_values(name, number, type)
  values ('IS', 7, 'L')
insert spt_values(name, number, type)
  values ('IU', 8, 'L')
insert spt_values(name, number, type)
  values ('IX', 9, 'L')
insert spt_values(name, number, type)
  values ('SIU', 10, 'L')
insert spt_values(name, number, type)
  values ('SIX', 11, 'L')
insert spt_values(name, number, type)
  values ('UIX', 12, 'L')
insert spt_values(name, number, type)
  values ('BU', 13, 'L')
insert spt_values(name, number, type)
  values ('RangeS-S', 14, 'L')
insert spt_values(name, number, type)
  values ('RangeS-U', 15, 'L')
insert spt_values(name, number, type)
  values ('RangeIn-Null', 16, 'L')
insert spt_values(name, number, type)
  values ('RangeIn-S', 17, 'L')
insert spt_values(name, number, type)
  values ('RangeIn-U', 18, 'L')
insert spt_values(name, number, type)
  values ('RangeIn-X', 19, 'L')
insert spt_values(name, number, type)
  values ('RangeX-S', 20, 'L')
insert spt_values(name, number, type)
  values ('RangeX-U', 21, 'L')
insert spt_values(name, number, type)
  values ('RangeX-X', 22, 'L')
go

-- Lock Resources.
--
raiserror('Insert spt_values.type=''LR '' ....',0,1)
go
insert spt_values(name, number, type)
  values ('LOCK RESOURCES', 0, 'LR')
insert spt_values(name, number, type)
  values ('NUL', 1, 'LR')
insert spt_values(name, number, type)
  values ('DB', 2, 'LR')
insert spt_values(name, number, type)
  values ('FIL', 3, 'LR')
insert spt_values(name, number, type)
  values ('TAB', 5, 'LR')
insert spt_values(name, number, type)
  values ('PAG', 6, 'LR')
insert spt_values(name, number, type)
  values ('KEY', 7, 'LR')
insert spt_values(name, number, type)
  values ('EXT', 8, 'LR')
insert spt_values(name, number, type)
  values ('RID', 9, 'LR')
insert spt_values(name, number, type)
  values ('APP', 10, 'LR')
insert spt_values(name, number, type)
  values ('MD', 11, 'LR')
insert spt_values(name, number, type)
  values ('HBT', 12, 'LR')
insert spt_values(name, number, type)
  values ('AU', 13, 'LR')
go

-- Lock Request Status Values
--
raiserror('Insert spt_values.type=''LS '' ....',0,1)
go
insert spt_values(name, number, type)
  values ('LOCK REQ STATUS', 0, 'LS')
insert spt_values(name, number, type)
  values ('GRANT', 1, 'LS')
insert spt_values(name, number, type)
  values ('CNVT', 2, 'LS')
insert spt_values(name, number, type)
  values ('WAIT', 3, 'LS')
insert spt_values(name, number, type)
  values ('RELN', 4, 'LS')
insert spt_values(name, number, type)
  values ('BLCKN', 5, 'LS')
go

-- Lock Owner Values
--
raiserror('Insert spt_values.type=''LO '' ....',0,1)
go
insert spt_values(name, number, type)
  values ('LOCK OWNER', 0, 'LO')
insert spt_values(name, number, type)
  values ('Xact', 1, 'LO')
insert spt_values(name, number, type)
  values ('Crsr', 2, 'LO')
insert spt_values(name, number, type)
  values ('Sess', 3, 'LO')
insert spt_values(name, number, type)
  values ('STWS', 4, 'LO')
insert spt_values(name, number, type)
  values ('XTWS', 5, 'LO')
insert spt_values(name, number, type)
  values ('WFR', 6, 'LO')
go

-- --- 'O' in 6.5, but gone in Sphinx (sysobjects.sysstat) OBSOLETE ?!?!
raiserror('Insert spt_values.type=''O  '' ....',0,1)
go
/*
**  These values define the object type.  The number made from the low
**  4 bits in sysobjects.sysstats indicates the type of object.
*/
insert spt_values (name, number, type)
	values ('OBJECT TYPES', 0, 'O')
insert spt_values (name, number, type)
	values ('system table', 1, 'O')
insert spt_values (name, number, type)
	values ('view', 2, 'O')
insert spt_values (name, number, type)
	values ('user table', 3, 'O')
insert spt_values (name, number, type)
	values ('stored procedure',4, 'O')
--no number 5
insert spt_values (name, number, type)
	values ('default', 6, 'O')
insert spt_values (name, number, type)
	values ('rule', 7, 'O')
insert spt_values (name, number, type)
	values ('trigger', 8, 'O')
insert spt_values (name, number, type)
	values ('replication filter stored procedure', 12, 'O')
go



-- --- 'O9T' sysobjects.type, for reports like sp_help (violate 1NF in name column).
--     These rows new in 7.0 (old 'O' for sysstat are gone).
--     Use  substring(v.name,1,2)  and  substring(v.name,5,31)
raiserror('Insert spt_values.type=''O9T'' ....',0,1)
go
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('sysobjects.type, reports'            ,0  ,'O9T' ,0 ,0 ,0)
                 ----+----1----+----2----+----3----+
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('AF: aggregate function'              ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('AP: application'                     ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('C : check cns'                       ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('D : default (maybe cns)'             ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('EN: event notification'              ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('F : foreign key cns'                 ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
    values ('FN: scalar function'                 ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
    values ('FS: assembly scalar function'        ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('FT: assembly table function'         ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('IF: inline function'                 ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('IS: inline scalar function'          ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('IT: internal table'                  ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('L : log'                             ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('P : stored procedure'                ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('PC : assembly stored procedure'      ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('PK: primary key cns'                 ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('R : rule'                            ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('RF: replication filter proc'         ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('S : system table'                    ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('SN: synonym'                         ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('SQ: queue'                           ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('TA: assembly trigger'                ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
    values ('TF: table function'                  ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('TR: trigger'                         ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('U : user table'                      ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('UQ: unique key cns'                  ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('V : view'                            ,-1 ,'O9T' ,0 ,0 ,0)
insert into spt_values (name ,number ,type ,low ,high ,status)
	values ('X : extended stored proc'            ,-1 ,'O9T' ,0 ,0 ,0)
go



--Adding bit position information  ''P''  (helpful with sysprotects.columns).
raiserror('Insert spt_values.type=''P  '' ....',0,1)
go
---- Cannot insert a header/dummy description row for type='P  ' (Bit Position rows).

insert spt_values (name ,number ,type ,low ,high ,status) values (null ,0 ,'P  ' ,1 ,0x00000001 ,0)
insert spt_values (name ,number ,type ,low ,high ,status) values (null ,1 ,'P  ' ,1 ,0x00000002 ,0)
insert spt_values (name ,number ,type ,low ,high ,status) values (null ,2 ,'P  ' ,1 ,0x00000004 ,0)
insert spt_values (name ,number ,type ,low ,high ,status) values (null ,3 ,'P  ' ,1 ,0x00000008 ,0)

insert spt_values (name ,number ,type ,low ,high ,status) values (null ,4 ,'P  ' ,1 ,0x00000010 ,0)
insert spt_values (name ,number ,type ,low ,high ,status) values (null ,5 ,'P  ' ,1 ,0x00000020 ,0)
insert spt_values (name ,number ,type ,low ,high ,status) values (null ,6 ,'P  ' ,1 ,0x00000040 ,0)
insert spt_values (name ,number ,type ,low ,high ,status) values (null ,7 ,'P  ' ,1 ,0x00000080 ,0)

go

-- 'P  ' continued....
declare
	 @number_track		integer
	,@char_number_track	varchar(12)

select	 @number_track		= 7
select	 @char_number_track	= convert(varchar,@number_track)

-- max columns is 1024 so we need 1024 bit position rows;
-- we'll actually insert entries for more than that
while @number_track < 1024
	begin

	raiserror('type=''P  '' ,@number_track=%d' ,0,1 ,@number_track)

	EXECUTE(
	'
	insert spt_values (name ,number ,type ,low ,high ,status)
	  select
		 null

		,(select	 max(c_val.number)
			from	 spt_values	c_val
			where	 c_val.type = ''P  ''
			and	 c_val.number between 0 and ' + @char_number_track + '
		 )
			+ a_val.number + 1

		,''P  ''

		,(select	 max(b_val.low)
			from	 spt_values	b_val
			where	 b_val.type = ''P  ''
			and	 b_val.number between 0 and ' + @char_number_track + '
		 )
			+ 1 + (a_val.number / 8)

		,a_val.high
		,0
	    from
		 spt_values	a_val
	    where
		 a_val.type = ''P  ''
	    and	 a_val.number between 0 and ' + @char_number_track + '
	')


	select @number_track = ((@number_track + 1) * 2) - 1
	select @char_number_track = convert(varchar,@number_track)

	end --loop
go


--sysobjects.userstat in 6.5 and backward.  Obsolete ?!?!
raiserror('Insert spt_values.type=''R  '' ....',0,1)
go
/*
**  These values translate the object type's userstat bits.  If the high
**  bit is set for a sproc, then it's a report.
*/
insert spt_values (name, number, type)
	values ('REPORT TYPES', 0, 'R')
insert spt_values (name, number, type)
	values ('', 0, 'R')
insert spt_values (name, number, type)
	values (' (rpt)', -32768, 'R')
go



raiserror('Insert spt_values.type=''SFL'' ....',0,1)
---------------------------------------
-- StarFighter Lock Description Strings
---------------------------------------
go
insert spt_values(name, number, type)
  values ('SF LOCK TYPES', 0, 'SFL')
insert spt_values(name, number, type)
  values ('Extent Lock - Exclusive', 8, 'SFL')
insert spt_values(name, number, type)
  values ('Extent Lock - Update', 9, 'SFL')
insert spt_values(name, number, type)
  values ('Extent Lock - Next', 11, 'SFL')
insert spt_values(name, number, type)
  values ('Extent Lock - Previous', 12, 'SFL')
go



--type=''SOP'' rows for SET Options status info.   See sp_help_setopts, @@options, and config=1534 (''user options'').
raiserror('Insert spt_values.type=''SOP'' ....',0,1)
go
--status&1=1 means configurable via 'user options'.
insert into spt_values (name ,number ,type ,status) values
      ('@@OPTIONS' ,0 ,'SOP' ,0)

insert into spt_values (name ,number ,type ,status) values
      ('disable_def_cnst_check'  ,1 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('implicit_transactions'   ,2 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('cursor_close_on_commit'  ,4 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('ansi_warnings'           ,8 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('ansi_padding'            ,16 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('ansi_nulls'              ,32 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('arithabort'              ,64 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('arithignore'             ,128 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('quoted_identifier'       ,256 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('nocount'                 ,512 ,'SOP' ,1)

--Mutually exclusive when ON.
insert into spt_values (name ,number ,type ,status) values
      ('ansi_null_dflt_on'       ,1024 ,'SOP' ,1)
insert into spt_values (name ,number ,type ,status) values
      ('ansi_null_dflt_off'      ,2048 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('concat_null_yields_null' ,0x1000 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('numeric_roundabort'      ,0x2000 ,'SOP' ,1)

insert into spt_values (name ,number ,type ,status) values
      ('xact_abort'			     ,0x4000 ,'SOP' ,1)
go


--Adding sysprotects.action AND protecttype values: thus 'T  ' overloaded but just happens to not share any one integer.
raiserror('Insert spt_values.type=''T  '' ....',0,1)
go
insert spt_values(name, number, type)
  values ('SYSPROTECTS.ACTION', 0, 'T')
insert spt_values(name, number, type)
  values ('References', 26, 'T')
insert spt_values(name, number, type)
  values ('Create Function', 178, 'T')
insert spt_values(name, number, type)
  values ('Select', 193, 'T')          --- action
insert spt_values(name, number, type)
  values ('Insert', 195, 'T')  --- Covers BCPin and LoadTable.
insert spt_values(name, number, type)
  values ('Delete', 196, 'T')
insert spt_values(name, number, type)
  values ('Update', 197, 'T')
insert spt_values(name, number, type)
  values ('Create Table', 198, 'T')
insert spt_values(name, number, type)
  values ('Create Database', 203, 'T')

insert spt_values(name, number, type)
  values ('Grant_WGO', 204, 'T')
insert spt_values(name, number, type)
  values ('Grant', 205, 'T')           --- protecttype
insert spt_values(name, number, type)
  values ('Deny', 206, 'T')

insert spt_values(name, number, type)
  values ('Create View', 207, 'T')
insert spt_values(name, number, type)
  values ('Create Procedure', 222, 'T')
insert spt_values(name, number, type)
  values ('Execute', 224, 'T')
insert spt_values(name, number, type)
  values ('Backup Database', 228, 'T')
insert spt_values(name, number, type)
  values ('Create Default', 233, 'T')
insert spt_values(name, number, type)
  values ('Backup Transaction', 235, 'T')
insert spt_values(name, number, type)
  values ('Create Rule', 236, 'T')

go

raiserror('Insert spt_values.type=''V  '' ....',0,1)
go
insert spt_values (name, number, type)
	values ('SYSDEVICES STATUS', 0, 'V')
insert spt_values (name, number, type)
	values ('default disk', 1, 'V')
insert spt_values (name, number, type)
	values ('physical disk', 2, 'V')
insert spt_values (name, number, type)
	values ('logical disk', 4, 'V')
insert spt_values (name, number, type)
	values ('backup device', 16, 'V')
insert spt_values (name, number, type)
	values ('serial writes', 32, 'V')
insert into spt_values(name, number, type, low, high)
	values ('read only', 4096, 'V', 0, 1)
insert into spt_values(name, number, type, low, high)
	values ('deferred', 8192, 'V', 0, 1)
go


-- Values for fixed server roles.
raiserror('Insert spt_values.type=''SRV'' ...',0,1)
go
insert spt_values(name, number, type, low)
  values ('sysadmin', 16, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('securityadmin', 32, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('serveradmin', 64, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('setupadmin', 128, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('processadmin', 256, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('diskadmin', 512, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('dbcreator', 1024, 'SRV', 0)
insert spt_values(name, number, type, low)
  values ('bulkadmin', 4096, 'SRV', 0)
go
-- UNDONE: REMOVE THESE (should be BOL only)
insert spt_values(name, number, type, low)
  values ('System Administrators', 16, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Security Administrators', 32, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Server Administrators', 64, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Setup Administrators', 128, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Process Administrators', 256, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Disk Administrators', 512, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Database Creators', 1024, 'SRV', -1)
insert spt_values(name, number, type, low)
  values ('Bulk Insert Administrators', 4096, 'SRV', -1)
go

-- Values for fixed db roles.
raiserror('Insert spt_values.type=''DBR'' ...',0,1)
go
-- UNDONE: REMOVE THESE (should be BOL only)
insert spt_values(name, number, type, low)
  values ('DB Owners', 16384, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Access Administrators', 16385, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Security Administrators', 16386, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB DDL Administrators', 16387, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Backup Operator', 16389, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Data Reader', 16390, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Data Writer', 16391, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Deny Data Reader', 16392, 'DBR', -1)
insert spt_values(name, number, type, low)
  values ('DB Deny Data Writer', 16393, 'DBR', -1)
go


-- SQL Server message group names stored in spt_values under type "LNG"
insert into spt_values (name, number, type) values (N'Bulgarian', 1026, N'LNG')
insert into spt_values (name, number, type) values (N'Czech', 1029,  N'LNG')
insert into spt_values (name, number, type) values (N'Danish', 1030,  N'LNG')
insert into spt_values (name, number, type) values (N'German', 1031,  N'LNG')
insert into spt_values (name, number, type) values (N'Greek', 1032, N'LNG')
insert into spt_values (name, number, type) values (N'English', 1033, N'LNG')
insert into spt_values (name, number, type) values (N'Spanish', 3082,  N'LNG')
insert into spt_values (name, number, type) values (N'Finnish', 1035,  N'LNG')
insert into spt_values (name, number, type) values (N'French', 1036,  N'LNG')
insert into spt_values (name, number, type) values (N'Hungarian', 1038,  N'LNG')
insert into spt_values (name, number, type) values (N'Italian', 1040,  N'LNG')
insert into spt_values (name, number, type) values (N'japanese', 1041, N'LNG')
insert into spt_values (name, number, type) values (N'Dutch', 1043,  N'LNG')
insert into spt_values (name, number, type) values (N'Polish', 1045,  N'LNG')
insert into spt_values (name, number, type) values (N'Romanian', 1048,  N'LNG')
insert into spt_values (name, number, type) values (N'Russian', 1049, N'LNG')
insert into spt_values (name, number, type) values (N'Croatian', 1050,  N'LNG')
insert into spt_values (name, number, type) values (N'Slovak', 1051,  N'LNG')
insert into spt_values (name, number, type) values (N'Swedish', 1053,  N'LNG')
insert into spt_values (name, number, type) values (N'Turkish', 1055,  N'LNG')
insert into spt_values (name, number, type) values (N'Slovenian', 1060,  N'LNG')
insert into spt_values (name, number, type) values (N'Norwegian', 2068,  N'LNG')
insert into spt_values (name, number, type) values (N'Portuguese', 2070,  N'LNG')
insert into spt_values (name, number, type) values (N'Estonian', 1061,  N'LNG')
insert into spt_values (name, number, type) values (N'Latvian', 1062,  N'LNG')
insert into spt_values (name, number, type) values (N'Lithuanian', 1063,  N'LNG')
insert into spt_values (name, number, type) values (N'Brazilian', 1046,  N'LNG')
insert into spt_values (name, number, type) values (N'Traditional Chinese', 1028,  N'LNG')
insert into spt_values (name, number, type) values (N'Korean', 1042,  N'LNG')
insert into spt_values (name, number, type) values (N'Simplified Chinese', 2052,  N'LNG')
insert into spt_values (name, number, type) values (N'Arabic', 1025,  N'LNG')
insert into spt_values (name, number, type) values (N'Thai', 1054,  N'LNG')
go

update statistics spt_values
go

declare @vdt varchar(99)
select  @vdt = convert(varchar,getdate(),113)
raiserror('Finishing at  %s',0,1,@vdt)
go

checkpoint
go


