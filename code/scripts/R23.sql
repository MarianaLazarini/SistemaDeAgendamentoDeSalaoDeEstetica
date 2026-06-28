----------Exclusão lógica de CLIENTE----------
----------Criar a Stored Procedure----------
CREATE OR REPLACE PROCEDURE PR_EXCLUIR_CLIENTE(
    P_ID_CLI NUMBER
)
AS
BEGIN

    UPDATE CLIENTE
    SET
        DELETADO_EM = SYSTIMESTAMP,
        ATUALIZADO_EM = SYSTIMESTAMP
    WHERE ID_CLI = P_ID_CLI
      AND DELETADO_EM IS NULL;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

----------Verificar se deu certo----------
SELECT OBJECT_NAME, STATUS
FROM USER_OBJECTS
WHERE OBJECT_NAME = 'PR_EXCLUIR_CLIENTE';

----------Inserir cliente para teste----------
----------Caso não exista----------
INSERT INTO CLIENTE (
    ID_CLI,
    NOME,
    TELEFONE,
    EMAIL,
    CPF
)
VALUES (
    100,
    'João Silva',
    '(18)99999-9999',
    'joao@email.com',
    '11122233344'
);

COMMIT;

----------Verificar antes de excluir----------
SELECT
    ID_CLI,
    NOME,
    DELETADO_EM
FROM CLIENTE
WHERE ID_CLI = 100;

----------Executar a exclusão lógica----------
BEGIN
    PR_EXCLUIR_CLIENTE(100);
END;
/

----------Verificar resultado----------
SELECT
    ID_CLI,
    NOME,
    DELETADO_EM
FROM CLIENTE
WHERE ID_CLI = 100;


/*Como listar apenas clientes ativos
A partir desse momento, praticamente todas as consultas devem usar*/
SELECT *
FROM CLIENTE
WHERE DELETADO_EM IS NULL;

/*Como impedir DELETE físico
Deixando o RF23 ainda mais completo, bloqueando o DELETE físico usando uma Trigger*/
CREATE OR REPLACE TRIGGER TRG_BLOQUEAR_DELETE_CLIENTE
BEFORE DELETE ON CLIENTE
BEGIN
    RAISE_APPLICATION_ERROR(
        -20023,
        'Exclusao fisica nao permitida. Utilize a rotina de exclusao logica.'
    );
END;
/

----------Testand0----------
DELETE FROM CLIENTE
WHERE ID_CLI = 100;