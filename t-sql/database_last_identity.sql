SELECT 
    tables.name As TableName,
    OBJECT_SCHEMA_NAME(tables.object_id, db_id())
    AS SchemaName,
    identity_columns.name as ColumnName,
    identity_columns.seed_value,
    identity_columns.increment_value,
    identity_columns.last_value,
    Power(cast(2 as varchar),(identity_columns.max_length * 8) -1) as max_value,
    sys.types.name as dataType
FROM sys.tables tables 
    JOIN sys.identity_columns identity_columns ON tables.object_id=identity_columns.object_id
    JOIN sys.types ON sys.types.system_type_id = identity_columns.system_type_id
WHERE identity_columns.last_value is not null
Order by identity_columns.last_value desc