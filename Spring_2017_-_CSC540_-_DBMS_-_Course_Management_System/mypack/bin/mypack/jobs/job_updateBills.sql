-- Scheduler job for updating student bills at end of every day

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
    job_name        => 'job_update_bills_daily',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN proc_GenerateBill; END;',
    start_date      => timestamp'2017-01-01 00:05:00',
    repeat_interval => 'freq=daily; byminute=0; bysecond=0;',
    enabled         => TRUE,
    comments        => 'Update bills at end of day for all students'
);
END;
/