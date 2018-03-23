/*

Availability Group Failover Script
Script will failover all AG's that are Secondary on the node script is executed on and where
synchronization state is healthy

i.e. Any AG on this node that is current Secondary will become Primary

*/

DECLARE @AgGroupCursor CURSOR;
DECLARE @AgGroupID varchar(50);
DECLARE @AgGroupName varchar(100);
DECLARE @SqlCmd varchar(max);

BEGIN
	SET @AgGroupCursor = CURSOR FOR
		select group_id from sys.dm_hadr_availability_replica_states 
			where is_local = 1
			and role = 2
			and operational_state = 2
			and synchronization_health = 2

	OPEN @AgGroupCursor
	FETCH NEXT FROM @AgGroupCursor
	INTO @AgGroupID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @AgGroupName =
			(select name from sys.availability_groups
				where group_id = @AgGroupID)

		SET @SqlCmd = 'ALTER AVAILABILITY GROUP[' + @AgGroupName + '] FAILOVER;'
		EXEC (@SqlCmd);

		FETCH NEXT FROM @AgGroupCursor
		INTO @AgGroupID
	END;

	CLOSE @AgGroupCursor;
	DEALLOCATE @AgGroupCursor;
END;