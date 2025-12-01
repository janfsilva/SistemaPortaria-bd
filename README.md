# EP4 – Sistema de Controle de Acesso da Portaria (SQLite)

Este repositório contém os scripts desenvolvidos para a **Experiência Prática 4** da disciplina  
**Modelagem de Banco de Dados** – Curso: *Análise e Desenvolvimento de Sistemas (Cruzeiro do Sul)*.

O projeto implementa, em SQLite, o banco de dados de um sistema de controle de acesso para a portaria de um condomínio residencial, incluindo criação, povoamento, consultas e manipulação de dados.

---

# 📦 Estrutura do Repositório 

   portaria-db/
│
├── 📄 script_completo.sql
│
├── 📁 sql/
│   ├── 📄 01_create_tables.sql
│   ├── 📄 02_insert_exemplos.sql
│   ├── 📄 03_select_consultas.sql
│   └── 📄 04_update_delete.sql
│
└── 📁 docs/
    ├── 📁 prints/        (prints reais do SQLiteStudio)
    └── 📁 diagramas/     (opcional)


---

# 🗄 Banco de Dados Utilizado

- **SGBD:** SQLite  
- **Ferramenta Cliente:** SQLiteStudio  
- **Arquitetura:** Modelo Relacional baseado no Modelo Lógico da EP3  
- **Integridade:** Chaves estrangeiras ON (`PRAGMA foreign_keys = ON;`)

---

# 🧱 1. CREATE TABLE (01_create_tables.sql)

Arquivo responsável por **criar TODAS as tabelas** do banco, contendo:

- Chaves primárias (`PRIMARY KEY AUTOINCREMENT`)
- Chaves estrangeiras com integridade
- Restrições `UNIQUE` e `NOT NULL`
- Nomes de tabelas padronizados

Tabelas criadas:

1. `unidade`
2. `pessoa`
3. `usuario_portaria`
4. `veiculo`
5. `autorizacao`
6. `agendamento`
7. `sessao_acesso`
8. `acesso_evento`

---

# 🧪 2. INSERT de Dados (02_insert_exemplos.sql)

Arquivo com dados de exemplo coerentes com o minimundo da portaria:

- 3 unidades
- 3 moradores
- 2 visitantes
- 2 porteiros
- 2 veículos
- Autorizações
- Agendamentos
- Sessão de acesso
- Evento de acesso

Esses dados permitem testar completamente todas as consultas e manipulações pedidas.

---

# 🔍 3. Consultas (03_select_consultas.sql)

Este arquivo contém consultas utilizando:

- `SELECT`
- `JOIN`
- `WHERE`
- `ORDER BY`
- `LIMIT`

Consultas incluídas:

1. Listar moradores e suas unidades
2. Consultar sessões de acesso em aberto
3. Exibir histórico de eventos por sessão
4. Listar próximos agendamentos previstos

Essas consultas são essenciais para demonstrar que o banco foi criado e povoado corretamente.

---

# ✏️ 4. Atualizações e Exclusões (04_update_delete.sql)

Arquivo contendo comandos solicitados na EP4:

- Atualização de status de um agendamento (`UPDATE`)
- Registro de saída de sessão (`UPDATE`)
- Exclusão de veículo (`DELETE`)
- Exclusão de agendamentos cancelados (`DELETE`)

Cada comando foi  executado separadamente para capturar os prints exigidos.

---

# ▶ Como Executar (Passo a Passo no SQLiteStudio)

1. Abra o **SQLiteStudio**  
2. Crie um banco novo (ex.: `portaria_ep4.db`)
3. Abra o editor SQL  
4. Execute **na ordem**:

### ✔ 1º – `01_create_tables.sql`
Cria todas as tabelas.  
**Tirar print:** lista de tabelas no painel esquerdo.

### ✔ 2º – `02_insert_exemplos.sql`
Popula as tabelas.  
**Tirar print:** mensagem "X rows affected" ou SELECT mostrando os dados.

### ✔ 3º – `03_select_consultas.sql`
Executar **cada SELECT separadamente**.  
**Tirar print:** cada tabela exibida na área inferior.

### ✔ 4º – `04_update_delete.sql`
Executar cada comando.  
**Tirar print:** mensagem "1 row affected".

---

# 📸 Prints solicitados:

1. **Print das tabelas criadas**  
2. **Print dos INSERTs executados**  
3. **Print dos SELECTs funcionando**  
4. **Print do UPDATE funcionando**  
5. **Print do DELETE funcionando**

Todos esses prints estão anexados na pasta `/docs/prints/`.

---

# 👤 Autor

**Nome:** Janailsonm F Silva 
**RA:** 45584834 
**Curso:** Análise e Desenvolvimento de Sistemas  
**Instituição:** Cruzeiro do Sul  
**Disciplina:** Modelagem de Banco de Dados  
**Experiência Prática:** EP4 – Implementação e Manipulação de Dados  

---

# 📌 Observação Final

Todos os scripts foram desenvolvidos de acordo com:  

- Modelo Conceitual (DER) da EP2  
- Modelo Lógico (EP3)  
- Minimundo e regras do domínio da portaria  

O banco foi projetado para funcionar plenamente no SQLiteStudio.

