-- always in january 1
SELECT
    cron.schedule('create_new_counters_1st_semester', '0 1 1 1 *', 'CALL faculty.create_new_counters();');

-- always in july 1
SELECT
    cron.schedule('create_new_counters_2nd_semester', '0 1 1 7 *', 'CALL faculty.create_new_counters();');

-- always in june 29
select cron.schedule('calculate_academic_transcripts_1st_semester', '0 1 29 6 *', 'REFRESH MATERIALIZED VIEW faculty.academic_transcripts;');

-- always in december 20
select cron.schedule('calculate_academic_transcripts_2nd_semester', '0 1 20 12 *', 'REFRESH MATERIALIZED VIEW faculty.academic_transcripts;');