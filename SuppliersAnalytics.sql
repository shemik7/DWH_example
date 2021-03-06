﻿IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'map')
EXEC sys.sp_executesql N'CREATE SCHEMA [map]'
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'oth')
EXEC sys.sp_executesql N'CREATE SCHEMA [oth]'
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'stg')
EXEC sys.sp_executesql N'CREATE SCHEMA [stg]'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clean_string_from_nonnumeric]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Shemetov I.V.
-- Create date: 2019-05-30
-- Description: очистка строки от нечисловых символов 
-- =============================================
CREATE FUNCTION [dbo].[clean_string_from_nonnumeric](
	@str nvarchar(2047)
)
RETURNS int
AS
BEGIN
	
	declare 
		@str2 varchar(50)
		,@ret int
	set @str2 = ''''

	select @str2 = @str2 + case when substring(@str, number, 1)  like ''[0-9]'' then substring(@str, number, 1) else '''' end
	from master..spt_values
	where type = ''P'' and number <= len(@str) and number <> 0
	
	return iif(isnumeric(@str2) = 1, convert(int, @str2), 0)

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[date_to_int]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: из даты в int
-- =============================================
--select dbo.date_to_int(''2017-01-01'')
CREATE FUNCTION [dbo].[date_to_int]
(
	@date date
)
RETURNS int
AS
BEGIN
	
	declare @res_date as int

	select @res_date = year(@date) * 10000 + month(@date) * 100 + day(@date)

	return @res_date

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IfFileExists]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[IfFileExists] (@path varchar(512))
RETURNS BIT
AS
BEGIN
     DECLARE @result INT
     EXEC master.dbo.xp_fileexist @path, @result OUTPUT
     RETURN cast(@result as bit)
END;' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[int_datediff]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: Разность дат типа int
-- =============================================
--select [dbo].[int_datediff](''yy'',20160130,20170130) as dt 
--select [dbo].[int_datediff](''dd'',20160130,20170130) as dt 
--select [dbo].[int_datediff](''mm'',20160130,20170130) as dt 
CREATE FUNCTION [dbo].[int_datediff]
(
	@date_format nvarchar(10),
	@date_start_int int,
	@date_end_int int
)
RETURNS int
AS
BEGIN
	
	declare @res int

	declare @date_start date
	declare @date_end date

	set @date_start = cast(cast(@date_start_int as varchar)as datetime )
	set @date_end = cast(cast(@date_end_int as varchar)as datetime )

	if(@date_format = ''d'' or @date_format = ''dd'')
	begin
		select @res = DATEDIFF(dd, @date_start, @date_end)		
	end		
	if(@date_format = ''m'' or @date_format = ''mm'')
	begin
		select @res = DATEDIFF(m, @date_start, @date_end)	
	end	
	if(@date_format = ''yy'' or @date_format = ''yyyy'')
	begin
		select @res = DATEDIFF(yy, @date_start, @date_end)	
	end				
	
		
	return @res

END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[int_day]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: Номер дня из даты типа int
-- =============================================
--select dbo.int_day(20170101)
CREATE FUNCTION [dbo].[int_day]
(
	@date_int int
)
RETURNS int
AS
BEGIN
	
	declare @res_day as int

	select @res_day = day(cast(cast(@date_int as varchar) as date))

	return @res_day

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[int_getdate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: Текущая дата дат типа int
-- =============================================
--select [dbo].[int_getdate]()
CREATE FUNCTION [dbo].[int_getdate]
(	
)
RETURNS int
AS
BEGIN
	
	declare @res int

	set @res = year(GETDATE()) * 10000 + month(GETDATE()) * 100 + day(GETDATE())	
			
	return @res

END



' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[int_month]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: Номер месяца из даты типа int
-- =============================================
--select dbo.int_month(20170101)
create FUNCTION [dbo].[int_month]
(
	@date_int int
)
RETURNS int
AS
BEGIN
	
	declare @res_month as int

	select @res_month = month(cast(cast(@date_int as varchar) as date))

	return @res_month

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[int_to_date]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: из int в дату
-- =============================================
--select dbo.int_to_date(20170101)
CREATE FUNCTION [dbo].[int_to_date]
(
	@date_int int
)
RETURNS date
AS
BEGIN
	
	declare @res as date

	select @res = cast(cast(@date_int as varchar) as date)

	return @res

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[int_year]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- =============================================
-- Author:		
-- Create date: 2017-09-20
-- Description: Номер года из даты типа int
-- =============================================
--select int_year(20170101)
CREATE FUNCTION [dbo].[int_year]
(
	@date_int int
)
RETURNS int
AS
BEGIN
	
	declare @res_year as int

	select @res_year = year(cast(cast(@date_int as varchar) as date))

	return @res_year

END

' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[npclean_string]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE function [dbo].[npclean_string] (
 @strIn as varchar(1000)
)
returns varchar(1000)
as
begin
 declare @iPtr as int
 set @iPtr = patindex(''%[^ -~0-9A-Z]%'', @strIn COLLATE LATIN1_GENERAL_BIN)
 while @iPtr > 0 begin
  set @strIn = replace(@strIn COLLATE LATIN1_GENERAL_BIN, substring(@strIn, @iPtr, 1), '''')
  set @iPtr = patindex(''%[^ -~0-9A-Z]%'', @strIn COLLATE LATIN1_GENERAL_BIN)
 end
 return LTRIM(RTRIM(@strIn))
end
' 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_rests]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_rests](
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[quantity] [money] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_rests]') AND name = N'IX_fct_rests')
CREATE CLUSTERED INDEX [IX_fct_rests] ON [dbo].[fct_rests]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_rests]'))
EXEC dbo.sp_executesql @statement = N'

CREATE view [dbo].[v_olap_fct_rests] as 
-- 2018-09-21 Shemetov I.V.
SELECT 
       f.[date_id]
      ,f.[apt_id]
      ,f.[good_id]
      ,f.[quantity]
FROM [dbo].[fct_rests] as f (nolock) 

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_volume_agreement_group]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_volume_agreement_group](
	[volume_agreement_group_id] [int] IDENTITY(1,1) NOT NULL,
	[volume_agreement_group] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_report_purchases](
	[source_id] [int] NOT NULL,
	[volume_agreement_id] [int] NOT NULL,
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[initial_supplier_id] [int] NULL,
	[supplier_id] [int] NULL,
	[manufacturer_id] [int] NULL,
	[volume_agreement_group_id] [int] NULL,
	[is_apt_in_list] [bit] NULL,
	[is_manufacturer_contract] [bit] NULL,
	[is_distributor_limitation] [bit] NULL,
	[qty] [money] NULL,
	[purch_net] [money] NULL,
	[purch_grs] [money] NULL,
	[price_cip] [money] NULL,
	[purch_cip] [money] NULL,
	[initial_supplier_id_sourcedwh] [int] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_purchases]') AND name = N'ix_cl_date_id_fct_report_purchases')
CREATE CLUSTERED INDEX [ix_cl_date_id_fct_report_purchases] ON [dbo].[fct_report_purchases]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_volume_agreements]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_volume_agreements](
	[volume_agreement_id] [int] IDENTITY(1,1) NOT NULL,
	[volume_agreement_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[manager_FIO] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[period] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[price_type] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[channel] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[list_type] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_all_apt] [bit] NOT NULL,
	[is_till_channel] [bit] NOT NULL,
	[is_list] [bit] NULL,
 CONSTRAINT [PK_dim_volume_agreement] PRIMARY KEY CLUSTERED 
(
	[volume_agreement_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_report_purchases]'))
EXEC dbo.sp_executesql @statement = N'





CREATE view [dbo].[v_olap_fct_report_purchases] as
SELECT 
	[source_id]
	,s.[volume_agreement_id]
	,[date_id]
	,[apt_id]
	,[good_id]
	,[supplier_id]
	,[manufacturer_id]
	,[volume_agreement_group_id]
    ,[is_apt_in_list]
    ,[is_manufacturer_contract]
    ,[is_distributor_limitation]
	,[qty]
	,[purch_net]
	,[purch_grs]
	,[price_cip]
	,[purch_cip]
FROM [dbo].[fct_report_purchases] as s
INNER JOIN [dbo].[dim_volume_agreements] as va
	ON s.[volume_agreement_id] = va.[volume_agreement_id]
WHERE va.[is_all_apt] = 1 --Отчет по всем аптекам
OR ([is_apt_in_list] = CONVERT(bit, 1)--Аптека в списке
AND [is_manufacturer_contract] = CONVERT(bit, 0))--Удаляем прямые контракты

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_date]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_date](
	[date_id] [int] NOT NULL,
	[date_time] [datetime] NOT NULL,
	[date_name] [char](10) COLLATE Cyrillic_General_CI_AS NULL,
	[day_type_id] [int] NULL,
	[day_type_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[weekday_number] [int] NULL,
	[weekday_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[week_id] [int] NULL,
	[week_name] [char](9) COLLATE Cyrillic_General_CI_AS NULL,
	[week_full_name] [char](14) COLLATE Cyrillic_General_CI_AS NULL,
	[week_number] [int] NULL,
	[month_id] [int] NULL,
	[month_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[month_full_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[month_number] [int] NULL,
	[quarter_id] [int] NULL,
	[quarter_name] [char](9) COLLATE Cyrillic_General_CI_AS NULL,
	[quarter_full_name] [char](14) COLLATE Cyrillic_General_CI_AS NULL,
	[year_id] [int] NULL,
	[year_name] [char](4) COLLATE Cyrillic_General_CI_AS NULL,
 CONSTRAINT [PK_dim_date] PRIMARY KEY CLUSTERED 
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_supplier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_supplier](
	[supplier_id] [int] NOT NULL,
	[initial_id] [int] NOT NULL,
	[descr] [nvarchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[table_row_guid] [uniqueidentifier] NOT NULL,
	[full_name] [nvarchar](500) COLLATE Cyrillic_General_CI_AS NULL,
	[phone] [nvarchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[email] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[address] [nvarchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[is_active] [int] NULL,
	[inn] [nvarchar](30) COLLATE Cyrillic_General_CI_AS NULL,
	[region] [nvarchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[legal_entity] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[fact_address] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[block_date] [datetime] NULL,
	[union_atr_name] [varchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[city] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[dt_row] [datetime] NULL,
	[ld_nm] [varchar](2) COLLATE Cyrillic_General_CI_AS NULL,
	[mdf_dt] [datetime] NULL,
	[mdf_user_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[region_code] [nvarchar](3) COLLATE Cyrillic_General_CI_AS NULL,
	[is_checked] [int] NULL,
 CONSTRAINT [PK_Dim_Supplier] PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_good]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_good](
	[good_id] [int] NOT NULL,
	[table_row_guid] [char](255) COLLATE Cyrillic_General_CI_AS NULL,
	[initial_id] [int] NULL,
	[descr] [nvarchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[country] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[claster] [nvarchar](500) COLLATE Cyrillic_General_CI_AS NULL,
	[paking] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[concern] [nvarchar](300) COLLATE Cyrillic_General_CI_AS NULL,
	[brand] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[trade_mark] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[form] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[dosage] [nvarchar](300) COLLATE Cyrillic_General_CI_AS NULL,
	[pre_packing] [nvarchar](300) COLLATE Cyrillic_General_CI_AS NULL,
	[mnn] [nvarchar](1024) COLLATE Cyrillic_General_CI_AS NULL,
	[form_out] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_vital] [bit] NULL,
	[goods_type] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[mega_cat] [varchar](13) COLLATE Cyrillic_General_CI_AS NULL,
	[with_codein] [bit] NULL,
	[pku_group] [bit] NULL,
	[properties] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[vat] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[application] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[is_actual] [bit] NULL,
	[claster_id] [int] NULL,
	[goods_group] [int] NULL,
	[is_hospital] [bit] NULL,
	[megs_cat] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[cat] [nvarchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[cpe] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[concern_id] [int] NULL,
	[rb_mnn] [varchar](1024) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_cpe] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_brend_or_mnn] [varchar](5) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_lef_form] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_dosage] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_fasov] [varchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_cpe_top_concern] [int] NULL,
	[rb_megs_cat] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[id_1c_dwh] [int] NULL,
	[rb_sposob_prim] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_zhnvls] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_nds] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_with_kodein] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_concern] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_manufacturer] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_category] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_claster] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_sub_group] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_brend] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_trade_mark] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_invest] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_bezdefectur] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[application_area_id] [int] NULL,
	[application_area_name] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[group_products_id] [int] NULL,
	[group_products_name] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[manufacturer_m_id] [int] NULL,
	[manufacturer_m_name] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[goods_group_name] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_brend_id] [int] NULL,
	[rb_claster_id] [int] NULL,
	[pku_group_rus] [varchar](16) COLLATE Cyrillic_General_CI_AS NULL,
	[with_codein_rus] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL,
	[is_vit_rus] [varchar](8) COLLATE Cyrillic_General_CI_AS NULL,
	[is_hospital_rus] [varchar](15) COLLATE Cyrillic_General_CI_AS NULL,
	[is_actual_rus] [varchar](13) COLLATE Cyrillic_General_CI_AS NULL,
	[manufacturer_id] [int] NULL,
	[manufacturer_name] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[vat_id] [int] NULL,
 CONSTRAINT [PK_dim_good] PRIMARY KEY CLUSTERED 
(
	[good_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_apt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_apt](
	[apt_id] [int] NOT NULL,
	[unit_id] [int] NULL,
	[unitInitial_id] [int] NULL,
	[unit_descr] [nvarchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_full_name] [nvarchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_phone] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_is_active_id] [int] NULL,
	[unit_is_active_name] [nvarchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[unitInn] [nvarchar](30) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_net_id] [int] NULL,
	[unit_net_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_net_status_id] [int] NULL,
	[unit_net_status_name] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_region_id] [int] NULL,
	[unit_region_name] [nvarchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_legal_entity] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_fact_address] [nvarchar](400) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_legal_entity_cc] [numeric](18, 4) NULL,
	[unit_contragent_marketing_date] [date] NULL,
	[unit_cll_pref] [nvarchar](20) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_lb_fa] [nvarchar](658) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_city] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_for_analysis_marketing_id] [bit] NULL,
	[unit_for_analysis_marketing_name] [varchar](3) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_apt_type_id] [int] NULL,
	[unit_apt_type_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_cntr_id] [int] NULL,
	[unit_cntr_name] [nvarchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_block_date] [datetime] NULL,
	[aptInitial_id] [bigint] NULL,
	[apt_descr] [nvarchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_full_name] [nvarchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_phone] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_Is_active_id] [tinyint] NULL,
	[apt_Is_active_name] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[aptInn] [nvarchar](30) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_net_id] [int] NULL,
	[apt_net_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_net_status_id] [int] NULL,
	[apt_net_status_name] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_region_id] [int] NULL,
	[apt_region_name] [nvarchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_legal_entity] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_fact_address] [nvarchar](400) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_legal_entity_cc] [numeric](18, 4) NULL,
	[apt_contragent_marketing_date] [int] NULL,
	[apt_clip_ref] [nvarchar](20) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_lb_fa] [nvarchar](658) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_city] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_apt_type_id] [int] NULL,
	[apt_apt_type_name] [nvarchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_cntr_id] [int] NULL,
	[apt_cntr_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_block_date] [datetime] NULL,
 CONSTRAINT [PK_dim_apt] PRIMARY KEY CLUSTERED 
(
	[apt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_auto_fct_report_purchases]'))
EXEC dbo.sp_executesql @statement = N'



CREATE VIEW [dbo].[v_auto_fct_report_purchases] as 
--Выборка для автоформирования отчета внутреннего (используются все поля)
SELECT 	
	r.[volume_agreement_id] as [volume_agreement_id]
	,convert(nvarchar(150), a.[unit_descr]) as [purchases_dim_apt_unit_descr]
	,convert(nvarchar(400), a.[unit_fact_address]) as [purchases_dim_apt_unit_fact_address]
	,convert(nvarchar(15), a.[unitInn]) as [purchases_dim_apt_unitInn]
	,convert(nvarchar(255), a.[unit_legal_entity]) as [purchases_dim_apt_unit_legal_entity]
	,convert(nvarchar(20), a.[unit_cll_pref]) as [purchases_dim_apt_unit_cll_pref]
	,convert(nvarchar(255), a.[unit_net_name]) as [purchases_dim_apt_unit_net_name]
	,convert(nvarchar(100), a.[unit_region_name]) as [purchases_dim_apt_unit_region_name]
	,convert(nvarchar(250), s.[descr]) as [purchases_dim_supplier_descr]
	,convert(nvarchar(250), s.[inn]) as [purchases_dim_supplier_inn]
	,convert(nvarchar(250), g.[descr]) as [purchases_dim_good_descr]
	,g.[initial_id] as [purchases_dim_good_initial_id]
	,r.[date_id]
	,d.[year_id] as [purchases_dim_date_year_id]
	,convert(nvarchar(255), d.[month_name]) as [purchases_dim_date_month_name]
	,convert(nvarchar, iif(r.[is_apt_in_list] = 1, ''Да'', ''Нет'')) as [purchases_dim_is_apt_in_list]
	,convert(nvarchar, iif(r.[is_manufacturer_contract] = 1, ''Да'', ''Нет'')) as [purchases_dim_is_manufacturer_contract]
	,convert(nvarchar, iif(r.[is_distributor_limitation] = 1, ''Да'', ''Нет'')) as [purchases_dim_is_distributor_limitation]
	,convert(nvarchar, gr.[volume_agreement_group]) as [purchases_dim_volume_agreement_group]
	,iif(r.[qty] = 0, null, r.[qty]) as [purchases_fct_report_purchases_qty]
	,iif(r.[purch_net] = 0, null, r.[purch_net]) as [purchases_fct_report_purchases_purch_net]
	,iif(r.[purch_grs] = 0, null, r.[purch_grs]) as [purchases_fct_report_purchases_purch_grs]
	,iif(r.[purch_cip] = 0, null, r.[purch_cip]) as [purchases_fct_report_purchases_purch_cip]
	,iif(r.[price_cip] = 0, null, r.[price_cip]) as [purchases_dim_report_purchases_price_cip]--[purchases_fct_report_purchases_price_cip]	
FROM [dbo].[v_olap_fct_report_purchases] as r
LEFT JOIN [dbo].[dim_apt] as a 
	ON r.[apt_id] = a.[apt_id]
LEFT JOIN [dbo].[dim_supplier] as s
	ON r.[supplier_id] = s.[supplier_id]
LEFT JOIN [dbo].[dim_good] as g
	ON r.[good_id] = g.[good_id]
LEFT JOIN [dbo].[dim_date] as d 
	ON r.[date_id] = d.[date_id]
LEFT JOIN [dbo].[dim_volume_agreement_group] as gr
	ON r.[volume_agreement_group_id] = gr.[volume_agreement_group_id]
WHERE 
	isnull(r.[qty], 0) > 0
	OR isnull(r.[purch_net], 0) > 0
	OR isnull(r.[purch_grs], 0) > 0
	OR isnull(r.[purch_cip], 0) > 0

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_manufacturer]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_manufacturer](
	[manufacturer_id] [int] IDENTITY(1,1) NOT NULL,
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_manufacturer]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[v_olap_dim_manufacturer] 
as 
SELECT 
	[manufacturer_id]
	,[manufacturer]
FROM [dbo].[dim_manufacturer]

UNION ALL

SELECT 
	-1 as [manufacturer_id]
	,''Н/Д'' as [manufacturer]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_sources]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_sources](
	[source_id] [int] IDENTITY(1,1) NOT NULL,
	[source] [nvarchar](64) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dim_sources]') AND name = N'ix_cl_source_id_dim_sources')
CREATE CLUSTERED INDEX [ix_cl_source_id_dim_sources] ON [dbo].[dim_sources]
(
	[source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_sources]'))
EXEC dbo.sp_executesql @statement = N'

CREATE view [dbo].[v_olap_dim_sources]
as 
SELECT 
	[source_id]
	,[source]
FROM [dbo].[dim_sources]

UNION ALL

SELECT 
	-1 as [source_id]
	,''Н/Д'' as [source]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_volume_agreement_group]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[v_olap_dim_volume_agreement_group] as 

SELECT [volume_agreement_group_id]
      ,[volume_agreement_group]
  FROM [dbo].[dim_volume_agreement_group]

UNION ALL

SELECT -1 as [volume_agreement_group_id]
      ,''Н/Д'' as [volume_agreement_group]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_volume_agreements]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[v_olap_dim_volume_agreements] as 
SELECT [volume_agreement_id]
      ,[volume_agreement_source_id]
      ,[manufacturer]
      ,[manager_FIO]
      ,[period]
      ,[price_type]
      ,[channel]
      ,[list_type]
  FROM [dbo].[dim_volume_agreements]

UNION ALL

SELECT -1 as [volume_agreement_id]
      ,-1 as [volume_agreement_source_id]
      ,''Н/Д'' as [manufacturer]
      ,''Н/Д'' as [manager_FIO]
      ,''Н/Д'' as [period]
      ,''Н/Д'' as [price_type]
      ,''Н/Д'' as [channel]
      ,''Н/Д'' as [list_type]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_supplier]'))
EXEC dbo.sp_executesql @statement = N'




CREATE view [dbo].[v_olap_dim_supplier]
as
SELECT [supplier_id]
	,[initial_id]
	,[descr]
	,[full_name]
	,[phone]
	,[email]
	,[address]
	,[is_active]
	,[inn]
	,[region]
	,[legal_entity]
	,[fact_address]
	,[block_date]
	,[union_atr_name]
	,[city]
	,[dt_row]
	,[ld_nm]
	,[mdf_dt]
	,[mdf_user_name]
	,[region_code]
FROM [dbo].[dim_supplier]

UNION ALL

SELECT -1 as [supplier_id]
      ,-1 as [initial_id]
      ,''Н/Д'' as [descr]
      ,''Н/Д'' as [full_name]
      ,''Н/Д'' as [phone]
      ,''Н/Д'' as [email]
      ,''Н/Д'' as [address]
      ,-1 as [is_active]
      ,''Н/Д'' as [inn]
      ,''Н/Д'' as [region]
      ,''Н/Д'' as [legal_entity]
      ,''Н/Д'' as [fact_address]
      ,''1900.01.01 00:00:00.000'' as [block_date]
      ,''Н/Д'' as [union_atr_name]
      ,''Н/Д'' as [city]
      ,''1900.01.01 00:00:00.000'' as [dt_row]
      ,''Н/Д'' as [ld_nm]
      ,''1900.01.01 00:00:00.000'' as [mdf_dt]
      ,''Н/Д'' as [mdf_user_name]
      ,''Н/Д'' as [region_code]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_partner_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_partner_purchases](
	[apt_id] [int] NULL,
	[supplier_id] [int] NULL,
	[good_id] [int] NULL,
	[date_id] [int] NULL,
	[purch_grs] [money] NULL,
	[purch_net] [money] NULL,
	[qty] [money] NULL,
	[invoice_id] [int] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_partner_purchases]') AND name = N'ix_cl_date_id_partner_purchases')
CREATE CLUSTERED INDEX [ix_cl_date_id_partner_purchases] ON [dbo].[fct_partner_purchases]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_partner_purchases]'))
EXEC dbo.sp_executesql @statement = N'

CREATE view [dbo].[v_olap_fct_partner_purchases] 
as
SELECT [apt_id]
      ,ISNULL(s.[supplier_id], 0) as [supplier_id]
      ,[good_id]
      ,[date_id]
      ,[purch_grs]
      ,[purch_net]
      ,[qty]
FROM [dbo].[fct_partner_purchases] as f
LEFT JOIN [dbo].[v_olap_dim_supplier] as s
	ON f.[supplier_id] = s.[supplier_id]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_partner_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_partner_sales](
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[date_id] [int] NULL,
	[sale_grs] [money] NULL,
	[sale_net] [money] NULL,
	[qty] [money] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_partner_sales]') AND name = N'ix_cl_date_id_partner_sales')
CREATE CLUSTERED INDEX [ix_cl_date_id_partner_sales] ON [dbo].[fct_partner_sales]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_partner_sales]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[v_olap_fct_partner_sales] as
SELECT [apt_id]
      ,[good_id]
      ,[date_id]
      ,[sale_grs]
      ,[sale_net]
      ,[qty]
  FROM [dbo].[fct_partner_sales]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_statistician_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_statistician_purchases](
	[apt_id] [int] NULL,
	[supplier_id] [int] NULL,
	[good_id] [int] NULL,
	[date_id] [int] NULL,
	[purch_grs] [money] NULL,
	[purch_net] [money] NULL,
	[qty] [money] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_statistician_purchases]') AND name = N'ix_cl_date_id_statistician_purchases')
CREATE CLUSTERED INDEX [ix_cl_date_id_statistician_purchases] ON [dbo].[fct_statistician_purchases]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_statistician_purchases]'))
EXEC dbo.sp_executesql @statement = N'

CREATE view [dbo].[v_olap_fct_statistician_purchases] as 
SELECT [apt_id]
      ,ISNULL(s.[supplier_id], 0) as [supplier_id]
      ,[good_id]
      ,[date_id]
      ,[purch_grs]
      ,[purch_net]
      ,[qty]
FROM [dbo].[fct_statistician_purchases] as f
LEFT JOIN [dbo].[v_olap_dim_supplier] as s
	ON f.[supplier_id] = s.[supplier_id]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_statistician_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_statistician_sales](
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[date_id] [int] NULL,
	[sale_grs] [money] NULL,
	[sale_net] [money] NULL,
	[qty] [money] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_statistician_sales]') AND name = N'ix_cl_date_id_statistician_sales')
CREATE CLUSTERED INDEX [ix_cl_date_id_statistician_sales] ON [dbo].[fct_statistician_sales]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_statistician_sales]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[v_olap_fct_statistician_sales] as
SELECT [apt_id]
      ,[good_id]
      ,[date_id]
      ,[sale_grs]
      ,[sale_net]
      ,[qty]
  FROM [dbo].[fct_statistician_sales]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_report_sales](
	[source_id] [int] NOT NULL,
	[volume_agreement_id] [int] NOT NULL,
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[manufacturer_id] [int] NULL,
	[volume_agreement_group_id] [int] NULL,
	[is_apt_in_list] [bit] NULL,
	[is_manufacturer_contract] [bit] NULL,
	[qty] [money] NULL,
	[sale_net] [money] NULL,
	[sale_grs] [money] NULL,
	[price_cip] [money] NULL,
	[sale_cip] [money] NULL,
	[sales_channel_id] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_sales]') AND name = N'ix_cl_date_id_fct_report_sales')
CREATE CLUSTERED INDEX [ix_cl_date_id_fct_report_sales] ON [dbo].[fct_report_sales]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_report_sales]'))
EXEC dbo.sp_executesql @statement = N'









CREATE view [dbo].[v_olap_fct_report_sales] as 
SELECT 
	s.[source_id]
	,s.[volume_agreement_id]
	,s.[date_id]
	,s.[apt_id]
	,s.[good_id]
	,s.[manufacturer_id]
	,s.[volume_agreement_group_id]
    ,s.[is_apt_in_list]
    ,s.[is_manufacturer_contract]
	,s.[qty]
	,s.[sale_net]
	,s.[sale_grs]
	,s.[price_cip]
	,s.[sale_cip]
	,isnull(s.[sales_channel_id], -1) as [sales_channel_id]
FROM [dbo].[fct_report_sales] as s
INNER JOIN [dbo].[dim_volume_agreements] as va
	ON s.[volume_agreement_id] = va.[volume_agreement_id]
WHERE 
	(va.[is_all_apt] = 1 --Отчет по всем аптекам
		OR (s.[is_apt_in_list] = CONVERT(bit, 1)--Аптека в списке
			AND s.[is_manufacturer_contract] = CONVERT(bit, 0)
		)--Удаляем прямые контракты
	) 
	AND
	--(va.[is_till_channel] = 0 --Отчет по всем каналам
	--	 OR (s.[sales_channel_id] = 1 --Код канала "Касса"
	--		AND (s.[source_id] = 1 OR s.[source_id] = 4))--фильтруется только по Хранилище АСНА и Добавочные движения
	--)
	(va.[is_till_channel] = 0 --Отчет по всем каналам
		 OR s.[sales_channel_id] IN (1, -100, -101) --Код канала "Касса"--Партнеры--Cтатисты
	)


' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[BICubes]') AND type in (N'U'))
BEGIN
CREATE TABLE [oth].[BICubes](
	[CubeId] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[CubeName] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[Description] [nvarchar](max) COLLATE Cyrillic_General_CI_AS NULL,
 CONSTRAINT [PK_lasmart_t_work_BICube] PRIMARY KEY CLUSTERED 
(
	[CubeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[MeasureGroups]') AND type in (N'U'))
BEGIN
CREATE TABLE [oth].[MeasureGroups](
	[CubeId] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[MeasureGroupId] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[MeasureGroupName] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[Description] [nvarchar](max) COLLATE Cyrillic_General_CI_AS NULL,
	[DataSourceId] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
 CONSTRAINT [PK_lasmart_t_work_MeasureGroup] PRIMARY KEY CLUSTERED 
(
	[CubeId] ASC,
	[MeasureGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[MeasureGroupSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [oth].[MeasureGroupSettings](
	[CubeId] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[MeasureGroupId] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[Partitioned] [bit] NOT NULL,
	[Period] [nvarchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[PartitionPrefix] [nvarchar](128) COLLATE Cyrillic_General_CI_AS NULL,
	[SQLQuery] [nvarchar](500) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[Lag] [int] NULL,
	[Lead] [int] NULL,
	[PartitionSlice] [nvarchar](500) COLLATE Cyrillic_General_CI_AS NULL,
 CONSTRAINT [PK_lasmart_t_work_MeasureGroupSettings] PRIMARY KEY CLUSTERED 
(
	[CubeId] ASC,
	[MeasureGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[oth].[olap_processing]'))
EXEC dbo.sp_executesql @statement = N'



CREATE view [oth].[olap_processing] as 

with PeriodTabLag as ( 
					select 
						''Month'' as [Period],
						month_id as [PeriodId],
						cast(year([date_time]) as nvarchar (20)) + '' '' + right(''0''+cast(Month([date_time]) as nvarchar (20)),2) as [PeriodName],
						ROW_NUMBER()OVER ( order by month_id desc) as RNPeriod,
						min(date_id) as TimeMinId,
						max(date_id) as TimeMaxId
					from dim_date
					where [date_time] <= eomonth(cast(getdate() as date))
					group by month_id,
						cast(year([date_time]) as nvarchar (20)) + '' '' + right(''0''+cast(Month([date_time]) as nvarchar (20)),2)

					union all

					select 
						''Quarter'' as [Period],
						quarter_id as [PeriodId],
						cast(year(date_time) as nvarchar (20)) + '' '' + cast(datepart(qq, (date_time)) as nvarchar (20)) as [PeriodName],
						ROW_NUMBER()OVER ( order by quarter_id desc) as RNPeriod,
						min(date_id) as TimeMinId,
						max(date_id) as TimeMaxId
					from dim_date
					where [date_time] <= DATEADD(QQ, DATEDIFF(QQ,0,getdate()) + 1, -1) 
					group by quarter_id,
						cast(year(date_time) as nvarchar (20)) + '' '' + cast(datepart(qq, (date_time)) as nvarchar (20))
					
					union all

					select 
						''Year'' as [Period],
						year_id as [PeriodId],
						cast(year_id as nvarchar (20)) as [PeriodName],
						ROW_NUMBER()OVER ( order by year_id desc) as RNPeriod,
						min(date_id) as TimeMinId,
						max(date_id) as TimeMaxId
					from dim_date
					where [date_time] <= DATEADD(yy, DATEDIFF(yy,0,getdate()) + 1, -1) 
					group by year_id,
						cast(year_id as nvarchar (20))
				  ),
	PeriodTabLead as ( 
					select 
						''Month'' as [Period],
						month_id as [PeriodId],
						cast(year([date_time]) as nvarchar (20)) + '' '' + right(''0''+cast(Month([date_time]) as nvarchar (20)),2) as [PeriodName],
						ROW_NUMBER()OVER ( order by month_id asc) -1 as RNPeriod,
						min(date_id) as TimeMinId,
						max(date_id) as TimeMaxId
					from dim_date
					where [date_time] >= dateadd(month,datediff(month,0,GetDate()),0) 
						
					group by month_id,
						cast(year([date_time]) as nvarchar (20)) + '' '' + right(''0''+cast(Month([date_time]) as nvarchar (20)),2)
					
					union all

					select 
						''Quarter'' as [Period],
						quarter_id as [PeriodId],
						cast(quarter_full_name as nvarchar (20)) as [PeriodName],
						ROW_NUMBER()OVER ( order by quarter_id asc) -1 as RNPeriod,
						min(date_id) as TimeMinId,
						max(date_id) as TimeMaxId
					from dim_date
					where [date_time] >= dateadd(QQ, datediff(QQ, 0, getdate()), 0)
					group by quarter_id,
						cast(quarter_full_name as nvarchar (20))

					union all

					select 
						''Year'' as [Period],
						year_id as [PeriodId],
						cast(year_id as nvarchar (20)) as [PeriodName],
						ROW_NUMBER()OVER ( order by year_id asc) -1 as RNPeriod,
						min(date_id) as TimeMinId,
						max(date_id) as TimeMaxId
					from dim_date
					where [date_time] >= dateadd(yy, datediff(yy, 0, getdate()), 0)
					group by year_id,
						cast(year_id as nvarchar (20))
				  )

--select top 100 percent *
--from
--( 
select
		MS.[CubeId] as [CubeId], 
		MS.[MeasureGroupId] as [MeasureGroupId], 
		C.[CubeName] as [Cube], 
		MG.MeasureGroupName as  [MeasureGroup], 
		MG.[DataSourceId] as [DataSourceId], 
		[PartitionPrefix]+'' ''+ pt.[PeriodName] as [Partition], 
		convert(nvarchar(10),pt.TimeMinId) as TimeMinId, 
		convert(nvarchar(10),pt.TimeMaxId) as TimeMaxId,
		MS.[SQLQuery] as [SQLQuery],
		REPLACE(ms.PartitionSlice,''@SliceKey'',cast(pt.[PeriodId] as nvarchar(10)))  as PartitionSlice
from [oth].[MeasureGroupSettings] MS (nolock)
join [oth].[BICubes] C (nolock) 
	on MS.CubeId = C.CubeId
join [oth].[MeasureGroups] MG (nolock) 
	on MS.CubeId = MG.CubeId 
		and MS.MeasureGroupId= MG.MeasureGroupId
join PeriodTabLag as pt
	on pt.[Period] = ms.[Period]
		and pt.[RNPeriod] <= ms.Lag

union		

select
		MS.[CubeId], 
		MS.[MeasureGroupId], 
		C.[CubeName] as [Cube], 
		MG.MeasureGroupName as  [MeasureGroup], 
		MG.[DataSourceId] as [DataSourceId], 
		[PartitionPrefix]+'' ''+ pt.[PeriodName] as [Partition], 
		convert(nvarchar(10),pt.TimeMinId) as TimeMinId, 
		convert(nvarchar(10),pt.TimeMaxId) as TimeMaxId,
		cast(MS.[SQLQuery]as nvarchar(255)) as [SQLQuery],
		cast(REPLACE(ms.PartitionSlice,''@SliceKey'',cast(pt.[PeriodId] as nvarchar)) as nvarchar(255)) as PartitionSlice
from [oth].[MeasureGroupSettings] MS (nolock)
join [oth].[BICubes] C (nolock) 
	on MS.CubeId = C.CubeId
join [oth].[MeasureGroups] MG (nolock) 
	on MS.CubeId = MG.CubeId 
		and MS.MeasureGroupId= MG.MeasureGroupId
join PeriodTabLead as pt
	on pt.[Period] = ms.[Period]
		and ms.Lead >= pt.[RNPeriod]
			and ms.Lead != 0 --) as t
--order by MeasureGroupId -- упорядочивание сделано на уровне select запроса из представления в пакете
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_good]'))
EXEC dbo.sp_executesql @statement = N'






 CREATE view [dbo].[v_olap_dim_good]
--Shemetov I.V. 2018-09-20
as

SELECT 
       [good_id]
      ,ISNULL([initial_id], -1) [initial_id]
      ,ISNULL([descr], '''') as  [descr]
      ,ISNULL([country], '''') as  [country]
      ,ISNULL([claster], '''') as  [claster]
      ,ISNULL([paking], '''') as  [paking]
      ,ISNULL([concern], '''') as  [concern]
      ,ISNULL([brand], '''') as  [brand]
      ,ISNULL([trade_mark], '''') as  [trade_mark]
      ,ISNULL([form], '''') as  [form]
      ,ISNULL([dosage], '''') as  [dosage]
      ,ISNULL([pre_packing], '''') as  [pre_packing]
      ,ISNULL([mnn], '''') as  [mnn]
      ,ISNULL([form_out], '''') as  [form_out]
      ,ISNULL([is_vital], convert(bit, 0)) as  [is_vital]
      ,ISNULL([goods_type], '''') as  [goods_type]
      ,ISNULL([mega_cat], '''') as  [mega_cat]
      ,ISNULL([with_codein], convert(bit, 0)) as  [with_codein]
      ,ISNULL([pku_group], convert(bit, 0)) as  [pku_group]
      ,ISNULL([properties], '''') as  [properties]
      ,ISNULL([vat], '''') as  [vat]
      ,ISNULL([application], '''') as  [application]
      ,ISNULL([is_actual], convert(bit, 0)) as  [is_actual]
      ,ISNULL([claster_id], -1) [claster_id]
      ,ISNULL([goods_group], -1) as  [goods_group]
      ,ISNULL([is_hospital], convert(bit, 0)) as  [is_hospital]
      ,ISNULL([megs_cat], '''') as  [megs_cat]
      ,ISNULL([cat], '''') as  [cat]
      ,ISNULL([cpe], '''') as  [cpe]
      ,ISNULL([concern_id], -1) [concern_id]
      ,ISNULL([rb_mnn], '''') as  [rb_mnn]
      ,ISNULL([rb_cpe], '''') as  [rb_cpe]
      ,ISNULL([rb_brend_or_mnn], '''') as  [rb_brend_or_mnn]
      ,ISNULL([rb_lef_form], '''') as  [rb_lef_form]
      ,ISNULL([rb_dosage], '''') as  [rb_dosage]
      ,ISNULL([rb_fasov], '''') as  [rb_fasov]
      ,ISNULL([rb_cpe_top_concern], -1) as  [rb_cpe_top_concern]
      ,ISNULL([rb_megs_cat], '''') as  [rb_megs_cat]
      ,ISNULL([id_1c_dwh], -1) as  [id_1c_dwh]
      ,ISNULL([rb_sposob_prim], '''') as  [rb_sposob_prim]
      ,ISNULL([rb_zhnvls], '''') as  [rb_zhnvls]
      ,ISNULL([rb_nds], '''') as  [rb_nds]
      ,ISNULL([rb_with_kodein], '''') as  [rb_with_kodein]
      ,ISNULL([rb_concern], '''') as  [rb_concern]
      ,ISNULL([rb_manufacturer], '''') as  [rb_manufacturer]
      ,ISNULL([rb_category], '''') as  [rb_category]
      ,ISNULL([rb_claster], '''') as  [rb_claster]
      ,ISNULL([rb_sub_group], '''') as  [rb_sub_group]
      ,ISNULL([rb_brend], '''') as  [rb_brend]
      ,ISNULL([rb_trade_mark], '''') as  [rb_trade_mark]
      ,ISNULL([rb_invest], '''') as  [rb_invest]
      ,ISNULL([rb_bezdefectur], '''') as  [rb_bezdefectur]
      ,ISNULL([application_area_id], -1) [application_area_id]
      ,ISNULL([application_area_name], '''') as  [application_area_name]
      ,ISNULL([group_products_id], -1) [group_products_id]
      ,ISNULL([group_products_name], '''') as  [group_products_name]
      ,ISNULL([manufacturer_m_id], -1) [manufacturer_m_id]
      ,ISNULL([manufacturer_m_name], '''') as  [manufacturer_m_name]
      ,ISNULL([goods_group_name], '''') as  [goods_group_name]
      ,ISNULL([rb_brend_id], -1) [rb_brend_id]
      ,ISNULL([rb_claster_id], -1) [rb_claster_id]
      ,ISNULL([pku_group_rus], '''') as  [pku_group_rus]
      ,ISNULL([with_codein_rus], '''') as  [with_codein_rus]
      ,ISNULL([is_vit_rus], '''') as  [is_vit_rus]
      ,ISNULL([is_hospital_rus], '''') as  [is_hospital_rus]
      ,ISNULL([is_actual_rus], '''') as  [is_actual_rus]
      ,ISNULL([manufacturer_id], -1) [manufacturer_id]
      ,ISNULL(rtrim(ltrim(replace(replace(replace([manufacturer_name],char(9),''''),char(10),''''),char(13),''''))),'''') as [manufacturer_name]
  FROM [dbo].[dim_good] (nolock)

  union all
  
  select
  	-1 as [good_id],
	-1 as [initial_id],
	''нет данных'' as [descr],
	''нет данных'' as [country],
	''нет данных'' as [claster],
	''нет данных'' as [paking],
	''нет данных'' as [concern],
	''нет данных'' as [brand],
	''нет данных'' as [trade_mark],
	''нет данных'' as [form],
	''нет данных'' as [dosage],
	''нет данных'' as [pre_packing],
	''нет данных'' as [mnn],
	''нет данных'' as [form_out],
	convert(bit, 0) as  [is_vital],
	''нет данных'' as [goods_type],
	''нет данных'' as [mega_cat],
	convert(bit, 0) as  [with_codein],
	convert(bit, 0) as  [pku_group],
	''нет данных'' as [properties],
	''нет данных'' as [vat],
	''нет данных'' as [application],
	convert(bit, 0) as  [is_actual],
	-1 as [claster_id],
	-1 as [goods_group],
	convert(bit, 0) as  [is_hospital],
	''нет данных'' as [megs_cat],
	''нет данных'' as [cat],
	''нет данных'' as [cpe],
	-1 as [concern_id],
	''нет данных'' as [rb_mnn],
	''нет данных'' as [rb_cpe],
	''н/д'' as [rb_brend_or_mnn],
	''нет данных'' as [rb_lef_form],
	''нет данных'' as [rb_dosage],
	''нет данных'' as [rb_fasov],
	-1 as [rb_cpe_top_concern],
	''нет данных'' as [rb_megs_cat],
	-1 as [id_1c_dwh],
	''нет данных'' as [rb_sposob_prim],
	''нет данных'' as [rb_zhnvls],
	''нет данных'' as [rb_nds],
	''нет данных'' as [rb_with_kodein],
	''нет данных'' as [rb_concern],
	''нет данных'' as [rb_manufacturer],
	''нет данных'' as [rb_category],
	''нет данных'' as [rb_claster],
	''нет данных'' as [rb_sub_group],
	''нет данных'' as [rb_brend],
	''нет данных'' as [rb_trade_mark],
	''н/д'' as [rb_invest],
	''нет данных'' as [rb_bezdefectur],
	-1 as [application_area_id],
	''нет данных'' as [application_area_name],
	-1 as [group_products_id],
	''нет данных'' as [group_products_name],
	-1 as [manufacturer_m_id],
	''нет данных'' as [manufacturer_m_name],
	''нет данных'' as [goods_group_name],
	-1 as [rb_brend_id],
	-1 as [rb_claster_id],
	''нет данных'' as [pku_group_rus],
	''нет данных'' as [with_codein_rus],
	''н/д'' as [is_vit_rus],
	''нет данных'' as [is_hospital_rus],
	''нет данных'' as [is_actual_rus],
	-1 as [manufacturer_id],
	''нет данных'' as [manufacturer_name]
	
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_apt]'))
EXEC dbo.sp_executesql @statement = N'








 CREATE view [dbo].[v_olap_dim_apt]
--Shemetov I.V. 2018-09-21
as
SELECT 
	   [apt_id]
      ,ISNULL([unit_id],0) as [unit_id]
      ,ISNULL([unitInitial_id],0) as [unitInitial_id]
      ,ISNULL([unit_descr],'''') as [unit_descr]
      ,ISNULL([unit_full_name],'''') as [unit_full_name]
      ,ISNULL([unit_phone],'''') as [unit_phone]
      ,ISNULL([unit_is_active_id],0) as [unit_is_active_id]
      ,ISNULL([unit_is_active_name],'''') as [unit_is_active_name]
      ,ISNULL([unitInn],'''') as [unitInn]
      ,ISNULL([unit_net_id],0) as [unit_net_id]
      ,ISNULL([unit_net_name],'''') as [unit_net_name]
      ,ISNULL([unit_net_status_id],0) as [unit_net_status_id]
      ,ISNULL([unit_net_status_name],'''') as [unit_net_status_name]
      ,ISNULL([unit_region_id],0) as [unit_region_id]
      ,ISNULL([unit_region_name],'''') as [unit_region_name]
      ,ISNULL([unit_legal_entity],'''') as [unit_legal_entity]
      ,ISNULL([unit_fact_address],'''') as [unit_fact_address]
      ,ISNULL([unit_legal_entity_cc],0.0) as [unit_legal_entity_cc]
      ,ISNULL([unit_contragent_marketing_date],convert(date,''1900.01.01 00:00:00.000'')) as [unit_contragent_marketing_date]
      ,ISNULL([unit_cll_pref],'''') as [unit_cll_pref]
      ,ISNULL([unit_lb_fa],'''') as [unit_lb_fa]
      ,ISNULL([unit_city],'''') as [unit_city]
      ,ISNULL([unit_for_analysis_marketing_id],convert(bit, 0)) as [unit_for_analysis_marketing_id]
      ,ISNULL([unit_for_analysis_marketing_name],'''') as [unit_for_analysis_marketing_name]
      ,ISNULL([unit_apt_type_id],0) as [unit_apt_type_id]
      ,ISNULL([unit_apt_type_name],'''') as [unit_apt_type_name]
      ,ISNULL([unit_cntr_id],0) as [unit_cntr_id]
      ,ISNULL([unit_cntr_name],'''') as [unit_cntr_name]
      ,ISNULL([unit_block_date],convert(datetime,''1900.01.01'')) as [unit_block_date]
      ,ISNULL([aptInitial_id],0) as [aptInitial_id]
      ,ISNULL([apt_descr],'''') as [apt_descr]
      ,ISNULL([apt_full_name],'''') as [apt_full_name]
      ,ISNULL([apt_phone],'''') as [apt_phone]
      ,ISNULL([apt_Is_active_id],0) as [apt_Is_active_id]
      ,ISNULL([apt_Is_active_name],'''') as [apt_Is_active_name]
      ,ISNULL([aptInn],'''') as [aptInn]
      ,ISNULL([apt_net_id],0) as [apt_net_id]
      ,ISNULL([apt_net_name],'''') as [apt_net_name]
      ,ISNULL([apt_net_status_id],0) as [apt_net_status_id]
      ,ISNULL([apt_net_status_name],'''') as [apt_net_status_name]
      ,ISNULL([apt_region_id],0) as [apt_region_id]
      ,ISNULL([apt_region_name],'''') as [apt_region_name]
      ,ISNULL([apt_legal_entity],'''') as [apt_legal_entity]
      ,ISNULL([apt_fact_address],'''') as [apt_fact_address]
      ,ISNULL([apt_legal_entity_cc],0) as [apt_legal_entity_cc]
      ,ISNULL([apt_contragent_marketing_date], -1) as [apt_contragent_marketing_date]
      ,ISNULL([apt_clip_ref],'''') as [apt_clip_ref]
      ,ISNULL([apt_lb_fa],'''') as [apt_lb_fa]
      ,ISNULL([apt_city],'''') as [apt_city]
      ,ISNULL([apt_apt_type_id],0) as [apt_apt_type_id]
      ,ISNULL([apt_apt_type_name],'''') as [apt_apt_type_name]
      ,ISNULL([apt_cntr_id],0) as [apt_cntr_id]
      ,ISNULL([apt_cntr_name],'''') as [apt_cntr_name]
      ,ISNULL([apt_block_date],convert(datetime,''1900.01.01 00:00:00.000'')) as [apt_block_date]
  FROM [dbo].[dim_apt] (nolock)

  union all

  select
    -1 as [apt_id],
	-1 as [unit_id],
	-1 as [unitInitial_id],
	''нет данных'' as [unit_descr],
	''нет данных'' as [unit_full_name],
	''нет данных'' as [unit_phone],
	-1 as [unit_is_active_id],
	''нет данных'' as [unit_is_active_name],
	''нет данных'' as [unitInn],
	-1 as [unit_net_id],
	''нет данных'' as [unit_net_name],
	-1 as [unit_net_status_id],
	''нет данных'' as [unit_net_status_name] ,
	-1 as [unit_region_id],
	''нет данных'' as [unit_region_name],
	''нет данных'' as [unit_legal_entity],
	''нет данных'' as [unit_fact_address],
	 0.0 as [unit_legal_entity_cc],
	''1900.01.01'' as [unit_contragent_marketing_date],
	''нет данных'' as [unit_cll_pref],
	''нет данных'' as [unit_lb_fa],
	''нет данных'' as [unit_city],
	convert(bit, 0) as [unit_for_analysis_marketing_id],
	''н/д'' as [unit_for_analysis_marketing_name],
	-1 as [unit_apt_type_id],
	''нет данных'' as [unit_apt_type_name],
	-1 as [unit_cntr_id], 
	''нет данных'' as [unit_cntr_name],
	convert(date,''1900.01.01 00:00:00.000'') as [unit_block_date],
	-1 as [aptInitial_id],
	''нет данных'' as [apt_descr],
	''нет данных'' as [apt_full_name],
	''нет данных'' as [apt_phone],
	-1 as [apt_Is_active_id],
	''нет данных'' as [apt_Is_active_name],
	''нет данных'' as [aptInn],
	-1 as [apt_net_id],
	''нет данных'' as [apt_net_name],
	-1 as [apt_net_status_id],
	''нет данных'' as [apt_net_status_name],
	-1 as [apt_region_id],
	''нет данных'' as [apt_region_name],
	''нет данных'' as [apt_legal_entity],
	''нет данных'' as [apt_fact_address],
	 0.0 as [apt_legal_entity_cc],
	-1 as [apt_contragent_marketing_date],
	''нет данных'' as [apt_clip_ref],
	''нет данных'' as [apt_lb_fa],
	''нет данных'' as [apt_city],
	-1 as [apt_apt_type_id],
	''нет данных'' as [apt_apt_type_name],
	-1 as [apt_cntr_id],
	''нет данных'' as [apt_cntr_name],
	convert(datetime,convert(datetime,''1900.01.01 00:00:00.000'')) as [apt_block_date]

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_sales_channel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_sales_channel](
	[sales_channel_id] [int] NOT NULL,
	[descr] [nvarchar](50) COLLATE Cyrillic_General_CI_AS NULL,
 CONSTRAINT [PK_SalesChannel] PRIMARY KEY CLUSTERED 
(
	[sales_channel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_sales_channel]'))
EXEC dbo.sp_executesql @statement = N'


CREATE view [dbo].[v_olap_dim_sales_channel]
as
SELECT 
	[sales_channel_id]
	,[descr]
FROM [dbo].[dim_sales_channel]

UNION ALL 

SELECT
	-1 as [sales_channel_id]
	,''Н/Д'' as [descr]

UNION ALL 

SELECT
	-100 as [sales_channel_id]
	,''Партнеры'' as [descr]

UNION ALL 

SELECT
	-101 as [sales_channel_id]
	,''Статисты'' as [descr]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_auto_fct_report_sales]'))
EXEC dbo.sp_executesql @statement = N'

















CREATE VIEW [dbo].[v_auto_fct_report_sales] as 
--Выборка для автоформирования отчета внутреннего (используются все поля)
SELECT 	
	r.[volume_agreement_id] as [volume_agreement_id]
	,convert(nvarchar(150), a.[unit_descr]) as [sales_dim_apt_unit_descr]
	,convert(nvarchar(400), a.[unit_fact_address]) as [sales_dim_apt_unit_fact_address]
	,convert(nvarchar(15), a.[unitInn]) as [sales_dim_apt_unitInn]
	,convert(nvarchar(255), a.[unit_legal_entity]) as [sales_dim_apt_unit_legal_entity]
	,convert(nvarchar(20), a.[unit_cll_pref]) as [sales_dim_apt_unit_cll_pref]
	,convert(nvarchar(255), a.[unit_net_name]) as [sales_dim_apt_unit_net_name]
	,convert(nvarchar(100), a.[unit_region_name]) as [sales_dim_apt_unit_region_name]
	,convert(nvarchar(250), g.[descr]) as [sales_dim_good_descr]
	,g.[initial_id] as [sales_dim_good_initial_id]
	,r.[date_id]
	,d.[year_id] as [sales_dim_date_year_id]
	,convert(nvarchar(255), d.[month_name]) as [sales_dim_date_month_name]
	,convert(nvarchar, iif(r.[is_apt_in_list] = 1, ''Да'', ''Нет'')) as [sales_dim_is_apt_in_list]
	,convert(nvarchar, iif(r.[is_manufacturer_contract] = 1, ''Да'', ''Нет'')) as [sales_dim_is_manufacturer_contract]
	,convert(nvarchar, gr.[volume_agreement_group]) as [sales_dim_volume_agreement_group]
	,iif(r.[qty] = 0, null, r.[qty]) as [sales_fct_report_sales_qty]
	,iif(r.[sale_net] = 0, null, r.[sale_net]) as [sales_fct_report_sales_sale_net]
	,iif(r.[sale_grs] = 0, null, r.[sale_grs]) as [sales_fct_report_sales_sale_grs]
	,iif(r.[sale_cip] = 0, null, r.[sale_cip]) as [sales_fct_report_sales_sale_cip]
	,iif(r.[price_cip] = 0, null, r.[price_cip]) as [sales_dim_report_sales_price_cip]--[sales_fct_report_sales_price_cip]
FROM [dbo].[v_olap_fct_report_sales] as r
LEFT JOIN [dbo].[dim_apt] as a 
	ON r.[apt_id] = a.[apt_id]
LEFT JOIN [dbo].[dim_good] as g
	ON r.[good_id] = g.[good_id]
LEFT JOIN [dbo].[dim_date] as d 
	ON r.[date_id] = d.[date_id]
LEFT JOIN [dbo].[dim_volume_agreement_group] as gr
	ON r.[volume_agreement_group_id] = gr.[volume_agreement_group_id]
WHERE 
	isnull(r.[qty], 0) > 0
	OR isnull(r.[sale_net], 0) > 0
	OR isnull(r.[sale_grs], 0) > 0
	OR isnull(r.[sale_cip], 0) > 0
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_date]'))
EXEC dbo.sp_executesql @statement = N'
CREATE view [dbo].[v_olap_dim_date]
as
SELECT [date_id]
      ,[date_time]
      ,[date_name]
      ,[day_type_id]
      ,[day_type_name]
      ,[weekday_number]
      ,[weekday_name]
      ,[week_id]
      ,[week_name]
      ,[week_full_name]
      ,[week_number]
      ,[month_id]
      ,[month_name]
      ,[month_full_name]
      ,[month_number]
      ,[quarter_id]
      ,[quarter_name]
      ,[quarter_full_name]
      ,[year_id]
      ,[year_name]
  FROM [dbo].[dim_date] (nolock)

  union all

  select
	   19000101 as [date_id]
      ,N''1900-01-01'' as [date_time]
      ,N''01.01.1900'' as [date_name]
      ,1 as [day_type_id]
      ,N''Рабочий'' as [day_type_name]
      ,1 as [weekday_number]
      ,N''Понедельник'' as [weekday_name]
      ,190001 as [week_id]
      ,N''00 Неделя'' as [week_name]
      ,N''1900/00 Неделя'' as [week_full_name]
      ,0 as [week_number]
      ,190001 as [month_id]
      ,N''Январь'' as [month_name]
      ,N''1900/Январь'' as [month_full_name]
      ,1 as [month_number]
      ,19001 as [quarter_id]
      ,N''1 квартал'' as [quarter_name]
      ,N''1900/1 квартал'' as [quarter_full_name]
      ,1900 as [year_id]
      ,N''1900'' as [year_name]



' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_report_sales_pre]'))
EXEC dbo.sp_executesql @statement = N'




CREATE view [dbo].[v_olap_fct_report_sales_pre] as 
SELECT 
	[source_id]
	,[volume_agreement_id]
	,[date_id]
	,[apt_id]
	,[good_id]
	,[manufacturer_id]
	,[volume_agreement_group_id]
	,[is_apt_in_list]
	,[is_manufacturer_contract]
	,[qty]
	,[sale_net]
	,[sale_grs]
	,[price_cip]
	,[sale_cip]
	,isnull([sales_channel_id], -1) as [sales_channel_id]
FROM [dbo].[fct_report_sales]

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_report_purchases_pre]'))
EXEC dbo.sp_executesql @statement = N'




CREATE view [dbo].[v_olap_fct_report_purchases_pre] as
SELECT 
	[source_id]
	,[volume_agreement_id]
	,[date_id]
	,[apt_id]
	,[good_id]
	,[initial_supplier_id]
	,[supplier_id]
	,[manufacturer_id]
	,[volume_agreement_group_id]
	,[is_apt_in_list]
	,[is_manufacturer_contract]
	,[is_distributor_limitation]
	,[qty]
	,[purch_net]
	,[purch_grs]
	,[price_cip]
	,[purch_cip]
FROM [dbo].[fct_report_purchases]

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_partner_purchase_invoices]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_partner_purchase_invoices](
	[partner_purchase_invoice_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_number] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_date] [date] NULL,
 CONSTRAINT [PK_dim_partner_purchase_invoices] PRIMARY KEY CLUSTERED 
(
	[partner_purchase_invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_partner_purchase_invoices]'))
EXEC dbo.sp_executesql @statement = N'
--/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
--SELECT TOP (1000) [partner_purchase_invoice_id]
--      ,[invoice_number]
--      ,[invoice_date]
--  FROM [dbo].[dim_partner_purchase_invoices]

CREATE view [dbo].[v_olap_dim_partner_purchase_invoices] 
as
SELECT 
	[partner_purchase_invoice_id]
    ,[invoice_number]
    ,[invoice_date]
FROM [dbo].[dim_partner_purchase_invoices]

UNION ALL 

SELECT 
	-1 as [partner_purchase_invoice_id]
    ,'''' as [invoice_number]
    ,convert(date, ''1900-01-01'') as [invoice_date]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_initial_supplier]'))
EXEC dbo.sp_executesql @statement = N'

CREATE view [dbo].[v_olap_dim_initial_supplier]
as
SELECT [supplier_id] as [initial_supplier_id]
	,[initial_id]
	,[descr]
	,[full_name]
	,[phone]
	,[email]
	,[address]
	,[is_active]
	,[inn]
	,[region]
	,[legal_entity]
	,[fact_address]
	,[block_date]
	,[union_atr_name]
	,[city]
	,[dt_row]
	,[ld_nm]
	,[mdf_dt]
	,[mdf_user_name]
	,[region_code]
FROM [dbo].[dim_supplier]

UNION ALL

SELECT -1 as [initial_supplier_id]
      ,-1 as [initial_id]
      ,''Н/Д'' as [descr]
      ,''Н/Д'' as [full_name]
      ,''Н/Д'' as [phone]
      ,''Н/Д'' as [email]
      ,''Н/Д'' as [address]
      ,-1 as [is_active]
      ,''Н/Д'' as [inn]
      ,''Н/Д'' as [region]
      ,''Н/Д'' as [legal_entity]
      ,''Н/Д'' as [fact_address]
      ,''1900.01.01 00:00:00.000'' as [block_date]
      ,''Н/Д'' as [union_atr_name]
      ,''Н/Д'' as [city]
      ,''1900.01.01 00:00:00.000'' as [dt_row]
      ,''Н/Д'' as [ld_nm]
      ,''1900.01.01 00:00:00.000'' as [mdf_dt]
      ,''Н/Д'' as [mdf_user_name]
      ,''Н/Д'' as [region_code]
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[allocation_dim_invoices]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[allocation_dim_invoices](
	[invoice_id] [int] IDENTITY(1,1) NOT NULL,
	[invoice_number] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_date_id] [int] NULL,
	[apt_id] [int] NULL,
	[coefficient_invoice] [float] NULL,
	[allocation_month] [int] NULL,
 CONSTRAINT [PK_allocation_dim_invoices] PRIMARY KEY CLUSTERED 
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[allocation_fct_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[allocation_fct_purchases](
	[good_id] [int] NULL,
	[apt_id] [int] NULL,
	[invoice_id] [int] NULL,
	[is_purchase_on_source] [bit] NULL,
	[allocation_month] [int] NULL,
	[purch_qty] [int] NULL,
	[purch_price_net] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_allocation_fct_purchases]'))
EXEC dbo.sp_executesql @statement = N'





CREATE view [dbo].[v_allocation_fct_purchases]
as
SELECT 
	 convert(nvarchar(255), a.[unit_descr]) as [unit_descr]-- as [Аптека]
	,convert(nvarchar(255), a.[unit_cll_pref]) as [unit_cll_pref]-- as [Внешний код]
	,convert(nvarchar(255), a.[unit_fact_address]) as [unit_fact_address]-- as [Фактический адрес]
	,a.[unitInn]-- as [ИНН]
	,convert(nvarchar(255), a.[unit_legal_entity]) as [unit_legal_entity]-- as [Юр.лицо]
	,convert(nvarchar(255), a.[unit_net_name]) as [unit_net_name]-- as [Сеть]
	,convert(nvarchar(255), a.[unit_region_name]) as [unit_region_name]-- as [Регион]
	,N''ООО "АСНА"'' as [Supplier]--as [Поставщик]
	,N''7728850310'' as [SuppliersINN]--as [ИНН поставщика]
	,convert(nvarchar(255), g.[descr]) as [good_descr] --as [Товар]
	,g.[initial_id] --as [Код товара (ННТ)]
	,convert(nvarchar(255), i.[invoice_number]) as [invoice_number] --as [Номер Накладной]
	,convert(datetime, dbo.int_to_date([invoice_date_id])) as [invoice_date]-- as [Дата Накладной]
	,p.[allocation_month] / 100 as [year]-- as [1.Год]
	,p.[allocation_month] % 100 as [month] --[4.Месяц]
	,convert(numeric(19,2), p.[purch_qty] * p.[purch_price_net] * 1.05 * (1 + convert(float, g.[vat_id]) / 100)) as [purch_grs]--[Сумма приход (закупочная цена) с НДС, руб.] --цена CIP * (100% + 5% ) * (100% + НДС по товару)
	,convert(numeric(19,2), p.[purch_qty] * p.[purch_price_net] * 1.05) as [purch_net]-- [Сумма приход (закупочная цена) без НДС, руб.]
	,p.[purch_qty] as [qty]--[Количество приход, уп]
FROM [dbo].[allocation_fct_purchases] as p
INNER JOIN [dbo].[dim_apt] as a
	ON p.[apt_id] = a.[apt_id]
INNER JOIN [dbo].[dim_good] as g
	ON p.[good_id] = g.[good_id]
INNER JOIN [dbo].[allocation_dim_invoices] as i
	ON p.[invoice_id] = i.[invoice_id]




  
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[allocation_fct_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[allocation_fct_sales](
	[good_id] [int] NULL,
	[apt_id] [int] NULL,
	[allocation_month] [int] NULL,
	[sale_qty] [int] NULL,
	[sale_price_net] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_allocation_fct_sales]'))
EXEC dbo.sp_executesql @statement = N'



CREATE view [dbo].[v_allocation_fct_sales]
as
SELECT 
	 convert(nvarchar(255), a.[unit_descr]) as [unit_descr] --as [Аптека]
	,convert(nvarchar(255), a.[unit_cll_pref]) as [unit_cll_pref] --as [Внешний код]
	,convert(nvarchar(255), a.[unit_fact_address]) as [unit_fact_address] --as [Фактический адрес]
	,a.[unitInn] --as [ИНН]
	,convert(nvarchar(255), a.[unit_legal_entity]) as [unit_legal_entity] --as [Юр.лицо]
	,convert(nvarchar(255), a.[unit_net_name]) as [unit_net_name] --as [Сеть]
	,convert(nvarchar(255), a.[unit_region_name]) as [unit_region_name] --as [Регион]
	,convert(nvarchar(255), g.[descr]) as [good_descr] --as [Товар]
	,g.[initial_id] --as [Код товара (ННТ)]
	,p.[allocation_month] / 100 [year]--as [1.Год]
	,p.[allocation_month] % 100 [month]--as [4.Месяц]
	,convert(numeric(19,2), p.[sale_qty] * p.[sale_price_net] * 1.05 * (1 + convert(float, g.[vat_id]) / 100)) as [sale_grs] --[Выручка  (закупочная цена) с НДС, руб.]
	,convert(numeric(19,2), p.[sale_qty] * p.[sale_price_net] * 1.05) as [sale_net]--[Выручка  (закупочная цена) без НДС, руб.]
	,p.[sale_qty] as [qty]--[Количество продано, уп.]
FROM [dbo].[allocation_fct_sales] as p
INNER JOIN [dbo].[dim_apt] as a
	ON p.[apt_id] = a.[apt_id]
INNER JOIN [dbo].[dim_good] as g
	ON p.[good_id] = g.[good_id]




  
' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_sales](
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[quantity] [money] NULL,
	[sale_net] [money] NULL,
	[sale_grs] [money] NULL,
	[sales_channel_id] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_sales]') AND name = N'IX_fct_sales')
CREATE CLUSTERED INDEX [IX_fct_sales] ON [dbo].[fct_sales]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_sales]'))
EXEC dbo.sp_executesql @statement = N'




CREATE view [dbo].[v_olap_fct_sales] as 
-- 2018-09-21 Shemetov I.V.
SELECT 
       f.[date_id]
      ,f.[apt_id]
      ,f.[good_id]
	  ,f.[sales_channel_id]
      ,f.[quantity]
      ,f.[sale_grs]
      ,f.[sale_net]
FROM [dbo].[fct_sales] as f (nolock) 

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_supplys]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_supplys](
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[supplier_id] [int] NULL,
	[quantity] [money] NULL,
	[purch_net] [money] NULL,
	[purch_grs] [money] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_supplys]') AND name = N'IX_fct_supplys')
CREATE CLUSTERED INDEX [IX_fct_supplys] ON [dbo].[fct_supplys]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_fct_supplys]'))
EXEC dbo.sp_executesql @statement = N'





CREATE view [dbo].[v_olap_fct_supplys] as 
-- 2018-09-21 Shemetov I.V.
SELECT 
       f.[date_id]
      ,f.[apt_id]
      ,f.[good_id]
	  ,f.[supplier_id]
      ,f.[quantity]
      ,f.[purch_grs]
      ,f.[purch_net]
FROM [dbo].[fct_supplys] as f (nolock) 

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_is_apt_in_list]'))
EXEC dbo.sp_executesql @statement = N'


CREATE view [dbo].[v_olap_dim_is_apt_in_list] 
as
SELECT CONVERT(bit, 0) as id, ''Нет'' as [name]
UNION ALL
SELECT CONVERT(bit, 1) as id, ''Да'' as [name]
	

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_is_distributor_limitation]'))
EXEC dbo.sp_executesql @statement = N'


CREATE view [dbo].[v_olap_dim_is_distributor_limitation] 
as
SELECT CONVERT(bit, 0) as id, ''Нет'' as [name]
UNION ALL
SELECT CONVERT(bit, 1) as id, ''Да'' as [name]
	

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[v_olap_dim_is_manufacturer_contract]'))
EXEC dbo.sp_executesql @statement = N'



CREATE view [dbo].[v_olap_dim_is_manufacturer_contract] 
as
SELECT CONVERT(bit, 0) as id, ''Нет'' as [name]
UNION ALL
SELECT CONVERT(bit, 1) as id, ''Да'' as [name]
	

' 
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[allocation_fct_source_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[allocation_fct_source_purchases](
	[good_id] [int] NULL,
	[qty] [float] NULL,
	[volume_agreement_id] [int] NULL,
	[manufacturer_id] [int] NULL,
	[purch_price_net] [money] NULL,
	[is_purchase_on_source] [bit] NULL,
	[is_arrival_from_source] [bit] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[allocation_fct_coefficients]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[allocation_fct_coefficients](
	[allocation_month] [int] NULL,
	[is_purchase_on_source] [bit] NULL,
	[is_arrival_from_source] [bit] NULL,
	[purchases_coefficient] [float] NULL,
	[sales_coefficient] [float] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[allocation_fct_sales_coefficients]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[allocation_fct_sales_coefficients](
	[purchase_allocation_month] [int] NULL,
	[sales_allocation_month] [int] NULL,
	[sales_coefficient] [float] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[auto_volume_agreements_list]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[auto_volume_agreements_list](
	[volume_agreement_source_id] [int] NULL,
	[volume_agreement_id] [int] NULL,
	[volume_agreement_right_source_id] [int] NULL,
	[volume_agreement_right_id] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[auto_volume_agreements_settings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[auto_volume_agreements_settings](
	[volume_agreement_source_id] [int] NULL,
	[volume_agreement_id] [int] NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL,
	[purchases_dim_apt_unit_descr] [int] NULL,
	[purchases_dim_apt_unit_fact_address] [int] NULL,
	[purchases_dim_apt_unitInn] [int] NULL,
	[purchases_dim_apt_unit_legal_entity] [int] NULL,
	[purchases_dim_apt_unit_cll_pref] [int] NULL,
	[purchases_dim_apt_unit_net_name] [int] NULL,
	[purchases_dim_apt_unit_region_name] [int] NULL,
	[purchases_dim_supplier_descr] [int] NULL,
	[purchases_dim_supplier_inn] [int] NULL,
	[purchases_dim_good_descr] [int] NULL,
	[purchases_dim_good_initial_id] [int] NULL,
	[purchases_dim_date_year_id] [int] NULL,
	[purchases_dim_date_month_name] [int] NULL,
	[purchases_dim_is_apt_in_list] [int] NOT NULL,
	[purchases_dim_is_manufacturer_contract] [int] NOT NULL,
	[purchases_dim_is_distributor_limitation] [int] NOT NULL,
	[purchases_dim_volume_agreement_group] [int] NOT NULL,
	[purchases_dim_report_purchases_price_cip] [int] NULL,
	[purchases_fct_report_purchases_purch_cip] [int] NULL,
	[purchases_fct_report_purchases_purch_grs] [int] NULL,
	[purchases_fct_report_purchases_purch_net] [int] NULL,
	[purchases_fct_report_purchases_qty] [int] NULL,
	[sales_dim_apt_unit_descr] [int] NULL,
	[sales_dim_apt_unit_fact_address] [int] NULL,
	[sales_dim_apt_unitInn] [int] NULL,
	[sales_dim_apt_unit_legal_entity] [int] NULL,
	[sales_dim_apt_unit_cll_pref] [int] NULL,
	[sales_dim_apt_unit_net_name] [int] NULL,
	[sales_dim_apt_unit_region_name] [int] NULL,
	[sales_dim_good_descr] [int] NULL,
	[sales_dim_good_initial_id] [int] NULL,
	[sales_dim_date_year_id] [int] NULL,
	[sales_dim_date_month_name] [int] NULL,
	[sales_dim_is_apt_in_list] [int] NOT NULL,
	[sales_dim_is_manufacturer_contract] [int] NOT NULL,
	[sales_dim_volume_agreement_group] [int] NOT NULL,
	[sales_dim_report_sales_price_cip] [int] NULL,
	[sales_fct_report_sales_sale_cip] [int] NULL,
	[sales_fct_report_sales_sale_grs] [int] NULL,
	[sales_fct_report_sales_sale_net] [int] NULL,
	[sales_fct_report_sales_qty] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_apt_sourcedwh]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_apt_sourcedwh](
	[apt_id] [int] NOT NULL,
	[unit_id] [int] NULL,
	[unitInitial_id] [int] NULL,
	[unit_descr] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_full_name] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_phone] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_is_active_id] [int] NULL,
	[unit_is_active_name] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[unitInn] [varchar](15) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_net_id] [int] NULL,
	[unit_net_name] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_net_status_id] [int] NULL,
	[unit_net_status_name] [varchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_region_id] [int] NULL,
	[unit_region_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_legal_entity] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_fact_address] [varchar](400) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_legal_entity_cc] [float] NULL,
	[unit_contragent_marketing_date] [date] NULL,
	[unit_cll_pref] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_lb_fa] [varchar](658) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_city] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_for_analysis_marketing_id] [bit] NULL,
	[unit_for_analysis_marketing_name] [varchar](3) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_apt_type_id] [int] NULL,
	[unit_apt_type_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_cntr_id] [int] NULL,
	[unit_cntr_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[unit_block_date] [datetime] NULL,
	[aptInitial_id] [bigint] NULL,
	[apt_descr] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_full_name] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_phone] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_Is_active_id] [tinyint] NULL,
	[apt_Is_active_name] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[aptInn] [varchar](15) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_net_id] [int] NULL,
	[apt_net_name] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_net_status_id] [int] NULL,
	[apt_net_status_name] [varchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_region_id] [int] NULL,
	[apt_region_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_legal_entity] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_fact_address] [varchar](400) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_legal_entity_cc] [float] NULL,
	[apt_contragent_marketing_date] [int] NULL,
	[apt_clip_ref] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_lb_fa] [varchar](658) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_city] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_apt_type_id] [int] NULL,
	[apt_apt_type_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_cntr_id] [int] NULL,
	[apt_cntr_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_block_date] [datetime] NULL,
 CONSTRAINT [PK_dim_apt_sourcedwh] PRIMARY KEY CLUSTERED 
(
	[apt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_distributor_limitations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_distributor_limitations](
	[manufacturer_id] [int] NULL,
	[supplier_id] [int] NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_good_sourcedwh]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_good_sourcedwh](
	[good_id] [int] NOT NULL,
	[table_row_guid] [char](255) COLLATE Cyrillic_General_CI_AS NULL,
	[initial_id] [int] NULL,
	[descr] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[country] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[claster] [varchar](500) COLLATE Cyrillic_General_CI_AS NULL,
	[paking] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[concern] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[brand] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[trade_mark] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[form] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[dosage] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[pre_packing] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[mnn] [varchar](1024) COLLATE Cyrillic_General_CI_AS NULL,
	[form_out] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_vital] [bit] NULL,
	[goods_type] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[mega_cat] [varchar](13) COLLATE Cyrillic_General_CI_AS NULL,
	[with_codein] [bit] NULL,
	[pku_group] [bit] NULL,
	[properties] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[vat] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[application] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[is_actual] [bit] NULL,
	[claster_id] [int] NULL,
	[goods_group] [int] NULL,
	[is_hospital] [bit] NULL,
	[megs_cat] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[cat] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[cpe] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[concern_id] [int] NULL,
	[rb_mnn] [varchar](1024) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_cpe] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_brend_or_mnn] [varchar](5) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_lef_form] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_dosage] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_fasov] [varchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_cpe_top_concern] [int] NULL,
	[rb_megs_cat] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[id_1c_dwh] [int] NULL,
	[rb_sposob_prim] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_zhnvls] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_nds] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_with_kodein] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_concern] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_manufacturer] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_category] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_claster] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_sub_group] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_brend] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_trade_mark] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_invest] [varchar](10) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_bezdefectur] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[application_area_id] [int] NULL,
	[application_area_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[group_products_id] [int] NULL,
	[group_products_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[manufacturer_m_id] [int] NULL,
	[manufacturer_m_name] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[goods_group_name] [varchar](100) COLLATE Cyrillic_General_CI_AS NULL,
	[rb_brend_id] [int] NULL,
	[rb_claster_id] [int] NULL,
	[pku_group_rus] [varchar](16) COLLATE Cyrillic_General_CI_AS NULL,
	[with_codein_rus] [varchar](20) COLLATE Cyrillic_General_CI_AS NULL,
	[is_vit_rus] [varchar](8) COLLATE Cyrillic_General_CI_AS NULL,
	[is_hospital_rus] [varchar](15) COLLATE Cyrillic_General_CI_AS NULL,
	[is_actual_rus] [varchar](13) COLLATE Cyrillic_General_CI_AS NULL,
	[manufacturer_id] [int] NULL,
	[manufacturer_name] [varchar](150) COLLATE Cyrillic_General_CI_AS NULL,
	[vat_id] [int] NULL,
 CONSTRAINT [PK_dim_good_sourcedwh] PRIMARY KEY CLUSTERED 
(
	[good_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_manufacturer_contracts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_manufacturer_contracts](
	[manufacturer_id] [int] NULL,
	[apt_net_id] [int] NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_sales_channel_sourcedwh]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_sales_channel_sourcedwh](
	[sales_channel_id] [int] NOT NULL,
	[descr] [nvarchar](50) COLLATE Cyrillic_General_CI_AS NULL,
 CONSTRAINT [PK_SalesChannel_sourcedwh] PRIMARY KEY CLUSTERED 
(
	[sales_channel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_supplier_sourcedwh]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_supplier_sourcedwh](
	[supplier_id] [int] NOT NULL,
	[initial_id] [int] NOT NULL,
	[descr] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[table_row_guid] [uniqueidentifier] NOT NULL,
	[full_name] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL,
	[phone] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[email] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[address] [varchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[is_active] [int] NULL,
	[inn] [varchar](30) COLLATE Cyrillic_General_CI_AS NULL,
	[region] [nvarchar](200) COLLATE Cyrillic_General_CI_AS NULL,
	[legal_entity] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[fact_address] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[block_date] [datetime] NULL,
	[union_atr_name] [varchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[city] [varchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[dt_row] [datetime] NULL,
	[ld_nm] [varchar](2) COLLATE Cyrillic_General_CI_AS NULL,
	[mdf_dt] [datetime] NULL,
	[mdf_user_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NULL,
	[region_code] [nvarchar](3) COLLATE Cyrillic_General_CI_AS NULL,
	[is_checked] [int] NULL,
 CONSTRAINT [PK_Dim_Supplier_sourcedwh] PRIMARY KEY CLUSTERED 
(
	[supplier_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dim_supplier_replacements]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dim_supplier_replacements](
	[manufacturer_id] [int] NULL,
	[initial_supplier_id] [int] NULL,
	[replacement_supplier_id] [int] NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL,
	[initial_supplier_id_sourcedwh] [int] NULL,
	[replacement_supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_source_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_source_purchases](
	[good_id] [int] NULL,
	[qty] [money] NULL,
	[supplier_id] [int] NULL,
	[arrival_date] [int] NULL,
	[invoice_number_in] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier_id] [int] NULL,
	[delivery_date] [int] NULL,
	[invoice_number_out] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[volume_agreement_id] [int] NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL,
	[manufacturer_id] [int] NULL,
	[purch_price_net] [money] NULL,
	[supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier_id_sourcedwh] [int] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_purchases_prepare]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_report_purchases_prepare](
	[volume_agreement_id] [int] NULL,
	[is_apt_list] [bit] NULL,
	[source_id] [int] NOT NULL,
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[initial_supplier_id] [int] NULL,
	[supplier_id] [int] NULL,
	[manufacturer_id] [int] NULL,
	[volume_agreement_group_id] [int] NULL,
	[is_distributor_limitation] [bit] NULL,
	[qty] [money] NULL,
	[purch_net] [money] NULL,
	[purch_grs] [money] NULL,
	[price_cip] [money] NULL,
	[purch_cip] [money] NULL,
	[initial_supplier_id_sourcedwh] [int] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_purchases_prepare]') AND name = N'ix_cl_date_id_fct_report_purchases_prepare')
CREATE CLUSTERED INDEX [ix_cl_date_id_fct_report_purchases_prepare] ON [dbo].[fct_report_purchases_prepare]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_sales_prepare]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_report_sales_prepare](
	[volume_agreement_id] [int] NULL,
	[is_apt_list] [bit] NULL,
	[source_id] [int] NOT NULL,
	[date_id] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[manufacturer_id] [int] NULL,
	[volume_agreement_group_id] [int] NULL,
	[qty] [money] NULL,
	[sale_net] [money] NULL,
	[sale_grs] [money] NULL,
	[price_cip] [money] NULL,
	[sale_cip] [money] NULL,
	[sales_channel_id] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_report_sales_prepare]') AND name = N'ix_cl_date_id_fct_report_sales_prepare')
CREATE CLUSTERED INDEX [ix_cl_date_id_fct_report_sales_prepare] ON [dbo].[fct_report_sales_prepare]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_sales_additional]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_sales_additional](
	[date_id] [int] NULL,
	[day_number] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[quantity] [money] NULL,
	[sale_net] [money] NULL,
	[sale_grs] [money] NULL,
	[sales_channel_id] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_sales_additional]') AND name = N'ix_cl_date_id_sales_additional')
CREATE CLUSTERED INDEX [ix_cl_date_id_sales_additional] ON [dbo].[fct_sales_additional]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_supplys_additional]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_supplys_additional](
	[date_id] [int] NULL,
	[day_number] [int] NULL,
	[apt_id] [int] NULL,
	[good_id] [int] NULL,
	[supplier_id] [int] NULL,
	[quantity] [money] NULL,
	[purch_net] [money] NULL,
	[purch_grs] [money] NULL,
	[supplier_id_sourcedwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_supplys_additional]') AND name = N'ix_cl_date_id_supplys_additional')
CREATE CLUSTERED INDEX [ix_cl_date_id_supplys_additional] ON [dbo].[fct_supplys_additional]
(
	[date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fct_volume_agreements]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[fct_volume_agreements](
	[volume_agreement_id] [int] NOT NULL,
	[good_id] [int] NOT NULL,
	[apt_id] [int] NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL,
	[manufacturer_id] [int] NULL,
	[volume_agreement_group_id] [int] NULL,
	[increase_movements] [int] NULL,
	[price_cip] [money] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_volume_agreements]') AND name = N'ix_cl_date_from_date_to_fct_volume_agreements')
CREATE CLUSTERED INDEX [ix_cl_date_from_date_to_fct_volume_agreements] ON [dbo].[fct_volume_agreements]
(
	[date_from] ASC,
	[date_to] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[map].[change_apt_id]') AND type in (N'U'))
BEGIN
CREATE TABLE [map].[change_apt_id](
	[apt_id_sourcedwh] [int] NOT NULL,
	[apt_id_betadwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[map].[change_apt_id]') AND name = N'ix_cl_change_apt_id__apt_id_sourcedwh')
CREATE CLUSTERED INDEX [ix_cl_change_apt_id__apt_id_sourcedwh] ON [map].[change_apt_id]
(
	[apt_id_sourcedwh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[map].[change_good_id]') AND type in (N'U'))
BEGIN
CREATE TABLE [map].[change_good_id](
	[good_id_sourcedwh] [int] NOT NULL,
	[good_id_betadwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[map].[change_good_id]') AND name = N'ix_cl_change_good_id__good_id_sourcedwh')
CREATE CLUSTERED INDEX [ix_cl_change_good_id__good_id_sourcedwh] ON [map].[change_good_id]
(
	[good_id_sourcedwh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[map].[change_supplier_id]') AND type in (N'U'))
BEGIN
CREATE TABLE [map].[change_supplier_id](
	[supplier_id_sourcedwh] [int] NOT NULL,
	[supplier_id_betadwh] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[map].[change_supplier_id]') AND name = N'ix_cl_change_supplier_id__supplier_id_sourcedwh')
CREATE CLUSTERED INDEX [ix_cl_change_supplier_id__supplier_id_sourcedwh] ON [map].[change_supplier_id]
(
	[supplier_id_sourcedwh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[sup_change_objects_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [oth].[sup_change_objects_log](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[database_name] [varchar](256) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[event_type] [varchar](50) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[object_name] [varchar](256) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[object_type] [varchar](25) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[sql_command] [varchar](max) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[event_date] [datetime] NOT NULL,
	[login_name] [varchar](256) COLLATE Cyrillic_General_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[oth].[sup_change_objects_log]') AND name = N'ix_cl_log_id_sup_change_objects_log')
CREATE CLUSTERED INDEX [ix_cl_log_id_sup_change_objects_log] ON [oth].[sup_change_objects_log]
(
	[log_id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[sup_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [oth].[sup_log](
	[date_time] [datetime] NULL,
	[name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[system_user] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[state_name] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[row_count] [int] NULL,
	[err_number] [int] NULL,
	[err_severity] [int] NULL,
	[err_state] [int] NULL,
	[err_object] [nvarchar](max) COLLATE Cyrillic_General_CI_AS NULL,
	[err_line] [int] NULL,
	[err_message] [nvarchar](max) COLLATE Cyrillic_General_CI_AS NULL,
	[sp_id] [int] NULL,
	[duration] [nvarchar](50) COLLATE Cyrillic_General_CI_AS NULL,
	[duration_ord] [int] NULL,
	[description] [nvarchar](500) COLLATE Cyrillic_General_CI_AS NULL,
	[input_parametrs] [nvarchar](500) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[oth].[sup_log]') AND name = N'ix_cl_date_time_sup_log')
CREATE CLUSTERED INDEX [ix_cl_date_time_sup_log] ON [oth].[sup_log]
(
	[date_time] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[allocation_fct_source_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[allocation_fct_source_purchases](
	[good_source_id] [int] NULL,
	[good] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[qty] [float] NULL,
	[supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[arrival_date] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_number_in] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[delivery_date] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_number_out] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[volume_agreement_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[purch_price_net] [float] NULL,
	[is_purchase_on_source] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_arrival_from_source] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_apt_by_volume_agreements]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_dim_apt_by_volume_agreements](
	[volume_agreement_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[prefix] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_apt_by_volume_agreements]') AND name = N'ix_cl_volume_agreement_source_id_excel_dim_apt_by_volume_agreements')
CREATE CLUSTERED INDEX [ix_cl_volume_agreement_source_id_excel_dim_apt_by_volume_agreements] ON [stg].[excel_dim_apt_by_volume_agreements]
(
	[volume_agreement_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_distributor_limitations]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_dim_distributor_limitations](
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_goods_by_volume_agreements]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_dim_goods_by_volume_agreements](
	[volume_agreement_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good_source_id] [int] NULL,
	[good] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[price_cip] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[volume_agreement_group] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_goods_by_volume_agreements]') AND name = N'ix_cl_volume_agreement_source_id_excel_dim_goods_by_volume_agreements')
CREATE CLUSTERED INDEX [ix_cl_volume_agreement_source_id_excel_dim_goods_by_volume_agreements] ON [stg].[excel_dim_goods_by_volume_agreements]
(
	[volume_agreement_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_manufacturer_contracts]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_dim_manufacturer_contracts](
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[net] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_supplier_replacements]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_dim_supplier_replacements](
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[initial_supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[initial_supplier_INN] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[replacement_supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[replacement_supplier_INN] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_volume_agreements]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_dim_volume_agreements](
	[volume_agreement_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[manager_FIO] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[period] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_to] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[price_type] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[channel] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[list_type] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_list] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_purchase] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_arrival] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_all_apt] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[increase_movements] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[is_till_channel] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_volume_agreements]') AND name = N'ix_cl_volume_agreement_source_id_excel_dim_volume_agreements')
CREATE CLUSTERED INDEX [ix_cl_volume_agreement_source_id_excel_dim_volume_agreements] ON [stg].[excel_dim_volume_agreements]
(
	[volume_agreement_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_fct_source_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_fct_source_purchases](
	[good_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[qty] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[arrival_date] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_number_in] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sub_supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[delivery_date] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_number_out] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[volume_agreement_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[date_from] [int] NULL,
	[date_to] [int] NULL,
	[manufacturer] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[purch_price_net] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_fct_partner_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_fct_partner_purchases](
	[apt] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[address] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[legal_person] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[net] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[region] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good_source_id] [int] NULL,
	[invoice_number] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[invoice_date] [date] NULL,
	[year] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[month] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[purch_grs] [money] NULL,
	[purch_net] [money] NULL,
	[qty] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_fct_partner_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_fct_partner_sales](
	[apt] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[address] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[legal_person] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[net] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[region] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good_source_id] [int] NULL,
	[year] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[month] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[sale_grs] [money] NULL,
	[sale_net] [money] NULL,
	[qty] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[excel_fct_statistician_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[excel_fct_statistician_purchases](
	[apt] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[apt_source_id] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[address] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[legal_person] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[net] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[region] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[supplier_inn] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[good_source_id] [int] NULL,
	[year] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[month] [nvarchar](255) COLLATE Cyrillic_General_CI_AS NULL,
	[purch_grs] [money] NULL,
	[purch_net] [money] NULL,
	[qty] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fct_rests]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[fct_rests](
	[date_source_id] [int] NULL,
	[apt_source_id] [int] NULL,
	[good_source_id] [int] NULL,
	[quantity] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fct_sales]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[fct_sales](
	[date_source_id] [int] NULL,
	[apt_source_id] [int] NULL,
	[good_source_id] [int] NULL,
	[quantity] [money] NULL,
	[sale_net] [money] NULL,
	[sale_grs] [money] NULL,
	[sales_channel_id] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fct_sales_additional]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[fct_sales_additional](
	[date_source_id] [int] NOT NULL,
	[apt_source_id] [int] NOT NULL,
	[good_source_id] [int] NOT NULL,
	[quantity] [money] NOT NULL,
	[sale_net] [money] NOT NULL,
	[sale_grs] [money] NOT NULL,
	[sales_channel_id] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fct_statistician_purchases]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[fct_statistician_purchases](
	[apt_id] [int] NULL,
	[supplier_id] [int] NULL,
	[good_id] [int] NULL,
	[date_id] [int] NULL,
	[purch_grs] [money] NULL,
	[purch_net] [money] NULL,
	[qty] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fct_supplys]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[fct_supplys](
	[date_source_id] [int] NULL,
	[apt_source_id] [int] NULL,
	[good_source_id] [int] NULL,
	[supplier_source_id] [int] NULL,
	[quantity] [money] NULL,
	[purch_net] [money] NULL,
	[purch_grs] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fct_supplys_additional]') AND type in (N'U'))
BEGIN
CREATE TABLE [stg].[fct_supplys_additional](
	[date_source_id] [int] NOT NULL,
	[apt_source_id] [int] NOT NULL,
	[good_source_id] [int] NOT NULL,
	[supplier_source_id] [int] NOT NULL,
	[quantity] [money] NOT NULL,
	[purch_net] [money] NOT NULL,
	[purch_grs] [money] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[dim_good]') AND name = N'ix_initial_id_excel_dim_goods_by_volume_agreements')
CREATE NONCLUSTERED INDEX [ix_initial_id_excel_dim_goods_by_volume_agreements] ON [dbo].[dim_good]
(
	[initial_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[fct_volume_agreements]') AND name = N'ix_5_3_volume_agreements')
CREATE NONCLUSTERED INDEX [ix_5_3_volume_agreements] ON [dbo].[fct_volume_agreements]
(
	[apt_id] ASC,
	[good_id] ASC,
	[date_from] ASC,
	[date_to] ASC,
	[increase_movements] ASC
)
INCLUDE ( 	[manufacturer_id],
	[volume_agreement_group_id],
	[volume_agreement_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[stg].[excel_dim_goods_by_volume_agreements]') AND name = N'ix_good_source_id_excel_dim_goods_by_volume_agreements')
CREATE NONCLUSTERED INDEX [ix_good_source_id_excel_dim_goods_by_volume_agreements] ON [stg].[excel_dim_goods_by_volume_agreements]
(
	[good_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__purch__08162EEB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((0)) FOR [purchases_dim_supplier_inn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__purch__090A5324]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [purchases_dim_is_apt_in_list]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__purch__09FE775D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [purchases_dim_is_manufacturer_contract]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__purch__0AF29B96]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [purchases_dim_is_distributor_limitation]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__purch__0BE6BFCF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [purchases_dim_volume_agreement_group]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__purch__0CDAE408]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [purchases_dim_report_purchases_price_cip]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__sales__0DCF0841]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [sales_dim_is_apt_in_list]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__sales__0EC32C7A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [sales_dim_is_manufacturer_contract]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__sales__0FB750B3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [sales_dim_volume_agreement_group]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__auto_volu__sales__10AB74EC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[auto_volume_agreements_settings] ADD  DEFAULT ((1)) FOR [sales_dim_report_sales_price_cip]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[DF_events_log_event_date]') AND type = 'D')
BEGIN
ALTER TABLE [oth].[sup_change_objects_log] ADD  CONSTRAINT [DF_events_log_event_date]  DEFAULT (getdate()) FOR [event_date]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_dim]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_dim] AS' 
END
GO






-- =========================================================
-- Author:		
-- Create date: 2018-09-20
-- Description:	Обновление справочников хранилища
-- =========================================================
ALTER PROCEDURE [dbo].[fill_all_dim]

AS
BEGIN
	SET NOCOUNT ON;	
	-------------------------------------------------------------------
	--Справочники
	-------------------------------------------------------------------

	-- Товары 
	-- [sourceDWH].[source_DWH].[DWH].[vDim_Goods]
	exec [dbo].[fill_dim_good]


	-- Аптеки 
	-- [sourceDWH].[source_DWH].[ProcOlap].[vOlap_Dim_Farmacie] 
	exec [dbo].[fill_dim_apt]

	--Поставщики
	--[source_DWH].[DWH].[Dim_Supplier]
	exec [dbo].[fill_dim_supplier]

	--Каналы продаж
	--[source_DWH].[DWH].[Dim_SalesChannel]
	exec [dbo].[fill_dim_sales_channel]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_excel_allocation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_excel_allocation] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-05-31
---- Description:  'Мастер-процедура запуска алгоритма распределения накладных'
---- EXEC example:	exec [dbo].[fill_all_excel_allocation] @pathForFilesLoad = N'C:\FTP\source\input\data\', @pathForHistoryFolder = N'C:\FTP\source\hist\' 
---- корр Ильин В.А. 23/1/2020 Добавление параметров @pathForFilesLoad, @pathForHistoryFolder
---- ================================================================================
ALTER procedure [dbo].[fill_all_excel_allocation] @pathForFilesLoad NVARCHAR (MAX), @pathForHistoryFolder NVARCHAR (MAX)
as

declare @destination_folder_final nvarchar(4000)
declare @filename varchar(255)
declare @filepath varchar(255)
--declare @path varchar(255) -- !UPD 23/1/2020 вместо @path добавлен параметр @pathForFilesLoad 
declare @sql varchar(8000)
declare @cmd varchar(1000)
declare @hist_full_folder_path nvarchar(max) -- !UPD 23/1/2020 полный путь для исторической папки 

CREATE TABLE #files_for_load
	([filename] varchar(255))

--Получение перечня всех файлов в директории для загрузки

--SET @path = 'C:\FTP\source\input\allocation\'
SET @cmd = 'dir "' + @pathForFilesLoad + '"*.xlsx /b' -- !UPD 23/1/2020 вместо @path добавлен параметр @pathForFilesLoad 
SET @hist_full_folder_path = @pathForHistoryFolder + 'allocation\' -- !UPD 23/1/2020 полный путь к исторической папке 

INSERT INTO  #files_for_load ([filename])
EXEC Master..xp_cmdShell @cmd
DELETE FROM #files_for_load where [filename] is NULL

SELECT @filename = max([filename]) FROM #files_for_load WHERE [filename] LIKE '%allocation_%'

IF @filename IS NOT NULL
BEGIN
	SET @filepath = @pathForFilesLoad + @filename
	--Загрузка Закуп на АСНА на уровень stg
	exec [stg].[fill_allocation_fct_source_purchases] 
		@filepath = @filepath
		,@sheet = 'Закуп на АСНА'
	
	--Загрузка Закуп на АСНА на уровень dbo
	exec [dbo].[fill_allocation_fct_source_purchases]

	--Загрузка накладных для распределения на уровень dbo
	exec [dbo].[fill_allocation_dim_invoices] 
		@filepath = @filepath
		,@sheet = 'Накладные'
	
	--Загрузка коэффициентов распределения по месяцам на уровень dbo
	exec [dbo].[fill_allocation_fct_coefficients] 
		@filepath = @filepath
		,@sheet = 'Коэффициенты'

	--Загрузка коэффициентов Продаж распределения по месяцам на уровень dbo
	exec [dbo].[fill_allocation_fct_sales_coefficients]
		@filepath = @filepath
		,@sheet = 'Коэффициенты Продаж'

	--Процедура формировния распределения по закупкам
	exec [dbo].[fill_allocation_fct_purchases] 

	--Процедура формировния распределения по продажам
	exec [dbo].[fill_allocation_fct_sales] 

	--Перемещение файла в директорию с ичторическими файлами
	EXEC oth.p_move_file 
		@source_file = @filename, 
		@source_folder = @pathForFilesLoad, --UPD 23/1/20
		--@destination_folder = 'C:\FTP\source\hist\allocation\',
		@destination_folder = @hist_full_folder_path, --UPD 23/1/20
		@destination_folder_final = @destination_folder_final output
END

DROP table if exists #files_for_load
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_excel_data_files]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_excel_data_files] AS' 
END
GO
--exec [dbo].[fill_all_excel_data_files] @p_quarter = 20194, @pathForFilesLoad = N'C:\FTP\source\input\data\',  @pathForHistoryFolder = N'C:\FTP\source\hist\' 
-- корр Ильин В.А. 23/1/2020 - добавлены параметры @p_quarter, @pathForFilesLoad, @pathForHistoryFolder
ALTER procedure [dbo].[fill_all_excel_data_files] @p_quarter int, @pathForFilesLoad NVARCHAR (MAX), @pathForHistoryFolder NVARCHAR (MAX)
as

declare @destination_folder_final nvarchar(4000)
declare @filename			varchar(255)
declare @filepath			varchar(255)
--declare @path				varchar(255)  -- !UPD 23/1/2020 вместо @path добавлен параметр @pathForFilesLoad 
declare @sql				varchar(8000)
declare @cmd				varchar(1000)
declare @hist_full_folder_path_partners nvarchar(max) -- !UPD 23/1/2020 полный путь для исторической папки c файлами партнеров
declare @hist_full_folder_path_source nvarchar(max) -- !UPD 23/1/2020 полный путь для исторической папки с закупками АСНА
declare @Cursor_download	CURSOR
declare @dt_date_from		date
declare @dt_date_to			date
declare @dt_int_from		int
declare @dt_int_to			int
declare @quarter			int

CREATE TABLE #files_for_load
	([filename] varchar(255))

--Получение перечня всех файлов в директории для загрузки
--SET @path = 'C:\FTP\source\input\data\'
SET @cmd = 'dir "' + @pathForFilesLoad + '"*.xlsx /b'
SET @hist_full_folder_path_partners = @pathForHistoryFolder + 'partners\' -- !UPD 23/1/2020 полный путь к исторической папке c файлами партнеров
SET @hist_full_folder_path_source = @pathForHistoryFolder + 'source_purchases\' -- !UPD 23/1/2020 полный путь к исторической папке с закупками АСНА
INSERT INTO  #files_for_load ([filename])
EXEC Master..xp_cmdShell @cmd
DELETE FROM #files_for_load where [filename] is NULL
	
--Инициирование загрузки для каждого из четырех типов данных
--Загрузка файлов партнеров

SET @Cursor_download = CURSOR SCROLL FOR 
	SELECT [filename] FROM #files_for_load WHERE [filename] like 'partners_%'
open @Cursor_download
fetch next from @Cursor_download into @filename
WHILE @@fetch_status <> -1
BEGIN
	
	--Определение параметров запуска процедур ETL
	
	SET @filepath = @pathForFilesLoad + @filename
	SET @quarter = CONVERT(int, LEFT(RIGHT(@filename, 10), 5))
	SELECT 
		@dt_int_from = min([date_id])
		,@dt_int_to = [dbo].[date_to_int](DATEADD(dd, 1, max([date_time])))
		,@dt_date_from = min([date_time])
		,@dt_date_to = DATEADD(dd, 1, max([date_time]))
	FROM [dbo].[dim_date]
	where quarter_id = @quarter


	exec [stg].[fill_excel_fct_partner_purchases]
		@filepath = @filepath
		,@date_from = @dt_date_from
		,@date_to = @dt_date_to

	exec [stg].[fill_excel_fct_partner_sales]
		@filepath = @filepath
		,@date_from = @dt_date_from
		,@date_to = @dt_date_to

	exec [dbo].[fill_fct_partner_purchases]
		@date_from = @dt_int_from
		,@date_to = @dt_int_to

	exec [dbo].[fill_fct_partner_sales]
		@date_from = @dt_int_from
		,@date_to = @dt_int_to

	if @quarter <> @p_quarter --UPD 23/1/20 - перерасчет отчетных данных только если нетекущий квартал
		BEGIN
			--Формирование отчетных данных Продаж
			exec [dbo].[fill_fct_report_sales_prepare]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
			exec [dbo].[fill_fct_report_sales]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
	
			--Формирование отчетных данных Закупок
			exec [dbo].[fill_fct_report_purchases_prepare]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
			exec [dbo].[fill_fct_report_purchases]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
		END
	--Перемещение файла в директорию с иcторическими файлами
	EXEC oth.p_move_file 
		@source_file = @filename, 
		@source_folder = @pathForFilesLoad, 
		--@destination_folder = 'C:\FTP\source\hist\partners\',
		@destination_folder = @hist_full_folder_path_partners, --UPD 23/1/20
		@destination_folder_final = @destination_folder_final output

	fetch next from @Cursor_download into @filename
END
close @Cursor_download

--Загрузка файлов Закупка на АСНА

SET @Cursor_download = CURSOR SCROLL FOR 
	SELECT [filename] FROM #files_for_load WHERE [filename] like 'source_purchases_%'
open @Cursor_download
fetch next from @Cursor_download into @filename
WHILE @@fetch_status <> -1
BEGIN
	
	--Определение параметров запуска процедур ETL

	SET @filepath = @pathForFilesLoad + @filename
	SET @quarter = CONVERT(int, LEFT(RIGHT(@filename, 10), 5))
	SELECT 
		@dt_int_from = min([date_id])
		,@dt_int_to = [dbo].[date_to_int](DATEADD(dd, 1, max([date_time])))
		,@dt_date_from = min([date_time])
		,@dt_date_to = DATEADD(dd, 1, max([date_time]))
	FROM [dbo].[dim_date]
	where quarter_id = @quarter

	exec [stg].[fill_excel_fct_source_purchases] 
		@filepath = @filepath,
		@sheet = 'Закуп на АСНА',  
		@date_from = @dt_date_from, 
		@date_to = @dt_date_to

	exec [dbo].[fill_fct_source_purchases]
		@date_from = @dt_int_from
		,@date_to = @dt_int_to

	--Перемещение файла в директорию с ичторическими файлами
	EXEC oth.p_move_file 
		@source_file = @filename, 
		@source_folder = @pathForFilesLoad, 
		--@destination_folder = 'C:\FTP\source\hist\source_purchases\',
		@destination_folder = @hist_full_folder_path_source, --UPD 23/1/20
		@destination_folder_final = @destination_folder_final output

	fetch next from @Cursor_download into @filename
END
close @Cursor_download

deallocate @Cursor_download
DROP table #files_for_load
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_excel_data_files_invoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_excel_data_files_invoice] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-01-15
---- Description:  'Мастер-процедура получения перечня всех Excel файлов фактов из ftp
----				и загрузка на уровни stg и dbo'
---- EXEC example:	exec [dbo].[fill_all_excel_data_files_invoice]
---- ================================================================================
ALTER procedure [dbo].[fill_all_excel_data_files_invoice]
as

declare @destination_folder_final nvarchar(4000)
declare @filename varchar(255)
declare @filepath varchar(255)
declare @path varchar(255)
declare @sql varchar(8000)
declare @cmd varchar(1000)
declare @Cursor_download CURSOR
declare @dt_date_from date
declare @dt_date_to date
declare @dt_int_from int
declare @dt_int_to int
declare @quarter int
declare @month int

CREATE TABLE #files_for_load
	([filename] varchar(255))

--Получение перечня всех файлов в директории для загрузки
SET @path = 'C:\FTP\source\input\data\'
SET @cmd = 'dir "' + @path + '"*.xlsx /b'
INSERT INTO  #files_for_load ([filename])
EXEC Master..xp_cmdShell @cmd
DELETE FROM #files_for_load where [filename] is NULL
	
--Инициирование загрузки для каждого из четырех типов данных
--Загрузка файлов партнеров

SET @Cursor_download = CURSOR SCROLL FOR 
	SELECT [filename] FROM #files_for_load WHERE [filename] like 'partners_%'
open @Cursor_download
fetch next from @Cursor_download into @filename
WHILE @@fetch_status <> -1
BEGIN
	
	--Определение параметров запуска процедур ETL
	
	SET @filepath = @path + @filename
	SET @month = CONVERT(int, LEFT(RIGHT(@filename, 11), 6))
	SELECT 
		@dt_int_from = min([date_id])
		,@dt_int_to = [dbo].[date_to_int](DATEADD(dd, 1, max([date_time])))
		,@dt_date_from = min([date_time])
		,@dt_date_to = DATEADD(dd, 1, max([date_time]))
	FROM [dbo].[dim_date]
	where month_id = @month


	exec [stg].[fill_excel_fct_partner_purchases]
		@filepath = @filepath
		,@date_from = @dt_date_from
		,@date_to = @dt_date_to

	exec [stg].[fill_excel_fct_partner_sales]
		@filepath = @filepath
		,@date_from = @dt_date_from
		,@date_to = @dt_date_to

	exec [dbo].[fill_fct_partner_purchases]
		@date_from = @dt_int_from
		,@date_to = @dt_int_to

	exec [dbo].[fill_fct_partner_sales]
		@date_from = @dt_int_from
		,@date_to = @dt_int_to

	--Перемещение файла в директорию с историческими файлами
	EXEC oth.p_move_file 
		@source_file = @filename, 
		@source_folder = @path, 
		@destination_folder = 'C:\FTP\source\hist\partners\',
		@destination_folder_final = @destination_folder_final output

	fetch next from @Cursor_download into @filename
END
close @Cursor_download

--Загрузка файлов Закупка на АСНА

SET @Cursor_download = CURSOR SCROLL FOR 
	SELECT [filename] FROM #files_for_load WHERE [filename] like 'source_purchases_%'
open @Cursor_download
fetch next from @Cursor_download into @filename
WHILE @@fetch_status <> -1
BEGIN
	
	--Определение параметров запуска процедур ETL

	SET @filepath = @path + @filename
	SET @quarter = CONVERT(int, LEFT(RIGHT(@filename, 10), 5))
	SELECT 
		@dt_int_from = min([date_id])
		,@dt_int_to = [dbo].[date_to_int](DATEADD(dd, 1, max([date_time])))
		,@dt_date_from = min([date_time])
		,@dt_date_to = DATEADD(dd, 1, max([date_time]))
	FROM [dbo].[dim_date]
	where quarter_id = @quarter

	exec [stg].[fill_excel_fct_source_purchases] 
		@filepath = @filepath,
		@sheet = 'Закуп на АСНА',  
		@date_from = @dt_date_from, 
		@date_to = @dt_date_to

	exec [dbo].[fill_fct_source_purchases]
		@date_from = @dt_int_from
		,@date_to = @dt_int_to

	--Перемещение файла в директорию с ичторическими файлами
	EXEC oth.p_move_file 
		@source_file = @filename, 
		@source_folder = @path, 
		@destination_folder = 'C:\FTP\source\hist\source_purchases\',
		@destination_folder_final = @destination_folder_final output

	fetch next from @Cursor_download into @filename
END
close @Cursor_download

deallocate @Cursor_download
DROP table #files_for_load
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_excel_dim_dbo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_excel_dim_dbo] AS' 
END
GO







-- =========================================================
-- Author:			Shemetov
-- Create date:		2018-10-05
-- Description:		Обновление справочников по ОС хранилища из excel
--					Указывается период с включением date_to
-- EXEC Example		exec [dbo].[fill_all_excel_dim_dbo] @date_from = 20181001, @date_to = 20181231
-- =========================================================
ALTER PROCEDURE [dbo].[fill_all_excel_dim_dbo]
@date_from int
,@date_to int
AS
BEGIN
	SET NOCOUNT ON;	
	-------------------------------------------------------------------
	--Справочники
	-------------------------------------------------------------------
	--ОС
	exec [dbo].[fill_dim_volume_agreements]
	--Производители
	exec [dbo].[fill_dim_manufacturer]
	--Группы по ОС
	exec [dbo].[fill_dim_volume_agreement_group]
	--Ограничения дистрибьюторов
	exec [dbo].[fill_dim_distributor_limitations] @date_from = @date_from, @date_to = @date_to
	--Прямые контракты
	exec [dbo].[fill_dim_manufacturer_contracts] @date_from = @date_from, @date_to = @date_to
	--Замена поставщиков
	exec [dbo].[fill_dim_supplier_replacements] @date_from = @date_from, @date_to = @date_to

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_excel_dim_stg]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_excel_dim_stg] AS' 
END
GO






-- =========================================================
-- Author:			Shemetov
-- Create date:		2018-10-05
-- Description:		Загрузка справочной информации по ОС на уровень stg
-- EXEC example:	exec [dbo].[fill_all_excel_dim_stg] @filepath = 'C:\Lasmart\20181127\Шаблоны на 4 кв 2018.xlsx', @date_from = '2018-10-01', @date_to = '2018-12-31'
-- =========================================================
ALTER PROCEDURE [dbo].[fill_all_excel_dim_stg]
@filepath varchar(255)
,@date_from date
,@date_to   date
AS
BEGIN
	SET NOCOUNT ON;	
	-------------------------------------------------------------------
	--Справочники
	-------------------------------------------------------------------
	--Аптеки по ОС
	exec [stg].[fill_excel_dim_apt_by_volume_agreements] @filepath = @filepath, @date_from = @date_from, @date_to = @date_to
	--Ограничения дистрибьторов
	exec [stg].[fill_excel_dim_distributor_limitations] @filepath = @filepath, @date_from = @date_from, @date_to = @date_to
	--Товары по ОС
	exec [stg].[fill_excel_dim_goods_by_volume_agreements] @filepath = @filepath, @date_from = @date_from, @date_to = @date_to
	--Прямые контракты
	exec [stg].[fill_excel_dim_manufacturer_contracts] @filepath = @filepath, @date_from = @date_from, @date_to = @date_to
	--Замена поставщиков
	exec [stg].[fill_excel_dim_supplier_replacements] @filepath = @filepath, @date_from = @date_from, @date_to = @date_to
	--ОС
	exec [stg].[fill_excel_dim_volume_agreements] @filepath = @filepath

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_excel_VA_files]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_excel_VA_files] AS' 
END
GO

-- корр Ильин В.А. 23/1/2020 - добавлены параметры @p_quarter, @pathForFilesLoad, @pathForHistoryFolder 
--exec [dbo].[fill_all_excel_VA_files] @p_quarter = 20194, @pathForFilesLoad = N'C:\FTP\source\input\data\', @pathForHistoryFolder = N'C:\FTP\source\hist\'
ALTER procedure [dbo].[fill_all_excel_VA_files] @p_quarter int, @pathForFilesLoad NVARCHAR (MAX), @pathForHistoryFolder NVARCHAR (MAX)
as

declare @destination_folder_final nvarchar(4000)
declare @filename			varchar(255)
declare @filepath			varchar(255)
--declare @path				varchar(255) -- !UPD 23/1/2020 вместо @path добавлен параметр @pathForFilesLoad 
declare @sql				varchar(8000)
declare @cmd				varchar(1000)
declare @hist_full_folder_path nvarchar(max) -- !UPD 23/1/2020 полный путь для исторической папки
declare @Cursor_download	CURSOR
declare @dt_date_from		date
declare @dt_date_to			date
declare @dt_int_from		int
declare @dt_int_to			int
declare @quarter			int

CREATE TABLE #files_for_load
	([filename] varchar(255))

--Получение перечня всех файлов в директории для загрузки
--SET @path = 'C:\FTP\source\input\data\'
SET @cmd = 'dir "' + @pathForFilesLoad + '"*.xlsx /b'
SET @hist_full_folder_path = @pathForHistoryFolder + 'os_data\' -- !UPD 23/1/2020 полный путь к исторической папке
INSERT INTO  #files_for_load ([filename])
EXEC Master..xp_cmdShell @cmd
DELETE FROM #files_for_load where [filename] is NULL
	
--Инициирование загрузки для каждого из четырех типов данных

--Загрузка настроечного файла ОС

SET @Cursor_download = CURSOR SCROLL FOR 
	SELECT [filename] FROM #files_for_load WHERE [filename] like 'os_data_%'
open @Cursor_download
fetch next from @Cursor_download into @filename
WHILE @@fetch_status <> -1
BEGIN
	
	--Определение параметров запуска процедур ETL
	
	SET @filepath = @pathForFilesLoad + @filename
	SET @quarter = CONVERT(int, CONVERT(int, LEFT(RIGHT(@filename, 10), 5)))
	SELECT 
		@dt_int_from = min([date_id])
		,@dt_int_to = [dbo].[date_to_int](DATEADD(dd, 1, max([date_time])))
		,@dt_date_from = min([date_time])
		,@dt_date_to = max([date_time])
	FROM [dbo].[dim_date]
	where quarter_id = @quarter

	--Загрузка справочников ОС на stg
	exec [dbo].[fill_all_excel_dim_stg]
		@filepath = @filepath, 
		@date_from = @dt_date_from, 
		@date_to = @dt_date_to

	--Загрузка справочников ОС на dbo
	DECLARE @dt_int_to_excel int
	SET @dt_int_to_excel = [dbo].[date_to_int](@dt_date_to)
	exec [dbo].[fill_all_excel_dim_dbo]
		@date_from = @dt_int_from, 
		@date_to = @dt_int_to_excel

	--Формирование промежуточной таблицы фактов ОС
	exec [dbo].[fill_fct_volume_agreements]				
		@date_from = @dt_int_from, 
		@date_to = @dt_int_to

	if @quarter <> @p_quarter --UPD 23/1/20 - перерасчет отчетных данных только если нетекущий квартал
		BEGIN
			--Формирование отчетных данных Продаж
			exec [dbo].[fill_fct_report_sales_prepare]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
			exec [dbo].[fill_fct_report_sales]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
	
			--Формирование отчетных данных Закупок
			exec [dbo].[fill_fct_report_purchases_prepare]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to
			exec [dbo].[fill_fct_report_purchases]				
				@date_from = @dt_int_from, 
				@date_to = @dt_int_to	
		END
	--Перемещение файла в директорию с иcторическими файлами
	EXEC oth.p_move_file 
		@source_file = @filename, 
		@source_folder = @pathForFilesLoad, 
		--@destination_folder = 'C:\FTP\source\hist\os_data\',
		@destination_folder = @hist_full_folder_path, --UPD 23/1/20 - историческая папка в параметре @pathForHistoryFolder
		@destination_folder_final = @destination_folder_final output

	fetch next from @Cursor_download into @filename
END
close @Cursor_download
deallocate @Cursor_download
DROP table #files_for_load
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_fct_dbo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_fct_dbo] AS' 
END
GO
-- =============================================
-- Author:		
-- Create date: 2018-09-20
-- Description:	Обновление фактов хранилища данных из ХД АСНЫ
-- =============================================
ALTER PROCEDURE [dbo].[fill_all_fct_dbo]
	@date_from int,
	@date_to int
AS
BEGIN
SET NOCOUNT ON;	
-- -------------------------------------------------------------------------------------------

	--Отсатки
	exec [dbo].[fill_fct_rests]					@date_from, @date_to
	
	--Продажи
	exec [dbo].[fill_fct_sales]					@date_from, @date_to
	
	--Закупки поступления
	exec [dbo].[fill_fct_supplys]			    @date_from, @date_to
	
	--Добавочные Продажи
	exec [dbo].[fill_fct_sales_additional]		@date_from, @date_to

	--Добавочные Закупки
	exec [dbo].[fill_fct_supplys_additional]	@date_from, @date_to

-- -------------------------------------------------------------------------------------------
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_fct_stg]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_fct_stg] AS' 
END
GO


-- =============================================
-- Author:		
-- Create date: 2018-09-20
-- Description:	Обновление фактов хранилища из ХД АСНЫ
-- =============================================
ALTER PROCEDURE [dbo].[fill_all_fct_stg]
	@date_from date,
	@date_to date
AS
BEGIN
	SET NOCOUNT ON;	

	------------------------------------------------------------------------------------------------------------------------
	----Факты из источника
	------------------------------------------------------------------------------------------------------------------------
	
	--Отсатки
	exec [stg].[fill_fct_rests]					@date_from, @date_to
	
	--Продажи
	exec [stg].[fill_fct_sales]					@date_from, @date_to
	
	--Закупки поступления
	exec [stg].[fill_fct_supplys]			    @date_from, @date_to
	
	--Добавочные Продажи
	exec [stg].[fill_fct_sales_additional]		@date_from, @date_to

	--Добавочные Закупки
	exec [stg].[fill_fct_supplys_additional]	@date_from, @date_to

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_all_reports]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_all_reports] AS' 
END
GO
-- =============================================
-- Author:			Шеметов
-- Create date:		2018-12-06
-- Description:		Загрузка справочников по ОС и формирование отчетов
--					Для полноты формирования конечных отчетов необходимо,
--					чтобы были загружены добавочные движения из хд АСНЫ
--					Обратите внимание, что процедура запускается с исключением даты по, 
--					но справочные данные по ОС грузятся с включением даты по,
-- EXEC example:	exec [dbo].[fill_all_reports] @filepath = 'C:\Lasmart\20181127\Шаблоны на 4 кв 2018.xlsx', @date_from = 20181001, @date_to = 20190101
-- =============================================
ALTER PROCEDURE [dbo].[fill_all_reports]
	@filepath varchar(255),
	@date_from int,
	@date_to int
AS
BEGIN
SET NOCOUNT ON;	
-- -------------------------------------------------------------------------------------------
	DECLARE @date_to_excel int
	DECLARE @date_from_dt date
	DECLARE @date_to_dt date

	SET @date_to_excel = dbo.date_to_int(EOMONTH(dbo.int_to_date(@date_from), 2))
	SET @date_from_dt = [dbo].[int_to_date](@date_from)
	SET @date_to_dt = [dbo].[int_to_date](@date_to_excel)

	--Загрузка справочников ОС на stg
	exec [dbo].[fill_all_excel_dim_stg]					@filepath, @date_from = @date_from_dt, @date_to = @date_to_dt

	--Загрузка справочников ОС на dbo
	exec [dbo].[fill_all_excel_dim_dbo]					@date_from, @date_to = @date_to_excel

	--Формирование промежуточной таблицы фактов ОС
	exec [dbo].[fill_fct_volume_agreements]				@date_from, @date_to

	--Формирование отчетных данных Продаж
	exec [dbo].[fill_fct_report_sales_prepare]			@date_from, @date_to
	exec [dbo].[fill_fct_report_sales]					@date_from, @date_to
	
	--Формирование отчетных данных Закупок
	exec [dbo].[fill_fct_report_purchases_prepare]		@date_from, @date_to
	exec [dbo].[fill_fct_report_purchases]				@date_from, @date_to

-- -------------------------------------------------------------------------------------------
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_allocation_dim_invoices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_allocation_dim_invoices] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-04-09
---- Description:	'Заполнение Накладных по отчетному периоду на уровень dbo'
---- EXEC example:	exec [dbo].[fill_allocation_dim_invoices] @filepath = 'C:\allocation_20184.xlsx', @sheet = 'Накладные'
---- ================================================================================
ALTER procedure [dbo].[fill_allocation_dim_invoices]
	@filepath nvarchar(255)
	,@sheet nvarchar(255) = 'Накладные'
as

DECLARE @name varchar(128) = '[dbo].[fill_allocation_dim_invoices]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[allocation_dim_invoices] из Excel накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') + ''''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [dbo].[allocation_dim_invoices]
	
	exec ('INSERT INTO [dbo].[allocation_dim_invoices] (
			  [invoice_number]
			  ,[invoice_date_id]
			  ,[apt_id]
			  ,[coefficient_invoice]
			  ,[allocation_month])
			SELECT distinct 
			  i.[invoice_number]
			  ,dbo.[date_to_int](i.[invoice_date]) as [invoice_date_id]
			  ,a.[apt_id]
			  ,i.[coefficient_invoice]
			  ,i.[allocation_month]			
			FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Номер накладной от АСНА] as [invoice_number]
						,[Дата Накладной] as [invoice_date]
						,[Префикс] as [prefix]
						,[Коэффициент накладной] as [coefficient_invoice]
						,[Распределение в месяц] as [allocation_month]
					FROM [' + @sheet + '$]'') as i
			INNER JOIN (SELECT MAX([apt_id]) as [apt_id], [unit_cll_pref] FROM [dbo].[dim_apt] GROUP BY [unit_cll_pref]) as a 
				ON a.[unit_cll_pref] = i.[prefix]')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_allocation_fct_source_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_allocation_fct_source_purchases] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-04-08
---- Description:	'Заполнение таблицы фактов закуп на АСНА накладных по отчетному периоду на уровень dbo'
---- EXEC example:	exec [dbo].[fill_allocation_fct_source_purchases]
---- ================================================================================
ALTER procedure [dbo].[fill_allocation_fct_source_purchases]
as

DECLARE @name varchar(128) = '[dbo].[fill_allocation_fct_source_purchases_fill]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[allocation_fct_source_purchases]'
DECLARE @input_parametrs nvarchar(128) =  ''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	IF EXISTS (SELECT top 1 * FROM [stg].[allocation_fct_source_purchases])
	BEGIN
		truncate table [dbo].[allocation_fct_source_purchases]

		INSERT INTO [dbo].[allocation_fct_source_purchases] (
				[good_id]
				,[qty]
				,[volume_agreement_id]
				,[manufacturer_id]
				,[purch_price_net]
				,[is_purchase_on_source]
				,[is_arrival_from_source])
		SELECT 
			isnull(g.[good_id], -1) as [good_id]
			,SUM([qty]) as [qty] 
			,isnull(va.[volume_agreement_id], -1) as [volume_agreement_id]
			,isnull(m.[manufacturer_id], -1) as [manufacturer_id]
			,MAX(p.[purch_price_net]) as [purch_price_net]
			,[is_purchase_on_source]
			,[is_arrival_from_source]
		FROM [stg].[allocation_fct_source_purchases] as p
		LEFT JOIN [dbo].[dim_good] as g 
			ON p.[good_source_id] = g.[initial_id]
		LEFT JOIN [dbo].[dim_volume_agreements] as va
			ON p.volume_agreement_source_id = va.volume_agreement_source_id
		LEFT JOIN [dbo].[dim_manufacturer] as m
			ON p.[manufacturer] = m.[manufacturer]
		WHERE p.good_source_id IS NOT NULL
		GROUP BY
			isnull(g.[good_id], -1)
			,isnull(va.[volume_agreement_id], -1)
			,isnull(m.[manufacturer_id], -1)
			,[is_purchase_on_source]
			,[is_arrival_from_source]
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_allocation_fct_coefficients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_allocation_fct_coefficients] AS' 
END
GO



---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-04-23
---- Description:	'Заполнение таблицы коэффициентов для распределения накладных'
---- EXEC example:	exec [dbo].[fill_allocation_fct_coefficients] @filepath = 'C:\allocation_20184.xlsx', @sheet = 'Коэффициенты'
---- EXEC example:	exec [dbo].[fill_allocation_fct_coefficients] @filepath = 'C:\allocation_20190925_test.xlsx', @sheet = 'Коэффициенты'
---- ================================================================================
ALTER procedure [dbo].[fill_allocation_fct_coefficients]
	@filepath nvarchar(255)
	,@sheet nvarchar(255) = 'Коэффициенты'
as

DECLARE @name varchar(128) = '[dbo].[fill_allocation_fct_coefficients]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы коэффициентов [dbo].[allocation_fct_coefficients] из Excel накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') + ''''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [dbo].[allocation_fct_coefficients]
	
	exec ('INSERT INTO [dbo].[allocation_fct_coefficients] (
			  [allocation_month]
			  ,[is_arrival_from_source]
			  ,[is_purchase_on_source]
			  ,[purchases_coefficient]
			  ,[sales_coefficient])
			SELECT distinct * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Месяц]
						,[Учитывают приход от АСНА]
						,[Учитывают закупки на склад АСНА]
						,[Закупки]
						,[Продажи]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_allocation_fct_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_allocation_fct_purchases] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-05-22
---- Description:	'Процедура механизма распределения закупа партнера по накладным'
---- Ильин В.А. Update 3/2/20: Внесено ограничение по аптекам из списка и по прямым контрактам в независимости от того, стоит ли для ОС признак "Отчет по всем аптекам".
---- EXEC example:	exec [dbo].[fill_allocation_fct_purchases] 
---- ================================================================================
ALTER procedure [dbo].[fill_allocation_fct_purchases]
as

DECLARE @name varchar(128) = '[dbo].[fill_allocation_fct_purchases]'
DECLARE @description nvarchar(128) = 'Распределение накладных в таблицу [dbo].[allocation_fct_purchases]'
DECLARE @input_parametrs nvarchar(128) = ''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	DECLARE @first_month int
	SELECT @first_month = MIN(allocation_month) * 100 + 1
	FROM [dbo].[allocation_fct_coefficients] 

	drop table if exists #alloc
	CREATE TABLE #alloc(
		[good_id] [int] NULL,
		[volume_agreement_id] [int] NULL,
		[manufacturer_id] [int] NULL,
		[is_purchase_on_source] [bit] NULL,
		[allocation_month] [int] NULL,
		[final_sum] [float] NULL,
		[purch_price_net] [float] NULL
	) 

	/*
	--Блок распределения количества товаров по месяцам распределения
	--из таблицы коэффициентов.
	--Идет первым в распределении, т.к. благодаря ему можно заранее определить,
	--Сколько товара будет в конкретном месяце, и распределение не будет меняться 
	--при приходе новых накладных в новом месяце.
	--
	--Коэффициенты умножаются на сумму шт по накладным, каждая строка нумеруется по порядку
	--Затем, чтобы уравнять сумму распределенного количества и сумму по накладной,
	--поочередно по пронумерованным строкам отнимается 1 шт до тех пор, пока сумма не уравняется
	*/
	INSERT INTO #alloc(
		[good_id],
		[volume_agreement_id],
		[manufacturer_id],
		[is_purchase_on_source],
		[allocation_month],
		[final_sum],
		[purch_price_net]
	)
	SELECT 
		/*
		Данный внешний запрос предназначен для того, чтобы уравнять сумму до распределения с суммой после (т.к. после умножения на коэффициент и округления до большего сумма может получиться больше, чем была изначальной)
		[qty]	[allocation_month]	[qty_ceiling]	sum([qty_ceiling]) OVER (PARTITION BY [good_id])	sum([qty_ceiling]) OVER (PARTITION BY [good_id]) - [qty]	[row_number]	iif(сравнение разницы и номера строки)	[final_sum]
		5		201812					1			6													1															2				TRUE									1
		5		201901					4			6													1															1				FALSE									3
		5		201902					1			6													1															3				TRUE									1
		*/
		a.[good_id]
		,a.[volume_agreement_id]
		,a.[manufacturer_id]
		,a.[is_purchase_on_source]
		,a.[allocation_month]
		,iif(
			a.[row_number] > sum(a.[qty_ceiling]) OVER (PARTITION BY a.[good_id]) - a.qty
			,a.[qty_ceiling]
			,a.[qty_ceiling] - 1	/*отнимается 1 от округленного кол-ва у тех строк, у которых номер строки больше разницы между изначальным кол-вом и суммой по кол-ву, умноженному на коэффициент и округленному до большего*/
		) as [final_sum]
		,a.[purch_price_net]
	FROM (
		SELECT 
			/*
			кол-во для распределения
			p.[qty]
			5

			коэффициенты по месяцам
			c.[allocation_month]	c.[purchases_coefficient]
			201812					0.2
			201901					0.7
			201902					0.1

			производится пересечение таблиц кол-ва для распределения с таблицей коэффициентов по месяцам
			p.[qty]	c.[allocation_month]	c.[purchases_coefficient]	[qty_ceiling]	[row_number]
			5		201812					0.2							1				2
			5		201901					0.7							4				1
			5		201902					0.1							1				3
			*/
			p.[good_id]
			,p.[volume_agreement_id]
			,p.[manufacturer_id]
			,p.[is_purchase_on_source]
			,c.[allocation_month]
			,p.[qty] /*изначальное кол-во пробрасывается во внешний запрос, чтобы сравнить разницу с суммой по распределенному кол-ву*/					
			,CEILING(c.[purchases_coefficient] * p.[qty]) as [qty_ceiling] /*делается распределение: умножается изначальное кол-во для распределения на коэффициент месяца*/
			,p.[purch_price_net]
			,ROW_NUMBER() OVER(PARTITION BY p.[good_id] ORDER BY c.[purchases_coefficient] desc) as [row_number]/*нумеруются строки в порядке убывания коэффициентов, протягивается во внешний запрос для корректировки разницы сумм после распределения*/
		FROM [dbo].[allocation_fct_source_purchases] as p
		INNER JOIN [dbo].[allocation_fct_coefficients] as c
			ON (p.[is_arrival_from_source] = c.[is_arrival_from_source]
			AND p.[is_purchase_on_source] = c.[is_purchase_on_source])
	) as a
	CREATE CLUSTERED INDEX ix on #alloc (is_purchase_on_source)

	/*
	Блок распределения по накладным
	Принцип распределения такой же, как в предыдущем блоке распределения по месяцам
	*/
	truncate table [dbo].[allocation_fct_purchases]
	INSERT INTO [dbo].[allocation_fct_purchases]
	(
		[good_id]
		,[apt_id]
		,[invoice_id]
		,[is_purchase_on_source]
		,[allocation_month]
		,[purch_qty]
		,[purch_price_net]
	)
	SELECT
		b.[good_id]
		,b.[apt_id]
		,b.[invoice_id]
		,b.[is_purchase_on_source]
		,b.[allocation_month]
		,SUM(b.[final_sum]) as [purch_qty]
		,[purch_price_net]
	FROM(
		SELECT 
			a.[good_id]
			,a.[apt_id]
			,a.[invoice_id]
			,a.[is_purchase_on_source]
			,a.[allocation_month]
			,iif(
				a.[row_number] > sum(a.[qty_ceiling]) OVER (PARTITION BY a.[good_id], a.[allocation_month]) - a.[final_sum]
				,a.[qty_ceiling]
				,a.[qty_ceiling] - 1
			) as [final_sum]
			,a.[purch_price_net]
		FROM (
			SELECT 
				c.[good_id]
				,c.[apt_id]
				,c.[invoice_id]
				,c.[is_purchase_on_source]
				,c.[final_sum]
				,c.[allocation_month]
				,c.[purch_price_net]
				,CEILING(c.[coefficient_invoice] / (sum(c.[coefficient_invoice]) OVER (PARTITION BY c.[good_id], c.[allocation_month])) * c.[final_sum]) as [qty_ceiling]
				,ROW_NUMBER() OVER(PARTITION BY c.[good_id], c.[allocation_month] ORDER BY c.[coefficient_invoice] desc, c.[apt_id]) as [row_number]
			FROM (
				-- ОС с признаком "Нужен список аптек"
				SELECT 
					p.[good_id]
					,i.[apt_id]
					,i.[invoice_id]
					,p.[is_purchase_on_source]
					,p.[final_sum]
					,p.[allocation_month]
					,p.[purch_price_net]
					,i.[coefficient_invoice]
				FROM #alloc as p
				INNER JOIN [dbo].[allocation_dim_invoices] as i -- получение перечня накладных
					/*не помню, для чего это было сделано. Убрал 20190905, т.к. распределение шло в хаотичные месяца
					ON CASE 
						WHEN p.is_purchase_on_source = 1 AND p.[allocation_month] = i.[allocation_month] THEN 1
						WHEN p.is_purchase_on_source = 0 THEN 1
						ELSE 0
					END = 1
					*/
					ON p.[allocation_month] = i.[allocation_month]
				INNER JOIN [dbo].[dim_apt] as a  -- для получения информация об аптечной сети a.[apt_net_id]
					ON i.[apt_id] = a.[apt_id]
				INNER JOIN [dbo].[dim_volume_agreements] as dva --для получения информации о признаке ОС "Нужен список аптек"
					ON p.[volume_agreement_id] = dva.[volume_agreement_id]
				INNER JOIN (
					select distinct [volume_agreement_id], [apt_id] 
					FROM [dbo].[fct_volume_agreements]
					where apt_id <> -1
				) as va--Ограничение списка аптек, разрешенными аптеками из справчоника ОС (1.2.3.Аптеки по ОС)
					ON p.[volume_agreement_id] = va.[volume_agreement_id]
					AND i.[apt_id] = va.[apt_id]
				LEFT JOIN [dbo].[dim_manufacturer_contracts] as mc -- таблица прямых контрактов, для исключения 
					ON p.[manufacturer_id] = mc.[manufacturer_id]
					AND a.[apt_net_id] = mc.[apt_net_id]
					AND @first_month >= mc.[date_from] AND @first_month <= mc.[date_to]--продумать данный момент
				WHERE 
					--dva.[is_all_apt] = 0-- ОС Аптеки из списка
					[dva].[is_list] = 1 -- upd 3/2/20! выбираем ОС со списком аптек
					AND a.[unit_block_date] = convert(date, '1900-01-01')--Исключаются закрытые аптеки
					AND mc.[apt_net_id] IS NULL --Исключаются прямые контракты

				UNION ALL

				-- ОС без признака "Нужен список аптек" 
				SELECT 
					p.[good_id]
					,i.[apt_id]
					,i.[invoice_id]
					,p.[is_purchase_on_source]
					,p.[final_sum]
					,p.[allocation_month]
					,p.[purch_price_net]
					,i.[coefficient_invoice]
				FROM #alloc as p
				INNER JOIN [dbo].[allocation_dim_invoices] as i
					/*не помню, для чего это было сделано. Убрал 20190905, т.к. распределение шло в хаотичные месяца
					ON CASE 
						WHEN p.is_purchase_on_source = 1 AND p.[allocation_month] = i.[allocation_month] THEN 1
						WHEN p.is_purchase_on_source = 0 THEN 1
						ELSE 0
					END = 1
					*/
					ON p.[allocation_month] = i.[allocation_month]
				INNER JOIN [dbo].[dim_apt] as a -- для получения информация об аптечной сети a.[apt_net_id]
					ON i.[apt_id] = a.[apt_id] 
				INNER JOIN [dbo].[dim_volume_agreements] as dva --для получения информации о признаке ОС "Нужен список аптек"
					ON p.[volume_agreement_id] = dva.[volume_agreement_id]
				LEFT JOIN [dbo].[dim_manufacturer_contracts] as mc -- таблица прямых контрактов, для исключения 
					ON p.[manufacturer_id] = mc.[manufacturer_id]
					AND a.[apt_net_id] = mc.[apt_net_id]
					AND @first_month >= mc.[date_from] AND @first_month <= mc.[date_to]--продумать данный момент
				WHERE 
					--dva.[is_all_apt] = 1-- ОС без ограничений по аптекам
					[dva].[is_list] = 0 -- upd 3/2/20! выбираем ОС без списка аптек 
					AND a.[unit_block_date] = convert(date, '1900-01-01')--Исключаются закрытые аптеки
					AND mc.[apt_net_id] IS NULL --Исключаются прямые контракты
			) as c			
		) as a
	) as b
	GROUP BY 
		b.[good_id]
		,b.[apt_id]
		,b.[invoice_id]
		,b.[is_purchase_on_source]
		,b.[allocation_month]
		,b.[purch_price_net]
	HAVING SUM(b.[final_sum]) > 0
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_allocation_fct_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_allocation_fct_sales] AS' 
END
GO



---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-05-29
---- Description:	'Процедура механизма распределения закупа партнера по накладным'
---- EXEC example:	exec [dbo].[fill_allocation_fct_sales] 
---- ================================================================================
ALTER procedure [dbo].[fill_allocation_fct_sales]
as

DECLARE @name varchar(128) = '[dbo].[fill_allocation_fct_sales]'
DECLARE @description nvarchar(128) = 'Распределение накладных в таблицу [dbo].[allocation_fct_sales]'
DECLARE @input_parametrs nvarchar(128) = ''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	
	truncate table [dbo].[allocation_fct_sales]
	--Заполняем распределение продаж для типа учета "Учитывают закуп на АСНА"
	--Для данного типа учета продажи переходят из закупок в те месяцы, которые указаны в таблице коээфициентов Продаж [allocation_fct_sales_coefficients] 
	INSERT INTO [dbo].[allocation_fct_sales]
	(
		[good_id]
		,[apt_id]
		,[allocation_month]
		,[sale_qty]
		,[sale_price_net]
	)
	/*Версия до 20190927. Раньше распределение продаж по типу  "Учитывают закупки на склад АСНА" шло ровно из месяца в месяц
	, теперь добавлены месяцы, в которые необходимо распределять*/
	--SELECT 
	--	[good_id]
	--	,[apt_id]
	--	,[allocation_month]
	--	,SUM([purch_qty]) as [sale_qty]
	--	,[purch_price_net] as [sale_price_net]
	--FROM [dbo].[allocation_fct_purchases]
	--where [is_purchase_on_source] = 1
	--group by 
	--	[good_id]
	--	,[apt_id]
	--	,[allocation_month]
	--	,[purch_price_net]
	SELECT 
		[good_id]
		,[apt_id]
		,[allocation_month]
		,SUM([sale_qty]) as [sale_qty]
		,[sale_price_net]
	FROM (
		SELECT 
			a.[good_id]
			,a.[apt_id]
			,a.[sales_allocation_month] as [allocation_month]
			,iif(
				a.[row_number] > sum(a.[qty_ceiling]) OVER (PARTITION BY a.[good_id], a.[apt_id], a.[purchase_allocation_month]) - a.qty
				,a.[qty_ceiling]
				,a.[qty_ceiling] - 1
			) as [sale_qty]
			,a.[sale_price_net]
		FROM (
			SELECT 
				p.[good_id]
				,p.[apt_id]
				,sc.[purchase_allocation_month]
				,sc.[sales_allocation_month]
				,SUM(p.[purch_qty]) as [qty]
				,CEILING(SUM(sc.[sales_coefficient] * p.[purch_qty])) as [qty_ceiling] --as [sale_qty]
				,p.[purch_price_net] as [sale_price_net]
				,ROW_NUMBER() OVER(PARTITION BY p.[good_id], p.[apt_id], sc.[purchase_allocation_month] ORDER BY sc.[sales_allocation_month] desc) as [row_number]
			FROM [dbo].[allocation_fct_purchases] as p
			INNER JOIN [dbo].[allocation_fct_sales_coefficients] as sc
				ON p.[allocation_month] = sc.[purchase_allocation_month]
			WHERE p.[is_purchase_on_source] = 1
				and sc.[sales_coefficient] != 0
			GROUP BY 
				p.[good_id]
				,p.[apt_id]
				,sc.[purchase_allocation_month]
				,sc.[sales_allocation_month]
				,p.[purch_price_net]
		) as a
	) as b
	GROUP BY 
		[good_id]
		,[apt_id]
		,[allocation_month]
		,[sale_price_net]
	HAVING SUM([sale_qty]) > 0
	
	--Заполняем распределение продаж для типа учета "Учитывают приход от АСНА"
	--Для данного типа учета продажи распределяются по коэффициентам
	INSERT INTO [dbo].[allocation_fct_sales]
	(
		[good_id]
		,[apt_id]
		,[allocation_month]
		,[sale_qty]
		,[sale_price_net]
	)	
	SELECT 
		[good_id]
		,[apt_id]
		,[allocation_month]
		,SUM([sale_qty]) as [sale_qty]
		,[sale_price_net]
	FROM (
		SELECT 
			a.[good_id]
			,a.[apt_id]
			,a.[allocation_month]
			,iif(
				a.[row_number] > sum(a.[qty_ceiling]) OVER (PARTITION BY a.[good_id], a.[apt_id]) - a.qty
				,a.[qty_ceiling]
				,a.[qty_ceiling] - 1
			) as [sale_qty]
			,a.[sale_price_net]
		FROM (
			SELECT 
				p.[good_id]
				,p.[apt_id]
				,c.[allocation_month]
				,SUM(p.[purch_qty]) as [qty]
				,CEILING(SUM(c.[sales_coefficient] * p.[purch_qty])) as [qty_ceiling] --as [sale_qty]
				,p.[purch_price_net] as [sale_price_net]
				,ROW_NUMBER() OVER(PARTITION BY p.[good_id], p.[apt_id] ORDER BY c.[allocation_month] desc) as [row_number]
			FROM [dbo].[allocation_fct_purchases] as p
			INNER JOIN [dbo].[allocation_fct_coefficients] as c
				ON c.[is_purchase_on_source] = 0
			WHERE p.[is_purchase_on_source] = 0
			GROUP BY 
				p.[good_id]
				,p.[apt_id]
				,c.[allocation_month]
				,p.[purch_price_net]
			HAVING CEILING(SUM(c.[sales_coefficient] * p.[purch_qty])) > 0
		) as a
	) as b
	GROUP BY 
		[good_id]
		,[apt_id]
		,[allocation_month]
		,[sale_price_net]
	HAVING SUM([sale_qty]) > 0

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_allocation_fct_sales_coefficients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_allocation_fct_sales_coefficients] AS' 
END
GO



---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-04-23
---- Description:	'Заполнение таблицы коэффициентов Продаж для распределения продаж из закупок'
---- EXEC example:	exec [dbo].[fill_allocation_fct_sales_coefficients] @filepath = 'C:\Lasmart\allocation_20190925_test.xlsx', @sheet = 'Коэффициенты Продаж'
---- ================================================================================
ALTER procedure [dbo].[fill_allocation_fct_sales_coefficients]
	@filepath nvarchar(255)
	,@sheet nvarchar(255) = 'Коэффициенты Продаж'
as

DECLARE @name varchar(128) = '[dbo].[fill_allocation_fct_sales_coefficients]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы коэффициентов продаж [dbo].[allocation_fct_sales_coefficients] из Excel накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') + ''''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [dbo].[allocation_fct_sales_coefficients]
	
	exec ('INSERT INTO [dbo].[allocation_fct_sales_coefficients] (
			  [purchase_allocation_month]
			  ,[sales_allocation_month]
			  ,[sales_coefficient])
			SELECT distinct * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Месяц Закупки]
						,[Месяц Продажи]
						,[Продажи]
					FROM [' + @sheet + '$A2:C]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_auto_volume_agreements_list]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_auto_volume_agreements_list] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-12-25
---- Description:	'Заполнение списка ОС для автоформирования отчетов по ОС'
---- EXEC example:	exec [dbo].[fill_auto_volume_agreements_list] 'C:\.xlsb', 'Список ОС'
---- ================================================================================
ALTER procedure [dbo].[fill_auto_volume_agreements_list]
	@filepath nvarchar(255) = 'C:\FTP\source\input\os\os.xlsx'
	,@sheet nvarchar(255) = 'Список ОС'
as

DECLARE @name varchar(128) = '[dbo].[fill_auto_volume_agreements_list]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[auto_volume_agreements_list] из Excel накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ' + isnull(@filepath,'') + ', @sheet = ' + isnull(@sheet,'')

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [dbo].[auto_volume_agreements_list]
	
	exec ('INSERT INTO [dbo].[auto_volume_agreements_list] (
			    [volume_agreement_source_id]
			    ,[volume_agreement_id])
			SELECT  
				convert(int, a.[Список на пересчет])
				,isnull(va1.[volume_agreement_id], -1)
			FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=NO;
					IMEX=1;'',
					''SELECT 
						F1 as [Список на пересчет]
					FROM [' + @sheet + '$A2:A]'') as a
			INNER JOIN [dbo].[dim_volume_agreements] as va1
				ON convert(int, a.[Список на пересчет]) = va1.[volume_agreement_source_id]')

	exec ('INSERT INTO [dbo].[auto_volume_agreements_list] (
			    [volume_agreement_right_source_id]
				,[volume_agreement_right_id])
			SELECT  
				convert(int, a.[Список на пересчет месяц справа])
				,isnull(va2.[volume_agreement_id], -1)
			FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=NO;
					IMEX=1;'',
					''SELECT 
						F1 as [Список на пересчет месяц справа] 
					FROM [' + @sheet + '$B2:B]'') as a
			INNER JOIN [dbo].[dim_volume_agreements] as va2
				ON convert(int, a.[Список на пересчет месяц справа]) = va2.[volume_agreement_source_id]')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_auto_volume_agreements_settings]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_auto_volume_agreements_settings] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-12-25
---- Description:	'Заполнение таблицы настроек для автоформирования отчетов по ОС'
---- EXEC example:	exec [dbo].[fill_auto_volume_agreements_settings] 'C:\FTP\source\examples\os.xlsx', 'ОС Мероприятия'
---- ================================================================================
ALTER procedure [dbo].[fill_auto_volume_agreements_settings]
	@filepath nvarchar(255) = 'C:\FTP\source\input\os\os.xlsx'
	,@sheet nvarchar(255) = 'ОС Мероприятия'
as

DECLARE @name varchar(128) = '[dbo].[fill_auto_volume_agreements_settings]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[auto_volume_agreements_settings] из Excel накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ' + isnull(@filepath,'') + ', @sheet = ' + isnull(@sheet,'')

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [dbo].[auto_volume_agreements_settings]
	
	exec ('INSERT INTO [dbo].[auto_volume_agreements_settings] (
			  [volume_agreement_source_id]
			  ,[volume_agreement_id]
			  ,[date_from]
			  ,[date_to]
			  ,[purchases_dim_apt_unit_descr]
			  ,[purchases_dim_apt_unit_fact_address]
			  ,[purchases_dim_apt_unitInn]
			  ,[purchases_dim_apt_unit_legal_entity]
			  ,[purchases_dim_apt_unit_cll_pref]
			  ,[purchases_dim_apt_unit_net_name]
			  ,[purchases_dim_apt_unit_region_name]
			  ,[purchases_dim_supplier_descr]
			  ,[purchases_dim_supplier_inn]
			  ,[purchases_dim_good_descr]
			  ,[purchases_dim_good_initial_id]
			  ,[purchases_dim_date_year_id]
			  ,[purchases_dim_date_month_name]
			  ,[purchases_fct_report_purchases_purch_cip]
			  ,[purchases_fct_report_purchases_purch_grs]
			  ,[purchases_fct_report_purchases_purch_net]
			  ,[purchases_fct_report_purchases_qty]
			  ,[sales_dim_apt_unit_descr]
			  ,[sales_dim_apt_unit_fact_address]
			  ,[sales_dim_apt_unitInn]
			  ,[sales_dim_apt_unit_legal_entity]
			  ,[sales_dim_apt_unit_cll_pref]
			  ,[sales_dim_apt_unit_net_name]
			  ,[sales_dim_apt_unit_region_name]
			  ,[sales_dim_good_descr]
			  ,[sales_dim_good_initial_id]
			  ,[sales_dim_date_year_id]
			  ,[sales_dim_date_month_name]
			  ,[sales_fct_report_sales_sale_cip]
			  ,[sales_fct_report_sales_sale_grs]
			  ,[sales_fct_report_sales_sale_net]
			  ,[sales_fct_report_sales_qty] )
			SELECT 
					convert(int, [Код 1с]) 
					,isnull(va.[volume_agreement_id], -1)
					,dbo.date_to_int(convert(date, [Начало]))
					,dbo.date_to_int(convert(date, [Конец] ))
					,[Закупки Аптека (тек)] 
					,[Закупки Фактический адрес (тек)] 
					,[Закупки ИНН Сети - аптеки (тек)] 
					,[Закупки Юр лицо (тек)] 
					,[Закупки Внешний код (тек)] 
					,[Закупки Сеть (тек)] 
					,[Закупки Регион (тек)]
					,[Закупки Поставщик] 
					,[Закупки ИНН Поставщика]
					,[Закупки Товар] 
					,[Закупки Код товара (ННТ)] 
					,[Закупки Год] 
					,[Закупки Месяц] 
					,[Закупки сумма руб CIP по ОС] 
					,[Закупки руб с НДС по ОС] 
					,[Закупки руб без НДС по ОС] 
					,[Закупки шт по ОС] 
					,[Продажи Аптека (тек)] 
					,[Продажи Фактический адрес (тек)] 
					,[Продажи ИНН Сети - аптеки (тек)] 
					,[Продажи Юр лицо (тек)] 
					,[Продажи Внешний код (тек)] 
					,[Продажи Сеть (тек)] 
					,[Продажи Регион (тек)] 
					,[Продажи Товар] 
					,[Продажи Код товара (ННТ)] 
					,[Продажи Год] 
					,[Продажи Месяц] 
					,[Продажи сумма руб CIP по ОС] 
					,[Продажи с НДС по ОС] 
					,[Продажи без НДС по ОС] 
					,[Продажи шт по ОС]
				FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=NO;
					IMEX=1;'',
					''SELECT 
						F1 as [Код 1с] 
						,F6 as [Начало] 
						,F7 as [Конец] 
						,F10 as [Закупки Аптека (тек)] 
						,F11 as [Закупки Фактический адрес (тек)] 
						,F12 as [Закупки ИНН Сети - аптеки (тек)] 
						,F13 as [Закупки Юр лицо (тек)] 
						,F14 as [Закупки Внешний код (тек)] 
						,F15 as [Закупки Сеть (тек)] 
						,F16 as [Закупки Регион (тек)]
						,F17 as [Закупки Поставщик] 
						,F18 as [Закупки ИНН Поставщика]
						,F19 as [Закупки Товар] 
						,F20 as [Закупки Код товара (ННТ)] 
						,F21 as [Закупки Год] 
						,F22 as [Закупки Месяц] 
						,F23 as [Закупки цена руб CIP]
						,F24 as [Закупки сумма руб CIP по ОС] 
						,F25 as [Закупки руб с НДС по ОС] 
						,F26 as [Закупки руб без НДС по ОС] 
						,F27 as [Закупки шт по ОС] 
						,F28 as [Продажи Аптека (тек)] 
						,F29 as [Продажи Фактический адрес (тек)] 
						,F30 as [Продажи ИНН Сети - аптеки (тек)] 
						,F31 as [Продажи Юр лицо (тек)] 
						,F32 as [Продажи Внешний код (тек)] 
						,F33 as [Продажи Сеть (тек)] 
						,F34 as [Продажи Регион (тек)] 
						,F35 as [Продажи Товар] 
						,F36 as [Продажи Код товара (ННТ)] 
						,F37 as [Продажи Год] 
						,F38 as [Продажи Месяц] 
						,F39 as [Продажи цена руб CIP]
						,F40 as [Продажи сумма руб CIP по ОС] 
						,F41 as [Продажи с НДС по ОС] 
						,F42 as [Продажи без НДС по ОС] 
						,F43 as [Продажи шт по ОС]
					FROM [' + @sheet + '$A4:BZ]'') as a
					INNER JOIN [dbo].[dim_volume_agreements] as va
						ON convert(int, a.[Код 1с]) = va.[volume_agreement_source_id]')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_apt]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_apt] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-20
---- Description:  'Заполнение справочника Аптеки'
---- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
---- ================================================================================
---- exec [dbo].[fill_dim_apt]
ALTER PROCEDURE [dbo].[fill_dim_apt]
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_apt]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Аптеки'
DECLARE @input_parametrs nvarchar(500) = ''
begin try
exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	

	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'SELECT 
		 [PHARM_ID]
		,[UNIT_ID]
		,[UNIT_INITIAL_ID]
		,[UNIT_NAME]
		,[UNIT_FULL_NAME]
		,[UNIT_PHONE]
		,[UNIT_IS_ACTIVE]
		,[UNIT_IS_ACTIVE_NAME]
		,[UNIT_INN]
		,[UNIT_NET_ID]
		,[UNIT_NET_NAME]
		,[UNIT_NET_STATUS_ID]
		,[UNIT_NET_STATUS_NAME]
		,[UNIT_REGION_ID]
		,[UNIT_REGION_NAME]
		,[UNIT_LEGAL_ENTITY]
		,[UNIT_ADDRESS]
		,[UNIT_COMMISSION_source]
		,[UNIT_MARKETING_DATE]
		,[UNIT_PREFIX]
		,[UNIT_LEGAL_ENTITY_ADDRESS]
		,[UNIT_CITY]
		,0 as [UnitForAnalysisMarketingID]
		,''н/д'' as [UnitForAnalysisMarketingName]
		,[UNIT_TYPE_ID]
		,[UNIT_TYPE_NAME]
		,[UNIT_COUNTRY_ID]
		,[UNIT_COUNTRY_NAME]
		,[UNIT_BLOCK_DATE]
		,[PHARM_INITIAL_ID]
		,[PHARM_NAME]
		,[PHARM_FULL_NAME]
		,[PHARM_PHONE]
		,[PHARM_IS_ACTIVE]
		,[PHARM_IS_ACTIVE_NAME]
		,[PHARM_INN]
		,[PHARM_NET_ID]
		,[PHARM_NET_NAME]
		,[PHARM_NET_STATUS_ID]
		,[PHARM_NET_STATUS_NAME]
		,[PHARM_REGION_ID]
		,[PHARM_REGION_NAME]
		,[PHARM_LEGAL_ENTITY]
		,[PHARM_ADDRESS]
		,[PHARM_COMMISSION_source]
		,[PHARM_MARKETING_DATE]
		,[PHARM_PREFIX]
		,[PHARM_LEGAL_ENTITY_ADDRESS]
		,[PHARM_CITY]
		,[PHARM_TYPE_ID]
		,[PHARM_TYPE_NAME]
		,[PHARM_COUNTRY_ID]
		,[PHARM_COUNTRY_NAME]
		,[PHARM_BLOCK_DATE]
	FROM [source_DWH].[DWH].[UV_DIM_PHARMACIES] with (nolock)'
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')' --Update 20-03-2020 Изменился источник данных


if Object_ID('tempdb..#dim_apt') is not null drop table #dim_apt
create table #dim_apt
(
	[apt_id] [int] NOT NULL,
	[unit_id] [int] NULL,
	[unitInitial_id] [int] NULL,
	[unit_descr] [nvarchar](150) NULL,
	[unit_full_name] [nvarchar](250) NULL,
	[unit_phone] [nvarchar](100) NULL,
	[unit_is_active_id] [int] NULL,
	[unit_is_active_name] [nvarchar](10) NULL,
	[unitInn] [nvarchar](30) NULL,
	[unit_net_id] [int] NULL,
	[unit_net_name] [varchar](255) NULL,
	[unit_net_status_id] [int] NULL,
	[unit_net_status_name] [nvarchar](100) NULL,
	[unit_region_id] [int] NULL,
	[unit_region_name] [nvarchar](200) NULL,
	[unit_legal_entity] [nvarchar](255) NULL,
	[unit_fact_address] [nvarchar](400) NULL,
	[unit_legal_entity_cc] [numeric](18, 4) NULL,
	[unit_contragent_marketing_date] [date] NULL,
	[unit_cll_pref] [nvarchar](20) NULL,
	[unit_lb_fa] [nvarchar](658) NULL,
	[unit_city] [nvarchar](255) NULL,
	[unit_for_analysis_marketing_id] [bit] NULL,
	[unit_for_analysis_marketing_name] [varchar](3) NULL,
	[unit_apt_type_id] [int] NULL,
	[unit_apt_type_name] [varchar](100) NULL,
	[unit_cntr_id] [int] NULL,
	[unit_cntr_name] [nvarchar](60) NULL,
	[unit_block_date] [datetime] NULL,
	[aptInitial_id] [bigint] NULL,
	[apt_descr] [nvarchar](250) NULL,
	[apt_full_name] [nvarchar](250) NULL,
	[apt_phone] [nvarchar](100) NULL,
	[apt_Is_active_id] [tinyint] NULL,
	[apt_Is_active_name] [varchar](10) NULL,
	[aptInn] [nvarchar](30) NULL,
	[apt_net_id] [int] NULL,
	[apt_net_name] [nvarchar](255) NULL,
	[apt_net_status_id] [int] NULL,
	[apt_net_status_name] [nvarchar](100) NULL,
	[apt_region_id] [int] NULL,
	[apt_region_name] [nvarchar](200) NULL,
	[apt_legal_entity] [nvarchar](255) NULL,
	[apt_fact_address] [nvarchar](400) NULL,
	[apt_legal_entity_cc] [numeric](18, 4) NULL,
	[apt_contragent_marketing_date] [int] NULL,
	[apt_clip_ref] [nvarchar](20) NULL,
	[apt_lb_fa] [nvarchar](658) NULL,
	[apt_city] [nvarchar](255) NULL,
	[apt_apt_type_id] [int] NULL,
	[apt_apt_type_name] [nvarchar](100) NULL,
	[apt_cntr_id] [int] NULL,
	[apt_cntr_name] [varchar](60) NULL,
	[apt_block_date] [datetime] NULL
)
insert into #dim_apt
(
	   [apt_id]
      ,[unit_id]
      ,[unitInitial_id]
      ,[unit_descr]
      ,[unit_full_name]
      ,[unit_phone]
      ,[unit_is_active_id]
      ,[unit_is_active_name]
      ,[unitInn]
      ,[unit_net_id]
      ,[unit_net_name]
      ,[unit_net_status_id]
      ,[unit_net_status_name]
      ,[unit_region_id]
      ,[unit_region_name]
      ,[unit_legal_entity]
      ,[unit_fact_address]
      ,[unit_legal_entity_cc]
      ,[unit_contragent_marketing_date]
      ,[unit_cll_pref]
      ,[unit_lb_fa]
      ,[unit_city]
      ,[unit_for_analysis_marketing_id]
      ,[unit_for_analysis_marketing_name]
      ,[unit_apt_type_id]
      ,[unit_apt_type_name]
      ,[unit_cntr_id]
      ,[unit_cntr_name]
      ,[unit_block_date]
      ,[aptInitial_id]
      ,[apt_descr]
      ,[apt_full_name]
      ,[apt_phone]
      ,[apt_Is_active_id]
      ,[apt_Is_active_name]
      ,[aptInn]
      ,[apt_net_id]
      ,[apt_net_name]
      ,[apt_net_status_id]
      ,[apt_net_status_name]
      ,[apt_region_id]
      ,[apt_region_name]
      ,[apt_legal_entity]
      ,[apt_fact_address]
      ,[apt_legal_entity_cc]
      ,[apt_contragent_marketing_date]
      ,[apt_clip_ref]
      ,[apt_lb_fa]
      ,[apt_city]
      ,[apt_apt_type_id]
      ,[apt_apt_type_name]
      ,[apt_cntr_id]
      ,[apt_cntr_name]
      ,[apt_block_date]
)
exec (@sql_openquery)


IF  
(select count(1) from #dim_apt)>0
BEGIN 
truncate table dbo.dim_apt
insert into dbo.dim_apt
(
       [apt_id]
      ,[unit_id]
      ,[unitInitial_id]
      ,[unit_descr]
      ,[unit_full_name]
      ,[unit_phone]
      ,[unit_is_active_id]
      ,[unit_is_active_name]
      ,[unitInn]
      ,[unit_net_id]
      ,[unit_net_name]
      ,[unit_net_status_id]
      ,[unit_net_status_name]
      ,[unit_region_id]
      ,[unit_region_name]
      ,[unit_legal_entity]
      ,[unit_fact_address]
      ,[unit_legal_entity_cc]
      ,[unit_contragent_marketing_date]
      ,[unit_cll_pref]
      ,[unit_lb_fa]
      ,[unit_city]
      ,[unit_for_analysis_marketing_id]
      ,[unit_for_analysis_marketing_name]
      ,[unit_apt_type_id]
      ,[unit_apt_type_name]
      ,[unit_cntr_id]
      ,[unit_cntr_name]
      ,[unit_block_date]
      ,[aptInitial_id]
      ,[apt_descr]
      ,[apt_full_name]
      ,[apt_phone]
      ,[apt_Is_active_id]
      ,[apt_Is_active_name]
      ,[aptInn]
      ,[apt_net_id]
      ,[apt_net_name]
      ,[apt_net_status_id]
      ,[apt_net_status_name]
      ,[apt_region_id]
      ,[apt_region_name]
      ,[apt_legal_entity]
      ,[apt_fact_address]
      ,[apt_legal_entity_cc]
      ,[apt_contragent_marketing_date]
      ,[apt_clip_ref]
      ,[apt_lb_fa]
      ,[apt_city]
      ,[apt_apt_type_id]
      ,[apt_apt_type_name]
      ,[apt_cntr_id]
      ,[apt_cntr_name]
      ,[apt_block_date]
)
SELECT 
	[apt_id],
	isnull([unit_id], 0) as [unit_id],
	isnull([unitInitial_id], 0) as [unitInitial_id],
	isnull([unit_descr], '') as [unit_descr],
	isnull([unit_full_name], '') as [unit_full_name],
	isnull([unit_phone], '') as [unit_phone],
	isnull([unit_is_active_id], 0) as [unit_is_active_id],
	isnull([unit_is_active_name], '') as [unit_is_active_name],
	isnull([unitInn], '') as [unitInn],
	isnull([unit_net_id], 0) as [unit_net_id],
	isnull([unit_net_name], '') as [unit_net_name],
	isnull([unit_net_status_id], 0) as [unit_net_status_id],
	isnull([unit_net_status_name], '') as [unit_net_status_name],
	isnull([unit_region_id], 0) as [unit_region_id],
	isnull([unit_region_name], '') as [unit_region_name],
	isnull([unit_legal_entity], '') as [unit_legal_entity],
	isnull([unit_fact_address], '') as [unit_fact_address],
	isnull([unit_legal_entity_cc], 0) as [unit_legal_entity_cc],
	isnull([unit_contragent_marketing_date], convert(date, '1900-01-01')) as [unit_contragent_marketing_date],
	isnull([unit_cll_pref], '') as [unit_cll_pref],
	isnull([unit_lb_fa], '') as [unit_lb_fa],
	isnull([unit_city], '') as [unit_city],
	isnull([unit_for_analysis_marketing_id], convert(bit, 0)) as [unit_for_analysis_marketing_id],
	isnull([unit_for_analysis_marketing_name], '') as [unit_for_analysis_marketing_name],
	isnull([unit_apt_type_id], 0) as [unit_apt_type_id],
	isnull([unit_apt_type_name], '') as [unit_apt_type_name],
	isnull([unit_cntr_id], 0) as [unit_cntr_id],
	isnull([unit_cntr_name], '') as [unit_cntr_name],
	isnull([unit_block_date], convert(datetime, '1900-01-01 00:00:00.000')) as [unit_block_date],
	isnull([aptInitial_id], 0) as [aptInitial_id],
	isnull([apt_descr], '') as [apt_descr],
	isnull([apt_full_name], '') as [apt_full_name],
	isnull([apt_phone], '') as [apt_phone],
	isnull([apt_Is_active_id], 0) as [apt_Is_active_id],
	isnull([apt_Is_active_name], '') as [apt_Is_active_name],
	isnull([aptInn], '') as [aptInn],
	isnull([apt_net_id], 0) as [apt_net_id],
	isnull([apt_net_name], '') as [apt_net_name],
	isnull([apt_net_status_id], 0) as [apt_net_status_id],
	isnull([apt_net_status_name], '') as [apt_net_status_name],
	isnull([apt_region_id], 0) as [apt_region_id],
	isnull([apt_region_name], '') as [apt_region_name],
	isnull([apt_legal_entity], '') as [apt_legal_entity],
	isnull([apt_fact_address], '') as [apt_fact_address],
	isnull([apt_legal_entity_cc], 0) as [apt_legal_entity_cc],
	isnull([apt_contragent_marketing_date], 0) as [apt_contragent_marketing_date],
	isnull([apt_clip_ref], '') as [apt_clip_ref],
	isnull([apt_lb_fa], '') as [apt_lb_fa],
	isnull([apt_city], '') as [apt_city],
	isnull([apt_apt_type_id], 0) as [apt_apt_type_id],
	isnull([apt_apt_type_name], '') as [apt_apt_type_name],
	isnull([apt_cntr_id], 0) as [apt_cntr_id],
	isnull([apt_cntr_name], '') as [apt_cntr_name],
	isnull([apt_block_date], convert(datetime, '1900-01-01 00:00:00.000')) as [apt_block_date]
 FROM #dim_apt
 END


 exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
  if  Object_ID('tempdb..#dim_apt') is not null drop table #dim_apt
 end try      
 begin catch
 exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
  if  Object_ID('tempdb..#dim_apt') is not null drop table #dim_apt
 return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_date]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_date] AS' 
END
GO



--delete from  dbo.lasmart_t_dim_date where date_id >=20180101
ALTER procedure [dbo].[fill_dim_date]
as
--устанавливаем первый деньо недели - ПОНЕДЕЛЬНИК
set datefirst 1
truncate table dbo.dim_date
declare @dt datetime

set @dt = '2000-01-01'
while @dt<'2050-01-01'
begin
insert dbo.dim_date([date_time],[date_id],[date_name],[year_id],[year_name],[quarter_id],[quarter_name],[quarter_full_name],
[month_id],[month_name],[month_full_name],[month_number],[week_id],[week_name],[week_full_name],[weekday_number],[weekday_name],[week_number],[day_type_id],[day_type_name])


select 
	[date_time] = @dt, 
	[date_id] = datepart(yyyy,@dt)*10000+datepart(mm,@dt)*100 + datepart(dd,@dt), 
	[date_name] = convert(char(10),@dt,104),
	[year_id] = datepart(yyyy,@dt),
	[year_name] = convert(char(4),datepart(yyyy,@dt)),
	[quarter_id] = datepart(yyyy,@dt)*10+datepart(qq,@dt),
	[quarter_name] = convert(char(1),datepart(qq,@dt)) + ' квартал',
	[quarter_full_name] = convert(char(4),datepart(yyyy,@dt)) +'/'+convert(char(1),datepart(qq,@dt)) + ' квартал',
	[month_id] = datepart(yyyy,@dt)*100+datepart(mm,@dt),
	[month_name] = case datepart(mm,@dt) 
						when 1  then 'Январь'
						when 2  then 'Февраль'
						when 3  then 'Март'
						when 4  then 'Апрель'
						when 5  then 'Май'
						when 6  then 'Июнь'
						when 7  then 'Июль'
						when 8  then 'Август'
						when 9  then 'Сентябрь'
						when 10 then 'Октябрь'
						when 11 then 'Ноябрь'
						when 12 then 'Декабрь'
					 end,
	[month_full_name] = convert(char(4),datepart(yyyy,@dt)) +'/'+ case datepart(mm,@dt) 
														when 1  then 'Январь'
														when 2  then 'Февраль'
														when 3  then 'Март'
														when 4  then 'Апрель'
														when 5  then 'Май'
														when 6  then 'Июнь'
														when 7  then 'Июль'
														when 8  then 'Август'
														when 9  then 'Сентябрь'
														when 10 then 'Октябрь'
														when 11 then 'Ноябрь'
														when 12 then 'Декабрь'
					 end,
	[month_number] = datepart(mm,@dt),					
	[week_id] = datepart(yyyy,@dt)*100+datepart(wk,@dt),
	[week_name] = left ('00', 2-len(convert(char(4),datepart(wk,@dt))) )+convert(varchar(4),datepart(wk,@dt))+ ' Неделя',
	[week_full_name] = convert(char(4),datepart(yyyy,@dt)) +'/'+left ('00', 2-len(convert(varchar(4),datepart(wk,@dt))) )+ convert(varchar(4),datepart(wk,@dt))+ ' Неделя',
	[weekday_number] = 	case datepart(dw,@dt) 
					when 1  then 1
					when 2  then 2
					when 3  then 3
					when 4  then 4
					when 5  then 5
					when 6  then 6
					when 7  then 7
				end,
	[weekday_name] = case datepart(dw,@dt) 
			when 1  then 'Понедельник'
			when 2  then 'Вторник'
			when 3  then 'Среда'
			when 4  then 'Четверг'
			when 5  then 'Пятница'
			when 6  then 'Суббота'
			when 7  then 'Воскресенье'
	end,
	[week_number] = datepart(wk,@dt),	
	[day_type_id] = case datepart(dw,@dt) 
					when 1  then 1
					when 2  then 1
					when 3  then 1
					when 4  then 1
					when 5  then 1
					when 6  then 2
					when 7  then 2
				END,
	[day_type_name] = case datepart(dw,@dt) 
					when 1  then 'Рабочий'
					when 2  then 'Рабочий'
					when 3  then 'Рабочий'
					when 4  then 'Рабочий'
					when 5  then 'Рабочий'
					when 6  then 'Выходной'
					when 7  then 'Выходной'
				end
	select @dt = dateadd(day,1,@dt)
end

select * from dbo.dim_date order by 1

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_distributor_limitations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_distributor_limitations] AS' 
END
GO




---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-31
---- Description:  'Заполнение справочника Ограничения дистрибьюторов'
---- EXEC example:	exec [dbo].[fill_dim_distributor_limitations] @date_from = 20181001, @date_to = 20181231
ALTER PROCEDURE [dbo].[fill_dim_distributor_limitations]
@date_from int
,@date_to int
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_distributor_limitations]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Ограничения дистрибьюторов'
DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)
begin try
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	IF exists (SELECT top 1 * 
		FROM [stg].[excel_dim_distributor_limitations] 
		WHERE date_from = @date_from AND date_to = @date_to)
	BEGIN
		DELETE FROM [dbo].[dim_distributor_limitations] WHERE date_from = @date_from AND date_to = @date_to
		INSERT INTO [dbo].[dim_distributor_limitations] 
			([manufacturer_id]
			,[supplier_id]
			,[date_from]
			,[date_to])
		SELECT distinct
			m.[manufacturer_id]
			,s.[supplier_id]
			,sp.[date_from]
			,sp.[date_to]
		FROM [stg].[excel_dim_distributor_limitations] as sp
		INNER JOIN [dbo].[dim_manufacturer] as m on m.manufacturer = sp.manufacturer
		INNER JOIN [dbo].[dim_supplier] as s on s.inn = sp.supplier_inn
	END
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 end try      
 begin catch
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_good]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_good] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-20
---- Description:  'Заполнение справочника Товары'
---- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
---- ================================================================================
---- exec [dbo].[fill_dim_good]
ALTER PROCEDURE [dbo].[fill_dim_good]
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_good]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Товары'
DECLARE @input_parametrs nvarchar(500) = ''
begin try
exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	

	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'SELECT 
		[ID]
		,''нет данных'' as [TableRowGUID]
		,[INITIAL_ID]
		,[NAME]
		,[COUNTRY_NAME]
		,[MARKETING_CLUSTER_NAME]
		,[PACKING]
		,[CONCERN_NAME]
		,[BRAND_NAME]
		,[TRADE_MARK_NAME]
		,''нет данных'' as [Form]
		,iif([DOSAGE_UNIT] IS NULL, ''Нет данных'', CONVERT(NVARCHAR(30), [DOSAGE]) + '' ''+ [DOSAGE_UNIT]) as [Dosage]
		,iif([PRE_PACKING_UNIT] IS NULL, ''Нет данных'', CONVERT(NVARCHAR(30), [PRE_PACKING]) + '' '' + [PRE_PACKING_UNIT]) as [PrePacking]
		,[MNN_NAME]
		,''нет данных'' as [FormOut]
		,[IS_VITAL]
		,[PRODUCT_PHARM_GROUP_NAME]
		,''нет данных''
		,[IS_CODEIN]
		,[IS_PKU_GROUP]
		,''нет данных'' as [Properties]
		,[VAT_RATE]
		,[MODE_APPLICATION]
		,[IS_ACTIVE]
		,[CLUSTER_ID]
		,[PRODUCT_GROUP_ID]
		,[IS_HOSPITAL]
		,[MEGA_CATEGORY_NAME] as [megs_cat]
		,[CATEGORY_NAME]
		,[CPE_NAME]
		,-1 as [ConcernID]
		,''нет данных'' as [RbMNN]
		,''нет данных'' as [RbCPE]
		,''н/д'' as [RbBrendOrMNN]
		,''нет данных'' as [RbLefForm]
		,''нет данных'' as [RbDosage]
		,''нет данных'' as [RbFasov]
		,-1 as [RbCpeTopConcern]
		,''нет данных'' as [RbMegsCat]
		,-1 as [ID_1C_DWH]
		,''нет данных'' as [RbSposobPrim]
		,''нет данных'' as [RbZHNVLS]
		,''нет данных'' as [RbNDS]
		,''нет данных'' as [RbWithKodein]
		,''нет данных'' as [RbConcern]
		,''нет данных'' as [RbManufacturer]
		,''нет данных'' as [RbCategory]
		,''нет данных'' as [RbClaster]
		,''нет данных'' as [RbSubGroup]
		,''нет данных'' as [RbBrend]
		,''нет данных'' as [RbTradeMark]
		,''н/д'' as [RbInvest]
		,''нет данных'' as [RbBezdefectur]
		,[APPLICATION_AREA_ID]
		,[APPLICATION_AREA_NAME]
		,[PRODUCT_GROUP_ID] as [group_products_id]
		,[PRODUCT_GROUP_NAME] as [group_products_name]
		,[MANUFACTURER_ID] as [manufacturer_m_id]
		,[MANUFACTURER_NAME] as [manufacturer_m_name]
		,[MEDICATION_GROUP_NAME]
		,[MARKETING_BRAND_ID]
		,[MARKETING_CLUSTER_ID]
		,[PKU_GROUP]
		,[CODEIN]
		,[VITAL]
		,[HOSPITAL]
		,[ACTIVE]
		,[MANUFACTURER_ID]
		,[MANUFACTURER_NAME]
	FROM [source_DWH].[DWH].[UV_DIM_PRODUCTS] with (nolock)'
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')' --Update 20-03-2020 Изменился источник данных


if  Object_ID('tempdb..#dim_good') is not null drop table #dim_good
create table #dim_good
(
	[good_id] [int] NOT NULL,
	[table_row_guid] [char](255) NULL,
	[initial_id] [int] NULL,
	[descr] [nvarchar](250) NULL,
	[country] [nvarchar](150) NULL,
	[claster] [nvarchar](500) NULL,
	[paking] [nvarchar](150) NULL,
	[concern] [nvarchar](300) NULL,
	[brand] [nvarchar](100) NULL,
	[trade_mark] [nvarchar](255) NULL,
	[form] [nvarchar](255) NULL,
	[dosage] [nvarchar](300) NULL,
	[pre_packing] [nvarchar](300) NULL,
	[mnn] [nvarchar](1024) NULL,
	[form_out] [varchar](255) NULL,
	[is_vital] [bit] NULL,
	[goods_type] [nvarchar](150) NULL,
	[mega_cat] [varchar](13) NULL,
	[with_codein] [bit] NULL,
	[pku_group] [bit] NULL,
	[properties] [varchar](255) NULL,
	[vat] [nvarchar](100) NULL,
	[application] [nvarchar](100) NULL,
	[is_actual] [bit] NULL,
	[claster_id] [int] NULL,
	[goods_group] [int] NULL,
	[is_hospital] [bit] NULL,
	[megs_cat] [nvarchar](100) NULL,
	[cat] [nvarchar](200) NULL,
	[cpe] [nvarchar](150) NULL,
	[concern_id] [int] NULL,
	[rb_mnn] [varchar](1024) NULL,
	[rb_cpe] [varchar](100) NULL,
	[rb_brend_or_mnn] [varchar](5) NULL,
	[rb_lef_form] [varchar](255) NULL,
	[rb_dosage] [varchar](255) NULL,
	[rb_fasov] [varchar](50) NULL,
	[rb_cpe_top_concern] [int] NULL,
	[rb_megs_cat] [varchar](100) NULL,
	[id_1c_dwh] [int] NULL,
	[rb_sposob_prim] [varchar](255) NULL,
	[rb_zhnvls] [varchar](255) NULL,
	[rb_nds] [varchar](255) NULL,
	[rb_with_kodein] [varchar](255) NULL,
	[rb_concern] [varchar](100) NULL,
	[rb_manufacturer] [varchar](255) NULL,
	[rb_category] [varchar](255) NULL,
	[rb_claster] [varchar](255) NULL,
	[rb_sub_group] [varchar](255) NULL,
	[rb_brend] [varchar](255) NULL,
	[rb_trade_mark] [varchar](255) NULL,
	[rb_invest] [varchar](10) NULL,
	[rb_bezdefectur] [varchar](255) NULL,
	[application_area_id] [int] NULL,
	[application_area_name] [nvarchar](100) NULL,
	[group_products_id] [int] NULL,
	[group_products_name] [nvarchar](100) NULL,
	[manufacturer_m_id] [int] NULL,
	[manufacturer_m_name] [nvarchar](150) NULL,
	[goods_group_name] [nvarchar](100) NULL,
	[rb_brend_id] [int] NULL,
	[rb_claster_id] [int] NULL,
	[pku_group_rus] [varchar](16) NULL,
	[with_codein_rus] [varchar](20) NULL,
	[is_vit_rus] [varchar](8) NULL,
	[is_hospital_rus] [varchar](15) NULL,
	[is_actual_rus] [varchar](13) NULL,
	[manufacturer_id] [int] NULL,
	[manufacturer_name] [nvarchar](150) NULL
)
insert into #dim_good
(
	   [good_id]
      ,[table_row_guid]
      ,[initial_id]
      ,[descr]
      ,[country]
      ,[claster]
      ,[paking]
      ,[concern]
      ,[brand]
      ,[trade_mark]
      ,[form]
      ,[dosage]
      ,[pre_packing]
      ,[mnn]
      ,[form_out]
      ,[is_vital]
      ,[goods_type]
      ,[mega_cat]
      ,[with_codein]
      ,[pku_group]
      ,[properties]
      ,[vat]
      ,[application]
      ,[is_actual]
      ,[claster_id]
      ,[goods_group]
      ,[is_hospital]
      ,[megs_cat]
      ,[cat]
      ,[cpe]
      ,[concern_id]
      ,[rb_mnn]
      ,[rb_cpe]
      ,[rb_brend_or_mnn]
      ,[rb_lef_form]
      ,[rb_dosage]
      ,[rb_fasov]
      ,[rb_cpe_top_concern]
      ,[rb_megs_cat]
      ,[id_1c_dwh]
      ,[rb_sposob_prim]
      ,[rb_zhnvls]
      ,[rb_nds]
      ,[rb_with_kodein]
      ,[rb_concern]
      ,[rb_manufacturer]
      ,[rb_category]
      ,[rb_claster]
      ,[rb_sub_group]
      ,[rb_brend]
      ,[rb_trade_mark]
      ,[rb_invest]
      ,[rb_bezdefectur]
      ,[application_area_id]
      ,[application_area_name]
      ,[group_products_id]
      ,[group_products_name]
      ,[manufacturer_m_id]
      ,[manufacturer_m_name]
      ,[goods_group_name]
      ,[rb_brend_id]
      ,[rb_claster_id]
      ,[pku_group_rus]
      ,[with_codein_rus]
      ,[is_vit_rus]
      ,[is_hospital_rus]
      ,[is_actual_rus]
      ,[manufacturer_id]
      ,[manufacturer_name]
)
exec (@sql_openquery)



IF  
(select count(1) from #dim_good)>0
BEGIN 
truncate table dbo.dim_good
insert into dbo.dim_good
(
	   [good_id]
      ,[table_row_guid]
      ,[initial_id]
      ,[descr]
      ,[country]
      ,[claster]
      ,[paking]
      ,[concern]
      ,[brand]
      ,[trade_mark]
      ,[form]
      ,[dosage]
      ,[pre_packing]
      ,[mnn]
      ,[form_out]
      ,[is_vital]
      ,[goods_type]
      ,[mega_cat]
      ,[with_codein]
      ,[pku_group]
      ,[properties]
      ,[vat]
      ,[application]
      ,[is_actual]
      ,[claster_id]
      ,[goods_group]
      ,[is_hospital]
      ,[megs_cat]
      ,[cat]
      ,[cpe]
      ,[concern_id]
      ,[rb_mnn]
      ,[rb_cpe]
      ,[rb_brend_or_mnn]
      ,[rb_lef_form]
      ,[rb_dosage]
      ,[rb_fasov]
      ,[rb_cpe_top_concern]
      ,[rb_megs_cat]
      ,[id_1c_dwh]
      ,[rb_sposob_prim]
      ,[rb_zhnvls]
      ,[rb_nds]
      ,[rb_with_kodein]
      ,[rb_concern]
      ,[rb_manufacturer]
      ,[rb_category]
      ,[rb_claster]
      ,[rb_sub_group]
      ,[rb_brend]
      ,[rb_trade_mark]
      ,[rb_invest]
      ,[rb_bezdefectur]
      ,[application_area_id]
      ,[application_area_name]
      ,[group_products_id]
      ,[group_products_name]
      ,[manufacturer_m_id]
      ,[manufacturer_m_name]
      ,[goods_group_name]
      ,[rb_brend_id]
      ,[rb_claster_id]
      ,[pku_group_rus]
      ,[with_codein_rus]
      ,[is_vit_rus]
      ,[is_hospital_rus]
      ,[is_actual_rus]
      ,[manufacturer_id]
      ,[manufacturer_name]
	  ,[vat_id]
)
SELECT 
	[good_id],
	isnull([table_row_guid], '') as [table_row_guid],
	isnull([initial_id], 0) as [initial_id],
	isnull([descr], '') as [descr],
	isnull([country], '') as [country],
	isnull([claster], '') as [claster],
	isnull([paking], '') as [paking],
	isnull([concern], '') as [concern],
	isnull([brand], '') as [brand],
	isnull([trade_mark], '') as [trade_mark],
	isnull([form], '') as [form],
	isnull([dosage], '') as [dosage],
	isnull([pre_packing], '') as [pre_packing],
	isnull([mnn], '') as [mnn],
	isnull([form_out], '') as [form_out],
	isnull([is_vital], convert(bit, 0)) as [is_vital],
	isnull([goods_type], '') as [goods_type],
	isnull([mega_cat], '') as [mega_cat],
	isnull([with_codein], convert(bit, 0)) as [with_codein],
	isnull([pku_group], convert(bit, 0)) as [pku_group],
	isnull([properties], '') as [properties],
	isnull([vat], '') as [vat],
	isnull([application], '') as [application],
	isnull([is_actual], convert(bit, 0)) as [is_actual],
	isnull([claster_id], 0) as [claster_id],
	isnull([goods_group], 0) as [goods_group],
	isnull([is_hospital], convert(bit, 0)) as [is_hospital],
	isnull([megs_cat], '') as [megs_cat],
	isnull([cat], '') as [cat],
	isnull([cpe], '') as [cpe],
	isnull([concern_id], 0) as [concern_id],
	isnull([rb_mnn], '') as [rb_mnn],
	isnull([rb_cpe], '') as [rb_cpe],
	isnull([rb_brend_or_mnn], '') as [rb_brend_or_mnn],
	isnull([rb_lef_form], '') as [rb_lef_form],
	isnull([rb_dosage], '') as [rb_dosage],
	isnull([rb_fasov], '') as [rb_fasov],
	isnull([rb_cpe_top_concern], 0) as [rb_cpe_top_concern],
	isnull([rb_megs_cat], '') as [rb_megs_cat],
	isnull([id_1c_dwh], 0) as [id_1c_dwh],
	isnull([rb_sposob_prim], '') as [rb_sposob_prim],
	isnull([rb_zhnvls], '') as [rb_zhnvls],
	isnull([rb_nds], '') as [rb_nds],
	isnull([rb_with_kodein], '') as [rb_with_kodein],
	isnull([rb_concern], '') as [rb_concern],
	isnull([rb_manufacturer], '') as [rb_manufacturer],
	isnull([rb_category], '') as [rb_category],
	isnull([rb_claster], '') as [rb_claster],
	isnull([rb_sub_group], '') as [rb_sub_group],
	isnull([rb_brend], '') as [rb_brend],
	isnull([rb_trade_mark], '') as [rb_trade_mark],
	isnull([rb_invest], '') as [rb_invest],
	isnull([rb_bezdefectur], '') as [rb_bezdefectur],
	isnull([application_area_id], 0) as [application_area_id],
	isnull([application_area_name], '') as [application_area_name],
	isnull([group_products_id], 0) as [group_products_id],
	isnull([group_products_name], '') as [group_products_name],
	isnull([manufacturer_m_id], 0) as [manufacturer_m_id],
	isnull([manufacturer_m_name], '') as [manufacturer_m_name],
	isnull([goods_group_name], '') as [goods_group_name],
	isnull([rb_brend_id], 0) as [rb_brend_id],
	isnull([rb_claster_id], 0) as [rb_claster_id],
	isnull([pku_group_rus], '') as [pku_group_rus],
	isnull([with_codein_rus], '') as [with_codein_rus],
	isnull([is_vit_rus], '') as [is_vit_rus],
	isnull([is_hospital_rus], '') as [is_hospital_rus],
	isnull([is_actual_rus], '') as [is_actual_rus],
	isnull([manufacturer_id], 0) as [manufacturer_id],
	isnull([manufacturer_name], '') as [manufacturer_name],
	[dbo].[clean_string_from_nonnumeric](vat) as [vat_id]
 FROM #dim_good
 END


 exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
  if  Object_ID('tempdb..#dim_good') is not null drop table #dim_good
 end try      
 begin catch
 exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
  if  Object_ID('tempdb..#dim_good') is not null drop table #dim_good
 return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_manufacturer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_manufacturer] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-09
---- Description:  'Заполнение справочника Производители из Excel файлов по ОС'
---- EXEC example:	exec [dbo].[fill_dim_manufacturer]
---- ================================================================================
ALTER PROCEDURE [dbo].[fill_dim_manufacturer]
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_manufacturer]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Производители'
DECLARE @input_parametrs nvarchar(500) = ''

BEGIN TRY
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	INSERT INTO [dbo].[dim_manufacturer] ([manufacturer])
	SELECT a.[manufacturer] 
	FROM (select distinct [manufacturer] from [stg].[excel_dim_volume_agreements] where [manufacturer] IS NOT NULL) as a
	LEFT JOIN [dbo].[dim_manufacturer] as b on a.[manufacturer] = b.[manufacturer]
	WHERE b.[manufacturer] IS NULL

	INSERT INTO [dbo].[dim_manufacturer] ([manufacturer])
	SELECT a.[manufacturer] 
	FROM (select distinct [manufacturer] from [stg].[excel_dim_manufacturer_contracts] where [manufacturer] IS NOT NULL) as a
	LEFT JOIN [dbo].[dim_manufacturer] as b on a.[manufacturer] = b.[manufacturer]
	WHERE b.[manufacturer] IS NULL

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 END TRY      
 BEGIN CATCH
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	RETURN
 END CATCH 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_manufacturer_contracts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_manufacturer_contracts] AS' 
END
GO




---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-31
---- Description:  'Заполнение справочника Прямые контракты'
---- EXEC example:	exec [dbo].[fill_dim_manufacturer_contracts] @date_from = 20181001, @date_to = 20181231
ALTER PROCEDURE [dbo].[fill_dim_manufacturer_contracts]
@date_from int
,@date_to int
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_manufacturer_contracts]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Прямые контракты'
DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)
begin try
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	IF exists (SELECT top 1 * 
		FROM [stg].[excel_dim_manufacturer_contracts]
		WHERE date_from = @date_from AND date_to = @date_to)
	BEGIN
		DELETE FROM [dbo].[dim_manufacturer_contracts] WHERE date_from = @date_from AND date_to = @date_to
		
		INSERT INTO [dbo].[dim_manufacturer_contracts] 
			([manufacturer_id]
			,[apt_net_id]
			,[date_from]
			,[date_to])
		SELECT distinct
			m.[manufacturer_id]
			,a.[apt_net_id]
			,sp.[date_from]
			,sp.[date_to]
		FROM [stg].[excel_dim_manufacturer_contracts] as sp
		INNER JOIN [dbo].[dim_manufacturer] as m on m.manufacturer = sp.manufacturer
		INNER JOIN (SELECT distinct [apt_net_id], apt_net_name FROM [dbo].[dim_apt]) as a on a.apt_net_name = sp.net
	END
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 end try      
 begin catch
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_partner_purchase_invoices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_partner_purchase_invoices] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-05-22
---- Description:  'Заполнение справочника Накладных из Excel партнеров, данных по закупкам'
---- EXEC example:	exec [dbo].[fill_dim_partner_purchase_invoices]
---- ================================================================================
ALTER PROCEDURE [dbo].[fill_dim_partner_purchase_invoices]
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_partner_purchase_invoices]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Накладных закупок партнеров'
DECLARE @input_parametrs nvarchar(500) = ''

BEGIN TRY
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	INSERT INTO [dbo].[dim_partner_purchase_invoices] (
		[invoice_number]
		,[invoice_date]
	)
	SELECT 
		a.[invoice_number]
		,a.[invoice_date]
	FROM (
		SELECT distinct 
			[invoice_number]
			,[invoice_date]
		FROM [stg].[excel_fct_partner_purchases]
		WHERE 
			[invoice_number] IS NOT NULL
			AND [invoice_date] IS NOT NULL
	) as a
	LEFT JOIN [dbo].[dim_partner_purchase_invoices] as b 
		ON a.[invoice_number] = b.[invoice_number]
		AND a.[invoice_date] = b.[invoice_number]
	WHERE b.[invoice_number] IS NULL

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 END TRY      
 BEGIN CATCH
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	RETURN
 END CATCH 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_sales_channel]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_sales_channel] AS' 
END
GO

ALTER PROCEDURE [dbo].[fill_dim_sales_channel]
AS
BEGIN
---- ===============================================================================
---- Author:		Shemetov
---- Create date:   20191101
---- Description:  'Заполнение справочника Каналов продаж'
---- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
---- ================================================================================
---- exec [dbo].[fill_dim_sales_channel]
SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_sales_channel]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Каналов продаж'
DECLARE @input_parametrs nvarchar(500) = ''
begin try
exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'SELECT 
		[ID] as [sales_channel_id],
		[NAME] as [descr]
	FROM [source_DWH].[DWH].[DIM_SALE_CHANNELS] with (nolock)'
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'


if  Object_ID('tempdb..#dim_sales_channel') is not null drop table #dim_sales_channel
create table #dim_sales_channel
(
	[sales_channel_id] [int] NOT NULL,
	[descr] [nvarchar](50) NOT NULL,
)
insert into #dim_sales_channel
(
	   [sales_channel_id],
		[descr]
)
exec (@sql_openquery)

IF  
(select count(1) from #dim_sales_channel)>0
BEGIN 
truncate table dbo.dim_sales_channel
insert into dbo.dim_sales_channel
(
	   [sales_channel_id],
		[descr]
)
SELECT 
	[sales_channel_id],
	isnull([descr], '') as [descr]
 FROM #dim_sales_channel
 END

 exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
  if  Object_ID('tempdb..#dim_sales_channel') is not null drop table #dim_sales_channel
 end try      
 begin catch
 exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
  if  Object_ID('tempdb..#dim_sales_channel') is not null drop table #dim_sales_channel
 return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_supplier]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_supplier] AS' 
END
GO
 ---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-26
---- Description:	'Заполнение справочника Поставщики'
---- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
---- EXEC example:	exec [dbo].[fill_dim_supplier]
---- ================================================================================
ALTER PROCEDURE [dbo].[fill_dim_supplier]
AS
BEGIN

	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[dbo].[fill_dim_supplier]'
	DECLARE @description nvarchar(500) = 'Заполнение справочника Поставщики'
	DECLARE @input_parametrs nvarchar(500) = ''
	begin try
		exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
		Declare @sql as varchar(max)
		Declare @sql_openquery as varchar(max)
		--Update 20-03-2020 Изменился источник данных
		Set @sql=
		'
			SELECT s.[ID]
					,s.[INITIAL_ID]
					,iif(s.[INN] != s.[NAME], s.[NAME], ''Неопределено'') as [DESCR]
					,0x00 as [TableRowGUID]
					,s.[FULL_NAME]
					,s.[PHONE]
					,''нет данных'' as [Email]
					,s.[ADDRESS]
					,s.[IS_ACTIVE]
					,iif(s.[INN] != s.[NAME], s.[INN], ''Неопределено'') as [Inn]
					,s.[REGION]
					,''нет данных'' as [LegalEntity]
					,s.[FACT_ADDRESS]
					,convert(datetime, ''1900-01-01 00:00:00.000'') as [BlockDate]
					,''нет данных'' as [UnionAtrName]
					,s.[CITY]
					,s.[UPDATE_DATETIME] as [dtRow]
					,'''' as [ldNm]
					,convert(datetime, ''1900-01-01 00:00:00.000'') as [mdf_dt]
					,''нет данных'' as [mdfUserName]
					,r.[A3] as [region_code]
					,c.[IS_CHECKED]
			FROM [source_DWH].[DWH].[DIM_SUPPLIERS] as s
			left join (
						SELECT [SUPPLIER_ID], MIN([IS_CHECKED]+0) as [IS_CHECKED]
						FROM [source_DWH].[DWH].[DIM_SUPPLIER_LINKS]
						GROUP BY [SUPPLIER_ID]
						)  as c	
				on c.[SUPPLIER_ID]  = s.ID
					and s.ID <> 0
			LEFT JOIN [source_DWH].[DWH].[DIM_REGISTRATION_COUNTRIES] as r
				ON s.[REGISTRATION_COUNTRY_ID] = r.[ID]
				
				'
		Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')' --Update 20-03-2020 Изменился источник данных


		if  Object_ID('tempdb..#dim_supplier') is not null drop table #dim_supplier
		create table #dim_supplier
		(
			[supplier_id] [int] NOT NULL,
			[initial_id] [int] NOT NULL,
			[descr] [nvarchar](250) NULL,
			[table_row_guid] [uniqueidentifier] NOT NULL,
			[full_name] [nvarchar](500) NULL,
			[phone] [nvarchar](60) NULL,
			[email] [varchar](60) NULL,
			[address] [nvarchar](200) NULL,
			[is_active] [int] NULL,
			[inn] [nvarchar](30) NULL,
			[region] [nvarchar](200) NULL,
			[legal_entity] [varchar](255) NULL,
			[fact_address] [nvarchar](255) NULL,
			[block_date] [datetime] NULL,
			[union_atr_name] [varchar](50) NULL,
			[city] [nvarchar](255) NULL,
			[dt_row] [datetime] NULL,
			[ld_nm] [varchar](2) NULL,
			[mdf_dt] [datetime] NULL,
			[mdf_user_name] [varchar](60) NULL,
			[region_code] [nvarchar](3) NULL,
			[is_checked] [int] NULL
		)
		insert into #dim_supplier
		(
			[supplier_id]
			,[initial_id]
			,[descr]
			,[table_row_guid]
			,[full_name]
			,[phone]
			,[email]
			,[address]
			,[is_active]
			,[inn]
			,[region]
			,[legal_entity]
			,[fact_address]
			,[block_date]
			,[union_atr_name]
			,[city]
			,[dt_row]
			,[ld_nm]
			,[mdf_dt]
			,[mdf_user_name]
			,[region_code]
			,[is_checked]
		)
		exec (@sql_openquery)

		IF (select count(1) from #dim_supplier)>0
		BEGIN 
			truncate table dbo.dim_supplier
			insert into dbo.dim_supplier
			(
				[supplier_id]
				,[initial_id]
				,[descr]
				,[table_row_guid]
				,[full_name]
				,[phone]
				,[email]
				,[address]
				,[is_active]
				,[inn]
				,[region]
				,[legal_entity]
				,[fact_address]
				,[block_date]
				,[union_atr_name]
				,[city]
				,[dt_row]
				,[ld_nm]
				,[mdf_dt]
				,[mdf_user_name]
				,[region_code]
				,[is_checked]
			)
			SELECT 
				[supplier_id]
				,[initial_id]
				,isnull([descr], '') as [descr]
				,[table_row_guid]
				,isnull([full_name], '') as [full_name]
				,isnull([phone], '') as [phone]
				,isnull([email], '') as [email]
				,isnull([address], '') as [address]
				,isnull([is_active], 0) as [is_active]
				,isnull([inn], '') as [inn]
				,isnull([region], '') as [region]
				,isnull([legal_entity], '') as [legal_entity]
				,isnull([fact_address], '') as [fact_address]
				,isnull([block_date], convert(datetime, '1900-01-01 00:00:00.000')) as [block_date]
				,isnull([union_atr_name], '') as [union_atr_name]
				,isnull([city], '') as [city]
				,isnull([dt_row], convert(datetime, '1900-01-01 00:00:00.000')) as [dt_row]
				,isnull([ld_nm], '') as [ld_nm]
				,isnull([mdf_dt], convert(datetime, '1900-01-01 00:00:00.000')) as [mdf_dt]
				,isnull([mdf_user_name], '') as [mdf_user_name]
				,isnull([region_code], '') as [region_code]
				,isnull([is_checked], 0) as [is_checked]
			FROM #dim_supplier
		END


		exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
		if  Object_ID('tempdb..#dim_supplier') is not null drop table #dim_supplier
	end try      
	begin catch
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	if  Object_ID('tempdb..#dim_supplier') is not null drop table #dim_supplier
	return
	end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_supplier_replacements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_supplier_replacements] AS' 
END
GO



---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:  'Заполнение справочника Замена поставщиков'
---- EXEC example:	exec [dbo].[fill_dim_supplier_replacements] @date_from = 20181001, @date_to = 20181231
---- ================================================================================
ALTER PROCEDURE [dbo].[fill_dim_supplier_replacements]
@date_from int
,@date_to int
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_supplier_replacements]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Замена поставщиков'
DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)
begin try
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	IF exists (SELECT top 1 * 
		FROM [stg].[excel_dim_supplier_replacements]
		WHERE date_from = @date_from AND date_to = @date_to)
	BEGIN
		DELETE FROM [dbo].[dim_supplier_replacements] WHERE date_from = @date_from AND date_to = @date_to

		INSERT INTO [dbo].[dim_supplier_replacements] 
			([manufacturer_id]
			,[initial_supplier_id]
			,[replacement_supplier_id]
			,[date_from]
			,[date_to])
		SELECT distinct
			m.[manufacturer_id]
			,si.[supplier_id] as [initial_supplier_id]
			,sr.[supplier_id] as [replacement_supplier_id]
			,sp.[date_from]
			,sp.[date_to]
		FROM [stg].[excel_dim_supplier_replacements] as sp
		INNER JOIN [dbo].[dim_manufacturer] as m on m.manufacturer = sp.manufacturer
		INNER JOIN [dbo].[dim_supplier] as si on si.inn = sp.initial_supplier_INN
		INNER JOIN [dbo].[dim_supplier] as sr on sr.inn = sp.replacement_supplier_INN
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 end try      
 begin catch
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_volume_agreement_group]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_volume_agreement_group] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-09
---- Description:  'Заполнение справочника Группа по объемному соглашению'
---- EXEC example:	exec [dbo].[fill_dim_volume_agreement_group]
---- ================================================================================
ALTER PROCEDURE [dbo].[fill_dim_volume_agreement_group]
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_volume_agreement_group]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Группа по объемному соглашению'
DECLARE @input_parametrs nvarchar(500) = ''

BEGIN TRY
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	INSERT INTO [dbo].[dim_volume_agreement_group] ([volume_agreement_group])
	SELECT a.[volume_agreement_group] 
	FROM (select distinct [volume_agreement_group]  from [stg].[excel_dim_goods_by_volume_agreements] where [volume_agreement_group] IS NOT NULL) as a
	LEFT JOIN [dbo].[dim_volume_agreement_group] as b on a.[volume_agreement_group] = b.[volume_agreement_group]
	WHERE b.[volume_agreement_group] IS NULL

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 END TRY      
 BEGIN CATCH
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	RETURN
 END CATCH 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_dim_volume_agreements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_dim_volume_agreements] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:  'Заполнение справочника Объемные соглашения'
---- Update Ильин В.А. 04/02/2020 Добавление заполнения поля [is_list]
---- EXEC example:	exec [dbo].[fill_dim_volume_agreements]
---- ================================================================================
ALTER PROCEDURE [dbo].[fill_dim_volume_agreements]
AS
BEGIN

SET NOCOUNT ON;	
DECLARE @name varchar(max) = '[dbo].[fill_dim_volume_agreements]'
DECLARE @description nvarchar(500) = 'Заполнение справочника Объемные соглашения'
DECLARE @input_parametrs nvarchar(500) = ''
begin try
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
  	
	merge [dbo].[dim_volume_agreements] as target
	using 
		(select [volume_agreement_source_id]
			  ,[manufacturer]
			  ,[manager_FIO]
			  ,[period]
			  ,[price_type]
			  ,[channel]
			  ,[list_type]
			  ,[is_all_apt]
			  ,[is_till_channel]
			  ,[is_list] -- upd 04/02/20 !
			from [stg].[excel_dim_volume_agreements] 
			where [volume_agreement_source_id] IS NOT NULL
		) as source (
		  [volume_agreement_source_id]
		  ,[manufacturer]
		  ,[manager_FIO]
		  ,[period]
		  ,[price_type]
		  ,[channel]
		  ,[list_type]
		  ,[is_all_apt]
		  ,[is_till_channel]
		  ,[is_list]) -- upd 04/02/20 !
		on (target.[volume_agreement_source_id]=source.[volume_agreement_source_id] AND target.[period] = source.[period])
	when matched then
		update set 
				target.[manufacturer] = isnull(source.[manufacturer],''), 
				target.[manager_FIO] = isnull(source.[manager_FIO],''),	
				target.[price_type] = isnull(source.[price_type],''), 
				target.[channel] = isnull(source.[channel],''), 
				target.[list_type] = isnull(source.[list_type],''),
				target.[is_all_apt] = isnull(convert(bit, source.[is_all_apt]), 1),
				target.[is_till_channel] = isnull(convert(bit, source.[is_till_channel]), 0),
				target.[is_list] = isnull(convert(bit, source.[is_list]), 0) -- upd 04/02/20 !
	when not matched then
		insert ([volume_agreement_source_id]
		  ,[manufacturer]
		  ,[manager_FIO]
		  ,[period]
		  ,[price_type]
		  ,[channel]
		  ,[list_type]
		  ,[is_all_apt]
		  ,[is_till_channel]
		  ,[is_list]) -- upd 04/02/20 !
		values (source.[volume_agreement_source_id]
		  ,isnull(source.[manufacturer],'')
		  ,isnull(source.[manager_FIO],'')
		  ,isnull(source.[period],'')
		  ,isnull(source.[price_type],'')
		  ,isnull(source.[channel],'')
		  ,isnull(source.[list_type],'')
		  ,isnull(convert(bit, source.[is_all_apt]), 1)
		  ,isnull(convert(bit, source.[is_till_channel]), 1)
		  ,isnull(convert(bit, source.[is_list]), 0)); -- upd 04/02/20 !

	 exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
 end try      
 begin catch
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID , @description = @description, @input_parametrs = @input_parametrs   
	return
 end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_DWH]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_DWH] AS' 
END
GO

-- =========================================================
-- Author:		Shemetov IV
-- Create date: 2019-02-20
-- Description:	Скрипт полного регламентного обновления ХД
-- Example:		exec [dbo].[fill_DWH] @quarter_id = 20191, @pathForFilesLoad = N'C:\FTP\source\input\data\', @pathForHistoryFolder = N'C:\FTP\source\hist\'
--корр Ильин В.А. 23/1/2020 - добавлены параметры к процедурам [dbo].[fill_all_excel_data_files], [dbo].[fill_all_excel_VA_files]
-- =========================================================
ALTER PROCEDURE [dbo].[fill_DWH] @quarter_id int, @pathForFilesLoad NVARCHAR(MAX), @pathForHistoryFolder NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;	

	DECLARE @dt_int_from int
	DECLARE @dt_int_to int

	DECLARE @dt_date_from_i date
	DECLARE @dt_date_to_i date
	DECLARE @dt_int_from_i int
	DECLARE @dt_int_to_i int

	SELECT 
		@dt_int_from = min(date_id) 
	FROM dbo.dim_date
	WHERE quarter_id = @quarter_id
	SET @dt_int_to = [dbo].[date_to_int](DATEADD(mm, 3, [dbo].[int_to_date](@dt_int_from)))
	
	/*
	Заполнение справочника Товаров из ХД
	*/
	exec [dbo].[fill_dim_good]
	
	/*
	Заполнение справочника Аптек из ХД
	*/
	exec [dbo].[fill_dim_apt]
	
	/*
	Заполнение справочника Поставщиков из ХД
	*/
	exec [dbo].[fill_dim_supplier]

	/*
	Заполнение справочника Каналов продаж из ХД
	*/
	exec [dbo].[fill_dim_sales_channel]

	/*
	Загрузка фактов из FTP
	*/
	exec [dbo].[fill_all_excel_data_files] @p_quarter = @quarter_id, @pathForFilesLoad = @pathForFilesLoad, @pathForHistoryFolder = @pathForHistoryFolder -- upd 23/1/20
	
	/*
	Загрузка Остатков из ХД АСНЫ
	*/
	
	SET @dt_date_from_i = [dbo].[int_to_date](@dt_int_from)
	SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_from_i)
	SET @dt_int_from_i = @dt_int_from
	SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	
	WHILE @dt_int_from_i < @dt_int_to
	BEGIN	
		exec [stg].[fill_fct_rests] @dt_date_from_i, @dt_date_to_i	
		exec [dbo].[fill_fct_rests] @dt_int_from_i, @dt_int_to_i		

		SET @dt_date_from_i = DATEADD(mm, 1, @dt_date_from_i)
		SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_to_i)
		SET @dt_int_from_i = [dbo].[date_to_int](@dt_date_from_i)
		SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	END	
	
	
	/*
	Загрузка Продаж из ХД АСНЫ
	*/
	SET @dt_date_from_i = [dbo].[int_to_date](@dt_int_from)
	SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_from_i)
	SET @dt_int_from_i = @dt_int_from
	SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	
	WHILE @dt_int_from_i < @dt_int_to
	BEGIN	
		exec [stg].[fill_fct_sales] @dt_date_from_i, @dt_date_to_i
		exec [dbo].[fill_fct_sales] @dt_int_from_i, @dt_int_to_i
		

		SET @dt_date_from_i = DATEADD(mm, 1, @dt_date_from_i)
		SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_to_i)
		SET @dt_int_from_i = [dbo].[date_to_int](@dt_date_from_i)
		SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	END	
	
	/*
	Загрузка Закупок из ХД АСНЫ
	*/
	SET @dt_date_from_i = [dbo].[int_to_date](@dt_int_from)
	SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_from_i)
	SET @dt_int_from_i = @dt_int_from
	SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	
	WHILE @dt_int_from_i < @dt_int_to
	BEGIN
		exec [stg].[fill_fct_supplys] @dt_date_from_i, @dt_date_to_i	
		exec [dbo].[fill_fct_supplys] @dt_int_from_i, @dt_int_to_i			

		SET @dt_date_from_i = DATEADD(mm, 1, @dt_date_from_i)
		SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_to_i)
		SET @dt_int_from_i = [dbo].[date_to_int](@dt_date_from_i)
		SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	END
	
	/*
	Загрузка Добавочных Продаж из ХД АСНЫ
	*/
	SET @dt_date_from_i = [dbo].[int_to_date](@dt_int_from)
	SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_from_i)
	SET @dt_int_from_i = @dt_int_from
	SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	
	WHILE @dt_int_from_i < @dt_int_to
	BEGIN
		exec [stg].[fill_fct_sales_additional] @dt_date_from_i, @dt_date_to_i
		exec [dbo].[fill_fct_sales_additional] @dt_int_from_i, @dt_int_to_i		

		SET @dt_date_from_i = DATEADD(mm, 1, @dt_date_from_i)
		SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_to_i)
		SET @dt_int_from_i = [dbo].[date_to_int](@dt_date_from_i)
		SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	END
	
	/*
	Загрузка Добавочных Закупок из ХД АСНЫ
	*/
	SET @dt_date_from_i = [dbo].[int_to_date](@dt_int_from)
	SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_from_i)
	SET @dt_int_from_i = @dt_int_from
	SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	
	WHILE @dt_int_from_i < @dt_int_to
	BEGIN
		exec [stg].[fill_fct_supplys_additional] @dt_date_from_i, @dt_date_to_i	
		exec [dbo].[fill_fct_supplys_additional] @dt_int_from_i, @dt_int_to_i		

		SET @dt_date_from_i = DATEADD(mm, 1, @dt_date_from_i)
		SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_to_i)
		SET @dt_int_from_i = [dbo].[date_to_int](@dt_date_from_i)
		SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	END
	
	/*
	Загрузка Закупок и Продаж Статистов
	*/
	SET @dt_date_from_i = [dbo].[int_to_date](@dt_int_from)
	SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_from_i)
	SET @dt_int_from_i = @dt_int_from
	SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	
	WHILE @dt_int_from_i < @dt_int_to
	BEGIN
		exec [stg].[fill_fct_statistician_purchases] @dt_date_from_i, @dt_date_to_i	
		exec [dbo].[fill_fct_statistician_purchases] @dt_int_from_i, @dt_int_to_i	
		exec [dbo].[fill_fct_statistician_sales] @dt_int_from_i, @dt_int_to_i		

		SET @dt_date_from_i = DATEADD(mm, 1, @dt_date_from_i)
		SET @dt_date_to_i = DATEADD(mm, 1, @dt_date_to_i)
		SET @dt_int_from_i = [dbo].[date_to_int](@dt_date_from_i)
		SET @dt_int_to_i = [dbo].[date_to_int](@dt_date_to_i)
	END

	/*
	Загрузка настроечного файла ОС из FTP
	*/
	exec [dbo].[fill_all_excel_VA_files] @p_quarter = @quarter_id, @pathForFilesLoad = @pathForFilesLoad, @pathForHistoryFolder = @pathForHistoryFolder -- upd 23/1/20
	
	/*
	Формирование отчетных данных Продаж
	*/
	exec [dbo].[fill_fct_report_sales_prepare]				
		@date_from = @dt_int_from, 
		@date_to = @dt_int_to

	exec [dbo].[fill_fct_report_sales]				
		@date_from = @dt_int_from, 
		@date_to = @dt_int_to
	
	/*
	Формирование отчетных данных Закупок
	*/
	exec [dbo].[fill_fct_report_purchases_prepare]				
		@date_from = @dt_int_from, 
		@date_to = @dt_int_to

	exec [dbo].[fill_fct_report_purchases]				
		@date_from = @dt_int_from, 
		@date_to = @dt_int_to
		
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_source_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_source_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-12-27
---- Description:	'Заполнение таблицы фактов закуп на АСНА накладных по отчетному периоду на уровень dbo'
---- EXEC example:	exec [dbo].[fill_fct_source_purchases] @date_from = 20180801, @date_to = 20180901
---- ================================================================================
ALTER procedure [dbo].[fill_fct_source_purchases]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_source_purchases_fill]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[fct_source_purchases]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int
	
	IF exists(SELECT top 1 * from [stg].[excel_fct_source_purchases] 
		where date_from >= @date_from
		AND @date_to <= @date_to)
	BEGIN
		delete top (100000) [dbo].[fct_source_purchases] where date_from >= @date_from AND @date_to <= @date_to
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000)  [dbo].[fct_source_purchases] where date_from >= @date_from AND @date_to <= @date_to
			SET @i = @@ROWCOUNT
		end

		INSERT INTO [dbo].[fct_source_purchases] (
				[good_id]
			  ,[qty]
			  ,[supplier_id]
			  ,[arrival_date]
			  ,[invoice_number_in]
			  ,[sub_supplier_id]
			  ,[delivery_date]
			  ,[invoice_number_out]
			  ,[volume_agreement_id]
			  ,[date_from]
			  ,[date_to])
		SELECT 
			isnull(g.[good_id], -1) as [good_id]
			,IIF(ISNUMERIC(REPLACE([qty], ' ', '')) = 1, convert(money, REPLACE([qty], ' ', '')), 0 ) as [qty]
			,isnull(s1.[supplier_id], -1) as [supplier_id]
			,IIF(ISDATE([arrival_date]) = 1, [dbo].[date_to_int](convert(date, [arrival_date])), 0) as [arrival_date]
			,[invoice_number_in]
			,isnull(s2.[supplier_id], -1) as [sub_supplier_id]
			,IIF(ISDATE([delivery_date]) = 1, [dbo].[date_to_int](convert(date, [delivery_date])), 0) as [delivery_date]
			,[invoice_number_out]
			,isnull(va.[volume_agreement_id], -1) as [volume_agreement_id]
			,[date_from]
			,[date_to]
		FROM [stg].[excel_fct_source_purchases] as p
		LEFT JOIN [dbo].[dim_good] as g 
			ON p.[good_source_id] = g.[initial_id]
		LEFT JOIN [dbo].[dim_volume_agreements] as va 
			ON p.volume_agreement_source_id = va.volume_agreement_source_id
		LEFT JOIN [dbo].[dim_supplier] as s1
			ON p.[supplier_inn] = s1.[inn]
		LEFT JOIN [dbo].[dim_supplier] as s2
			ON p.[sub_supplier_inn] = s2.[inn]
		where date_from >= @date_from AND @date_to <= @date_to
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_partner_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_partner_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Закупок Партнеров на уровень dbo'
---- EXEC example:	exec [dbo].[fill_fct_partner_purchases] @date_from = 20180801, @date_to = 20180901
---- ================================================================================
ALTER procedure [dbo].[fill_fct_partner_purchases]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_partner_purchases_fill]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[fct_partner_purchases] из Excel листа 1.3.2.Статисты'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	IF exists(SELECT top 1 * from [stg].[excel_fct_partner_purchases] 
		where convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 >= @date_from
		AND convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 < @date_to)
	BEGIN
		delete top (100000) [dbo].[fct_partner_purchases] where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000)  [dbo].[fct_partner_purchases] where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end
		INSERT INTO [dbo].[fct_partner_purchases] ([date_id]
		  ,[good_id]
		  ,[apt_id]
		  ,[supplier_id]
		  ,[purch_grs]
		  ,[purch_net]
		  ,[qty])
		SELECT 
			convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 as [date_id]
			,isnull(g.[good_id], -1) as [good_id]
			,isnull(a.[apt_id], -1) as [apt_id]
			,isnull(s.[supplier_id], -1) as [supplier_id]
			,[purch_grs]
			,[purch_net]
			,[qty]
		FROM [stg].[excel_fct_partner_purchases] as exc
		LEFT JOIN (SELECT MAX([apt_id]) as [apt_id], [unit_cll_pref] FROM [dbo].[dim_apt] GROUP BY [unit_cll_pref]) as a 
			ON a.[unit_cll_pref] = exc.[apt_source_id]
		LEFT JOIN [dbo].[dim_good] as g 
			ON g.[initial_id] = exc.[good_source_id]
		LEFT JOIN [dbo].[dim_supplier] as s
			ON s.[inn] = convert(varchar(32), exc.[supplier_inn])
		where convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 >= @date_from
		AND convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 < @date_to
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_partner_purchases_invoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_partner_purchases_invoice] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Закупок Партнеров на уровень dbo.
----				Попутно заполняется справочник Накладных закупок партнеров'
---- EXEC example:	exec [dbo].[fill_fct_partner_purchases] @date_from = 20180801, @date_to = 20180901
---- ================================================================================
ALTER procedure [dbo].[fill_fct_partner_purchases_invoice]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_partner_purchases_fill]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[fct_partner_purchases] из Excel листа 1.3.2.Статисты'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	--Заполнение справочника Накладных закупок партнеров
	exec [dbo].[fill_dim_partner_purchase_invoices]
	
	IF exists(SELECT top 1 * from [stg].[excel_fct_partner_purchases] 
		where convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 >= @date_from
		AND convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 < @date_to)
	BEGIN
		delete top (100000) [dbo].[fct_partner_purchases] where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000)  [dbo].[fct_partner_purchases] where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end
		INSERT INTO [dbo].[fct_partner_purchases] ([date_id]
		  ,[good_id]
		  ,[apt_id]
		  ,[supplier_id]
		  ,[invoice_id]
		  ,[purch_grs]
		  ,[purch_net]
		  ,[qty])
		SELECT 
			convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 as [date_id]
			,isnull(g.[good_id], -1) as [good_id]
			,isnull(a.[apt_id], -1) as [apt_id]
			,isnull(s.[supplier_id], -1) as [supplier_id]
			,isnull(i.partner_purchase_invoice_id, -1) as [invoice_id]
			,[purch_grs]
			,[purch_net]
			,[qty]
		FROM [stg].[excel_fct_partner_purchases] as exc
		LEFT JOIN (SELECT MAX([apt_id]) as [apt_id], [unit_cll_pref] FROM [dbo].[dim_apt] GROUP BY [unit_cll_pref]) as a 
			ON a.[unit_cll_pref] = exc.[apt_source_id]
		LEFT JOIN [dbo].[dim_good] as g 
			ON g.[initial_id] = exc.[good_source_id]
		LEFT JOIN [dbo].[dim_supplier] as s
			ON s.[inn] = convert(varchar(32), exc.[supplier_inn])
		LEFT JOIN [dbo].[dim_partner_purchase_invoices] as i
			ON i.[invoice_number] = exc.[invoice_number]
			AND i.[invoice_date] = exc.[invoice_date]
		where convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 >= @date_from
		AND convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 < @date_to
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_partner_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_partner_sales] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Продаж Партнеров на уровень dbo'
---- EXEC example:	exec [dbo].[fill_fct_partner_sales] @date_from = 20180801, @date_to = 20180901
---- ================================================================================
ALTER procedure [dbo].[fill_fct_partner_sales]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_partner_sales_fill]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[fct_partner_sales] из Excel листа 1.3.2.Статисты'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int
	
	IF exists(SELECT top 1 * from [stg].[excel_fct_partner_sales] 
		where convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 >= @date_from
		AND convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 < @date_to)
	BEGIN
		delete top (100000) [dbo].[fct_partner_sales] where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000)  [dbo].[fct_partner_sales] where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end

		INSERT INTO [dbo].[fct_partner_sales] ([date_id]
		  ,[good_id]
		  ,[apt_id]
		  ,[sale_grs]
		  ,[sale_net]
		  ,[qty])
		SELECT 
			convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 as [date_id]
			,isnull(g.[good_id], -1) as [good_id]
			,isnull(a.[apt_id], -1) as [apt_id]
			,[sale_grs]
			,[sale_net]
			,[qty]
		FROM [stg].[excel_fct_partner_sales] as exc
		LEFT JOIN (SELECT MAX([apt_id]) as [apt_id], [unit_cll_pref] FROM [dbo].[dim_apt] GROUP BY [unit_cll_pref]) as a 
			ON a.[unit_cll_pref] = exc.[apt_source_id]
		LEFT JOIN [dbo].[dim_good] as g 
			ON g.[initial_id] = exc.[good_source_id]
		where convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 >= @date_from
		AND convert(int, [year]) * 10000 + convert(int, [month]) * 100 + 1 < @date_to
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_report_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_report_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-31
---- Description:	'Заполнение таблицы фактов Закупок "Формирование данных в разрезе объемных соглашений"
----				на уровень dbo'
----				Применяется округление упаковок
---- EXEC example:	exec [dbo].[fill_fct_report_purchases] @date_from = 20180701, @date_to = 20181001
---- ================================================================================
ALTER procedure [dbo].[fill_fct_report_purchases]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_report_purchases]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы "Предварительных отчетных данных" [dbo].[fct_report_purchases]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	IF exists(SELECT top 1 * from [dbo].[fct_volume_agreements]
		where date_from >= @date_from
		AND date_from < @date_to
		AND date_to >= @date_from
		AND date_to < @date_to
		)
	BEGIN
		delete top (100000) [dbo].[fct_report_purchases] 
		where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000) [dbo].[fct_report_purchases] 
			where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end
		INSERT INTO [dbo].[fct_report_purchases]
			([source_id]
			  ,[volume_agreement_id]
			  ,[date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[initial_supplier_id]
			  ,[supplier_id]
			  ,[manufacturer_id]
			  ,[volume_agreement_group_id]
			  ,[is_apt_in_list]
			  ,[is_manufacturer_contract]
			  ,[is_distributor_limitation]
			  ,[qty]
			  ,[purch_net]
			  ,[purch_grs]
			  ,[price_cip]
			  ,[purch_cip])
		
		
		--список аптек НУЖЕН для отсеивания
		SELECT 
			s.source_id
			,s.volume_agreement_id
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[initial_supplier_id]
			,s.[supplier_id]
			,s.[manufacturer_id]
			,s.[volume_agreement_group_id]
			,IIF(va.volume_agreement_id IS NULL, convert(bit, 0), convert(bit, 1)) as [is_apt_in_list]
			,IIF(mc.[apt_net_id] IS NULL, convert(bit, 0), convert(bit, 1)) as [is_manufacturer_contract]
			,IIF(d.manufacturer_id IS NULL, s.[is_distributor_limitation] ,convert(bit, 1)) [is_distributor_limitation]
			,s.[qty]
			,s.[purch_net]
			,s.[purch_grs]
			,s.[price_cip]
			,s.[purch_cip]
		FROM [dbo].[fct_report_purchases_prepare] as s with (nolock)
		LEFT HASH JOIN [dbo].[fct_volume_agreements] as va with(nolock, index ([ix_5_3_volume_agreements]))
			ON s.[apt_id] = va.[apt_id]
			AND s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			and s.volume_agreement_id = va.volume_agreement_id
		INNER JOIN [dbo].[dim_apt] as a
			ON s.[apt_id] = a.[apt_id]
		LEFT JOIN [dbo].[dim_manufacturer_contracts] as mc
			ON mc.[manufacturer_id] = s.[manufacturer_id]
			AND a.[apt_net_id] = mc.[apt_net_id]
			AND s.[date_id] >= mc.[date_from] AND s.[date_id] <= mc.[date_to]
		LEFT JOIN [dbo].[dim_distributor_limitations] as d
			ON s.supplier_id = d.supplier_id 
			AND s.manufacturer_id = d.manufacturer_id
			AND s.[date_id] >= d.[date_from] AND s.[date_id] <= d.[date_to]
		WHERE s.[is_apt_list] = 1
		and date_id >= @date_from and date_id < @date_to 

		UNION ALL

		--список аптек НЕ НУЖЕН для отсеивания
		SELECT 
			s.source_id
			,s.volume_agreement_id
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[initial_supplier_id]
			,s.[supplier_id]
			,s.[manufacturer_id]
			,s.[volume_agreement_group_id]
			,convert(bit, 1) as [is_apt_in_list]
			,IIF(mc.[apt_net_id] IS NULL, convert(bit, 0), convert(bit, 1)) as [is_manufacturer_contract]
			,IIF(d.manufacturer_id IS NULL, s.[is_distributor_limitation] ,convert(bit, 1)) [is_distributor_limitation]
			,s.[qty]
			,s.[purch_net]
			,s.[purch_grs]
			,s.[price_cip]
			,s.[purch_cip]
		FROM [dbo].[fct_report_purchases_prepare] as s with (nolock)
		LEFT HASH JOIN [dbo].[fct_volume_agreements] as va with(nolock, index ([ix_5_3_volume_agreements]))
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			and s.volume_agreement_id = va.volume_agreement_id
		INNER JOIN [dbo].[dim_apt] as a
			ON s.[apt_id] = a.[apt_id]
		LEFT JOIN [dbo].[dim_manufacturer_contracts] as mc
			ON mc.[manufacturer_id] = s.[manufacturer_id]
			AND a.[apt_net_id] = mc.[apt_net_id]
			AND s.[date_id] >= mc.[date_from] AND s.[date_id] <= mc.[date_to]
		LEFT JOIN [dbo].[dim_distributor_limitations] as d
			ON s.supplier_id = d.supplier_id 
			AND s.manufacturer_id = d.manufacturer_id
			AND s.[date_id] >= d.[date_from] AND s.[date_id] <= d.[date_to]
		WHERE s.[is_apt_list] = 0
		and date_id >= @date_from and date_id < @date_to 
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_report_purchases_prepare]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_report_purchases_prepare] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-31
---- Description:	'Заполнение промежуточной таблицы фактов Закупок "Формирование данных в разрезе объемных соглашений"
----				на уровень dbo'. Данные отсеиваются по списку товаров и списку аптек
----				Применяется округление упаковок
---- EXEC example:	exec [dbo].[fill_fct_report_purchases_prepare] @date_from = 20180701, @date_to = 20181001
---- ================================================================================
ALTER procedure [dbo].[fill_fct_report_purchases_prepare]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_report_purchases_prepare]'
DECLARE @description nvarchar(128) = 'Заполнение промежуточной таблицы "Предварительных отчетных данных" [dbo].[fct_report_purchases_prepare]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	IF exists(SELECT top 1 * from [dbo].[fct_volume_agreements]
		where date_from >= @date_from
		AND date_from < @date_to
		AND date_to >= @date_from
		AND date_to < @date_to
		)
	BEGIN
		delete top (100000) [dbo].[fct_report_purchases_prepare] 
		where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000) [dbo].[fct_report_purchases_prepare] 
			where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end
		INSERT INTO [dbo].[fct_report_purchases_prepare]
			([volume_agreement_id]
			  ,[is_apt_list]
			  ,[source_id]
			  ,[date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[initial_supplier_id]
			  ,[supplier_id]
			  ,[manufacturer_id]
			  ,[volume_agreement_group_id]
			  ,[qty]
			  ,[purch_net]
			  ,[purch_grs]
			  ,[price_cip]
			  ,[purch_cip])

		/*
		Список аптек НЕ нужен
		*/
		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,1 as source_id --Хранилище АСНА
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [purch_cip]
		FROM [dbo].[fct_supplys] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL 

		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,2 as source_id --Партнеры
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[qty] < 1 , 1, convert(decimal(13,0), s.[qty])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [purch_cip]
		FROM [dbo].[fct_partner_purchases] as s with (nolock)
		INNER HASH JOIN (SELECT distinct volume_agreement_id, good_id, date_from, date_to, manufacturer_id, volume_agreement_group_id, price_cip from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL

		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,3 as source_id --Статисты
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[qty] < 1 , 1, convert(decimal(13,0), s.[qty])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [purch_cip]
		FROM [dbo].[fct_statistician_purchases] as s with (nolock)
		INNER HASH JOIN (SELECT distinct volume_agreement_id, good_id, date_from, date_to, manufacturer_id, volume_agreement_group_id, price_cip from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL
		
		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,4 as source_id --Добавочные движения
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [purch_cip]
		FROM [dbo].[fct_supplys_additional] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					increase_movements, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			AND s.[day_number] <= va.increase_movements
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 
		and va.increase_movements != 0

		/*
		Нужен список аптек
		*/
		UNION ALL
		
		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,1 as source_id --Хранилище АСНА
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [purch_cip]
		FROM [dbo].[fct_supplys] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL 

		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,2 as source_id --Партнеры
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[qty] < 1 , 1, convert(decimal(13,0), s.[qty])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [purch_cip]
		FROM [dbo].[fct_partner_purchases] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL

		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,3 as source_id --Статисты
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[qty] < 1 , 1, convert(decimal(13,0), s.[qty])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [purch_cip]
		FROM [dbo].[fct_statistician_purchases] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL
		
		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,4 as source_id --Добавочные движения
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[supplier_id] as [initial_supplier_id]
			,ISNULL(sp.[replacement_supplier_id], s.[supplier_id]) as [supplier_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [qty]
			,s.[purch_net]
			,s.[purch_grs]
			,va.[price_cip]
			,va.[price_cip] * iif(s.[quantity] < 1 , 1, convert(decimal(13,0), s.[quantity])) as [purch_cip]
		FROM [dbo].[fct_supplys_additional] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id,  
					date_from, 
					date_to, 
					increase_movements, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			AND s.[day_number] <= va.increase_movements
		LEFT JOIN [dbo].[dim_supplier_replacements] as sp 
			ON va.[manufacturer_id] = sp.[manufacturer_id]
			AND s.[supplier_id] = sp.[initial_supplier_id]
			AND s.[date_id] >= sp.[date_from] AND s.[date_id] <= sp.[date_to]
		WHERE date_id >= @date_from and date_id < @date_to 
		and va.increase_movements != 0

		--Проставляем ограничения дистрибьютора по спискам производителей
		--На втором этапе формирования предварительных данных ограничения дистрибьторов
		--дополнятся по списку поставщиков
		UPDATE s 
		SET s.is_distributor_limitation = IIF(d.manufacturer_id IS NULL, convert(bit, 1), convert(bit, 0))
		FROM [dbo].[fct_report_purchases_prepare] as s with (nolock)
		LEFT JOIN (SELECT distinct manufacturer_id FROM [dbo].[dim_distributor_limitations]
					WHERE date_from >= @date_from
					AND date_from < @date_to
					AND date_to >= @date_from
					AND date_to < @date_to) as d
		ON s.manufacturer_id = d.manufacturer_id
		WHERE date_id >= @date_from and date_id < @date_to
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_report_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_report_sales] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Продаж "Формирование данных в разрезе объемных соглашений" 
----				на уровень dbo'
----				Округления упаковок не нужны
---- EXEC example:	exec [dbo].[fill_fct_report_sales] @date_from = 20180701, @date_to = 20181001
---- ================================================================================
ALTER procedure [dbo].[fill_fct_report_sales]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_report_sales]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы "Предварительных отчетных данных" [dbo].[fct_report_sales]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	
	IF exists(SELECT top 1 * from [dbo].[fct_volume_agreements]
		where date_from >= @date_from
		AND date_from < @date_to
		AND date_to >= @date_from
		AND date_to < @date_to
		)
	BEGIN
		delete top (100000) [dbo].[fct_report_sales]
		where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000) [dbo].[fct_report_sales]
			where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end

		INSERT INTO [dbo].[fct_report_sales]
			([source_id]
			  ,[volume_agreement_id]
			  ,[date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[manufacturer_id]
			  ,[volume_agreement_group_id]
			  ,[is_apt_in_list]
			  ,[is_manufacturer_contract]
			  ,[qty]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[price_cip]
			  ,[sale_cip]
			  ,[sales_channel_id])

		--список аптек нужен для отсеивания

		SELECT 
			s.source_id 
			,s.volume_agreement_id
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[manufacturer_id]
			,s.[volume_agreement_group_id]
			,IIF(va.volume_agreement_id IS NULL, convert(bit, 0), convert(bit, 1)) as [is_apt_in_list]
			,IIF(mc.[apt_net_id] IS NULL, convert(bit, 0), convert(bit, 1)) as [is_manufacturer_contract]
			,s.[qty]
			,s.[sale_net]
			,s.[sale_grs]
			,s.[price_cip]
			,s.[sale_cip]
			,s.[sales_channel_id]
		FROM [dbo].[fct_report_sales_prepare] as s with(nolock)
		LEFT HASH JOIN [dbo].[fct_volume_agreements] as va with(nolock, index ([ix_5_3_volume_agreements]))
			ON s.[apt_id] = va.[apt_id]
			AND s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to  
			and s.volume_agreement_id = va.volume_agreement_id
		INNER JOIN [dbo].[dim_apt] as a
			ON s.[apt_id] = a.[apt_id]
		LEFT JOIN [dbo].[dim_manufacturer_contracts] as mc
			ON mc.[manufacturer_id] = s.[manufacturer_id]
			AND a.[apt_net_id] = mc.[apt_net_id]
			AND s.[date_id] >= mc.[date_from] AND s.[date_id] <= mc.[date_to]
		WHERE s.[is_apt_list] = 1
		and s.date_id >= @date_from and s.date_id < @date_to 

		UNION ALL

		--список аптек НЕ нужен для отсеивания
		SELECT 
			s.source_id
			,s.volume_agreement_id
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,s.[manufacturer_id]
			,s.[volume_agreement_group_id]
			,IIF(va.volume_agreement_id IS NULL, convert(bit, 0), convert(bit, 1)) as [is_apt_in_list]
			,IIF(mc.[apt_net_id] IS NULL, convert(bit, 0), convert(bit, 1)) as [is_manufacturer_contract]
			,s.[qty]
			,s.[sale_net]
			,s.[sale_grs]
			,s.[price_cip]
			,s.[sale_cip]
			,s.[sales_channel_id]
		FROM [dbo].[fct_report_sales_prepare] as s with(nolock)
		LEFT HASH JOIN [dbo].[fct_volume_agreements] as va with(nolock, index ([ix_5_3_volume_agreements]))
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			and s.volume_agreement_id = va.volume_agreement_id 
		INNER JOIN [dbo].[dim_apt] as a
			ON s.[apt_id] = a.[apt_id]
		LEFT JOIN [dbo].[dim_manufacturer_contracts] as mc
			ON mc.[manufacturer_id] = s.[manufacturer_id]
			AND a.[apt_net_id] = mc.[apt_net_id]
			AND s.[date_id] >= mc.[date_from] AND s.[date_id] <= mc.[date_to]
		WHERE s.[is_apt_list] = 0
		and s.date_id >= @date_from and s.date_id < @date_to 
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_report_sales_prepare]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_report_sales_prepare] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-10-31
---- Description:	'Заполнение промежуточной таблицы фактов Продаж "Формирование данных в разрезе объемных соглашений" 
----				на уровень dbo'. Данные отсеиваются по списку товаров и списку аптек
----				Округления упаковок не нужны
---- EXEC example:	exec [dbo].[fill_fct_report_sales_prepare] @date_from = 20180701, @date_to = 20181001
---- ================================================================================
ALTER procedure [dbo].[fill_fct_report_sales_prepare]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_report_sales_prepare]'
DECLARE @description nvarchar(128) = 'Заполнение промежуточной таблицы "Предварительных отчетных данных" [dbo].[fct_report_sales_prepare]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int
		
	IF exists(SELECT top 1 * from [dbo].[fct_volume_agreements]
		where date_from >= @date_from
		AND date_from < @date_to
		AND date_to >= @date_from
		AND date_to < @date_to
		)
	BEGIN
		delete top (100000) [dbo].[fct_report_sales_prepare]
		where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000) [dbo].[fct_report_sales_prepare]
			where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end

		INSERT INTO [dbo].[fct_report_sales_prepare]
			([volume_agreement_id]
			  ,[is_apt_list]
			  ,[source_id]
			  ,[date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[manufacturer_id]
			  ,[volume_agreement_group_id]
			  ,[qty]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[price_cip]
			  ,[sale_cip]
			  ,[sales_channel_id])
		
		/*
		Список аптек НЕ нужен
		*/
		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,1 as source_id --Хранилище АСНА
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[quantity] as [qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[quantity] as [sale_cip]
			,s.[sales_channel_id]
		FROM [dbo].[fct_sales] as s with(nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to  
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL 

		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,2 as source_id --Партнеры
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [sale_cip]
			,-100 as [sales_channel_id]
		FROM [dbo].[fct_partner_sales] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to  
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL

		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,3 as source_id --Статисты
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [sale_cip]
			,-101 as [sales_channel_id]
		FROM [dbo].[fct_statistician_sales] as s with(nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL
		
		SELECT 
			va.volume_agreement_id
			,convert(bit, 0) as [is_apt_list]
			,4 as source_id --Добавочные движения
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[quantity] as [qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[quantity] as [sale_cip]
			,s.[sales_channel_id]
		FROM [dbo].[fct_sales_additional] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					increase_movements, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id = -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			AND s.[day_number] <= va.increase_movements
		WHERE date_id >= @date_from and date_id < @date_to 
		and va.increase_movements != 0

		/*
		Нужен список аптек
		*/
		UNION ALL

		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,1 as source_id --Хранилище АСНА
			,[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,[quantity] as [qty]
			,[sale_net]
			,[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[quantity] as [sale_cip]
			,s.[sales_channel_id]
		FROM [dbo].[fct_sales] as s with(nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id,
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to  
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL 

		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,2 as source_id --Партнеры
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [sale_cip]
			,-100 as [sales_channel_id]
		FROM [dbo].[fct_partner_sales] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id,
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.good_id
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to  
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL

		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,3 as source_id --Статисты
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[qty] as [sale_cip]
			,-101 as [sales_channel_id]
		FROM [dbo].[fct_statistician_sales] as s with(nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.[good_id]
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
		WHERE date_id >= @date_from and date_id < @date_to 

		UNION ALL
		
		SELECT 
			va.volume_agreement_id
			,convert(bit, 1) as [is_apt_list]
			,4 as source_id --Добавочные движения
			,s.[date_id]
			,s.[apt_id]
			,s.[good_id]
			,va.[manufacturer_id]
			,va.[volume_agreement_group_id]
			,s.[quantity] as [qty]
			,s.[sale_net]
			,s.[sale_grs]
			,va.[price_cip]
			,va.[price_cip] * s.[quantity] as [sale_cip]
			,s.[sales_channel_id]
		FROM [dbo].[fct_sales_additional] as s with (nolock)
		INNER HASH JOIN (
				SELECT distinct 
					volume_agreement_id, 
					good_id, 
					date_from, 
					date_to, 
					increase_movements, 
					manufacturer_id, 
					volume_agreement_group_id, 
					price_cip 
				from [dbo].[fct_volume_agreements] with(nolock, index ([ix_5_3_volume_agreements])) 
				where apt_id != -1) as va
			ON s.[good_id] = va.[good_id]
			AND s.[date_id] >= va.date_from
			AND s.[date_id] <= va.date_to 
			AND s.[day_number] <= va.increase_movements
		WHERE date_id >= @date_from and date_id < @date_to 
		and va.increase_movements != 0
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_rests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_rests] AS' 
END
GO
-- =========================================================================
-- Author:		Shemetov I.V.
-- Create date: 2018-09-20
-- Description:	Заполнение таблицы фактов Остатки
-- =========================================================================
ALTER PROCEDURE [dbo].[fill_fct_rests]
	@date_from int,
	@date_to   int	
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @name varchar(max) = '[dbo].[fill_fct_rests]'
	DECLARE @description nvarchar(500) = 'Заполнение таблицы фактов Остатки'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')
	BEGIN TRY
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name,  @state_name = 'start',  @task_id=null, @sp_id = @@SPID,  @description = @description,  @input_parametrs = @input_parametrs   
	

		--Проверка на существование актуальных данных		
		IF Exists 
		(
			select top(1) 1
			from [stg].[fct_rests] with (nolock)
		) 
		BEGIN

			--Удаляем данные в постоянном хранилище индексированных фактов за указанный период			
			delete top (100000) t
			from [dbo].[fct_rests] as t 
			WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to			
			WHILE @@ROWCOUNT > 0 
			begin
				delete top (100000) t
			    from [dbo].[fct_rests] as t 
				WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to		
			end 


			--Вставляем данные в постоянное хранилище индексированных фактов, за указанный период		
			insert into [dbo].[fct_rests]
			( 
			   [date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[quantity]
			)
			select
			   [date_source_id]
			  ,[apt_source_id]
			  ,[good_source_id]
			  ,[quantity]
			from [stg].[fct_rests] (nolock)
		END				


	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish',  @task_id=null, @sp_id = @@SPID, @description = @description,  @input_parametrs = @input_parametrs   
	END TRY 
	BEGIN CATCH
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
	return
	END CATCH 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_sales] AS' 
END
GO
-- =========================================================================
-- Author:		Shemetov I.V.
-- Create date: 2018-09-20
-- Description:	Заполнение таблицы фактов Продажи
-- =========================================================================
ALTER PROCEDURE [dbo].[fill_fct_sales]
	@date_from int,
	@date_to   int	
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @name varchar(max) = '[dbo].[fill_fct_sales]'
	DECLARE @description nvarchar(500) = 'Заполнение таблицы фактов Продажи'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')
	BEGIN TRY
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name,  @state_name = 'start',  @task_id=null, @sp_id = @@SPID,  @description = @description,  @input_parametrs = @input_parametrs   
	

		--Проверка на существование актуальных данных		
		IF Exists 
		(
			select top(1) 1
			from [stg].[fct_sales] with (nolock)
		) 
		BEGIN

			--Удаляем данные в постоянном хранилище индексированных фактов за указанный период			
			delete top (100000) t
			from [dbo].[fct_sales] as t 
			WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to			
			WHILE @@ROWCOUNT > 0 
			begin
				delete top (100000) t
			    from [dbo].[fct_sales] as t 
				WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to			
			end 


			--Вставляем данные в постоянное хранилище индексированных фактов, за указанный период		
			insert into [dbo].[fct_sales]
			( 
			   [date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			)
			select
			   [date_source_id]
			  ,apt_unit_max.apt_id--Замена кода аптеки, чтобы ключи по префиксу были одинаковыми во всех данных ХД
			  ,[good_source_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			from [stg].[fct_sales] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
		END				

	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish',  @task_id=null, @sp_id = @@SPID, @description = @description,  @input_parametrs = @input_parametrs   
	END TRY 
	BEGIN CATCH
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
	return
	END CATCH 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_sales_additional]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_sales_additional] AS' 
END
GO
-- =========================================================================
-- Author:			Shemetov I.V.
-- Create date:		2018-10-16
-- Description:		Заполнение таблицы фактов Добавочные Продажи
-- EXEC example:	exec [dbo].[fill_fct_sales_additional] @date_from = 20181010, @date_to = 20181011
-- =========================================================================
ALTER PROCEDURE [dbo].[fill_fct_sales_additional]
	@date_from int,
	@date_to   int
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @name varchar(max) = '[dbo].[fill_fct_sales_additional]'
	DECLARE @description nvarchar(500) = 'Заполнение таблицы фактов Добавочные Продажи'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')
	
	DECLARE @first_day int 	

	BEGIN TRY
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name,  @state_name = 'start',  @task_id=null, @sp_id = @@SPID,  @description = @description,  @input_parametrs = @input_parametrs   
	

		--Проверка на существование актуальных данных		
		IF Exists 
		(
			select top(1) 1
			from [stg].[fct_sales_additional] with (nolock)
		) 
		BEGIN

			--Удаляем данные в постоянном хранилище индексированных фактов за указанный период			
			delete top (100000) t
			from [dbo].[fct_sales_additional] as t 
			WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to			
			WHILE @@ROWCOUNT > 0 
			begin
				delete top (100000) t
			    from [dbo].[fct_sales_additional] as t 
				WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to			
			end 


			--Вставляем данные в постоянное хранилище индексированных фактов, за указанный период
			--3 раза для получения 9 добавочных дней
			SELECT @first_day = min([date_source_id]) from [stg].[fct_sales_additional]

			--1 - 3 день
			insert into [dbo].[fct_sales_additional]
			( 
			   [date_id]
			  ,[day_number]
			  ,[apt_id]
			  ,[good_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			)
			select
			   [date_source_id]
			  ,[date_source_id] - @first_day + 1
			  ,apt_unit_max.apt_id--Замена кода аптеки, чтобы ключи по префиксу были одинаковыми во всех данных ХД
			  ,[good_source_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov 
			from [stg].[fct_sales_additional] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
			where [date_source_id] >= @date_from AND [date_source_id] < @date_to
			
			--4 - 6 день
			insert into [dbo].[fct_sales_additional]
			( 
			   [date_id]
			  ,[day_number]
			  ,[apt_id]
			  ,[good_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			)
			select
			   [date_source_id]
			  ,[date_source_id] - @first_day + 4
			  ,apt_unit_max.apt_id--Замена кода аптеки, чтобы ключи по префиксу были одинаковыми во всех данных ХД
			  ,[good_source_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			from [stg].[fct_sales_additional] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
			where [date_source_id] >= @date_from AND [date_source_id] < @date_to

			
			--7 - 9 день
			insert into [dbo].[fct_sales_additional]
			( 
			   [date_id]
			  ,[day_number]
			  ,[apt_id]
			  ,[good_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			)
			select
			   [date_source_id]
			  ,[date_source_id] - @first_day + 7
			  ,apt_unit_max.apt_id--Замена кода аптеки, чтобы ключи по префиксу были одинаковыми во всех данных ХД
			  ,[good_source_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			from [stg].[fct_sales_additional] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
			where [date_source_id] >= @date_from AND [date_source_id] < @date_to
		END				


	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish',  @task_id=null, @sp_id = @@SPID, @description = @description,  @input_parametrs = @input_parametrs   
	END TRY 
	BEGIN CATCH
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
	return
	END CATCH 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_statistician_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_statistician_purchases] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Закупок Статистов на уровень dbo'
---- EXEC example:	exec [dbo].[fill_fct_statistician_purchases] @date_from = 20180801, @date_to = 20180901
---- ================================================================================
ALTER procedure [dbo].[fill_fct_statistician_purchases]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_statistician_purchases_fill]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[fct_statistician_purchases] из [stg].[fct_statistician_purchases]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	IF exists(SELECT top 1 * from [stg].[fct_statistician_purchases] 
		where [date_id] >= @date_from
		AND [date_id] < @date_to)
	BEGIN
		delete top (100000) [dbo].[fct_statistician_purchases] where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000)  [dbo].[fct_statistician_purchases] where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end
		INSERT INTO [dbo].[fct_statistician_purchases] ([date_id]
		  ,[good_id]
		  ,[apt_id]
		  ,[supplier_id]
		  ,[purch_grs]
		  ,[purch_net]
		  ,[qty])
		SELECT 
			[date_id]
		    ,[good_id]
		    ,[apt_id]
		    ,[supplier_id]
		    ,[purch_grs]
		    ,[purch_net]
		    ,[qty]
		FROM [stg].[fct_statistician_purchases] as exc
		where [date_id] >= @date_from
		AND [date_id] < @date_to
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_statistician_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_statistician_sales] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-03-05
---- Description:	'Заполнение таблицы [dbo].[fct_statistician_sales] на основании закупок из [dbo].[fct_statistician_purchases]'
----				'Алгоритм расчета продаж:
----				Продажи мин., шт. текущий месяц = (85% *закупки текущего месяца без дельты) * округляем до целого
----				Продажи мин., шт. предыдущий месяц  = (85% *закупки предыдущего месяца без дельты) * округляем до целого
----				Дельта, шт. предудущий месяц = Продажи (закупки) месяца фактические пред мес  - продажи мин., шт. пред мес.
----				Продажи итоговые, шт.  = (Продажи мин., шт. текущего месяца +  Дельта, шт.  (за предыдущий месяц)) округляем до целого
----				Цена уп. с НДС отчетный месяц = Сумма закуп (сз) с НДС, руб. прошлый месяц /к-во уп. прошлый месяц									
----					если нет данных по продажам за предыдущий месяц, то берем фактическую стоимость упаковки за данный месяц								
----				Цена уп. без НДС отчетный месяц = Сумма закуп (сз) без НДС, руб. прошлый месяц /к-во уп. прошлый мес.									
----					если нет данных по продажам за предыдущий месяц, то берем фактическую стоимость упаковки за данный месяц
----				Продажи итоговые без НДС = 	Продажи итоговые, шт. * Цена уп. без НДС отчетный месяц	
----				Продажи итоговые с НДС = 	Продажи итоговые, шт. * Цена уп. с НДС отчетный месяц'	
---- EXEC example:	exec [dbo].[fill_fct_statistician_sales] @date_from = 20180801, @date_to = 20180901
---- ================================================================================
ALTER procedure [dbo].[fill_fct_statistician_sales]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_statistician_sales]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [dbo].[fct_statistician_sales] на основании закупок из [dbo].[fct_statistician_purchases]'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int

	IF exists(SELECT top 1 * from [dbo].[fct_statistician_purchases]
		where [date_id] >= @date_from
		AND [date_id] < @date_to)
	BEGIN
		delete top (100000) [dbo].[fct_statistician_sales] where date_id >= @date_from and date_id < @date_to 
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (100000)  [dbo].[fct_statistician_sales] where date_id >= @date_from and date_id < @date_to 
			SET @i = @@ROWCOUNT
		end

		DECLARE 
			@date_from_prev int,
			@date_to_prev int
		SET @date_from_prev = dbo.date_to_int(DATEADD(mm, -1, dbo.int_to_date(@date_from)))
		SET @date_to_prev =dbo.date_to_int(DATEADD(mm, -1, dbo.int_to_date(@date_to)))

		INSERT INTO [dbo].[fct_statistician_sales] ([date_id]
		  ,[good_id]
		  ,[apt_id]
		  ,[sale_grs]
		  ,[sale_net]
		  ,[qty])
		SELECT 
			[date_id]
			,[good_id]
			,[apt_id]
			,convert(decimal(20, 10), IIF( --[price_grs_calc]
				ISNULL(SUM([qty_prev]), 0) != 0
				,SUM([purch_grs_prev]) / SUM([qty_prev])
				,IIF(
					ISNULL(SUM([qty_cur]), 0) != 0
					,SUM([purch_grs_cur]) / SUM([qty_cur])
					,NULL
				)
			) 
			* (CEILING(0.85 * SUM([qty_cur])) + SUM([qty_prev]) - CEILING(0.85 * SUM([qty_prev])))) as [purch_grs_calc]
			,convert(decimal(20, 10), IIF( --[price_net_calc]
				ISNULL(SUM([qty_prev]), 0) != 0
				,SUM([purch_net_prev]) / SUM([qty_prev])
				,IIF(
					ISNULL(SUM([qty_cur]), 0) != 0
					,SUM([purch_net_cur]) / SUM([qty_cur])
					,NULL
				)
			) 
			* (CEILING(0.85 * SUM([qty_cur])) + SUM([qty_prev]) - CEILING(0.85 * SUM([qty_prev])))) as [purch_grs_calc]
			,convert(decimal(20, 10), CEILING(0.85 * SUM([qty_cur])) + SUM([qty_prev]) - CEILING(0.85 * SUM([qty_prev]))) as [qty]
		FROM (
			--Текущий месяц
			SELECT 
				[apt_id]
				,[good_id]
				,[date_id]
				,convert(decimal(20, 10), [purch_grs]) as [purch_grs_cur]
				,convert(decimal(20, 10), [purch_net]) as [purch_net_cur] 
				,convert(decimal(20, 10), [qty]) as [qty_cur]
				,0 as [purch_grs_prev]
				,0 as [purch_net_prev] 
				,0 as [qty_prev]
			FROM [dbo].[fct_statistician_purchases]
			WHERE
				[date_id] >= @date_from
				AND [date_id] < @date_to

			UNION ALL
			--Предыдущий месяц
			SELECT 
				[apt_id]
				,[good_id]
				,dbo.date_to_int(DATEADD(mm, 1, dbo.int_to_date([date_id]))) as [date_id]
				,0 as [purch_grs_cur]
				,0 as [purch_net_cur] 
				,0 as [qty_cur]
				,convert(decimal(20, 10), [purch_grs]) as [purch_grs_prev]
				,convert(decimal(20, 10), [purch_net]) as [purch_net_prev] 
				,convert(decimal(20, 10), [qty]) as [qty_prev]
			FROM [dbo].[fct_statistician_purchases]
			WHERE
				[date_id] >= @date_from_prev
				AND [date_id] < @date_to_prev
		) as a
		GROUP BY 
			[apt_id]
			,[good_id]
			,[date_id]
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_supplys]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_supplys] AS' 
END
GO
-- =========================================================================
-- Author:		Shemetov I.V.
-- Create date: 2018-09-20
-- Description:	Заполнение таблицы фактов Закупки поступления
-- =========================================================================
ALTER PROCEDURE [dbo].[fill_fct_supplys]
	@date_from int,
	@date_to   int	
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @name varchar(max) = '[dbo].[fill_fct_supplys]'
	DECLARE @description nvarchar(500) = 'Заполнение таблицы фактов Закупки поступления'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')
	BEGIN TRY
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name,  @state_name = 'start',  @task_id=null, @sp_id = @@SPID,  @description = @description,  @input_parametrs = @input_parametrs   
	

		--Проверка на существование актуальных данных		
		IF Exists 
		(
			select top(1) 1
			from [stg].[fct_supplys] with (nolock)
		) 
		BEGIN

			--Удаляем данные в постоянном хранилище индексированных фактов за указанный период			
			delete top (100000) t
			from [dbo].[fct_supplys] as t 
			WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to
			WHILE @@ROWCOUNT > 0 
			begin
				delete top (100000) t
			    from [dbo].[fct_supplys] as t 
				WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to	
			end 


			--Вставляем данные в постоянное хранилище индексированных фактов, за указанный период		
			insert into [dbo].[fct_supplys]
			( 
			   [date_id]
			  ,[apt_id]
			  ,[good_id]
			  ,[supplier_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			)
			select
			   [date_source_id]
			  ,apt_unit_max.apt_id--Замена кода аптеки, чтобы ключи по префиксу были одинаковыми во всех данных ХД
			  ,[good_source_id]
			  ,[supplier_source_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			from [stg].[fct_supplys] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
		END				


	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish',  @task_id=null, @sp_id = @@SPID, @description = @description,  @input_parametrs = @input_parametrs   
	END TRY 
	BEGIN CATCH
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
	return
	END CATCH 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_supplys_additional]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_supplys_additional] AS' 
END
GO

-- =========================================================================
-- Author:			Shemetov I.V.
-- Create date:		2018-10-16
-- Description:		Заполнение таблицы фактов добавочных Закупки поступления
-- EXEC Example:	exec [dbo].[fill_fct_supplys_additional] @date_from = 20181010, @date_to = 20181011
-- =========================================================================
ALTER PROCEDURE [dbo].[fill_fct_supplys_additional]
	@date_from int,
	@date_to   int	
AS
BEGIN	
	SET NOCOUNT ON;
	DECLARE @name varchar(max) = '[dbo].[fill_fct_supplys_additional]'
	DECLARE @description nvarchar(500) = 'Заполнение таблицы фактов Закупки поступления'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')
	
	DECLARE @first_day int 	
	 
	BEGIN TRY
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name,  @state_name = 'start',  @task_id=null, @sp_id = @@SPID,  @description = @description,  @input_parametrs = @input_parametrs   
	

		--Проверка на существование актуальных данных		
		IF Exists 
		(
			select top(1) 1
			from [stg].[fct_supplys_additional] with (nolock)
		) 
		BEGIN

			--Удаляем данные в постоянном хранилище индексированных фактов за указанный период			
			delete top (100000) t
			from [dbo].[fct_supplys_additional] as t 
			WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to
			WHILE @@ROWCOUNT > 0 
			begin
				delete top (100000) t
			    from [dbo].[fct_supplys_additional] as t 
				WHERE t.[date_id] >= @date_from and t.[date_id] < @date_to	
			end 
			
			--Вставляем данные в постоянное хранилище индексированных фактов, за указанный период
			--3 раза для получения 9 добавочных дней
			SELECT @first_day = min([date_source_id]) from [stg].[fct_supplys_additional]

			--1 - 3 день	
			insert into [dbo].[fct_supplys_additional]
			( 
			   [date_id]
			  ,[day_number]
			  ,[apt_id]
			  ,[good_id]
			  ,[supplier_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			)
			select
			   [date_source_id]
			  ,[date_source_id] - @first_day + 1
			  ,apt_unit_max.apt_id
			  ,[good_source_id]
			  ,[supplier_source_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			from [stg].[fct_supplys_additional] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
			where [date_source_id] >= @date_from AND [date_source_id] < @date_to
			
			--4 - 6 день	
			insert into [dbo].[fct_supplys_additional]
			( 
			   [date_id]
			  ,[day_number]
			  ,[apt_id]
			  ,[good_id]
			  ,[supplier_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			)
			select
			   [date_source_id]
			  ,[date_source_id] - @first_day + 4
			  ,apt_unit_max.apt_id
			  ,[good_source_id]
			  ,[supplier_source_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			from [stg].[fct_supplys_additional] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
			where [date_source_id] >= @date_from AND [date_source_id] < @date_to
			
			--7 - 9 день	
			insert into [dbo].[fct_supplys_additional]
			( 
			   [date_id]
			  ,[day_number]
			  ,[apt_id]
			  ,[good_id]
			  ,[supplier_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			)
			select
			   [date_source_id]
			  ,[date_source_id] - @first_day + 7
			  ,apt_unit_max.apt_id
			  ,[good_source_id]
			  ,[supplier_source_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			from [stg].[fct_supplys_additional] (nolock) as f
			join [dbo].[dim_apt] as apt
				on f.[apt_source_id] = apt.[apt_id]
			join (
					select MAX([apt_id]) as [apt_id], [unit_cll_pref] 
					from [dbo].[dim_apt]
					group by [unit_cll_pref] 
				 )as apt_unit_max
				on apt_unit_max.unit_cll_pref = apt.unit_cll_pref
			where [date_source_id] >= @date_from AND [date_source_id] < @date_to
		END			

	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish',  @task_id=null, @sp_id = @@SPID, @description = @description,  @input_parametrs = @input_parametrs   
	END TRY 
	BEGIN CATCH
	-- Запуск логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs   
	return
	END CATCH 
END





GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fill_fct_volume_agreements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[fill_fct_volume_agreements] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение промежуточной таблицы фактов [dbo].[fct_volume_agreements]
----				для отсеивания данных в отчетах по объемному соглашению'
---- EXEC example:	exec [dbo].[fill_fct_volume_agreements] @date_from = 20180701, @date_to = 20181001
---- ================================================================================
ALTER procedure [dbo].[fill_fct_volume_agreements]
	@date_from int,
	@date_to int
as

DECLARE @name varchar(128) = '[dbo].[fill_fct_volume_agreements]'
DECLARE @description nvarchar(128) = 'Заполнение промежуточной таблицы [dbo].[fct_volume_agreements] для отсеивания данных по объемному соглашению'
DECLARE @input_parametrs nvarchar(128) =  '@date_from = ' + convert(varchar(16), @date_from) + ', @date_to = ' + convert(varchar(16), @date_to)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	declare @i int
	declare @volume_agreement_source_id nvarchar(255)
	declare @Cursor_download	CURSOR

	IF exists(SELECT top 1 * from [stg].[excel_dim_volume_agreements]
		where [dbo].[date_to_int](date_from) >= @date_from
		AND [dbo].[date_to_int](date_from) < @date_to
		AND [dbo].[date_to_int](date_to) >= @date_from
		AND [dbo].[date_to_int](date_to) < @date_to
		)
	BEGIN

		delete top (500000) [dbo].[fct_volume_agreements] 
		where date_from >= @date_from and date_from < @date_to 
		and date_to >= @date_from and date_to < @date_to
		SET @i = @@ROWCOUNT
		while @i > 0
		begin 
			delete top (500000)  [dbo].[fct_volume_agreements] 
			where date_from >= @date_from and date_from < @date_to 
			and date_to >= @date_from and date_to < @date_to
			SET @i = @@ROWCOUNT
		end

		--Создается вспомогательная таблица, на основании которой в дальнейшем
		--собирается предварительный отчет.
		--Берется список товаров и, если нужен список аптек, то цепляется и он
		
		--20191113 Шеметов добавлен курсор, т.к. разбухала база темпа
		SET @Cursor_download = CURSOR SCROLL FOR 
			select distinct volume_agreement_source_id from [stg].[excel_dim_volume_agreements] 
		OPEN @Cursor_download
		FETCH NEXT FROM @Cursor_download INTO @volume_agreement_source_id

		WHILE @@fetch_status <> -1
		BEGIN
			INSERT INTO [dbo].[fct_volume_agreements]
				([volume_agreement_id]
				  ,[good_id]
				  ,[apt_id]
				  ,[date_from]
				  ,[date_to]
				  ,[manufacturer_id]
				  ,[volume_agreement_group_id]
				  ,[increase_movements]
				  ,[price_cip])

			/*
			Нужен список аптек
			*/

			SELECT va.volume_agreement_id
				,g.good_id 
				,a.[apt_id]
				,[dbo].[date_to_int](s.date_from) as [date_from]
				,[dbo].[date_to_int](s.date_to) as [date_to]
				,ISNULL(m.[manufacturer_id], -1) as [manufacturer_id]
				,ISNULL(vag.[volume_agreement_group_id],-1) as [volume_agreement_group_id]
				,ISNULL(s.increase_movements, 0) as [increase_movements]
				,iif(s.price_type = 'СИП', convert(money, isnull(gva.price_cip, 0)), 0) as [price_cip]
			FROM [stg].[excel_dim_volume_agreements] s
			INNER JOIN [dbo].[dim_volume_agreements] as va 
				ON s.volume_agreement_source_id = va.volume_agreement_source_id
			LEFT JOIN [dbo].[dim_manufacturer] as m
				ON s.[manufacturer] = m.manufacturer
			INNER JOIN [stg].[excel_dim_goods_by_volume_agreements] as gva 
				ON s.volume_agreement_source_id = gva.volume_agreement_source_id
			LEFT JOIN [dbo].[dim_volume_agreement_group] as vag
				ON gva.[volume_agreement_group] = vag.[volume_agreement_group]
			INNER JOIN [dbo].[dim_good] as g 
				ON g.initial_id = gva.good_source_id
			INNER JOIN (SELECT distinct [volume_agreement_source_id], [prefix], [date_from], [date_to] FROM [stg].[excel_dim_apt_by_volume_agreements]) as ava 
				ON s.volume_agreement_source_id = ava.volume_agreement_source_id
			INNER JOIN (SELECT MAX([apt_id]) as [apt_id], [unit_cll_pref] FROM [dbo].[dim_apt] GROUP BY [unit_cll_pref]) as a 
				ON a.[unit_cll_pref] = ava.[prefix]
			WHERE 
				s.[volume_agreement_source_id] = @volume_agreement_source_id
				AND s.is_list = '1'--нужен список аптек
				--AND [dbo].[date_to_int](s.date_from) >= @date_from
				--AND [dbo].[date_to_int](s.date_from) < @date_to
				--AND [dbo].[date_to_int](s.date_to) >= @date_from
				--AND [dbo].[date_to_int](s.date_to) < @date_to
				AND s.date_from >= [dbo].[int_to_date](@date_from)
				AND s.date_from < [dbo].[int_to_date](@date_to)
				AND s.date_to >= [dbo].[int_to_date](@date_from)
				AND s.date_to < [dbo].[int_to_date](@date_to)

			UNION ALL

			/*
			Список аптек НЕ нужен
			*/

			SELECT va.volume_agreement_id
				,g.good_id 
				,-1 as [apt_id]
				,[dbo].[date_to_int](s.date_from) as [date_from]
				,[dbo].[date_to_int](s.date_to) as [date_to]
				,ISNULL(m.[manufacturer_id], -1) as [manufacturer_id]
				,ISNULL(vag.[volume_agreement_group_id],-1) as [volume_agreement_group_id]
				,ISNULL(s.increase_movements, 0) as [increase_movements]
				,iif(s.price_type = 'СИП', convert(money, isnull(gva.price_cip, 0)), 0) as [price_cip]
			FROM [stg].[excel_dim_volume_agreements] s
			INNER JOIN [dbo].[dim_volume_agreements] as va 
				ON s.volume_agreement_source_id = va.volume_agreement_source_id
			INNER JOIN [stg].[excel_dim_goods_by_volume_agreements] as gva 
				ON s.volume_agreement_source_id = gva.volume_agreement_source_id
			INNER JOIN [dbo].[dim_good] as g 
				ON g.initial_id = gva.good_source_id
			LEFT JOIN [dbo].[dim_manufacturer] as m
				ON s.[manufacturer] = m.manufacturer
			LEFT JOIN [dbo].[dim_volume_agreement_group] as vag
				ON gva.[volume_agreement_group] = vag.[volume_agreement_group]
			WHERE 
				s.[volume_agreement_source_id] = @volume_agreement_source_id
				AND s.is_list = '0'--не нужен список аптек
				--AND [dbo].[date_to_int](s.date_from) >= @date_from
				--AND [dbo].[date_to_int](s.date_from) < @date_to
				--AND [dbo].[date_to_int](s.date_to) >= @date_from
				--AND [dbo].[date_to_int](s.date_to) < @date_to
				AND s.date_from >= [dbo].[int_to_date](@date_from)
				AND s.date_from < [dbo].[int_to_date](@date_to)
				AND s.date_to >= [dbo].[int_to_date](@date_from)
				AND s.date_to < [dbo].[int_to_date](@date_to)

			FETCH NEXT FROM @Cursor_download INTO @volume_agreement_source_id
		END
		close @Cursor_download
		deallocate @Cursor_download		
	END

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[p_sourcedwh_create_link]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[p_sourcedwh_create_link] AS' 
END
GO

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[p_auto_fct_report_source_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[p_auto_fct_report_source_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		 М.С.
---- Create date:   2019-01-11
---- Description:	'Процедура вывода отчета для страницы "Приход на АСНА"'
---- EXEC example:	exec [dbo].[p_auto_fct_report_source_purchases] @volume_agreement_id = 686
---- ================================================================================

ALTER PROCEDURE [dbo].[p_auto_fct_report_source_purchases]
 @volume_agreement_id int

as 
begin

	
	DECLARE @volume_agreement_source_id nvarchar(255)	
	SELECT @volume_agreement_source_id =  volume_agreement_source_id  from [dbo].[dim_volume_agreements] where volume_agreement_id = @volume_agreement_id

	IF (not exists(SELECT TOP 1 1 
					FROM [dbo].[fct_source_purchases] 
					WHERE volume_agreement_id = @volume_agreement_id
					)		
		)

	BEGIN
		--Если в ХД нет данных по введенному ОС
		SELECT cast('Нет данных в ХД по ОС = ' as nvarchar) + @volume_agreement_source_id as [ошибка]
	END
	ELSE BEGIN
		SELECT g.[initial_id] as [Код ННТ]
			  ,g.[descr] as [Наименование]
			  ,[qty] as [Приход уп.]
			  ,s.[inn] as [ИНН поставщика]
			  ,s.[descr] as [Поставщик]
			  ,case when f.[arrival_date] <> 0 then cast(dbo.int_to_date(f.[arrival_date]) as nvarchar) else '' end as [Дата поставки]
			  ,[invoice_number_in] as [Номер накладной (вх.)]
      
			  ,s2.[inn] as [ИНН Субпоставщика]
			  ,s2.[descr] as [Субпоставщик]

			   ,case when f.[delivery_date] <> 0 then cast(dbo.int_to_date(f.[delivery_date]) as nvarchar) else '' end  as [Дата отгрузки (исх.)]
			  ,[invoice_number_out] as [Номер накладной (исх.)]
		FROM [dbo].[fct_source_purchases] as f
		left join dim_good as g
			on g.good_id = f.good_id
		left join [dbo].[v_olap_dim_supplier] as s
			on s.[supplier_id] = f.supplier_id
		left join [dbo].[v_olap_dim_supplier] as s2
			on s2.[supplier_id] = f.[sub_supplier_id]
		where f.volume_agreement_id = @volume_agreement_id

	
	end
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[p_auto_fct_report_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[p_auto_fct_report_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-01-10
---- Description:	'Процедура вывода отчета автоформирования по загруженному настроечному файлу'
---- EXEC example:	exec [dbo].[p_auto_fct_report_purchases] @volume_agreement_id = 511, @out = true, @right = false
---- ================================================================================

ALTER PROCEDURE [dbo].[p_auto_fct_report_purchases]
 @volume_agreement_id int
,@out bit --0 = внутренний отчет, 1 = внешний отчет
,@right bit --0 = месяцы в строках ("отчет вниз"), 1 = месяцы в столбцах ("отчет справа") 
as 

DECLARE @date_from int
DECLARE @date_to int 
DECLARE @all_columns varchar(MAX)--все поля
DECLARE @volume_agreement_source_id nvarchar(255)
DECLARE @SQL nvarchar(max)
DECLARE @group_by_columns nvarchar(max)
DECLARE @necessary_columns varchar(MAX)--требуемые поля, помеченные 0 в таблице настроек
DECLARE @sum_columns varchar(MAX)--требуемые поля, помеченные 0 в таблице настроек
DECLARE @sub_select nvarchar(max)
DECLARE @CURSOR cursor
DECLARE @cur_eng_column_name nvarchar(64)
DECLARE @cur_rus_column_name nvarchar(64)
DECLARE @pivot_part nvarchar(MAX)
DECLARE @pivot_part_rus_monthes nvarchar(MAX)
DECLARE @total nvarchar(max)
DECLARE @sub_total nvarchar(max)

SELECT @date_from = MAX(date_from) FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = @volume_agreement_id
SELECT @date_to = MAX(date_to) FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = @volume_agreement_id
SELECT @volume_agreement_source_id =  volume_agreement_source_id  from [dbo].[dim_volume_agreements] where volume_agreement_id = @volume_agreement_id

IF not exists(SELECT TOP 1 1 FROM [dbo].[fct_report_purchases] 
	WHERE volume_agreement_id = @volume_agreement_id
	AND date_id >= @date_from
	AND date_id <= @date_to)
BEGIN
	--Если в ХД нет данных по введенному ОС
	SELECT cast('Нет данных в ХД по ОС = ' as nvarchar) + @volume_agreement_source_id as [ошибка]
END
ELSE BEGIN
	--Если в ХД есть данные по введенному ОС
	IF @out = 0--Отчет со всеми столбцами (внутренний)
	BEGIN
		IF @right = 0--месяцы вниз
		BEGIN			
			--Определение псевдонимов для столбцов
			SELECT @necessary_columns = COALESCE(@necessary_columns + ', ' + c.[name] + ' as [' + convert(nvarchar, ep.[value]) + ']' , c.[name] + ' as [' + convert(nvarchar, ep.[value]) + ']')
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND c.[name] LIKE 'purchases_dim%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'			

			--Определение полей для агрегации
			SELECT @sum_columns = COALESCE(@sum_columns + ', ' + 'iif(SUM(' + c.[name] + ') = 0, null, SUM(' + c.[name] + ')) as [' + convert(nvarchar, ep.[value]) + ']' , 'iif(SUM(' + c.[name] + ') = 0, null, SUM(' + c.[name] + ')) as [' + convert(nvarchar, ep.[value]) + ']')
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND c.[name] LIKE 'purchases_fct%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'

			--Определение полей для группировки
			SELECT @group_by_columns = COALESCE(@group_by_columns + ', ' + c.[name], c.[name])
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND c.[name] LIKE 'purchases_dim%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'

			--Вывод внутреннего отчета с учетом всех столбцов
			SET @SQL = ('SELECT ' + @necessary_columns + ', ' + @sum_columns +' FROM [dbo].[v_auto_fct_report_purchases]
			WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + '
				AND date_id >= ' + convert(nvarchar, @date_from) + '
				AND date_id <= ' + convert(nvarchar, @date_to) +
			'
			GROUP BY 
				' +  @group_by_columns
				)
			EXEC (@SQL)
		END
		ELSE BEGIN--месяцы справа
			
			SET @pivot_part = ''
			SET @sub_select = ''
			SET @total = ''
			
			--Определяем поля в подзапросе
			SELECT @necessary_columns = STRING_AGG(
				iif(convert(nvarchar(64), c.[name]) like 'purchases_fct_report_purchases_%'
					,'[' + convert(nvarchar(64), c.[name]) + ']'
					,convert(nvarchar(64), c.[name]) + ' as [' + convert(nvarchar, convert(nvarchar(64), ep.[value])) + ']')	
				, ', ')
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND convert(nvarchar(64), c.[name]) LIKE 'purchases_%'
				AND convert(nvarchar(64), c.[name]) NOT LIKE 'purchases_dim_date_year_id'	
				AND convert(nvarchar(64), c.[name]) NOT LIKE 'purchases_dim_date_month_name'
				AND convert(nvarchar(64), c.[name]) NOT LIKE 'purchases_fct_report_purchases_%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'

			--Определяем часть пивота
			SET @CURSOR = CURSOR SCROLL
			FOR
				SELECT convert(nvarchar(64), c.[name]) as [eng_column_name], convert(nvarchar(64), ep.[value]) as [rus_column_name]
				FROM sys.columns as c
				INNER JOIN sys.extended_properties as ep
					ON c.object_id = ep.major_id
				WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
					AND c.[name] LIKE 'purchases_fct_report_purchases_%'
					AND c.column_id = ep.minor_id
					AND ep.class = 1
					AND ep.name = 'RUS_column_name'
			OPEN @CURSOR
			FETCH NEXT FROM @CURSOR INTO @cur_eng_column_name, @cur_rus_column_name
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--Формирование части IN для PIVOT
				SELECT @pivot_part_rus_monthes = STRING_AGG('[' + @cur_rus_column_name + ' ' + [month] + ']', ', ') WITHIN GROUP (order by [month_id])
				FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
				SET @pivot_part = @pivot_part + iif(@pivot_part = '', '', ', ') + @pivot_part_rus_monthes
				--Формирование итоговых полей
				SELECT @sub_total = STRING_AGG('isnull([' + @cur_rus_column_name + ' ' + [month] + '], 0) ', ' + ') WITHIN GROUP (order by [month_id])
				FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
				SET @total = @total + ', iif((' + @sub_total + ') = 0, null, (' + @sub_total + ')) as [Итог ' + @cur_rus_column_name + '] '
				--Формирование тела подзапроса для PIVOT
				SET @sub_select = @sub_select 
									+ iif(@sub_select = '', '', ' UNION ALL ')
									+ 'SELECT '
									+ @necessary_columns
									+ ', [' + @cur_eng_column_name + '] as [val],'
									+ ' ''' + @cur_rus_column_name + '''' + ' + '' '' + convert(nvarchar, [purchases_dim_date_year_id]) + '' '' + convert(nvarchar, [purchases_dim_date_month_name]) as [col_name] '
									+ 'FROM [dbo].[v_auto_fct_report_purchases] 
									WHERE [volume_agreement_id] = ' + convert(nvarchar, @volume_agreement_id) +'
									AND date_id >= ' + convert(nvarchar, @date_from) + '
									AND date_id <= ' + convert(nvarchar, @date_to) + ' 
										'
				FETCH NEXT FROM @CURSOR INTO @cur_eng_column_name, @cur_rus_column_name
			END
			CLOSE @CURSOR


			--формируем финальный запрос
			SET @SQL = ('SELECT *'
					 + @total + '
					 FROM (
					' + @sub_select + ') as r
					PIVOT (SUM([val])
					FOR [col_name]
					IN (' + @pivot_part + ')) as pvt')
			EXEC sp_executesql @SQL
		END
	END 
	ELSE BEGIN--Отчет со столбцами из настроечного файла(внешний)
		IF NOT exists(SELECT TOP 1 * FROM [dbo].[auto_volume_agreements_settings]
		WHERE volume_agreement_id = @volume_agreement_id)
		BEGIN
			--Если в настроечном файле нет информации о введеном ОС
			SELECT cast('Нет данных в настроечной таблице по ОС = ' as nvarchar) + @volume_agreement_source_id as [ошибка]
		END
		ELSE BEGIN
			IF @right = 0 
			BEGIN
				-- Получение всех выводимых в отчете полей из настроечной таблицы. Помечены префиксом purchases 
				SELECT @all_columns = COALESCE(@all_columns + ', ' + COLUMN_NAME, COLUMN_NAME)
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE 
					TABLE_NAME = 'auto_volume_agreements_settings' 
					AND TABLE_SCHEMA='dbo'
					AND COLUMN_NAME LIKE 'purchases%'
	
				-- Получение перечня только требуемых полей 
				SET @SQL = '
					SELECT @necessary_columns = STRING_AGG(map.[COLUMN_NAME] + '' as ['' + map.[RUS_column_name] + '']'' , '', '')  
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND c.column_id = ep.minor_id
							AND c.[name] LIKE ''purchases_dim%''
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@necessary_columns nvarchar(MAX) OUTPUT', @necessary_columns OUTPUT

				-- Определение полей для агрегации
				SET @SQL = '
					SELECT @sum_columns = STRING_AGG(''iif(SUM('' + map.[COLUMN_NAME] + '') = 0, null, SUM('' + map.[COLUMN_NAME] + ''))  as ['' + map.[RUS_column_name] + '']'' , '', '')  
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND c.column_id = ep.minor_id
							AND c.[name] LIKE ''purchases_fct%''
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@sum_columns nvarchar(MAX) OUTPUT', @sum_columns OUTPUT

				-- Определение полей для группировки
				SET @SQL = '
					SELECT @group_by_columns = STRING_AGG(map.[COLUMN_NAME], '', '')  
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND c.column_id = ep.minor_id
							AND c.[name] LIKE ''purchases_dim%''
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@group_by_columns nvarchar(MAX) OUTPUT', @group_by_columns OUTPUT

				-- Вывод внешнего отчета с перечислением только требуемых полей
				set @SQL = 'SELECT ' + @necessary_columns + ', ' + @sum_columns + '
					FROM [dbo].[v_auto_fct_report_purchases]
					WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + '
						AND date_id >= ' + convert(nvarchar, @date_from) + '
						AND date_id <= ' + convert(nvarchar, @date_to) + '
					GROUP BY
					' + @group_by_columns

				EXEC(@SQL)
			END
			ELSE BEGIN				
				-------------------------
				--Определяем часть пивота
				-------------------------
				SELECT @all_columns = COALESCE(@all_columns + ', ' + COLUMN_NAME, COLUMN_NAME)
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE 
					TABLE_NAME = 'auto_volume_agreements_settings' 
					AND TABLE_SCHEMA='dbo'
					AND COLUMN_NAME LIKE 'purchases%'

				-- Получение перечня только требуемых полей измерений
				SET @SQL = '
					SELECT @necessary_columns = STRING_AGG(
							iif(convert(nvarchar(64), map.[COLUMN_NAME]) like ''purchases_fct_report_purchases_%''
								,''['' + convert(nvarchar(64), map.[COLUMN_NAME]) + '']''
								,convert(nvarchar(64), map.[COLUMN_NAME]) + '' as ['' + convert(nvarchar, convert(nvarchar(64), map.[RUS_column_name])) + '']'')	
							, '', '')				
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND convert(nvarchar(64), c.[name]) LIKE ''purchases_%''
							AND convert(nvarchar(64), c.[name]) NOT LIKE ''purchases_dim_date_year_id''	
							AND convert(nvarchar(64), c.[name]) NOT LIKE ''purchases_dim_date_month_name''
							AND convert(nvarchar(64), c.[name]) NOT LIKE ''purchases_fct_report_purchases_%''
							AND c.column_id = ep.minor_id
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@necessary_columns nvarchar(MAX) OUTPUT', @necessary_columns OUTPUT

				-- Фомирование подзапроса с перечнем только требуемых фактов 

				SET @SQL = 'DECLARE  dynamic_cursor CURSOR FOR 
					SELECT convert(nvarchar(64), map.[COLUMN_NAME]) as [eng_column_name], convert(nvarchar(64), map.[RUS_column_name]) as [rus_column_name]				
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' +  convert(nvarchar(64),@volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND convert(nvarchar(64), c.[name]) LIKE ''purchases_fct_report_purchases_%''
							AND c.column_id = ep.minor_id
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
							'
				exec sp_executesql @SQL

				SET @pivot_part = ''
				SET @sub_select = ''
				SET @total = ''

				OPEN dynamic_cursor
				FETCH NEXT FROM dynamic_cursor INTO @cur_eng_column_name, @cur_rus_column_name
				WHILE @@FETCH_STATUS = 0
				BEGIN
					--Формирование части IN для PIVOT
					SELECT @pivot_part_rus_monthes = STRING_AGG('[' + @cur_rus_column_name + ' ' + [month] + ']', ', ') WITHIN GROUP (order by [month_id])
					FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
					SET @pivot_part = @pivot_part + iif(@pivot_part = '', '', ', ') + @pivot_part_rus_monthes
					--Формирование итоговых полей
					SELECT @sub_total = STRING_AGG('isnull([' + @cur_rus_column_name + ' ' + [month] + '], 0) ', ' + ') WITHIN GROUP (order by [month_id])
					FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
					SET @total = @total + ', iif((' + @sub_total + ') = 0, null, (' + @sub_total + ')) as [Итог ' + @cur_rus_column_name + '] '
					--Формирование тела подзапроса для PIVOT
					SET @sub_select = @sub_select 
									 + iif(@sub_select = '', '', ' UNION ALL ')
									 + 'SELECT '
									 + @necessary_columns
									 + ', [' + @cur_eng_column_name + '] as [val],'
									 + ' ''' + @cur_rus_column_name + '''' + ' + '' '' + convert(nvarchar, [purchases_dim_date_year_id]) + '' '' + convert(nvarchar, [purchases_dim_date_month_name]) as [col_name] '
									 + 'FROM [dbo].[v_auto_fct_report_purchases] 
									 WHERE [volume_agreement_id] = ' + convert(nvarchar, @volume_agreement_id) +'
										AND date_id >= ' + convert(nvarchar, @date_from) + '
										AND date_id <= ' + convert(nvarchar, @date_to) + ' 
										'					
					FETCH NEXT FROM dynamic_cursor INTO @cur_eng_column_name, @cur_rus_column_name
				END
				CLOSE dynamic_cursor
				DEALLOCATE dynamic_cursor

				SET @SQL = ('SELECT *'
					 + @total + '
					 FROM (
					' + @sub_select + ') as r
					PIVOT (SUM([val])
					FOR [col_name]
					IN (' + @pivot_part + ')) as pvt')
				EXEC sp_executesql @SQL
			END
		END
	END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[p_auto_fct_report_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[p_auto_fct_report_sales] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-01-10
---- Description:	'Процедура вывода отчета автоформирования по загруженному настроечному файлу'
---- EXEC example:	exec [dbo].[p_auto_fct_report_sales] @volume_agreement_id = 511, @out = false, @right = false
---- ================================================================================

ALTER PROCEDURE [dbo].[p_auto_fct_report_sales]
  @volume_agreement_id int
,@out bit --0 = внутренний отчет, 1 = внешний отчет
,@right bit --0 = месяцы в строках ("отчет вниз"), 1 = месяцы в столбцах ("отчет справа") 
as 

DECLARE @date_from int
DECLARE @date_to int 
DECLARE @all_columns varchar(MAX)--все поля
DECLARE @volume_agreement_source_id nvarchar(255)
DECLARE @SQL nvarchar(max)
DECLARE @group_by_columns nvarchar(max)
DECLARE @necessary_columns varchar(MAX)--требуемые поля, помеченные 0 в таблице настроек
DECLARE @sum_columns varchar(MAX)--требуемые поля, помеченные 0 в таблице настроек
DECLARE @sub_select nvarchar(max)
DECLARE @CURSOR cursor
DECLARE @cur_eng_column_name nvarchar(64)
DECLARE @cur_rus_column_name nvarchar(64)
DECLARE @pivot_part nvarchar(MAX)
DECLARE @pivot_part_rus_monthes nvarchar(MAX)
DECLARE @total nvarchar(max)
DECLARE @sub_total nvarchar(max)

SELECT @date_from = MAX(date_from) FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = @volume_agreement_id
SELECT @date_to = MAX(date_to) FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = @volume_agreement_id
SELECT @volume_agreement_source_id =  volume_agreement_source_id  from [dbo].[dim_volume_agreements] where volume_agreement_id = @volume_agreement_id

IF not exists(SELECT TOP 1 1 FROM [dbo].[fct_report_sales] 
	WHERE volume_agreement_id = @volume_agreement_id
	AND date_id >= @date_from
	AND date_id <= @date_to)
BEGIN
	--Если в ХД нет данных по введенному ОС
	SELECT cast('Нет данных в ХД по ОС = ' as nvarchar) + @volume_agreement_source_id as [ошибка]
END
ELSE BEGIN
	--Если в ХД есть данные по введенному ОС
	IF @out = 0--Отчет со всеми столбцами (внутренний)
	BEGIN
		IF @right = 0--месяцы вниз
		BEGIN			
			--Определение псевдонимов для столбцов
			SELECT @necessary_columns = COALESCE(@necessary_columns + ', ' + c.[name] + ' as [' + convert(nvarchar, ep.[value]) + ']' , c.[name] + ' as [' + convert(nvarchar, ep.[value]) + ']')
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND c.[name] LIKE 'sales_dim%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'			

			--Определение полей для агрегации
			SELECT @sum_columns = COALESCE(@sum_columns + ', ' + 'iif(SUM(' + c.[name] + ') = 0, null, SUM(' + c.[name] + ')) as [' + convert(nvarchar, ep.[value]) + ']' , 'iif(SUM(' + c.[name] + ') = 0, null, SUM(' + c.[name] + ')) as [' + convert(nvarchar, ep.[value]) + ']')
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND c.[name] LIKE 'sales_fct%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'

			--Определение полей для группировки
			SELECT @group_by_columns = COALESCE(@group_by_columns + ', ' + c.[name], c.[name])
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND c.[name] LIKE 'sales_dim%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'

			--Вывод внутреннего отчета с учетом всех столбцов
			SET @SQL = ('SELECT ' + @necessary_columns + ', ' + @sum_columns +' FROM [dbo].[v_auto_fct_report_sales]
			WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + '
				AND date_id >= ' + convert(nvarchar, @date_from) + '
				AND date_id <= ' + convert(nvarchar, @date_to) +
			'
			GROUP BY 
				' +  @group_by_columns
				)
			EXEC (@SQL)
		END
		ELSE BEGIN--месяцы справа
			
			SET @pivot_part = ''
			SET @sub_select = ''
			SET @total = ''
			
			--Определяем поля в подзапросе
			SELECT @necessary_columns = STRING_AGG(
				iif(convert(nvarchar(64), c.[name]) like 'sales_fct_report_sales_%'
					,'[' + convert(nvarchar(64), c.[name]) + ']'
					,convert(nvarchar(64), c.[name]) + ' as [' + convert(nvarchar, convert(nvarchar(64), ep.[value])) + ']')	
				, ', ')
			FROM sys.columns as c
			INNER JOIN sys.extended_properties as ep
				ON c.object_id = ep.major_id
			WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
				AND convert(nvarchar(64), c.[name]) LIKE 'sales_%'
				AND convert(nvarchar(64), c.[name]) NOT LIKE 'sales_dim_date_year_id'	
				AND convert(nvarchar(64), c.[name]) NOT LIKE 'sales_dim_date_month_name'
				AND convert(nvarchar(64), c.[name]) NOT LIKE 'sales_fct_report_sales_%'
				AND c.column_id = ep.minor_id
				AND ep.class = 1
				AND ep.name = 'RUS_column_name'

			--Определяем часть пивота
			SET @CURSOR = CURSOR SCROLL
			FOR
				SELECT convert(nvarchar(64), c.[name]) as [eng_column_name], convert(nvarchar(64), ep.[value]) as [rus_column_name]
				FROM sys.columns as c
				INNER JOIN sys.extended_properties as ep
					ON c.object_id = ep.major_id
				WHERE c.object_id = OBJECT_ID('dbo.auto_volume_agreements_settings')
					AND c.[name] LIKE 'sales_fct_report_sales_%'
					AND c.column_id = ep.minor_id
					AND ep.class = 1
					AND ep.name = 'RUS_column_name'
			OPEN @CURSOR
			FETCH NEXT FROM @CURSOR INTO @cur_eng_column_name, @cur_rus_column_name
			WHILE @@FETCH_STATUS = 0
			BEGIN
				--Формирование части IN для PIVOT
				SELECT @pivot_part_rus_monthes = STRING_AGG('[' + @cur_rus_column_name + ' ' + [month] + ']', ', ') WITHIN GROUP (order by [month_id])
				FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
				SET @pivot_part = @pivot_part + iif(@pivot_part = '', '', ', ') + @pivot_part_rus_monthes
				--Формирование итоговых полей
				SELECT @sub_total = STRING_AGG('isnull([' + @cur_rus_column_name + ' ' + [month] + '], 0) ', ' + ') WITHIN GROUP (order by [month_id])
				FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
				SET @total = @total + ', iif((' + @sub_total + ') = 0, null, (' + @sub_total + ')) as [Итог ' + @cur_rus_column_name + '] '
				--Формирование тела подзапроса для PIVOT
				SET @sub_select = @sub_select 
									+ iif(@sub_select = '', '', ' UNION ALL ')
									+ 'SELECT '
									+ @necessary_columns
									+ ', [' + @cur_eng_column_name + '] as [val],'
									+ ' ''' + @cur_rus_column_name + '''' + ' + '' '' + convert(nvarchar, [sales_dim_date_year_id]) + '' '' + convert(nvarchar, [sales_dim_date_month_name]) as [col_name] '
									+ 'FROM [dbo].[v_auto_fct_report_sales] 
									WHERE [volume_agreement_id] = ' + convert(nvarchar, @volume_agreement_id) +'
									AND date_id >= ' + convert(nvarchar, @date_from) + '
									AND date_id <= ' + convert(nvarchar, @date_to) + ' 
										'
				FETCH NEXT FROM @CURSOR INTO @cur_eng_column_name, @cur_rus_column_name
			END
			CLOSE @CURSOR


			--формируем финальный запрос
			SET @SQL = ('SELECT *'
					 + @total + '
					 FROM (
					' + @sub_select + ') as r
					PIVOT (SUM([val])
					FOR [col_name]
					IN (' + @pivot_part + ')) as pvt')
				EXEC sp_executesql @SQL

		END
	END 
	ELSE BEGIN--Отчет со столбцами из настроечного файла(внешний)
		IF NOT exists(SELECT TOP 1 * FROM [dbo].[auto_volume_agreements_settings]
		WHERE volume_agreement_id = @volume_agreement_id)
		BEGIN
			--Если в настроечном файле нет информации о введеном ОС
			SELECT cast('Нет данных в настроечной таблице по ОС = ' as nvarchar) + @volume_agreement_source_id as [ошибка]
		END
		ELSE BEGIN
			IF @right = 0 
			BEGIN
				-- Получение всех выводимых в отчете полей из настроечной таблицы. Помечены префиксом sales 
				SELECT @all_columns = COALESCE(@all_columns + ', ' + COLUMN_NAME, COLUMN_NAME)
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE 
					TABLE_NAME = 'auto_volume_agreements_settings' 
					AND TABLE_SCHEMA='dbo'
					AND COLUMN_NAME LIKE 'sales%'
	
				-- Получение перечня только требуемых полей 
				SET @SQL = '
					SELECT @necessary_columns = STRING_AGG(map.[COLUMN_NAME] + '' as ['' + map.[RUS_column_name] + '']'' , '', '')  
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND c.column_id = ep.minor_id
							AND c.[name] LIKE ''sales_dim%''
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@necessary_columns nvarchar(MAX) OUTPUT', @necessary_columns OUTPUT

				-- Определение полей для агрегации
				SET @SQL = '
					SELECT @sum_columns = STRING_AGG(''iif(SUM('' + map.[COLUMN_NAME] + '') = 0, null, SUM('' + map.[COLUMN_NAME] + ''))  as ['' + map.[RUS_column_name] + '']'' , '', '')  
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND c.column_id = ep.minor_id
							AND c.[name] LIKE ''sales_fct%''
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@sum_columns nvarchar(MAX) OUTPUT', @sum_columns OUTPUT

				-- Определение полей для группировки
				SET @SQL = '
					SELECT @group_by_columns = STRING_AGG(map.[COLUMN_NAME], '', '')  
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND c.column_id = ep.minor_id
							AND c.[name] LIKE ''sales_dim%''
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@group_by_columns nvarchar(MAX) OUTPUT', @group_by_columns OUTPUT

				-- Вывод внешнего отчета с перечислением только требуемых полей
				set @SQL = 'SELECT ' + @necessary_columns + ', ' + @sum_columns + '
					FROM [dbo].[v_auto_fct_report_sales]
					WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + '
						AND date_id >= ' + convert(nvarchar, @date_from) + '
						AND date_id <= ' + convert(nvarchar, @date_to) + '
					GROUP BY
					' + @group_by_columns

				EXEC(@SQL)
			END
			ELSE BEGIN				
				-------------------------
				--Определяем часть пивота
				-------------------------
				SELECT @all_columns = COALESCE(@all_columns + ', ' + COLUMN_NAME, COLUMN_NAME)
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE 
					TABLE_NAME = 'auto_volume_agreements_settings' 
					AND TABLE_SCHEMA='dbo'
					AND COLUMN_NAME LIKE 'sales%'

				-- Получение перечня только требуемых полей измерений
				SET @SQL = '
					SELECT @necessary_columns = STRING_AGG(
							iif(convert(nvarchar(64), map.[COLUMN_NAME]) like ''sales_fct_report_sales_%''
								,''['' + convert(nvarchar(64), map.[COLUMN_NAME]) + '']''
								,convert(nvarchar(64), map.[COLUMN_NAME]) + '' as ['' + convert(nvarchar, convert(nvarchar(64), map.[RUS_column_name])) + '']'')	
							, '', '')				
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' + convert(nvarchar, @volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND convert(nvarchar(64), c.[name]) LIKE ''sales_%''
							AND convert(nvarchar(64), c.[name]) NOT LIKE ''sales_dim_date_year_id''	
							AND convert(nvarchar(64), c.[name]) NOT LIKE ''sales_dim_date_month_name''
							AND convert(nvarchar(64), c.[name]) NOT LIKE ''sales_fct_report_sales_%''
							AND c.column_id = ep.minor_id
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
				'
				EXEC sp_executesql @SQL, N'@necessary_columns nvarchar(MAX) OUTPUT', @necessary_columns OUTPUT

				-- Фомирование подзапроса с перечнем только требуемых фактов 

				SET @SQL = 'DECLARE  dynamic_cursor CURSOR FOR 
					SELECT convert(nvarchar(64), map.[COLUMN_NAME]) as [eng_column_name], convert(nvarchar(64), map.[RUS_column_name]) as [rus_column_name]				
					FROM 
					( SELECT ' + @all_columns + ' FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = ' +  convert(nvarchar(64),@volume_agreement_id) + ') as p
					UNPIVOT (value FOR COLUMN_NAME IN (' + @all_columns + ')) as unpvt
					INNER JOIN (
						SELECT c.name as [COLUMN_NAME], convert(nvarchar, ep.value) as [RUS_column_name] FROM sys.columns as c
						INNER JOIN sys.extended_properties as ep
							ON c.object_id = ep.major_id
						WHERE c.object_id = OBJECT_ID(''dbo.auto_volume_agreements_settings'')
							AND convert(nvarchar(64), c.[name]) LIKE ''sales_fct_report_sales_%''
							AND c.column_id = ep.minor_id
							AND ep.class = 1
							AND ep.name = ''RUS_column_name'') as map
						ON unpvt.COLUMN_NAME = map.COLUMN_NAME
					WHERE unpvt.value = 1
							'
				exec sp_executesql @SQL

				SET @pivot_part = ''
				SET @sub_select = ''
				SET @total = ''

				OPEN dynamic_cursor
				FETCH NEXT FROM dynamic_cursor INTO @cur_eng_column_name, @cur_rus_column_name
				WHILE @@FETCH_STATUS = 0
				BEGIN
					--Формирование части IN для PIVOT
					SELECT @pivot_part_rus_monthes = STRING_AGG('[' + @cur_rus_column_name + ' ' + [month] + ']', ', ') WITHIN GROUP (order by [month_id])
					FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
					SET @pivot_part = @pivot_part + iif(@pivot_part = '', '', ', ') + @pivot_part_rus_monthes
					--Формирование итоговых полей
					SELECT @sub_total = STRING_AGG('isnull([' + @cur_rus_column_name + ' ' + [month] + '], 0) ', ' + ') WITHIN GROUP (order by [month_id])
					FROM (SELECT distinct [year_name] + ' ' + [month_name] as [month], [month_id] FROM dbo.dim_date where date_id >= @date_from AND date_id <= @date_to) as a
					SET @total = @total + ', iif((' + @sub_total + ') = 0, null, (' + @sub_total + ')) as [Итог ' + @cur_rus_column_name + '] '
					--Формирование тела подзапроса для PIVOT
					SET @sub_select = @sub_select 
									 + iif(@sub_select = '', '', ' UNION ALL ')
									 + 'SELECT '
									 + @necessary_columns
									 + ', [' + @cur_eng_column_name + '] as [val],'
									 + ' ''' + @cur_rus_column_name + '''' + ' + '' '' + convert(nvarchar, [sales_dim_date_year_id]) + '' '' + convert(nvarchar, [sales_dim_date_month_name]) as [col_name] '
									 + 'FROM [dbo].[v_auto_fct_report_sales] 
									 WHERE [volume_agreement_id] = ' + convert(nvarchar, @volume_agreement_id) +'
										AND date_id >= ' + convert(nvarchar, @date_from) + '
										AND date_id <= ' + convert(nvarchar, @date_to) + ' 
										'					
					FETCH NEXT FROM dynamic_cursor INTO @cur_eng_column_name, @cur_rus_column_name
				END
				CLOSE dynamic_cursor
				DEALLOCATE dynamic_cursor

				SET @SQL = ('SELECT *'
					 + @total + '
					 FROM (
					' + @sub_select + ') as r
					PIVOT (SUM([val])
					FOR [col_name]
					IN (' + @pivot_part + ')) as pvt')
				EXEC sp_executesql @SQL
			END
		END
	END
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[p_auto_fct_report_totall]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[p_auto_fct_report_totall] AS' 
END
GO

---- ===============================================================================
---- Author:		 М.С.
---- Create date:   2019-01-11
---- Description:	'Процедура вывода отчета для страницы "Свод по отчету"'
---- EXEC example:	exec [dbo].[p_auto_fct_report_totall] @volume_agreement_id = 405
---- ================================================================================

ALTER PROCEDURE [dbo].[p_auto_fct_report_totall]
 @volume_agreement_id int

as 
begin

	DECLARE @date_from int
	DECLARE @date_to int 
	DECLARE @volume_agreement_source_id nvarchar(255)
	SELECT @date_from = MAX(date_from) FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = @volume_agreement_id
	SELECT @date_to = MAX(date_to) FROM [dbo].[auto_volume_agreements_settings] WHERE volume_agreement_id = @volume_agreement_id
	SELECT @volume_agreement_source_id =  volume_agreement_source_id  from [dbo].[dim_volume_agreements] where volume_agreement_id = @volume_agreement_id

	IF (not exists(SELECT TOP 1 1 
					FROM [dbo].[fct_report_purchases] 
					WHERE volume_agreement_id = @volume_agreement_id
						AND date_id >= @date_from
						AND date_id <= @date_to)
		and
		not exists(SELECT TOP 1 1 
					FROM [dbo].[fct_report_sales] 
					WHERE volume_agreement_id = @volume_agreement_id
						AND date_id >= @date_from
						AND date_id <= @date_to)
		)

	BEGIN
		--Если в ХД нет данных по введенному ОС
		SELECT cast('Нет данных в ХД по ОС = ' as nvarchar) + @volume_agreement_source_id as [ошибка]
	END
	ELSE BEGIN
		select
			t.[Год],
			t.[Год-месяц],
			t.[Код ОС],
			t.[Источник данных],
		
			case when sum(t.[Закупки руб без НДС]) = 0 then null else sum(t.[Закупки руб без НДС]) end  as [Закупки руб без НДС],
			case when sum(t.[Закупки руб с НДС]) = 0 then null else sum(t.[Закупки руб с НДС]) end  as [Закупки руб с НДС],
			case when sum(t.[Закупки сумма руб CIP]) = 0 then null else sum(t.[Закупки сумма руб CIP]) end  as [Закупки сумма руб CIP],
			case when sum(t.[Закупки шт]) = 0 then null else sum(t.[Закупки шт]) end as [Закупки шт],

			case when sum(t.[Продажи руб без НДС]) = 0 then null else sum(t.[Продажи руб без НДС]) end  as [Продажи руб без НДС],
			case when sum(t.[Продажи руб с НДС]) = 0 then null else sum(t.[Продажи руб с НДС]) end as [Продажи руб с НДС],
			case when sum(t.[Продажи сумма руб CIP]) = 0 then null else sum(t.[Продажи сумма руб CIP]) end as [Продажи сумма руб CIP],
			case when sum(t.[Продажи шт]) = 0 then null else sum(t.[Продажи шт]) end as [Продажи шт]
		from
		(
			select cast(d.[year_name] as nvarchar) as [Год],
				cast(d.[month_full_name] as nvarchar) as [Год-месяц],
				va.[volume_agreement_source_id] as [Код ОС],
				s.[source] as [Источник данных],
				sum(r.[purch_net]) as [Закупки руб без НДС],
				sum(r.[purch_grs]) as [Закупки руб с НДС],
				sum(r.[purch_cip]) as [Закупки сумма руб CIP],
				sum(r.[qty]) as [Закупки шт],

				0 as [Продажи руб без НДС],
				0 as [Продажи руб с НДС],
				0 as [Продажи сумма руб CIP],
				0 as [Продажи шт]
			FROM [dbo].[fct_report_purchases] as r
			join [dbo].[dim_sources] as s
				on s.source_id = r.source_id
			join [dbo].[dim_date] as d
				on d.date_id = r.date_id
			join [dbo].[v_olap_dim_volume_agreements] as va
				on va.volume_agreement_id = r.volume_agreement_id
			WHERE r.volume_agreement_id = @volume_agreement_id
				AND r.date_id >= @date_from
				AND r.date_id <= @date_to
			group by d.[year_name],
				d.[month_full_name],
				va.[volume_agreement_source_id],
				s.[source]

			union all

			select cast(d.[year_name] as nvarchar) as [Год],
				cast(d.[month_full_name] as nvarchar) as [Год-месяц],
				va.[volume_agreement_source_id] as [Код ОС],
				ss.[source] as [Источник данных],
				0 as [Закупки руб без НДС],
				0 as [Закупки руб с НДС],
				0 as [Закупки сумма руб CIP],
				0 as [Закупки шт],

				sum(s.sale_net) as [Продажи руб без НДС],
				sum(s.sale_grs) as [Продажи руб с НДС],
				sum(s.sale_cip) as [Продажи сумма руб CIP],
				sum(s.qty) as [Продажи шт]
			FROM [dbo].[fct_report_sales] as s
			join [dbo].[dim_sources] as ss
				on ss.source_id = s.source_id
			join [dbo].[dim_date] as d
				on d.date_id = s.date_id
			join [dbo].[v_olap_dim_volume_agreements] as va
				on va.volume_agreement_id = s.volume_agreement_id
			WHERE s.volume_agreement_id = @volume_agreement_id
				AND s.date_id >= @date_from
				AND s.date_id <= @date_to
			group by d.[year_name],
				d.[month_full_name],
				va.[volume_agreement_source_id],
				ss.[source]
		) as t
		group by t.[Год],
			t.[Год-месяц],
			t.[Код ОС],
			t.[Источник данных]
	
	end
end
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[map].[fill_apt_id]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [map].[fill_apt_id] AS' 
END
GO

-- процедура заполнения таблицы
ALTER procedure [map].[fill_apt_id]
AS
BEGIN
	
	TRUNCATE table [map].[change_apt_id]
	
	INSERT INTO [map].[change_apt_id]
										([apt_id_sourcedwh],
										[apt_id_betadwh])
	VALUES(0,0)
	
	INSERT INTO [map].[change_apt_id]
										([apt_id_sourcedwh],
										[apt_id_betadwh])
	VALUES(-1,-1)

	INSERT INTO [map].[change_apt_id]
										([apt_id_sourcedwh],
										[apt_id_betadwh])
	SELECT [dwh].[apt_id] as [apt_id_sourcedwh] 
	  ,[newsource].[PHARM_ID] as [apt_id_betadwh]
	FROM [dbo].[dim_apt] [dwh]
	LEFT JOIN [BETADWH].[source_DWH].[DWH].[UV_DIM_PHARMACIES] [newsource]
	ON [dwh].[apt_id] = [newsource].[PHARM_SOURCE_ID]
	WHERE [dwh].[apt_id] <> 0
	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[map].[fill_good_id]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [map].[fill_good_id] AS' 
END
GO

ALTER procedure [map].[fill_good_id]
AS
BEGIN
	
	TRUNCATE table [map].[change_good_id]
	
	INSERT INTO [map].[change_good_id]
										([good_id_sourcedwh],
										[good_id_betadwh])
	VALUES(0,0)

	INSERT INTO [map].[change_good_id]
										([good_id_sourcedwh],
										[good_id_betadwh])
	VALUES(-1,-1)
	
	INSERT INTO [map].[change_good_id]
										([good_id_sourcedwh],
										[good_id_betadwh])
	SELECT [dwh].[good_id] as [good_id_sourcedwh]    
			,[newsource].[ID] as [good_id_betadwh]
	FROM [dbo].[dim_good] [dwh]
	LEFT JOIN [BETADWH].[source_DWH].[DWH].[DIM_PRODUCTS] [newsource]
	ON [dwh].[good_id] = [newsource].[SOURCE_ID] 
	WHERE [dwh].[good_id]  <> 0

	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[map].[fill_supplier_id]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [map].[fill_supplier_id] AS' 
END
GO

ALTER procedure [map].[fill_supplier_id]
AS
BEGIN
	
	TRUNCATE table [map].[change_supplier_id]
	
	INSERT INTO [map].[change_supplier_id]
										([supplier_id_sourcedwh],
										[supplier_id_betadwh])
	VALUES(0,0)

	INSERT INTO [map].[change_supplier_id]
										([supplier_id_sourcedwh],
										[supplier_id_betadwh])
	VALUES(-1,-1)
	
	INSERT INTO [map].[change_supplier_id]
										([supplier_id_sourcedwh],
										[supplier_id_betadwh])

	SELECT [dwh].[supplier_id] as [supplier_id_sourcedwh]
		   ,CASE WHEN [newsource].[ID] IS NOT NULL THEN [newsource].[ID]
				 WHEN [view].[BETA_ID] IS NOT NULL THEN	[view].[BETA_ID]
				 ELSE NULL END as [supplier_id_betadwh]
		  --,[newsource].[ID]
		  --,[view].[BETA_ID]
	FROM [dbo].[dim_supplier] [dwh]
	LEFT JOIN [BETADWH].[source_DWH].[DWH].[DIM_SUPPLIERS] [newsource] 
		ON [dwh].[supplier_id] = [newsource].[SOURCE_ID]
	LEFT JOIN [BETADWH].[source_DWH].[TMP].[UV_DIM_SUPPLIERS_MATCHING] [view]
		ON [dwh].[supplier_id] = [view].[ALPHA_ID]
 	WHERE [dwh].[supplier_id] <> 0
	--AND [newsource].[ID] IS NOT NULL
	--	  AND [view].[BETA_ID] IS NOT NULL

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[fill_rebuild_indexes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [oth].[fill_rebuild_indexes] AS' 
END
GO




ALTER procedure [oth].[fill_rebuild_indexes]
-- =============================================
-- Author:		
-- Create date: 2018-09-20
-- Description:	Перестройка индексов
-- =============================================
as
begin

	DECLARE @name varchar(max) = '[oth].[fill_rebuild_indexes]'
	DECLARE @description nvarchar(500) = 'Ежедневное обновление индексов с фрагментацией более 10%'
	DECLARE @input_parametrs nvarchar(500) = ''
	
	begin try
	--------------------------------------------------------------------------------------------------
	--  Запускаем процедуру логирования
	--------------------------------------------------------------------------------------------------
		exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs
	--------------------------------------------------------------------------------------------------


		DECLARE @db_name varchar(50) = N'SuppliersAnalytics', 
				@table_name varchar(250) = N'db_name.dbo.tbl_name',
				@cmd varchar(max) ='',
				@count int = 1
		------------------------------------------------------------
		--Получаем список индексов, фрагментированных более 10%
		------------------------------------------------------------
			SELECT  IndStat.database_id, 
							IndStat.object_id, 
							QUOTENAME(s.name) + '.' + QUOTENAME(o.name) AS [object_name], 
							IndStat.index_id, 
							QUOTENAME(i.name) AS index_name,
							rank() over(order by s.name, o.name, i.name) as rnk
			into #index_to_rebuild
			FROM sys.dm_db_index_physical_stats
				(DB_ID(@db_name), OBJECT_ID(@table_name), NULL, NULL , 'LIMITED') AS IndStat
					INNER JOIN sys.objects AS o ON (IndStat.object_id = o.object_id)
					INNER JOIN sys.schemas AS s ON s.schema_id = o.schema_id
					INNER JOIN sys.indexes i ON (i.object_id = IndStat.object_id AND i.index_id = IndStat.index_id)
			WHERE IndStat.avg_fragmentation_in_percent > 10 AND IndStat.index_id > 0

		------------------------------------------------------------
		--В цикле делаем для каждого из индексов Rebuild
		------------------------------------------------------------
			while @count <= (select max(rnk) from #index_to_rebuild)
			begin
				set @cmd = 
						'
						ALTER INDEX '+(select [index_name] from #index_to_rebuild where rnk = @count)+' ON '+(select [object_name] from #index_to_rebuild where rnk = @count)+' 
						REBUILD PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
						'
				exec (@cmd)
				print @cmd
				print getdate()
				set @count = @count + 1
			end

		------------------------------------------------------------
		--Очищаем временные таблицы
		------------------------------------------------------------
			drop table #index_to_rebuild


		exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs

		end try      
	begin catch
		exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null, @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs
	end catch 

end

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[fill_sup_log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [oth].[fill_sup_log] AS' 
END
GO
ALTER procedure [oth].[fill_sup_log]
-- =============================================
-- Author:		
-- Create date: 2018-09-20
-- Description:	Логирование
-- =============================================

	@name varchar(255) = null,			--obj_name
	@state_name varchar(255) = null,	--start, finish, error
	@row_count int = null,
	@task_id int = null,
	@sp_id int = null,
	@description nvarchar(500) = null,
	@input_parametrs nvarchar(500) = null
as
begin
	
	--declare @date_start datetime
	--set @date_start = 
	--				(select max(date_time) 
	--				from lasmart_t_sup_log 
	--				where state_name = 'start' 
	--					and name = @name 
	--					and sp_id = @sp_id)

	insert into [oth].[sup_log]
	(
		date_time
		,name
		,[system_user]
		,state_name
		,row_count
		,err_number
		,err_severity
		,err_state
		,err_object
		,err_line
		,err_message
		,sp_id
		,[duration]
		,[duration_ord]
		,[description]
        ,[input_parametrs]
	)
	select 
		getdate()
		,@name
		,system_user
		,@state_name
		,case @state_name when 'finish' then @@rowcount when 'error' then -1 else null end
		,error_number()
		,error_severity()
		,error_state()
		,error_procedure()
		,error_line()
		,error_message()
		,@sp_id
		,case 
			when @state_name = 'start' then ''
			else 				 
				 cast(cast((DATEDIFF(ss,(select max(date_time) 
										from [oth].[sup_log] 
										where state_name = 'start' 
											and name = @name 
											and sp_id = @sp_id),getdate()))/3600 as int) as varchar(3)) 
				  +':'+ right('0'+ cast(cast(((DATEDIFF(ss,(select max(date_time) 
															from [oth].[sup_log] 
															where state_name = 'start' 
																and name = @name 
																and sp_id = @sp_id),getdate()))%3600)/60 as int) as varchar(2)),2) 
				  +':'+ right('0'+ cast(((DATEDIFF(ss,(select max(date_time) 
														from [oth].[sup_log] 
														where state_name = 'start' 
															and name = @name 
															and sp_id = @sp_id),getdate()))%3600)%60 as varchar(2)),2) +' (hh:mm:ss)'
		end
		,case 
			when @state_name = 'start' then 0
			else 				 
				 DATEDIFF(ss,(select max(date_time) 
								from [oth].[sup_log] 
								where state_name = 'start' 
									and name = @name 
									and sp_id = @sp_id),getdate())
		end
		,@description
		,@input_parametrs
	WAITFOR DELAY '00:00:00.100'


end


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[p_check_message]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [oth].[p_check_message] AS' 
END
GO
-- =============================================
-- Author:		Shemetov I.V.
-- Create date: 2019-03-14
-- Description:	Отправка письма со счетчиком ошибок
-- Update Ильин В.А. 06/02/2020 Добавление результатов работы пакета процессирования 
-- Update Ильин В.А. 23/03/2020 Выборка последних завершенных пакетов 
/* 
exec [oth].[p_check_message] 
	@etl_system_user = N'user', 
	@ssis_package_names = 'Process SSAS WithLogs.dtsx', 
	@job_id = '1852AD75-DCE6-4A83-A108-E3396FECD0AC', 
	@mail_profile_name = N'acc@mail.ru', 
	@mail_subject = N'Обновление BI Lasmart SuppliersAnalytics АСНА', 
	@mail_recipients = N'user@mail.ru;'
*/
-- =============================================
ALTER PROCEDURE [oth].[p_check_message]
	@etl_system_user nvarchar(128),--Учетная запись пользователя, из под которого вызываются процедуры регламентного обновления ХД
	@ssis_package_names nvarchar(128),--Наименования пакетов, по которым требуется осуществлять проверку лого. ЧЕРЕЗ ЗАПЯТУЮ
	@job_id uniqueidentifier,--Идентификатор задания (Job) регламентного обновления
	@mail_profile_name nvarchar(128),--Наименование профиля компонента Database Mail для отправки сообщений
	@mail_subject nvarchar(255),--Тема письма
	@mail_recipients nvarchar(max)--Получатели письма
AS
BEGIN
	
	SET NOCOUNT ON;

    declare @body nvarchar(MAX)
	declare @error_count int
	declare @importance varchar(6) = 'Normal'
	declare @count_errors int = 0  -- 06/02/2020: количество ошибок пакета процессирования
	declare @count_warnings int = 0  -- 06/02/2020: количество предупреждений пакета процессирования 

	SET @body =
			N'<html>
			<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
			<title></title>
			</head>
			<body style="margin: 0px; padding: 0px;"> 
				<table border="0" style="margin: 0px auto; max-width: 800px; padding: 70px 30px 50px 30px; background-color: white; ">
				<tr><td><table border="0">
					<tr><td><img src="http://Lasmart.ru/theme/Lasmart/img/logo.jpg" width="153" height="58" style="margin: 7px 30px 30px 0;"></td>
					<td><h1><font face="Cambria" color="#383484" size="4">Отчет о проверке корректности<br />обработки аналитики от ' + CONVERT(NVARCHAR(10),GETDATE(),120) + '</font></h1></td></tr>
				</table>
			'

	--Проверка ETL
	BEGIN		
		--  06/02/2020: в заголовок добавлен @mail_subject
		set @body = @body + N'<br><span><font face="Calibri" color="#000000" size="3" style="font-weight: normal;">'+@mail_subject+' выполнено:<span style="text-decoration: underline; "></span><br/>' 
						
		select @error_count = isnull(count(*),0)
		from [oth].[sup_log]
		where [state_name] = 'error'
		and [system_user] = @etl_system_user
		and [date_time] > = cast(GETDATE() as date)

		if @error_count = 0
		begin 
			set @body = @body + N'<br><span style="background-color: #5da946; color: white; padding: 1px 5px 1px 5px;">Ошибок в обработке данных (ETL) не возникло</span><br/>'
		end
		else 
		begin 	
			set @body = @body + N'<br><span style="background-color: #e36060; color: white; padding: 1px 5px 1px 5px;">'+ 'Ошибок обработки данных (ETL) = ' + cast(@error_count as nvarchar(255)) +'</span><br/>'
			set @importance = 'High'

			--Список ошибок
			set @body = @body + '<br><span><font face="Calibri" color="#000000" size="3" style="font-weight: normal;">Описание ошибок:<span style="text-decoration: underline; "></span><br/>'
							 
			set @body = @body +
			N'	<table border="0" bordercolor="#d18d8d" width="100%" cellpadding="0" cellspacing="0" style="font:12pt sans-serif; font-family: Calibri, Arial; border-spacing:0px;">
				<tr><th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Название процедуры</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Время запуска</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Номер ошибки</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Описание ошибки</th>			
			'+
							isnull(replace(replace(CAST(
							(SELECT 
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255),[name]) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255),convert(nvarchar(255),[date_time],20)) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255),[err_number]) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(1000),[err_message]) + N'</td>'		
							from [oth].[sup_log]
							where [state_name] = 'error'
							and [system_user] = @etl_system_user
							and [date_time] > = cast(GETDATE() as date)
							FOR XML PATH('tr'), TYPE)
							AS NVARCHAR(MAX)), '&gt;', '>'), '&lt;', '<'), N'') +
							N'</table>
			'

		end	
	
	END

	--  06/02/2020: Проверка логов пакета
	BEGIN

		-- Определяем количество предупреждений
		SELECT @count_warnings = COUNT(*)
		FROM [SSISDB].[catalog].[event_messages] msg
		WHERE [message_type] = 110
		AND [operation_id] IN (SELECT MAX(execution_id) -- !Update 23/03/2020: Выборка последних завершенных пакетов 
							   FROM [SSISDB].[catalog].[executions]
							   WHERE [end_time] > convert(date, getdate())
							   AND [package_name] IN (	SELECT value  
														FROM STRING_SPLIT(@ssis_package_names, ',')  ) 
							   GROUP BY [package_name])

		--определяем количество ошибок
		SELECT @count_errors = COUNT(*)
		FROM [SSISDB].[catalog].[event_messages] msg
		WHERE [message_type] = 120
		AND [operation_id] IN (SELECT MAX(execution_id) -- !Update 23/03/2020: Выборка последних завершенных пакетов 
							   FROM [SSISDB].[catalog].[executions]
							   WHERE [end_time] > convert(date, getdate())
							   AND [package_name] IN (	SELECT value  
														FROM STRING_SPLIT(@ssis_package_names, ',')  ) 
							   GROUP BY [package_name])
		

		--  06/02/2020: Добавляем логи в тело письма

		if @count_warnings <> 0 OR @count_errors <> 0
		begin
			if @count_warnings <> 0 
			begin
				set @body = @body + N'<br><span style="background-color: #B0A406; color: white; padding: 1px 5px 1px 5px;">В работе пакетов процессирования выявлено '+CONVERT(NVARCHAR, @count_warnings)+N' предупреждений</span><br/>'
			end
			
			if  @count_errors <> 0
			begin
				set @body = @body + N'<br><span style="background-color: #e36060; color: white; padding: 1px 5px 1px 5px;">В работе пакетов процессирования выявлено '+CONVERT(NVARCHAR, @count_errors)+N' ошибок</span><br/>'
			end

			--Список предупреждений и ошибок
			set @body = @body + '<br><span><font face="Calibri" color="#000000" size="3" style="font-weight: normal;">Описание предупреждений и ошибок пакетов процессирования:<span style="text-decoration: underline; "></span><br/>'

						set @body = @body +
			N'	<table border="0" bordercolor="#d18d8d" width="100%" cellpadding="0" cellspacing="0" style="font:12pt sans-serif; font-family: Calibri, Arial; border-spacing:0px;">
				<tr><th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Номер</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Время ошибки</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Название пакета</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Тип ошибки</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Описание ошибки</th>			
			'+
							isnull(replace(replace(CAST(
							(SELECT 
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255),ROW_NUMBER() OVER (ORDER BY [package_name], [message_time])) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255), CONVERT(datetime,[message_time]), 120) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' +  [package_name] + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' +  CASE([event_name]) WHEN 'OnWarning' THEN 'Предупреждение' WHEN 'OnError' THEN 'Ошибка' ELSE '-' END + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(1000),[message]) + N'</td>'		
							from [SSISDB].[catalog].[event_messages]
							where [message_type] IN (110, 120)
							AND [operation_id] IN (SELECT MAX(execution_id) -- !Update 23/03/2020: Выборка последних завершенных пакетов 
												   FROM [SSISDB].[catalog].[executions]
												   WHERE [end_time] > convert(date, getdate())
												   AND [package_name] IN (	SELECT value  
														FROM STRING_SPLIT(@ssis_package_names, ',')  ) 
												   GROUP BY [package_name]) 
							FOR XML PATH('tr'), TYPE)
							AS NVARCHAR(MAX)), '&gt;', '>'), '&lt;', '<'), N'') +
							N'</table>
			'	
		end

		if @count_warnings = 0 and @count_errors = 0
		begin
			set @body = @body + N'<br><span style="background-color: #5da946; color: white; padding: 1px 5px 1px 5px;">В работе пакета процессирования ошибок не возникло</span><br/>'
		end		
	END

	--Проверка Job'ов
	BEGIN
		--!!run_status!!
		--0	Failed
		--1	Succeeded
		--2	Retry (step only)
		--3	Canceled
		--4	In-progress message
		--5	Unknown		
						
		select @error_count = isnull(count(*),0)
		FROM msdb.dbo.sysjobhistory  sjh
		LEFT OUTER JOIN msdb.dbo.sysoperators so1  ON (sjh.operator_id_emailed = so1.id)
		LEFT OUTER JOIN msdb.dbo.sysoperators so2  ON (sjh.operator_id_netsent = so2.id)
		LEFT OUTER JOIN msdb.dbo.sysoperators so3  ON (sjh.operator_id_paged = so3.id),
		msdb.dbo.sysjobs_view sj
		WHERE (sj.job_id = sjh.job_id)
		and sjh.run_date = dbo.int_getdate()
		and sj.job_id = @job_id --Fill DWH and Process SSAS
		and sjh.run_status <> 1 --Только те шаги, которые завершились неудачно
		
		if @error_count = 0
		begin 
			set @body = @body + N'<br><span style="background-color: #5da946; color: white; padding: 1px 5px 1px 5px;">Ошибок в работе job-ов не возникло</span><br/>'		
		end
		else 	
		begin 			

			set @body = @body + N'<br><span style="background-color: #e36060; color: white; padding: 1px 5px 1px 5px;">'+ 'Ошибок в работе job-ов = ' + cast(@error_count as nvarchar(255)) +'</span><br/>'
			set @importance = 'High'

			--Список ошибок
			set @body = @body + '<br><span><font face="Calibri" color="#000000" size="3" style="font-weight: normal;">Описание ошибок:<span style="text-decoration: underline; "></span><br/>'
							 
			set @body = @body +
			N'	<table border="0" bordercolor="#d18d8d" width="100%" cellpadding="0" cellspacing="0" style="font:12pt sans-serif; font-family: Calibri, Arial; border-spacing:0px;">
				<tr><th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Название job-а</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Название шага</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Время запуска</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Статус ошибки</th>
				<th bgcolor="#e36060" style="padding: 5px; font-weight: normal; color: white;">Описание ошибки</th>			
			'+
							isnull(replace(replace(CAST(
							(SELECT 
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255),sj.name) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(255),sjh.step_name) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + convert(nvarchar(255),cast(cast(sjh.run_date as varchar(255)) as datetime) + 
																																	cast(STUFF(STUFF(STUFF(RIGHT('00000000' + cast(sjh.run_time * 100 AS VARCHAR(255)),8),3,0,':'),6,0,':'),9,0,'.') AS datetime),20) + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CASE 
																														WHEN sjh.run_status = 0 then N'Ошибка'
																														WHEN sjh.run_status = 2 then N'Повторный запуск'
																														WHEN sjh.run_status = 3 then N'Отмена'
																														ELSE N'Прочее'
																													END  + N'</td>'+
			N'<td bgcolor="#efefef" style="padding: 5px; text-align: center; border-bottom: 2px solid #e8e8e8;">' + CONVERT(nvarchar(1000),replace(replace(sjh.message,'<',''),'>','')) + N'</td>'		
							FROM msdb.dbo.sysjobhistory  sjh
							LEFT OUTER JOIN msdb.dbo.sysoperators so1  ON (sjh.operator_id_emailed = so1.id)
							LEFT OUTER JOIN msdb.dbo.sysoperators so2  ON (sjh.operator_id_netsent = so2.id)
							LEFT OUTER JOIN msdb.dbo.sysoperators so3  ON (sjh.operator_id_paged = so3.id),
							msdb.dbo.sysjobs_view sj
							WHERE (sj.job_id = sjh.job_id)
							and sjh.run_date = dbo.int_getdate()
							and sj.job_id = @job_id --Fill DWH and Process SSAS
							and sjh.run_status <> 1 --Только те шаги, которые завершились не удачно
							order by sj.job_id,sjh.step_id,sjh.run_time
							FOR XML PATH('tr'), TYPE)
							AS NVARCHAR(MAX)), '&gt;', '>'), '&lt;', '<'), N'') +
							N'</table>
			'
		end
	END

	SET @body = @body +
		N'<hr color="#e9e9e9" style="margin-top: 40px;"/>
		</td></tr></table>
		</body>
		</html>'

	--select @body
	--  06/02/2020: добавлены @mail_subject, @mail_profile_name,  @mail_recipients
	EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = @mail_profile_name,
		--@recipients = 'shemetov@Lasmart.ru;druzhinin@Lasmart.ru;barchenkov@lasmart.ru;ilin@lasmart.ru;l.prosyanikova@source.ru;m.vaindorf@source.ru',  
		--@recipients = 'druzhinin@Lasmart.ru',  
		@recipients = @mail_recipients, 
		@body = @body,  
		@subject = @mail_subject ,
		@importance = @importance,
		@body_format = 'HTML' ;	
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[oth].[p_move_file]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [oth].[p_move_file] AS' 
END
GO
-- ===============================================================================
-- Author: 
-- Create date: 2018-12-11
-- Description: Проверка наличия файла в папке и перемещение его в историческую папку
-- ================================================================================

--declare @destination_folder_final nvarchar(4000)
--EXEC oth.p_move_file @source_file = 'os.xlsx', @source_folder = 'C:\FTP\source\input\', @destination_folder = 'C:\FTP\source\hist\', @destination_folder_final = @destination_folder_final output
--select @destination_folder_final

ALTER PROCEDURE [oth].[p_move_file]
	@source_file nvarchar(4000),		
	@source_folder nvarchar(4000),		
	@destination_folder nvarchar(4000),
	@destination_folder_final nvarchar(4000) output
AS

BEGIN
	
	SET NOCOUNT ON;	
	DECLARE @name nvarchar(4000) = '[oth].[p_move_file]'
	DECLARE @description nvarchar(500) = 'Перемещение файлов'
	DECLARE @input_parametrs nvarchar(500) = '@source_file = ''' + isnull(@source_file,'') +''', @source_folder= ''' + isnull(@source_folder,'') +''', ' + '@destination_folder = ''' + isnull(@destination_folder,'') + '''' + ', @destination_folder_final = @destination_folder_final output'
	
	begin try
	--------------------------------------------------------------------------------------------------
	--  Запускаем процедуру логирования
	--------------------------------------------------------------------------------------------------
		exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
		
		declare @cmd nvarchar(4000)				

		create table #t (t1 int, t2 int, t3 int)
		set @cmd = 'exec master..xp_fileexist ''' + @source_folder + @source_file + ''''

		insert into #t
		exec (@cmd)
		/*проверим, доступен ли файл со списком ОС в папке \input\*/
		if (select top 1 isnull(t1, 0) from #t) = 1
		begin
			
			declare @date nvarchar(4000)
			set @date = replace(replace(replace(left(convert(nvarchar(4000), getdate(), 120), 16),':','')	,'-',''),' ','_')	
	
			SET @destination_folder_final = @destination_folder +@date+'\'			
		
			SET @cmd = ' if not exist  "' + @destination_folder_final + '" mkdir "' + @destination_folder_final + '" '

			/*Создаем папку в формате yyyymmdd_hhmi В исторической папке*/
			EXEC master..xp_cmdshell @cmd, no_output

			/*Перемещаем xlsx файл в историческую папку*/
			set @cmd = 'move "' + @source_folder + @source_file + '" "'+@destination_folder_final+'"'
			
			EXEC master..xp_cmdshell @cmd, no_output

		end
		exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  

		

	end try      
	begin catch
		exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end catch

	return

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_allocation_fct_source_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_allocation_fct_source_purchases] AS' 
END
GO


---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2019-04-08
---- Description:	'Заполнение таблицы фактов закуп на АСНА накладных по отчетному периоду на уровень stg'
---- EXEC example:	exec [stg].[fill_allocation_fct_source_purchases] @filepath = 'C:\allocation_20184.xlsx', @sheet = 'Закуп на АСНА'
---- ================================================================================
ALTER procedure [stg].[fill_allocation_fct_source_purchases]
	@filepath nvarchar(255)
	,@sheet nvarchar(255) = 'Закуп на АСНА'
as

DECLARE @name varchar(128) = '[stg].[fill_allocation_fct_source_purchases]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[allocation_fct_source_purchases] из allocation накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[allocation_fct_source_purchases]
	
	exec ('INSERT INTO [stg].[allocation_fct_source_purchases] (
			  [good_source_id]
			  ,[good]
			  ,[qty]
			  ,[supplier_inn]
			  ,[supplier]
			  ,[arrival_date]
			  ,[invoice_number_in]
			  ,[sub_supplier_inn]
			  ,[sub_supplier]
			  ,[delivery_date]
			  ,[invoice_number_out]
			  ,[volume_agreement_source_id]
			  ,[manufacturer]
			  ,[purch_price_net]
			  ,[is_arrival_from_source]
			  ,[is_purchase_on_source])
			SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Код ННТ]
						,[Наименование]	
						,[Приход уп#]	
						,[ИНН поставщика]	
						,[Поставщик]	
						,[Дата поставки]	
						,[Номер накладной (вх#)]	
						,[ИНН Субпоставщика]	
						,[Субпоставщик]	
						,[Дата отгрузки (исх#)]	
						,[Номер накладной (исх#)]	
						,[Код ОС]
						,[Производитель]
						,[Закупочная цена без НДС уп# по накладной]
						,[Учитывают приход от АСНА]
						,[Учитывают закупки на склад АСНА]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_dim_apt_by_volume_agreements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_dim_apt_by_volume_agreements] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение справочника "Аптеки по Объемному соглашению" на уровень stg'
----				обратите внимание, что параметр @date_to равен первому дню квартала ОС
----				@date_to равен последнему дню квартала ОС
---- EXEC example:	exec [stg].[fill_excel_dim_apt_by_volume_agreements] @filepath = 'C:\Lasmart\Имя_файла.xlsx', @sheet = 'Лист1', @date_from = '2018-07-01', @date_to = '2018-09-30'
---- ================================================================================
ALTER procedure [stg].[fill_excel_dim_apt_by_volume_agreements]
@filepath nvarchar(255) = 'C:\Lasmart\Data.xlsx'
,@sheet nvarchar(255) = '1.2.3.Аптеки по ОС'
,@date_from date
,@date_to   date	
as

DECLARE @name varchar(128) = '[stg].[fill_excel_dim_apt_by_volume_agreements]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_dim_apt_by_volume_agreements] из Excel листа 1.2.2.Аптеки по ОС'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''

DECLARE @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	
	truncate table [stg].[excel_dim_apt_by_volume_agreements]
	
	exec ('INSERT INTO [stg].[excel_dim_apt_by_volume_agreements] (
			[volume_agreement_source_id]
			,[apt]
			,[prefix]
			,[date_from]
			,[date_to] )
			SELECT distinct *, ' + @date_int_from + ', ' + @date_int_to + ' FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Код ОС],     
						[Аптека], 
						[Префикс]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_dim_distributor_limitations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_dim_distributor_limitations] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение справочника "Ограничения дистрибьюторов" на уровень stg'
----				обратите внимание, что параметр @date_to равен первому дню квартала ОС
----				@date_to равен последнему дню квартала ОС
---- EXEC example:	exec [stg].[fill_excel_dim_distributor_limitations] @filepath = 'C:\Lasmart\Имя_файла.xlsx', @sheet = 'Лист1', @date_from = '2018-07-01', @date_to = '2018-09-30'
---- ================================================================================
ALTER procedure [stg].[fill_excel_dim_distributor_limitations]
@filepath nvarchar(255) = 'C:\Lasmart\Data.xlsx'
,@sheet nvarchar(255) = '1.2.4.Огр.дистрибьюторов'
,@date_from date
,@date_to   date	
as

DECLARE @name varchar(128) = '[stg].[fill_excel_dim_distributor_limitations]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_dim_distributor_limitations] из Excel листа 1.2.4.Огр.дистрибьюторов'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''

DECLARE @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_dim_distributor_limitations]
	exec ('INSERT INTO [stg].[excel_dim_distributor_limitations] (
			[manufacturer]
			,[supplier_inn]
			,[date_from]
			,[date_to] )
	SELECT distinct *, ' + @date_int_from + ', ' + @date_int_to + ' FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Производитель],
						[ИНН Поставщика]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_dim_goods_by_volume_agreements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_dim_goods_by_volume_agreements] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение справочника "Товары по объемному соглашению" на уровень stg'
----				обратите внимание, что параметр @date_to равен первому дню квартала ОС
----				@date_to равен последнему дню квартала ОС
---- EXEC example:	exec [stg].[fill_excel_dim_goods_by_volume_agreements] @filepath = 'C:\Lasmart\Имя_файла.xlsx', @sheet = 'Лист1', @date_from = '2018-07-01', @date_to = '2018-09-30'
---- ================================================================================
ALTER procedure [stg].[fill_excel_dim_goods_by_volume_agreements]
@filepath nvarchar(255) = 'C:\Lasmart\Data.xlsx'
,@sheet nvarchar(255) = '1.2.2.Товары по ОС'
,@date_from date
,@date_to   date	
as

DECLARE @name varchar(128) = '[stg].[fill_excel_dim_goods_by_volume_agreements]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_dim_goods_by_volume_agreements] из Excel листа 1.2.2.Товары по ОС'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''


DECLARE @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_dim_goods_by_volume_agreements]
	exec ('INSERT INTO [stg].[excel_dim_goods_by_volume_agreements] (
			  [volume_agreement_source_id]
			  ,[good_source_id]
			  ,[good]
			  ,[price_cip]
			  ,[volume_agreement_group]
			  ,[date_from]
			  ,[date_to] )
	SELECT distinct *, ' + @date_int_from + ', ' + @date_int_to + ' FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Код ОС], 
						[Код ННТ], 
						[Номенклатура], 
						[Цена (СИП)], 
						[Группа по ОС]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_dim_manufacturer_contracts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_dim_manufacturer_contracts] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение справочника "Прямые контракты" на уровень stg'
----				обратите внимание, что параметр @date_to равен первому дню квартала ОС
----				@date_to равен последнему дню квартала ОС
---- EXEC example:	exec [stg].[fill_excel_dim_manufacturer_contracts] @filepath = 'C:\Lasmart\Имя_файла.xlsx', @sheet = 'Лист1', @date_from = '2018-07-01', @date_to = '2018-09-30'
---- ================================================================================
ALTER procedure [stg].[fill_excel_dim_manufacturer_contracts]
@filepath nvarchar(255) = 'C:\Lasmart\Data.xlsx'
,@sheet nvarchar(255) = '1.2.6.Прямые контракты'
,@date_from date
,@date_to   date	
as

DECLARE @name varchar(128) = '[stg].[fill_excel_dim_manufacturer_contracts]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_dim_manufacturer_contracts] из Excel листа 1.2.6.Прямые контракты'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''

DECLARE @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_dim_manufacturer_contracts]
	exec ('INSERT INTO [stg].[excel_dim_manufacturer_contracts] (
						[manufacturer]
						,[net]
						,[date_from]
						,[date_to] )
	SELECT distinct *, ' + @date_int_from + ', ' + @date_int_to + ' FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Производитель],
						[Сеть]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_dim_supplier_replacements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_dim_supplier_replacements] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение справочника Замена поставщиков" на уровень stg'
----				обратите внимание, что параметр @date_to равен первому дню квартала ОС
----				@date_to равен последнему дню квартала ОС
---- EXEC example:	exec [stg].[fill_excel_dim_supplier_replacements] @filepath = 'C:\Lasmart\Имя_файла.xlsx', @sheet = 'Лист1', @date_from = '2018-07-01', @date_to = '2018-09-30'
---- ================================================================================
ALTER procedure [stg].[fill_excel_dim_supplier_replacements]
@filepath nvarchar(255) = 'C:\Lasmart\Data.xlsx'
,@sheet nvarchar(255) = '1.2.5.Замена поставщиков'
,@date_from date
,@date_to   date	
as

DECLARE @name varchar(128) = '[stg].[fill_excel_dim_supplier_replacements]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_dim_supplier_replacements] из Excel листа 1.2.5.Замена поставщиков'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''

DECLARE @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_dim_supplier_replacements]
	exec ('INSERT INTO [stg].[excel_dim_supplier_replacements] (
			   [manufacturer]
			  ,[initial_supplier]
			  ,[initial_supplier_INN] 
			  ,[replacement_supplier]
			  ,[replacement_supplier_INN]
			  ,[date_from]
			  ,[date_to]  )
	SELECT distinct *, ' + @date_int_from + ', ' + @date_int_to + ' FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Производитель], 
						[Исходный поставщик], 
						[Исходный_поставщик_ИНН],
						[Замена_наименование], 
						[Замена_ИНН]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_dim_volume_agreements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_dim_volume_agreements] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение справочника "Объемные соглашения" на уровень stg'
---- EXEC example:	exec [stg].[fill_excel_dim_volume_agreements] @filepath = 'C:\FTP\source\input\data\os_data_20193.xlsx', @sheet = '1.2.1.Объемные соглашения'
---- ================================================================================
ALTER procedure [stg].[fill_excel_dim_volume_agreements]
@filepath nvarchar(255) = 'C:\Lasmart\Data.xlsx'
,@sheet nvarchar(255) = '1.2.1.Объемные соглашения'
as

DECLARE @name varchar(128) = '[stg].[fill_excel_dim_volume_agreements]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_dim_volume_agreements] из Excel листа 1.2.1.Объемные соглашения'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''''

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_dim_volume_agreements]
	exec ('INSERT INTO [stg].[excel_dim_volume_agreements] (
			   [volume_agreement_source_id]
			  ,[manufacturer]
			  ,[manager_FIO]
			  ,[period]
			  ,[date_from]
			  ,[date_to]
			  ,[price_type]
			  ,[channel]
			  ,[list_type]
			  ,[is_list]
			  ,[is_purchase]
			  ,[is_arrival]
			  ,[is_all_apt]
			  ,[increase_movements]
			  ,[is_till_channel] )
	SELECT distinct * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Код ОС], 
						[Производитель], 
						[УТК], 
						[Период], 
						[Начало], 
						[Конец], 
						[Тип цен], 
						[Канал], 
						[Тип списка], 
						[Нужен список аптек], 
						[Учитывают закупки на склад АСНА], 
						[Учитывают приход от АСНА], 
						[Отчет по всем аптекам ] as [Отчет по всем аптекам], 
						[Добавить движений, дней],
						[Канал продаж "Касса"]
					FROM [' + @sheet + '$]'')')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_fct_source_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_fct_source_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-12-25
---- Description:	'Заполнение таблицы фактов закуп на АСНА накладных по отчетному периоду на уровень stg'
---- EXEC example:	exec [stg].[fill_excel_fct_source_purchases] @filepath = 'C:\FTP\source\hist\source_purchases\source_purchases_20184.xlsx', @sheet = 'Закуп на АСНА',  @date_from = '2018-04-01', @date_to = '2018-07-01'
---- ================================================================================
ALTER procedure [stg].[fill_excel_fct_source_purchases]
	@filepath nvarchar(255) = 'C:\Lasmart\source_purchases_20184.xlsx'
	,@sheet nvarchar(255) = 'Закуп на АСНА'
	,@date_from date
	,@date_to date
as

DECLARE @name varchar(128) = '[stg].[fill_excel_fct_source_purchases]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_fct_source_purchases] из Excel накладных закуп на АСНА'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''
DECLARE @date_int_from as int set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_fct_source_purchases]
	
	exec ('INSERT INTO [stg].[excel_fct_source_purchases] (
			  [good_source_id]
			  ,[good]
			  ,[qty]
			  ,[supplier_inn]
			  ,[supplier]
			  ,[arrival_date]
			  ,[invoice_number_in]
			  ,[sub_supplier_inn]
			  ,[sub_supplier]
			  ,[delivery_date]
			  ,[invoice_number_out]
			  ,[volume_agreement_source_id]
			  ,[date_from]
			  ,[date_to] )
			SELECT [Код ННТ]
						,[Наименование]	
						,[Приход уп#]	
						,[ИНН поставщика]	
						,[Поставщик]	
						,[Дата поставки]
						,[Номер накладной (вх#)]	
						,[ИНН Субпоставщика]	
						,[Субпоставщик]	
						,[Дата отгрузки (исх#)]
						,[Номер накладной (исх#)]	
						,[Код ОС] 
						,' + @date_int_from + ', ' + @date_int_to + ' FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=NO;
					IMEX=1;'',
					''SELECT 
						F1 as [№ стр]
						,F2 as [Код ННТ]
						,F3 as [Наименование]	
						,F4 as [Приход уп#]	
						,F5 as [ИНН поставщика]	
						,F6 as [Поставщик]	
						,F7 as [Дата поставки]	
						,F8 as [Номер накладной (вх#)]	
						,F9 as [ИНН Субпоставщика]	
						,F10 as [Субпоставщик]	
						,F11 as [Дата отгрузки (исх#)]	
						,F12 as [Номер накладной (исх#)]	
						,F13 as [Код ОС]
					FROM [' + @sheet + '$A1:Z]'')
			WHERE [Наименование] != ''Наименование'' ')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_fct_partner_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_fct_partner_purchases] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Закупок Партнеров на уровень stg'
---- EXEC example:	exec [stg].[fill_excel_fct_partner_purchases] @filepath = 'C:\FTP\source\input\data\Имя_файла.xlsx', @date_from = '2018-08-01', @date_to = '2018-09-01'
---- UPD:			2020-01-10 Добавлено считывание данных с нескольких листов, имена листов определяются динамически
---- UPD: Ильин В.А.2020-01-30 Добавлена проверка на существование LINKED SERVER перед созданием
---- ================================================================================
ALTER procedure [stg].[fill_excel_fct_partner_purchases]
	@filepath nvarchar(255) = 'C:\Lasmart\data_fact.xlsx'
	,@date_from date
	,@date_to date
as

DECLARE @name varchar(128) = '[stg].[fill_excel_fct_partner_purchases]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_fct_partner_purchases] из Excel файла всех листов'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''
DECLARE @date_int_from as int set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)
DECLARE @sheet nvarchar(255)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_fct_partner_purchases]
	
	-- UPD 2020-01-30 проверка на существование LINKED SERVER перед созданием
	IF EXISTS(SELECT * FROM sys.servers WHERE name = 'Excel_partners')
	EXEC master.sys.sp_dropserver 'Excel_partners','droplogins'  
	
	--получение имен листов
	EXEC sp_addlinkedserver 'Excel_partners', '',
		'Microsoft.ACE.OLEDB.12.0',
		@filepath,
		NULL,
		'Excel 8.0'
	EXEC sp_addlinkedsrvlogin 'Excel_partners', 'false'
	DECLARE @T Table (TABLE_CAT VARCHAR(128),TABLE_SCHEM VARCHAR(128),TABLE_NAME VARCHAR(128),TABLE_TYPE VARCHAR(128),REMARKS VARCHAR(128))
	INSERT @T EXECUTE SP_TABLES_EX 'Excel_partners'
	EXEC sp_dropserver 'Excel_partners', 'droplogins'
		
	DECLARE @cursor cursor
	SET @cursor = CURSOR SCROLL
	FOR SELECT replace(replace(TABLE_NAME,'#','.'),'''','') 
	FROM @T
	WHERE TABLE_NAME not like '%filter%'
	OPEN @cursor	 
	FETCH NEXT FROM @cursor INTO @Sheet

	--Для каждого листа происходит загрузка данных
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec ('INSERT INTO [stg].[excel_fct_partner_purchases] (
			  [apt]
			  ,[apt_source_id]
			  ,[address]
			  ,[inn]
			  ,[legal_person]
			  ,[net]
			  ,[region]
			  ,[supplier]
			  ,[supplier_inn]
			  ,[good]
			  ,[good_source_id]
			  ,[year]
			  ,[month]
			  ,[purch_grs]
			  ,[purch_net]
			  ,[qty] )
			SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Аптека], 
						[Внешний код], 
						[Фактический адрес], 
						[ИНН], 
						[Юр#лицо], 
						[Сеть], 
						[Регион], 
						[Поставщик], 
						[ИНН поставщика], 
						[Товар], 
						[Код товара (ННТ)], 
						[1#Год], 
						[4#Месяц], 
						[Сумма приход (закупочная цена) с НДС, руб#], 
						[Сумма приход (закупочная цена) без НДС, руб#], 
						[Количество приход, уп]
					FROM [' + @sheet + 'A2:Z]'')					
					where convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 >= ' + @date_int_from +'
					and convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 < ' + @date_int_to +'')
		FETCH NEXT FROM @cursor INTO @Sheet
	END
	CLOSE @cursor

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	-- UPD 2020-01-30 проверка на существование LINKED SERVER 
	IF EXISTS(SELECT * FROM sys.servers WHERE name = 'Excel_partners')
	EXEC master.sys.sp_dropserver 'Excel_partners','droplogins' 
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_fct_partner_purchases_invoice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_fct_partner_purchases_invoice] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Закупок Партнеров на уровень stg'
---- EXEC example:	exec [stg].[fill_excel_fct_partner_purchases_invoice] @filepath = 'C:\FTP\source\input\data\Имя_файла.xlsx', @sheet = '1.3.1.Партнеры', @date_from = '2018-08-01', @date_to = '2018-09-01'
---- ================================================================================
ALTER procedure [stg].[fill_excel_fct_partner_purchases_invoice]
	@filepath nvarchar(255) 
	,@sheet nvarchar(255) = '1.3.1.Партнеры'
	,@date_from date
	,@date_to date
as

DECLARE @name varchar(128) = '[stg].[fill_excel_fct_partner_purchases_invoice]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_fct_partner_purchases] из Excel листа 1.3.1.Партнеры'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''
DECLARE @date_int_from as int set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_fct_partner_purchases]
	exec ('INSERT INTO [stg].[excel_fct_partner_purchases] (
			  [apt]
			  ,[apt_source_id]
			  ,[address]
			  ,[inn]
			  ,[legal_person]
			  ,[net]
			  ,[region]
			  ,[supplier]
			  ,[supplier_inn]
			  ,[good]
			  ,[good_source_id]
			  ,[invoice_number]
			  ,[invoice_date]
			  ,[year]
			  ,[month]
			  ,[purch_grs]
			  ,[purch_net]
			  ,[qty] )
			SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Аптека], 
						[Внешний код], 
						[Фактический адрес], 
						[ИНН], 
						[Юр#лицо], 
						[Сеть], 
						[Регион], 
						[Поставщик], 
						[ИНН поставщика], 
						[Товар], 
						[Код товара (ННТ)], 
						[Номер Накладной],
						[Дата Накладной],
						[1#Год], 
						[4#Месяц], 
						[Сумма приход (закупочная цена) с НДС, руб#], 
						[Сумма приход (закупочная цена) без НДС, руб#], 
						[Количество приход, уп]
					FROM [' + @sheet + '$A2:Z]'')					
					where convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 >= ' + @date_int_from +'
					and convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 < ' + @date_int_to +'')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_fct_partner_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_fct_partner_sales] AS' 
END
GO
---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Продаж Партнеров на уровень stg'
---- EXEC example:	exec [stg].[fill_excel_fct_partner_sales] @filepath = 'C:\FTP\source\input\data\Имя_файла.xlsx', @date_from = '2018-08-01', @date_to = '2018-09-01'
---- UPD:			2020-01-10 Добавлено считывание данных с нескольких листов, имена листов определяются динамически
---- UPD: Ильин В.А.2020-01-30 Добавлена проверка на существование LINKED SERVER перед созданием
---- ================================================================================
ALTER procedure [stg].[fill_excel_fct_partner_sales]
	@filepath nvarchar(255) = 'C:\Lasmart\data_fact.xlsx'
	,@date_from date
	,@date_to date
as

DECLARE @name varchar(128) = '[stg].[fill_excel_fct_partner_sales]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_fct_partner_sales] из Excel файла всех листов'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''
DECLARE @date_int_from as int set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)
DECLARE @sheet nvarchar(255)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_fct_partner_sales]
	-- UPD 2020-01-30 проверка на существование LINKED SERVER перед созданием
	IF EXISTS(SELECT * FROM sys.servers WHERE name = 'Excel_partners')
	EXEC master.sys.sp_dropserver 'Excel_partners','droplogins'  
	--получение имен листов
	EXEC sp_addlinkedserver 'Excel_partners', '',
		'Microsoft.ACE.OLEDB.12.0',
		@filepath,
		NULL,
		'Excel 8.0'
	EXEC sp_addlinkedsrvlogin 'Excel_partners', 'false'
	DECLARE @T Table (TABLE_CAT VARCHAR(128),TABLE_SCHEM VARCHAR(128),TABLE_NAME VARCHAR(128),TABLE_TYPE VARCHAR(128),REMARKS VARCHAR(128))
	INSERT @T EXECUTE SP_TABLES_EX 'Excel_partners'
	EXEC sp_dropserver 'Excel_partners', 'droplogins'
		
	DECLARE @cursor cursor
	SET @cursor = CURSOR SCROLL
	FOR SELECT replace(replace(TABLE_NAME,'#','.'),'''','') 
	FROM @T
	WHERE TABLE_NAME not like '%filter%'
	OPEN @cursor	 
	FETCH NEXT FROM @cursor INTO @Sheet

	--Для каждого листа происходит загрузка данных
	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec ('INSERT INTO [stg].[excel_fct_partner_sales] (
				  [apt]
				  ,[apt_source_id]
				  ,[address]
				  ,[inn]
				  ,[legal_person]
				  ,[net]
				  ,[region]
				  ,[good]
				  ,[good_source_id]
				  ,[year]
				  ,[month]
				  ,[sale_grs]
				  ,[sale_net]
				  ,[qty] )
				SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
						''Excel 12.0;Database=' + @filepath +';
						HDR=YES;
						IMEX=1;'',
						''SELECT 
							[Аптека], 
							[Внешний код], 
							[Фактический адрес], 
							[ИНН], 
							[Юр#лицо], 
							[Сеть], 
							[Регион], 
							[Товар], 
							[Код товара (ННТ)], 
							[1#Год], 
							[4#Месяц], 
							[Выручка  (закупочная цена) с НДС, руб#], 
							[Выручка  (закупочная цена) без НДС, руб#],
							[Количество продано, уп#]
						FROM [' + @sheet + 'R2:AE]'')
						where convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 >= ' + @date_int_from +'
						and convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 < ' + @date_int_to +'')
		FETCH NEXT FROM @cursor INTO @Sheet
	END
	CLOSE @cursor

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	-- UPD 2020-01-30 проверка на существование LINKED SERVER 
	IF EXISTS(SELECT * FROM sys.servers WHERE name = 'Excel_partners')
	EXEC master.sys.sp_dropserver 'Excel_partners','droplogins' 
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_excel_fct_statistician_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_excel_fct_statistician_purchases] AS' 
END
GO

---- ===============================================================================
---- Author:		Shemetov I.V.
---- Create date:   2018-09-27
---- Description:	'Заполнение таблицы фактов Закупок Статистов на уровень stg'
---- EXEC example:	exec [stg].[fill_excel_fct_statistician_purchases] @filepath = 'C:\Lasmart\Имя_файла.xlsx', @sheet = '1.3.2.Статисты', @date_from = '2018-08-01', @date_to = '2018-09-01'
---- ================================================================================
ALTER procedure [stg].[fill_excel_fct_statistician_purchases]
@filepath nvarchar(255) = 'C:\Lasmart\data_fact.xlsx'
,@sheet nvarchar(255) = '1.3.2.Статисты'
,@date_from date
,@date_to date
as

DECLARE @name varchar(128) = '[stg].[fill_excel_fct_statistician_purchases]'
DECLARE @description nvarchar(128) = 'Заполнение таблицы [stg].[excel_fct_statistician_purchases] из Excel листа 1.3.2.Статисты'
DECLARE @input_parametrs nvarchar(128) = '@filepath = ''' + isnull(@filepath,'') + ''''  + ', @sheet = ''' + isnull(@sheet,'') +  ''', @date_from = ''' + convert(varchar(16), @date_from) + ''', @date_to = ''' + convert(varchar(16), @date_to) + ''''
DECLARE @date_int_from as int set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
DECLARE @date_int_to   as int set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

BEGIN TRY 
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	truncate table [stg].[excel_fct_statistician_purchases]
	exec ('INSERT INTO [stg].[excel_fct_statistician_purchases] (
			  [apt]
			  ,[apt_source_id]
			  ,[address]
			  ,[inn]
			  ,[legal_person]
			  ,[net]
			  ,[region]
			  ,[supplier]
			  ,[supplier_inn]
			  ,[good]
			  ,[good_source_id]
			  ,[year]
			  ,[month]
			  ,[purch_grs]
			  ,[purch_net]
			  ,[qty] )
			SELECT * FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',
					''Excel 12.0;Database=' + @filepath +';
					HDR=YES;
					IMEX=1;'',
					''SELECT 
						[Аптека], 
						[Внешний код], 
						[Фактический адрес], 
						[ИНН], 
						[Юр#лицо], 
						[Сеть], 
						[Регион], 
						[Поставщик], 
						[ИНН поставщика], 
						[Товар], 
						[Код товара (ННТ)], 
						[1#Год], 
						[4#Месяц], 
						[Сумма приход (закупочная цена) с НДС, руб#], 
						[Сумма приход (закупочная цена) без НДС, руб#], 
						[Количество приход, уп]
					FROM [' + @sheet + '$A2:Z]'')
					where convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 >= ' + @date_int_from +'
					and convert(int, [1#Год]) * 10000 + convert(int, [4#Месяц]) * 100 + 1 < ' + @date_int_to +'')

	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END TRY
BEGIN CATCH
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
END CATCH
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_fct_rests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_fct_rests] AS' 
END
GO

-- ==========================================================================================
-- Author:		Shemetov I.V.
-- Create date: 2018-09-20
-- Description:	Заполнение фактов Остатки за указанный период с ичточника
-- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
-- ==========================================================================================
-- exec [stg].[fill_fct_rests] @date_from = '2019-01-01', @date_to = '2019-12-31'
ALTER PROCEDURE [stg].[fill_fct_rests]
	@date_from date,
	@date_to date
AS
BEGIN	
	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[stg].[fill_fct_rests]'
	DECLARE @description nvarchar(500) = 'Заполнение фактов Остатки за указанный период с иcточника'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')	
	begin try
	-- Запускаем процедуру логирования
    exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  

	Declare @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
	Declare @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)

	Set @sql=
	'
		select
				T.[DATE_OPER_ID] as [date_source_id]
			   ,T.[PHARMACY_LINK_ID] as [apt_source_id]
			   ,T.[PRODUCT_ID] as [good_source_id]
			   ,T.[QUANTITY] as [quantity]
		from [source_DWH].[RPT].[FACT_YEAR_MONTH_RESTS] as T (nolock)
	    where T.[DATE_OPER_ID] >= ' + cast(@date_int_from as varchar) +
        ' and T.[DATE_OPER_ID] <  ' + cast(@date_int_to   as varchar)
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'

	truncate table [stg].[fct_rests]
	insert into [stg].[fct_rests]
			  (
				   [date_source_id]
				  ,[apt_source_id]
				  ,[good_source_id]
				  ,[quantity]
			  )	
    exec (@sql_openquery)

    -- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end try      
	begin catch
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	return
	end catch 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_fct_sales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_fct_sales] AS' 
END
GO

-- ==========================================================================================
-- Author:		Shemetov I.V.
-- Create date: 2018-09-20
-- Description:	Заполнение фактов Продаж за указанный период с иcточника
-- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
-- ==========================================================================================
-- exec [stg].[fill_fct_sales] @date_from = '2019-01-01', @date_to = '2019-12-31'
ALTER PROCEDURE [stg].[fill_fct_sales]
	@date_from date,
	@date_to date
AS
BEGIN	
	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[stg].[fill_fct_sales]'
	DECLARE @description nvarchar(500) = 'Заполнение фактов Продаж за указанный период с иcточника'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')	
	begin try
	-- Запускаем процедуру логирования
    exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  


	Declare @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
	Declare @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'
		select
			  T.[DATE_OPER_ID] as [date_source_id]
		     ,T.[PHARMACY_LINK_ID] as [apt_source_id]
             ,T.[PRODUCT_ID] as [good_source_id]
             ,T.[QUANTITY] as [quantity]
             ,T.[SUM_IN_SUP_PRICE] as [sale_net]
             ,T.[SUM_IN_SUP_PRICE_WITH_VAT] as [sale_grs]
			 ,T.[SALE_CHANNEL_ID] as [sales_channel_id]
		from [source_DWH].[RPT].[FACT_YEAR_MONTH_SALES] as T (nolock)
	    where T.[DATE_OPER_ID] >= ' + cast(@date_int_from as varchar) +
        ' and T.[DATE_OPER_ID] <  ' + cast(@date_int_to   as varchar)
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'

	truncate table [stg].[fct_sales]	
	insert into [stg].[fct_sales]
			  (
			   [date_source_id]
			  ,[apt_source_id]
			  ,[good_source_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			  )	
    exec (@sql_openquery)

    -- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end try      
	begin catch
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	return
	end catch 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_fct_sales_additional]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_fct_sales_additional] AS' 
END
GO

-- ==========================================================================================
-- Author:			Shemetov I.V.
-- Create date:		2018-10-16
-- Description:		Заполнение фактов добавочных Продаж за указанный период с иcточника
-- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
-- EXEC Example:	exec [stg].[fill_fct_sales_additional] @date_from = '2018-10-10', @date_to = '2018-10-11'
-- ==========================================================================================
ALTER PROCEDURE [stg].[fill_fct_sales_additional]
	@date_from date,
	@date_to date
AS
BEGIN	
	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[stg].[fill_fct_sales_additional]'
	DECLARE @description nvarchar(500) = 'Заполнение фактов Продаж за указанный период с иcточника'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')	
	begin try
	-- Запускаем процедуру логирования
    exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  

	Declare @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
	Declare @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'
		SELECT [DATE_OPER_ID] as [date_source_id]
			  ,[PHARMACY_LINK_ID] as [apt_source_id]
			  ,[PRODUCT_ID] as [good_source_id]
			  ,[QUANTITY] as [quantity]
			  ,[SUM_IN_SUP_PRICE] as [purch_net]
			  ,[SUM_IN_SUP_PRICE_WITH_VAT] as [purch_grs]
			  ,[SALE_CHANNEL_ID] as [sales_channel_id]
		FROM [source_DWH].[RPT].[FACT_YEAR_MONTH_DAY_SALES] with (nolock)
	    where [DATE_OPER_ID] >= ' + cast(@date_int_from as varchar) +
        ' and [DATE_OPER_ID] <  ' + cast(@date_int_to   as varchar)
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'

	truncate table [stg].[fct_sales_additional]	
	insert into [stg].[fct_sales_additional]
			  (
			   [date_source_id]
			  ,[apt_source_id]
			  ,[good_source_id]
			  ,[quantity]
			  ,[sale_net]
			  ,[sale_grs]
			  ,[sales_channel_id]--20191101 Added Shemetov
			  )	
    exec (@sql_openquery)

    -- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end try      
	begin catch
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	return
	end catch 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_fct_statistician_purchases]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_fct_statistician_purchases] AS' 
END
GO


-- ==========================================================================================
-- Author:		Shemetov IV
-- Create date: 2019-02-21
-- Description:	Заполнение фактов закупок Статистов за указанный период с ичточника
-- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
-- Example:		exec [stg].[fill_fct_statistician_purchases] @date_from = '2019-01-01', @date_to = '2019-04-01'
-- ==========================================================================================
ALTER PROCEDURE [stg].[fill_fct_statistician_purchases]
	@date_from date,
	@date_to date
AS
BEGIN	
	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[stg].[fill_fct_statistician_purchases]'
	DECLARE @description nvarchar(500) = 'Заполнение фактов закупок Статистов за указанный период с иcточника'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')	
	begin try
	-- Запускаем процедуру логирования
    exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  

	Declare @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
	Declare @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)

	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'
		select 
			ISNULL(apt.[ID],0) as [apt_id], 
			ISNULL(sp.[ID],0) as [supplier_id],
			ISNULL(g.[PRODUCT_ID],0) as [good_id],
			s.[DATE_OPER_ID] as [date_id], 
			s.[SUM_IN_SUP_PRICE_WITH_VAT] as [purch_grs],
			s.[SUM_IN_SUP_PRICE] as [purch_net],
			s.[QUANTITY]as [qty]
		from [source_DWH].[STG].[PRE_FACT_SUPPLY_STATISTIC] as s -- заменили источник [source_DWH].DWH.Pre_fact_supply_statistics as s 
		inner join [source_DWH].[DWH].[DIM_PHARMACIES] f (nolock) 
			on f.[PREFIX] = s.[PHARMACY_PREFIX]
		left join [source_DWH].[DWH].[DIM_PHARMACY_LINKS] apt (nolock) 
			on apt.[PHARMACY_ID] = f.[ID] 
				and apt.[ID] = apt.[MAIN_ID]
		left join [source_DWH].[DWH].[DIM_PRODUCT_LINKS] g (nolock) 
			on g.[EXT_CODE] = s.[PRODUCT_EXT_CODE]
				and g.[RR_ID] = s.[RR_ID]
		left join [source_DWH].[DWH].[DIM_SUPPLIERS] sp (nolock) 
			on sp.[INN] = s.[SUPPLIER_INN]
		where f.[REGISTRATION_COUNTRY_ID] = 6 --РОССИЯ
			and s.[DATE_OPER_ID] >= ' + cast(@date_int_from as varchar) +
        ' and s.[DATE_OPER_ID] <  ' + cast(@date_int_to   as varchar)
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'
	
	truncate table [stg].[fct_statistician_purchases]	
	insert into [stg].[fct_statistician_purchases]
	(
	   [apt_id]
      ,[supplier_id]
      ,[good_id]
      ,[date_id]
      ,[purch_grs]
      ,[purch_net]
      ,[qty]
	)	
    exec (@sql_openquery)


    -- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end try      
	begin catch
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	return
	end catch 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_fct_supplys]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_fct_supplys] AS' 
END
GO

-- ==========================================================================================
-- Author:		Shemetov I.V.
-- Create date: 2018-09-20
-- Description:	Заполнение фактов Закупки поступления за указанный период с ичточника
-- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
-- ==========================================================================================
-- exec [stg].[fill_fct_supplys] @date_from = '2019-01-01', @date_to = '2019-12-31'
ALTER PROCEDURE [stg].[fill_fct_supplys]
	@date_from date,
	@date_to date
AS
BEGIN	
	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[stg].[fill_fct_supplys]'
	DECLARE @description nvarchar(500) = 'Заполнение фактов Закупки поступления за указанный период с иcточника'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')	
	begin try
	-- Запускаем процедуру логирования
    exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  


	Declare @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
	Declare @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)
	
	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'
		select
			   T.[DATE_OPER_ID] as [date_source_id]
			  ,T.[PHARMACY_LINK_ID] as [apt_source_id]
			  ,T.[PRODUCT_ID] as [good_source_id]
			  ,T.[SUPPLIER_ID] as [supplier_source_id]
			  ,T.[QUANTITY] as [quantity]
			  ,T.[SUM_IN_SUP_PRICE] as [purch_net]
			  ,T.[SUM_IN_SUP_PRICE_WITH_VAT] as [purch_grs]
		from [source_DWH].[RPT].[FACT_YEAR_MONTH_SUPPLIES] as T (nolock)
	    where T.[DATE_OPER_ID] >= ' + cast(@date_int_from as varchar) +
        ' and T.[DATE_OPER_ID] <  ' + cast(@date_int_to   as varchar)
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'

	truncate table [stg].[fct_supplys]
	insert into [stg].[fct_supplys]
			  (
			   [date_source_id]
			  ,[apt_source_id]
			  ,[good_source_id]
			  ,[supplier_source_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			  )	
    exec (@sql_openquery)

    -- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end try      
	begin catch
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	return
	end catch 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stg].[fill_fct_supplys_additional]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [stg].[fill_fct_supplys_additional] AS' 
END
GO

-- ==========================================================================================
-- Author:			Shemetov I.V.
-- Create date:		2018-10-16
-- Description:		Заполнение фактов добавочные Закупки поступления за указанный период с ичточника
-- Update 20-03-2020 Ильин В.А. : Переход на новый источник данных
-- EXEC Example:	exec [stg].[fill_fct_supplys_additional] @date_from = '2018-10-10', @date_to = '2018-10-11'
-- ==========================================================================================
ALTER PROCEDURE [stg].[fill_fct_supplys_additional]
	@date_from date,
	@date_to date
AS
BEGIN	
	SET NOCOUNT ON;	
	DECLARE @name varchar(max) = '[stg].[fill_fct_supplys_additional]'
	DECLARE @description nvarchar(500) = 'Заполнение фактов Закупки поступления за указанный период с ичточника'
	DECLARE @input_parametrs nvarchar(500) = '@date_from = ' + isnull(cast(@date_from as nvarchar),'') + ', @date_to = ' + isnull(cast(@date_to as nvarchar),'')	
	begin try
	-- Запускаем процедуру логирования
    exec [oth].[fill_sup_log] @name = @name, @state_name = 'start', @task_id=null  , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  


	Declare @date_int_from as int Set @date_int_from = isnull(dbo.date_to_int(@date_from),19000101)
	Declare @date_int_to   as int Set @date_int_to   = isnull(dbo.date_to_int(@date_to)  ,19000101)
	
	Declare @sql as varchar(max)
	Declare @sql_openquery as varchar(max)
	--Update 20-03-2020 Изменился источник данных
	Set @sql=
	'
		SELECT [DATE_OPER_ID] as [date_source_id]
			  ,[PHARMACY_LINK_ID] as [apt_source_id]
			  ,[PRODUCT_ID] as [good_source_id]
			  ,[SUPPLIER_ID] as [supplier_source_id]
			  ,[QUANTITY] as [quantity]
			  ,[SUM_IN_SUP_PRICE] as [purch_net]
			  ,[SUM_IN_SUP_PRICE_WITH_VAT] as [purch_grs]
		FROM [source_DWH].[RPT].[FACT_YEAR_MONTH_DAY_SUPPLIES] with (nolock)
	    where [DATE_OPER_ID] >= ' + cast(@date_int_from as varchar) +
        ' and [DATE_OPER_ID] <  ' + cast(@date_int_to   as varchar)
	Set @sql_openquery = 'select * from openquery([BETADWH], ''' + REPLACE(@sql, '''', '''''') + ''')'

	truncate table [stg].[fct_supplys_additional]
	insert into [stg].[fct_supplys_additional]
			  (
			   [date_source_id]
			  ,[apt_source_id]
			  ,[good_source_id]
			  ,[supplier_source_id]
			  ,[quantity]
			  ,[purch_net]
			  ,[purch_grs]
			  )	
    exec (@sql_openquery)


    -- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'finish', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	end try      
	begin catch
	-- Запускаем процедуру логирования
	exec [oth].[fill_sup_log] @name = @name, @state_name = 'error', @task_id=null , @sp_id = @@SPID, @description = @description, @input_parametrs = @input_parametrs  
	return
	end catch 
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE parent_class_desc = 'DATABASE' AND name = N'backup_objects')
EXECUTE dbo.sp_executesql N'



CREATE TRIGGER [backup_objects]
ON DATABASE
FOR CREATE_PROCEDURE, 
    ALTER_PROCEDURE, 
    DROP_PROCEDURE,
    CREATE_TABLE, 
    ALTER_TABLE, 
    DROP_TABLE,
    CREATE_FUNCTION, 
    ALTER_FUNCTION, 
    DROP_FUNCTION,
    CREATE_VIEW,
    ALTER_VIEW,
    DROP_VIEW
AS
 
SET NOCOUNT ON
 
DECLARE @data XML
SET @data = EVENTDATA()
 
INSERT INTO [oth].[sup_change_objects_log]([database_name]
      ,[event_type]
      ,[object_name]
      ,[object_type]
      ,[sql_command]      
      ,[login_name])
VALUES(
@data.value(''(/EVENT_INSTANCE/DatabaseName)[1]'', ''varchar(256)''),
@data.value(''(/EVENT_INSTANCE/EventType)[1]'', ''varchar(50)''), 
''[''+@data.value(''(/EVENT_INSTANCE/SchemaName)[1]'', ''varchar(256)'') + ''].['' +  @data.value(''(/EVENT_INSTANCE/ObjectName)[1]'', ''varchar(256)'') + '']'', 
@data.value(''(/EVENT_INSTANCE/ObjectType)[1]'', ''varchar(25)''), 
@data.value(''(/EVENT_INSTANCE/TSQLCommand)[1]'', ''varchar(max)''), 
@data.value(''(/EVENT_INSTANCE/LoginName)[1]'', ''varchar(256)'')
)
'
GO
ENABLE TRIGGER [backup_objects] ON DATABASE
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unit_descr'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Аптека (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unit_descr'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unit_fact_address'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Фактический адрес (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unit_fact_address'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unitInn'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'ИНН Сети - аптеки (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unitInn'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unit_legal_entity'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Юр лицо (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unit_legal_entity'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unit_cll_pref'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Внешний код (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unit_cll_pref'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unit_net_name'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Сеть (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unit_net_name'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_apt_unit_region_name'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Регион (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_apt_unit_region_name'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_supplier_descr'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Поставщик' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_supplier_descr'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_supplier_inn'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'ИНН Поставщика' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_supplier_inn'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_good_descr'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Товар' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_good_descr'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_good_initial_id'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Код товара (ННТ)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_good_initial_id'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_date_year_id'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Год' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_date_year_id'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_date_month_name'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Месяц' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_date_month_name'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_is_apt_in_list'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Аптека в списке' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_is_apt_in_list'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_is_manufacturer_contract'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Прямой контракт' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_is_manufacturer_contract'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_is_distributor_limitation'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Разрешенный дистрибьютор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_is_distributor_limitation'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_volume_agreement_group'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Группа по ОС' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_volume_agreement_group'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_dim_report_purchases_price_cip'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Закупки цена руб CIP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_dim_report_purchases_price_cip'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_fct_report_purchases_purch_cip'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Закупки сумма руб CIP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_fct_report_purchases_purch_cip'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_fct_report_purchases_purch_grs'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Закупки руб с НДС' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_fct_report_purchases_purch_grs'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_fct_report_purchases_purch_net'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Закупки руб без НДС' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_fct_report_purchases_purch_net'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'purchases_fct_report_purchases_qty'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Закупки шт' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'purchases_fct_report_purchases_qty'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unit_descr'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Аптека (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unit_descr'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unit_fact_address'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Фактический адрес (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unit_fact_address'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unitInn'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'ИНН Сети - аптеки (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unitInn'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unit_legal_entity'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Юр лицо (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unit_legal_entity'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unit_cll_pref'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Внешний код (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unit_cll_pref'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unit_net_name'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Сеть (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unit_net_name'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_apt_unit_region_name'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Регион (тек)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_apt_unit_region_name'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_good_descr'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Товар' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_good_descr'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_good_initial_id'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Код товара (ННТ)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_good_initial_id'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_date_year_id'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Год' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_date_year_id'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_date_month_name'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Месяц' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_date_month_name'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_is_apt_in_list'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Аптека в списке' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_is_apt_in_list'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_is_manufacturer_contract'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Прямой контракт' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_is_manufacturer_contract'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_volume_agreement_group'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Группа по ОС' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_volume_agreement_group'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_dim_report_sales_price_cip'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Продажи цена руб CIP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_dim_report_sales_price_cip'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_fct_report_sales_sale_cip'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Продажи сумма руб CIP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_fct_report_sales_sale_cip'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_fct_report_sales_sale_grs'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Продажи руб с НДС' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_fct_report_sales_sale_grs'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_fct_report_sales_sale_net'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Продажи руб без НДС' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_fct_report_sales_sale_net'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'RUS_column_name' , N'SCHEMA',N'dbo', N'TABLE',N'auto_volume_agreements_settings', N'COLUMN',N'sales_fct_report_sales_qty'))
EXEC sys.sp_addextendedproperty @name=N'RUS_column_name', @value=N'Продажи шт' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'auto_volume_agreements_settings', @level2type=N'COLUMN',@level2name=N'sales_fct_report_sales_qty'
GO
