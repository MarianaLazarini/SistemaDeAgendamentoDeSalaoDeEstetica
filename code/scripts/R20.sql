----------Criando a Stored Procedure ----------
CREATE OR REPLACE PROCEDURE PR_CANCELAR_ATENDIMENTOS_ATRASADOS
AS
BEGIN

    UPDATE ATENDIMENTO
    SET STATUS = 'CANCELADO'
    WHERE STATUS = 'AGENDADO'
      AND DATA_HORA_INICIO <= (
            SYSTIMESTAMP - INTERVAL '30' MINUTE
      );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

----------Verificando se está funcionando----------
SELECT OBJECT_NAME, STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'PR_CANCELAR_ATENDIMENTOS_ATRASADOS';

----------Criando um atendimento para teste----------
INSERT INTO ATENDIMENTO (
    ID_ATEND,
    ID_CLI,
    DATA_HORA_INICIO,
    STATUS
)
VALUES (
    50,
    1,
    SYSTIMESTAMP - INTERVAL '45' MINUTE,
    'AGENDADO'
);

COMMIT;

----------Verificando ----------
SELECT
    ID_ATEND,
    DATA_HORA_INICIO,
    STATUS
FROM ATENDIMENTO
WHERE ID_ATEND = 50;


----------Executando a Stored Procedure----------
BEGIN
    PR_CANCELAR_ATENDIMENTOS_ATRASADOS;
END;
/

----------Verificando o resultado----------
SELECT
    ID_ATEND,
    DATA_HORA_INICIO,
    STATUS
FROM ATENDIMENTO
WHERE ID_ATEND = 50;

----------Automatização com DBMS_SCHEDULER----------
----------rotina periódica funcionando automaticamente, sem precisar de alguém executar isso manualmente----------
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        JOB_NAME        => 'JOB_CANCELAR_ATRASADOS',
        JOB_TYPE        => 'STORED_PROCEDURE',
        JOB_ACTION      => 'PR_CANCELAR_ATENDIMENTOS_ATRASADOS',
        START_DATE      => SYSTIMESTAMP,
        REPEAT_INTERVAL => 'FREQ=HOURLY',
        ENABLED         => TRUE
    );
END;
/

----------Verificando o job----------
SELECT
    JOB_NAME,
    ENABLED,
    STATE,
    REPEAT_INTERVAL
FROM USER_SCHEDULER_JOBS
WHERE JOB_NAME = 'JOB_CANCELAR_ATRASADOS';
