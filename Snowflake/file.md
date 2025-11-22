# Snowflake to  100 Questions
=============================

1. What is Snowflake, and how is it different from traditional data warehouses?  
Snowflake is a cloud-native data warehouse that separates storage, compute, and services layers, providing unlimited scalability and on-demand compute.  
Traditional warehouses tightly couple compute & storage, causing scaling issues.

2. Explain Snowflake’s architecture.  
Snowflake uses a 3-tier architecture:  
1. Storage Layer – Manages compressed, encrypted columnar data.  
2. Compute Layer (Warehouses) – Independent cluster(s) that run queries.  
3. Cloud Services Layer – Authentication, optimization, metadata, transactions.

3. What are the key components of Snowflake?  
• Databases  
• Schemas  
• Tables  
• Virtual warehouses  
• Stages  
• File formats  
• Streams  
• Tasks  
• Roles & users

Virtual Warehouses:   Standard, Multi-cluster (Standard/Economy), Auto-suspend/Auto-resume
Databases:            Permanent, Transient, Temporary
Schemas:              Standard, Temporary, Transient
Tables:               Permanent, Transient, Temporary, External
Stages:               Internal (User, Table, Named), External (S3, Azure Blob, GCS)
File Formats:         CSV, JSON, Parquet, Avro, ORC, XML
Streams:              Standard, Append-only, Delta (External Table)
Tasks:                Scheduled, Dependency-based, One-time, Continuous
Roles & Users:        System roles (ACCOUNTADMIN, SYSADMIN, SECURITYADMIN), Custom roles, Standard users, Reader accounts

Databases and schemas are used for organizing data.
Tables are where data is stored.
Virtual warehouses handle compute tasks like running queries.
Stages and file formats manage how data is loaded/unloaded.
Streams and tasks help with change tracking and automation.
Roles & users control access and permissions in Snowflake.

Standard Edition: Suitable for small to medium businesses with basic needs.
Enterprise Edition: Ideal for businesses requiring more features, including extended Time Travel and better security.
Business Critical Edition: Designed for enterprises with stringent security, compliance, and governance requirements.

• SYSADMIN  
• SECURITYADMIN  
• ACCOUNTADMIN  
• PUBLIC  
• Custom roles

Virtual Private Snowflake (VPS) Edition: Best for large organizations requiring full infrastructure isolation and dedicated cloud resources.
4. What is virtual warehouse in Snowflake?  
A compute cluster used to execute queries, load data, and perform transformations.  
It scales independently and can auto-suspend/resume.

5. How does Snowflake separate storage and compute?  
They run on independent layers.  
Compute can be scaled up/down without impacting stored data.  
Multiple warehouses can query the same data without conflict.

6. What is micro-partitioning in Snowflake?  
Snowflake automatically divides data into micro-partitions (50–500 MB logical blocks).  
This helps in pruning, performance, and compression.

7. What is Time Travel in Snowflake?  
Allows retrieving historical data for 1–90 days depending on edition.  
You can query, clone, or restore tables to an earlier state.

8. What is Fail-safe?  
A 7-day recovery period Snowflake uses after Time Travel expires.  
It is for disaster recovery only — not user queries.

9. What is Cloud Services Layer?  
Manages:  
• Query optimization  
• Authentication & access control  
• Metadata  
• Transactions  
• Caching  
• Result warmth

10. What are different Snowflake editions?  
• Standard  
• Enterprise  
• Business Critical  
• Virtual Private Snowflake (VPS)

11. How does Snowflake store data?  
Data is stored in compressed, encrypted, columnar micro-partitions in cloud storage (AWS, Azure, GCP).

12. What are Snowflake virtual warehouse sizes?  
• X-Small  
• Small  
• Medium  
• Large  
• XL  
• 2XL  
• 3XL  
• 4XL  
Each is double the compute of the previous.

13. What is multi-cluster warehouse?  
A warehouse with multiple compute clusters to handle high concurrency automatically.

