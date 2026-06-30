CREATE OR REPLACE PROCEDURE SP_RELATORIO_SERVICOS (
   p_data_inicio IN DATE,
   p_data_fim    IN DATE
) IS
   CURSOR c_servicos IS
      SELECT s.id_serv,
             s.nome_servico,
             i.valor_cobrado
      FROM atendimento a
      JOIN atendimento_item i ON a.id_atendimento = i.id_atendimento
      JOIN servico s ON i.id_serv = s.id_serv
      WHERE a.status = 'CONCLUIDO'
        AND a.deletado = 'N'
        AND i.deletado = 'N'
        AND a.data_atendimento BETWEEN p_data_inicio AND p_data_fim
      ORDER BY s.id_serv;

   v_id_serv       NUMBER;
   v_nome_servico  VARCHAR2(100);
   v_total         NUMBER := 0;
   v_qtd           NUMBER := 0;
   v_atual_serv    NUMBER;
BEGIN
   FOR reg IN c_servicos LOOP
      -- Se mudou de serviço, imprime resultado anterior
      IF v_atual_serv IS NOT NULL AND reg.id_serv <> v_atual_serv THEN
         DBMS_OUTPUT.PUT_LINE(v_nome_servico || ' | Qtd: ' || v_qtd || ' | Total: ' || v_total);
         v_total := 0;
         v_qtd := 0;
      END IF;

      -- Acumula valores
      v_total := v_total + reg.valor_cobrado;
      v_qtd   := v_qtd + 1;
      v_nome_servico := reg.nome_servico;
      v_atual_serv   := reg.id_serv;
   END LOOP;

   -- Imprime último serviço
   IF v_atual_serv IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(v_nome_servico || ' | Qtd: ' || v_qtd || ' | Total: ' || v_total);
   END IF;
END;
/
