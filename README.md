# Sistema de Gestão para Salão de Beleza 💇‍♀️💅

## 📖 Sobre o Projeto

Este projeto foi desenvolvido para a disciplina de Banco de Dados e tem como objetivo implementar um sistema de gerenciamento para um salão de beleza utilizando **Oracle Database** e **PL/SQL**.

O sistema permite o cadastro e gerenciamento de clientes, profissionais, funções, serviços e atendimentos, além da implementação de regras de negócio diretamente na camada de banco de dados através de **Stored Procedures**, **Triggers**, **Constraints**, **Roles** e **Transações**.

---

## 🎯 Objetivos

* Aplicar conceitos de modelagem relacional.
* Implementar regras de negócio na camada de banco de dados.
* Garantir integridade, consistência e segurança dos dados.
* Utilizar recursos avançados do Oracle como PL/SQL, Procedures e Triggers.

---

## 🛠 Tecnologias Utilizadas

* Oracle Database XE
* Oracle SQL Developer
* Visual Studio Code
* PL/SQL
* SQL

---

## 🗂 Estrutura do Banco de Dados

O sistema é composto pelas seguintes entidades:

* CLIENTE
* PROFISSIONAL
* FUNCAO
* PROFISSIONAL_FUNCAO
* SERVICO
* ATENDIMENTO
* ATENDIMENTO_ITEM
* ITEM_PROFISSIONAL

---

## 📋 Requisitos Funcionais Implementados

### RF13 - Cadastro obrigatório de função para profissionais

Ao cadastrar um profissional, o sistema garante automaticamente a associação com pelo menos uma função, evitando profissionais ociosos.

**Implementação:** Stored Procedure.

---

### RF14 - Validação da capacitação do profissional

Antes de associar um profissional a um serviço, o sistema verifica se ele possui a capacitação necessária para executá-lo.

**Implementação:** Trigger com erro personalizado.

---

### RF19 - Antecedência mínima para agendamentos

Novos atendimentos somente podem ser agendados com pelo menos duas horas de antecedência em relação ao horário atual.

**Implementação:** Stored Procedure `PR_CRIAR_ATENDIMENTO`.

---

### RF20 - Cancelamento automático de agendamentos expirados

Uma rotina periódica verifica atendimentos com status `AGENDADO` cujo horário de início expirou há mais de 30 minutos e realiza o cancelamento automático.

**Implementação:** Stored Procedure e Job Scheduler do Oracle.

---

### RF22 - Atomicidade na finalização de atendimentos

A alteração do status para `CONCLUIDO` e o processamento financeiro ocorrem em uma única transação, garantindo consistência dos dados.

**Implementação:** Stored Procedure com controle transacional.

---

### RF23 - Exclusão lógica (Soft Delete)

Nenhuma informação é removida fisicamente do banco de dados. O sistema registra a data e hora da exclusão utilizando o campo `DELETADO_EM`.

**Implementação:** Stored Procedures e atualizações controladas.

---

### RF24 - Segurança da camada de dados

Usuários comuns não possuem permissão para executar comandos diretos de manipulação de dados (`INSERT`, `UPDATE` e `DELETE`) nas tabelas.

O acesso é realizado exclusivamente através de Procedures autorizadas.

**Implementação:** Roles e privilégios do Oracle.

---

## 🔒 Segurança

O sistema utiliza:

* Roles específicas para cada tipo de usuário.
* Controle de privilégios.
* Restrição de manipulação direta das tabelas.
* Execução controlada através de Procedures.

---

## ▶️ Como Executar

1. Instale o Oracle Database XE.
2. Crie as tabelas do projeto.
3. Execute os scripts de criação das Constraints.
4. Execute os scripts das Stored Procedures e Triggers.
5. Execute os scripts de testes disponibilizados no projeto.

---

## 👥 Equipe

* Mariana Sales de Oliveira Lazarini
* Maria Eduarda
* João
* Yago
* Stephany

---

## 📚 Conceitos Aplicados

* Modelagem Relacional
* Integridade Referencial
* Constraints
* Stored Procedures
* Triggers
* Transações
* Controle de Concorrência
* Segurança em Banco de Dados
* Soft Delete
* Oracle Scheduler

---

## 📄 Licença

Este projeto foi desenvolvido exclusivamente para fins acadêmicos.
