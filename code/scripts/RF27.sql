CREATE OR REPLACE PROCEDURE SP_RELATORIO_RECEITA_CURSOR (
   p_data_inicio   IN DATE,
   p_data_fim      IN DATE,
   p_granularidade IN VARCHAR2
) IS
   CURSOR c_itens IS
      SELECT a.data_atendimento, i.valor_cobrado
      FROM atendimento a
      JOIN atendimento_item i ON a.id_atendimento = i.id_atendimento
      WHERE a.status = 'CONCLUIDO'
        AND a.data_atendimento BETWEEN p_data_inicio AND p_data_fim
      ORDER BY a.data_atendimento;

   v_periodo VARCHAR2(20);
   v_total   NUMBER := 0;
   v_atual   VARCHAR2(20);
BEGIN
   FOR reg IN c_itens LOOP
      -- Define agrupamento conforme granularidade
      IF p_granularidade = 'DIA' THEN
         v_periodo := TO_CHAR(reg.data_atendimento, 'DD/MM/YYYY');
      ELSIF p_granularidade = 'SEMANA' THEN
         v_periodo := 'Semana ' || TO_CHAR(reg.data_atendimento, 'IW');
      ELSIF p_granularidade = 'MES' THEN
         v_periodo := TO_CHAR(reg.data_atendimento, 'MM/YYYY');
      ELSIF p_granularidade = 'ANO' THEN
         v_periodo := TO_CHAR(reg.data_atendimento, 'YYYY');
      END IF;

      -- Se mudou de período, imprime total anterior
      IF v_atual IS NOT NULL AND v_periodo <> v_atual THEN
         DBMS_OUTPUT.PUT_LINE(v_atual || ' - Total: ' || v_total);
         v_total := 0;
      END IF;

      -- Acumula valor
      v_total := v_total + reg.valor_cobrado;
      v_atual := v_periodo;
   END LOOP;

   -- Imprime último período
   IF v_atual IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(v_atual || ' - Total: ' || v_total);
   END IF;
END;
/
