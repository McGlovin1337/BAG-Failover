# BAG-Failover
MSSQL Basic Availability Group Failover

Basic Availability Group Failover Script
Script will failover all AG's that are Secondary on the node script is executed on and where
synchronization state is healthy
i.e. Any AG on local node that is currently Secondary will become Primary