14. Standard vs Economy multi-cluster?  
• Standard → Automatically adds/removes clusters based on load.  
• Economy → Only adds clusters when needed but removes aggressively to save cost.

15. What is auto-suspend and auto-resume?  
• Auto-suspend: Warehouse stops after inactivity to save cost.  
• Auto-resume: Warehouse restarts automatically when query arrives.

16. What happens when you suspend a warehouse?  
• No compute charges  
• Queries stop running  
• Storage unaffected  
• Cached results still available (remote cache)

17. What is query pruning?  
Snowflake reads only required micro-partitions rather than full table → improves performance.

18. Result cache vs Local disk cache vs Remote cache?  
Cache Type       Description  
Result Cache     Stores final query results for 24 hours.  
Local Cache      Cached data in the warehouse SSDs.  
Remote Cache     Cloud-level cache used when warehouse restarts.

19. What are micro-partitions and how large are they?  
Logical blocks of data sized 50–500 MB, created automatically and immutable.

20. How does Snowflake achieve columnar storage?  
Snowflake stores each column’s data separately inside micro-partitions → optimizing analytical workloads.


21. What are Snowflake databases and schemas?  
• A database is a logical container for schemas.  
• A schema is a container for tables, views, stages, file formats, and other objects.

22. Difference between transient database and permanent database?  
Type      Time Travel   Fail-safe    Cost  
Permanent Up to 90 days   Yes (7 days) Highest  
Transient  0–1 day       No          Lower  
Transient DBs reduce storage cost but have no fail-safe.

23. What is temporary table vs transient table?  
Feature       Temporary Table     Transient Table  
Lifespan      Session-based        Explicit drop  
Fail-safe     No                    No  
Time travel   Limited               Limited  
Use-case      Staging, intermediate  Semi-permanent, cost-saving

24. What is file format in Snowflake?  
A file format defines structure of input/output files:  
Examples:  
• CSV  
• JSON  
• PARQUET  
• AVRO  
• ORC  
• XML  
Used in COPY INTO commands.

25. How to create external tables?  
External tables reference data stored outside Snowflake (S3, GCS, Azure Blob).  
Steps:  
1. Create external stage  
2. Create file format  
3. Create external table referring to stage location

26. Explain stages (internal, external).  
Stages are locations for loading/unloading data.  
• Internal stage → inside Snowflake  
• User stage  
• Table stage  
• Named internal stage  
• External stage → external storage  
• AWS S3  
• Azure Blob  
• Google Cloud Storage

27. What is a Snowflake sequence?  
An object that generates auto-increment numbers, similar to SQL SEQUENCE.

28. What is masking policy?  
A rule that masks sensitive data (e.g., emails, credit cards) based on user role.  
Example:  
MASKING POLICY mask_phone AS (val STRING) RETURNS STRING ->  
  CASE WHEN CURRENT_ROLE() = 'ANALYST' THEN 'XXXXXX' ELSE val END;

29. What is row access policy?  
Policies that restrict row-level data visibility depending on user role.  
Used for dynamic row-based filtering.

30. What is tag in Snowflake?  
Metadata label attached to objects for:  
• cost tracking  
• data classification  
• compliance  
• governance

31. What is COPY INTO command?  
Used for loading data into and unloading data from Snowflake tables.  
Two types:  
• COPY INTO table → load  
• COPY INTO @stage → unload

32. What is Snowpipe?  
A continuous data ingestion service that loads new files automatically as they arrive.

33. What are internal vs external stages?  
• Internal stage: Managed by Snowflake  
• Snowflake stores the files  
• External stage: Refers to external cloud storage  
• S3, Blob, GCS

34. How to load data from S3/GCS/Azure?  
Using external stage + COPY INTO:  
CREATE STAGE mystage URL='s3://bucket/path';  
COPY INTO mytable FROM @mystage FILE_FORMAT=(TYPE=CSV);

