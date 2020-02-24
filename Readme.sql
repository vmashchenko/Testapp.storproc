-- Bulk Import csv file
/*
1. Create empty database
2. Create function and stored procedure 
	biGetColumnValue.sql 
	BulkImportFromFile.sql
3. Create import configuration 
	biConfiguration.sql

4. Test import 
	exec [dbo].BulkImportFile 'Sales', 'C:\Work\DataBulk\test1.csv'

5. Check dbo.Sales table

6. Update configuration if need for different files. Check import.

*/