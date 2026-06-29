----------verificar se existe um atendimento para teste-----------
SELECT *
FROM ATENDIMENTO;

/*Colocar o atendimento em andamento pois RF22 finaliza um atendimento que já está sendo executado.*/
UPDATE ATENDIMENTO
SET STATUS = 'EM_ANDAMENTO'
WHERE ID_ATEND = 2;

COMMIT;

----------Verifica----------
SELECT ID_ATEND, STATUS
FROM ATENDIMENTO
WHERE ID_ATEND = 2;


----------Criar a Stored Procedure-----------
CREATE OR REPLACE PROCEDURE PR_FINALIZAR_ATENDIMENTO(
    P_ID_ATEND NUMBER,
    P_FINANCEIRO_OK NUMBER
)
AS
BEGIN
    ---------------------------------------------------
    -- Atualiza o status do atendimento
    ---------------------------------------------------

    UPDATE ATENDIMENTO
    SET STATUS = 'CONCLUIDO'
    WHERE ID_ATEND = P_ID_ATEND
      AND STATUS = 'EM_ANDAMENTO';

    ---------------------------------------------------
    -- Simulação da lógica financeira
    ---------------------------------------------------

    IF P_FINANCEIRO_OK = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20022,
            'Falha no processamento financeiro.'
        );
    END IF;

    ---------------------------------------------------
    -- Tudo ocorreu corretamente
    ---------------------------------------------------

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

----------confirmar que a procedure foi criada----------
SELECT OBJECT_NAME, STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'PR_FINALIZAR_ATENDIMENTO';

----------testando----------
BEGIN
    PR_FINALIZAR_ATENDIMENTO(
        2,
        1
    );
END;
/

----------verificando se a procedure está correta----------
SELECT ID_ATEND, STATUS
FROM ATENDIMENTO
WHERE ID_ATEND = 2;

----------Partindo apenas para um teste de fala----------
---voltei o atendimento para "em andamento"
UPDATE ATENDIMENTO
SET STATUS = 'EM_ANDAMENTO'
WHERE ID_ATEND = 2;

COMMIT;

---
BEGIN
    PR_FINALIZAR_ATENDIMENTO(
        2,
        0
    );
END;
/

/* 0 -> significa:
        Falha no processamento financeiro.
Resultado esperado:
        Falha no processamento financeiro.
*/

----------verificando se o rollback funcionou----------
SELECT ID_ATEND, STATUS
FROM ATENDIMENTO
WHERE ID_ATEND = 2;