35. What happens if copy command fails?  
• Failed files recorded in load history  
• You can VALIDATE using VALIDATE() function  
• Partially loaded files can be reloaded or skipped

36. How to handle semi-structured data (JSON, XML)?  
Use VARIANT column data type and functions like:  
• FLATTEN  
• OBJECT_VALUE  
• PARSE_JSON  
• GET_PATH

37. What is VARIANT data type?  
A flexible data type supporting semi-structured data:  
JSON, XML, Avro, Parquet, ORC.  
Allows nested values and arrays.

38. What is auto-ingest in Snowpipe?  
Snowpipe automatically loads data upon file arrival using cloud event notifications:  
• S3 Events  
• Azure Event Grid  
• GCS Pub/Sub

39. What is continuous data loading?  
A system where data is loaded in near real-time via:  
• Snowpipe  
• Streams  
• Tasks  
• External tables

40. How to unload data to S3?  
Use COPY INTO <stage> command:  
COPY INTO @mystage FROM mytable FILE_FORMAT=(TYPE=CSV);


41. What is a Snowflake Stream?  
A change tracking object that captures INSERT, UPDATE, DELETE changes on a table for CDC (Change Data Capture).

42. Types of streams in Snowflake?  
1. Standard stream — Tracks all DML changes.  
2. Append-only stream — Tracks only inserts.  
3. Delta stream (on external tables) — Tracks file additions/removals.

43. What is CDC (Change Data Capture) in Snowflake?  
CDC identifies row-level changes (inserts/updates/deletes) for downstream consumption, often using Streams + Tasks.

44. How streams track changes?  
Streams maintain an offset (change tracking metadata) and return only changed rows since last consumption.

45. What is task in Snowflake?  
Tasks allow automating SQL execution on a schedule or based on dependency, similar to cron jobs.

46. What is task scheduling?  
Tasks run based on:  
• Time-based schedule:  
SCHEDULE = '1 MINUTE'  
• Dependency-based (task graphs)

47. Can stream read its own insert?  
No.  
A stream does not record changes made by the task/query that reads it. This avoids loops.

48. How to handle stream offsets?  
Offsets auto-advance when stream is consumed.  
To reset:  
ALTER STREAM <stream> TABLE = <same_table>;

49. What happens when stream retention expires?  
If underlying table’s CDC retention expires, the stream becomes stale, and Snowflake throws:  
“Stale stream error: data unavailable.”

50. Difference between table stream and external table stream?  
Table Stream  External Table Stream  
Tracks DML       Tracks file changes  
Works on internal DB tables  Works on external tables (S3/GCS/Azure)  
Supports INSERT/UPDATE/DELETE  Supports file-level changes only

51. What is clustering in Snowflake?  
Clustering organizes micro-partitions based on a column or set of columns to improve filtering & pruning.

52. Automatic clustering vs Manual clustering?  
• Automatic clustering: Snowflake maintains clustering behind the scenes.  
• Manual clustering: User defines clustering key; Snowflake reclusters as needed.

53. What is search optimization service?  
A service that makes queries faster for highly selective filters or searching inside VARIANT or columns without clustering.

54. How to analyze query performance in Snowflake?  
Using:  
• QUERY_HISTORY views  
• Query Profile visual tools  
• Execution steps: scanning, filtering, join, aggregation  
• Warehouse load

55. What is query profile?  
A visual explanation of how Snowflake executed a query, including:  
• Execution plan  
• Time spent on each operation  
• Partition pruning  
• Join strategies

56. What is warehouse credit consumption?  
Credits used by virtual warehouses for compute.  
Bigger warehouse → more credits/min  
Multi-cluster → multiple warehouses → more credits

57. How to reduce Snowflake cost?  
• Use auto-suspend & auto-resume  
• Use smaller warehouses  
• Avoid materialized views unless needed  
• Use clustering only when beneficial  
• Use result cache  
• Use transient objects  
• Monitor usage via ACCOUNT_USAGE

