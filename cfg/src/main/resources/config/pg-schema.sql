

drop table if exists SystemEvents CASCADE;
--drop SEQUENCE if exists SystemEvents_id_sec; --autogen sequence name
CREATE TABLE SystemEvents
(
        ID bigserial not null primary key,
        CustomerID bigint,
        ReceivedAt timestamp without time zone NULL,
        DeviceReportedTime timestamp without time zone NULL,
        Facility smallint NULL,
        Priority smallint NULL,
        FromHost varchar(60) NULL,
        Message text,
        NTSeverity int NULL,
        Importance int NULL,
        EventSource varchar(60),
        EventUser varchar(60) NULL,
        EventCategory int NULL,
        EventID int NULL,
        EventBinaryData text NULL,
        MaxAvailable int NULL,
        CurrUsage int NULL,
        MinUsage int NULL,
        MaxUsage int NULL,
        InfoUnitID int NULL ,
        SysLogTag varchar(60),
        EventLogType varchar(60),
        GenericFileName VarChar(60),
        SystemID int NULL
);

drop table if exists SystemEventsProperties CASCADE;
--drop SEQUENCE if exists SystemEventsProperties_id_sec; --autogen sequence name
CREATE TABLE SystemEventsProperties
(
        ID bigserial not null primary key,
        SystemEventID int NULL ,
        ParamName varchar(255) NULL ,
        ParamValue text NULL
);
