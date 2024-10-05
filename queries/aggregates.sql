CREATE OR REPLACE AGGREGATE faculty.classify_grades(grade float)(
    INITCOND = '(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)',
    SFUNC = faculty.classify_grade_state,
    STYPE = faculty.classify_grade_state,
    FINALFUNC = faculty.classify_grade_final
);