58. Difference between scaling up vs scaling out?  
Scaling Up    Scaling Out  
Increase warehouse size   Add more clusters  
More compute power     Handle concurrency  
Faster queries         Avoid queuing

59. What is materialized view?  
A view that stores pre-computed results for faster querying.  
Snowflake automatically refreshes it.

60. When to use materialized view?  
Use it when:  
• Queries repeatedly scan same data  
• High-cost aggregations  
• Large fact tables  
• Low-latency queries required


61. What is RBAC (Role-Based Access Control)?  
RBAC is Snowflake’s security model where permissions are assigned to roles, and roles are assigned to users, not directly to users.

62. What are roles in Snowflake?  
Roles are security objects defining what operations a user can perform.  
Examples:  
• SYSADMIN  
• SECURITYADMIN  
• ACCOUNTADMIN  
• PUBLIC  
• Custom roles

63. What is ACCOUNTADMIN?  
Highest-privileged role.  
Can manage:  
• Users  
• Warehouses  
• Roles  
• Billing  
• Security  
• Global account settings

64. What is SECURITYADMIN?  
Responsible for security functions:  
• Create/modify users  
• Create/modify roles  
• Manage grants  
But cannot manage billing or warehouses.

65. What is SYSADMIN?  
Manages databases, schemas, and warehouses.  
Used for day-to-day development operations.

66. What is PUBLIC role?  
A default role automatically granted to every user.  
You normally avoid giving sensitive privileges to PUBLIC.

67. How to implement masking policies?  
Masking policies hide data based on role.  
Example:  
CREATE MASKING POLICY mask_email AS (val string) RETURNS string ->  
  CASE WHEN CURRENT_ROLE()='HR' THEN val ELSE '*******' END;  
Apply:  
ALTER TABLE employees MODIFY COLUMN email SET MASKING POLICY mask_email;

68. What is dynamic data masking?  
A feature that masks or shows data dynamically depending on:  
• User’s role  
• User’s context  
• Custom logic  
No data copies are stored — masking is dynamic.

69. What is network policy?  
Network policies restrict login access based on IP address ranges, increasing security.

70. What is SSO and how to integrate with Snowflake?  
Single Sign-On allows login through identity providers like:  
• Azure AD  
• Okta  
• Ping  
• Google Identity  
Integration is via SAML or OAuth.

71. How to query JSON data in Snowflake?  
Load into a VARIANT column, then use:  
SELECT data:"name", data:"address":"city" FROM table;

72. What is LATERAL FLATTEN?  
A table function that expands arrays/objects inside JSON.  
Example:  
SELECT value FROM TABLE(FLATTEN(input => data:"items"));

73. How to extract nested values from VARIANT?  
Use colon notation:  
data:"person":"name";  
or dot notation:  
data:person.name;

74. What is PARSE_JSON?  
Converts a JSON string into a VARIANT object.  
Example:  
SELECT PARSE_JSON('{"id":1, "name":"Ankita"}');

75. What is OBJECT_CONSTRUCT and ARRAY_CONSTRUCT?  
OBJECT_CONSTRUCT → creates a JSON object  
ARRAY_CONSTRUCT → creates a JSON array  
Example:  
SELECT OBJECT_CONSTRUCT('id', 1, 'name', 'Ankita');

76. Difference between TRY_CAST and CAST?  
• CAST → throws error if conversion fails  
• TRY_CAST → returns NULL instead of error

77. What is QUALIFY clause?  
Used to filter results of window functions.  
Example:  
SELECT * FROM t  
QUALIFY ROW_NUMBER() OVER (PARTITION BY id ORDER BY ts DESC) = 1;

78. What is COPYABLE function?  
Functions that Snowflake can push down into COPY operations for optimization (e.g., simple conversions).  
Snowflake does internal optimizations during COPY.

79. How to use streams with JSON data?  
Same as normal tables — Snowflake tracks changes to VARIANT columns.  
Use stream to capture JSON inserts/updates and push downstream.

