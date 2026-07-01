CREATE OR REPLACE PROCEDURE SP_ABRIR_AGENDAMENTO (
   p_id_atendimento   IN NUMBER,
   p_cliente_id       IN NUMBER
) IS
BEGIN
   -- Inserir atendimento
   INSERT INTO ATENDIMENTO (ID_ATENDIMENTO, DATA_ATENDIMENTO, CLIENTE_ID)
   VALUES (p_id_atendimento, SYSDATE, p_cliente_id);

   -- Inserir itens vinculados
   INSERT INTO ATENDIMENTO_ITEM (ID_ITEM, ID_ATENDIMENTO, DESCRICAO, VALOR)
   VALUES (1, p_id_atendimento, 'Corte de cabelo', 100);

   INSERT INTO ATENDIMENTO_ITEM (ID_ITEM, ID_ATENDIMENTO, DESCRICAO, VALOR)
   VALUES (2, p_id_atendimento, 'Manicure', 80);

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Erro: transação desfeita.');
END;
/
