----------Bloquear acesso direto as tabelas----------
CREATE ROLE C##ROLE_APLICACAO; ---por estar sendo codado no vscode, e estar conectado ao CDB$ROOT, então precisa fazer

----------dar permissão de executar as procedures----------
GRANT EXECUTE
ON PR_CADASTRAR_PROFISSIONAL
TO C##ROLE_APLICACAO;

GRANT EXECUTE
ON PR_CRIAR_ATENDIMENTO
TO C##ROLE_APLICACAO;

----------Se a procedure existir----------
GRANT EXECUTE
ON PR_FINALIZAR_ATENDIMENTO
TO C##ROLE_APLICACAO;

----------criar o usuário da aplicação----------
CREATE USER C##APP_USER
IDENTIFIED BY "123456";

----------permitindo o login----------
GRANT CREATE SESSION TO C##APP_USER;

----------associar o role ao usuário ----------
GRANT C##ROLE_APLICACAO
TO C##APP_USER;

/*não foi testado a desconexão e conexão com outro usuário.