80. How to use MERGE in Snowflake?  
MERGE is used for UPSERT operations:  
MERGE INTO target t  
USING source s  
ON t.id = s.id  
WHEN MATCHED THEN UPDATE SET t.name = s.name  
WHEN NOT MATCHED THEN INSERT (id, name) VALUES (s.id, s.name);


81. What is zero-copy cloning?  
A feature that creates a logical copy of objects (database, schema, table) without duplicating data.  
Copies share the same underlying micro-partitions → saves storage & time.

82. What can be cloned in Snowflake?  
All major objects:  
• Databases  
• Schemas  
• Tables  
• Stages  
• File formats  
• Streams  
• Tasks  
• Shares

83. Does cloning cost extra?  
No initial cost — cloning is metadata-only.  
However:  
• Future changes create new micro-partitions → incur storage cost.

84. What is clone of a stream?  
A cloned stream preserves:  
• its offset  
• the change tracking metadata  
Useful for environment refresh (DEV → TEST).

85. What is clone of a task?  
A cloned task copies:  
• schedule  
• SQL  
• dependency graph  
• warehouse assignment  
Does not automatically copy active state.

86. What is retention period in Time Travel?  
Time Travel allows querying data back in time:  
• Standard Edition: 1 day  
• Enterprise Edition: 1–90 days  
• Tables: Based on object type (temp, transient, permanent)

87. Difference between Time Travel and Fail-safe?  
Feature              Time Travel    Fail-safe  
Purpose               Undo/restore by user  Disaster recovery only  
Access               User accessible  Snowflake only  
Duration             1–90 days       7 days  
Cost                 Yes              Yes

88. How does Snowflake achieve zero-copy cloning technically?  
Because Snowflake uses immutable micro-partitions, and the clone simply points to the same partitions.  
Actual data copy happens only when changes are made (Copy-on-write).

89. How to recover dropped table?  
Use Time Travel:  
UNDROP TABLE table_name;  
Or restore from a point in time:  
CREATE TABLE t_restore AS  
SELECT * FROM t AT (TIMESTAMP => '2024-01-05');

90. Can you restore a table beyond fail-safe?  
No. Fail-safe is the last recovery window, and accessing it requires Snowflake support.

91. What is Snowflake Marketplace?  
A platform to share or subscribe to datasets, applications, and services without copying data.

92. What is data sharing?  
A feature that allows sharing live data between Snowflake accounts without copying or moving it.

93. How to share data without copying?  
Using Secure Shares:  
• Provider creates share  
• Grants objects (DB, schema, tables)  
• Consumer gets live, real-time access

94. What is a reader account?  
A Snowflake account created for data consumers who don’t have their own Snowflake account.  
Provider pays compute & storage.

95. What is an external function?  
A function in Snowflake that calls an external API (AWS Lambda, Azure Function, GCP Cloud Function) and returns the result to SQL.

96. What is Snowpark?  
A developer framework for writing Snowflake code in:  
• Python  
• Java  
• Scala  
Snowpark lets you run complex transformations inside Snowflake compute.

97. Difference between Snowpark Python vs Stored Procedures?  
Snowpark Python    Stored Procedures  
DataFrame API       SQL logic or JavaScript  
Runs on Snowflake compute   Runs as JavaScript/SQL  
Great for ML / transformations   Great for orchestration

98. What is a UDF (User Defined Function)?  
Custom function written in:  
• SQL  
• JavaScript  
• Python (Snowpark)  
Used when built-in functions are insufficient.

99. What is Stage Encryption?  
All stage data is always encrypted (end-to-end encryption):  
• At rest  
• In transit  
• Using Snowflake-managed or customer-managed keys

100. Why is Snowflake considered serverless?  
Because:  
• Warehouse provisioning is automatic  
• Storage is fully managed  
• No infrastructure maintenance  
• Compute scales automatically  
• Snowpipe & serverless tasks run without warehouses
