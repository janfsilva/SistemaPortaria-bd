-- ========================================
--  SISTEMA DE CONTROLE DE ACESSO DA PORTARIA
-- ========================================

-- ============================================================
--  SCRIPT COMPLETO – EP4 PORTARIA (SQLite)
--  Inclui: DROP + CREATE + INSERT + SELECT + UPDATE + DELETE
--  TOTALMENTE COMENTADO PARA FACILITAR A AVALIAÇÃO
-- ============================================================


-- ------------------------------------------------------------
-- 1) ATIVAR CHAVES ESTRANGEIRAS NO SQLITE
-- ------------------------------------------------------------
-- OBS: No SQLite, as FKs só funcionam se este comando estiver ativo
PRAGMA foreign_keys = ON;


-- ------------------------------------------------------------
-- 2) LIMPEZA: EXCLUI TODAS AS TABELAS (SE EXISTIREM)
-- ------------------------------------------------------------
-- Isso permite rodar o script várias vezes sem erro
DROP TABLE IF EXISTS acesso_evento;
DROP TABLE IF EXISTS sessao_acesso;
DROP TABLE IF EXISTS agendamento;
DROP TABLE IF EXISTS autorizacao;
DROP TABLE IF EXISTS veiculo;
DROP TABLE IF EXISTS usuario_portaria;
DROP TABLE IF EXISTS pessoa;
DROP TABLE IF EXISTS unidade;


-- ------------------------------------------------------------
-- 3) CRIAÇÃO DAS TABELAS DO SISTEMA DE PORTARIA
-- ------------------------------------------------------------

-- ===============================
-- TABELA: unidade
-- Representa cada apartamento ou casa do condomínio
-- ===============================
CREATE TABLE unidade (
  id_unidade INTEGER PRIMARY KEY AUTOINCREMENT,
  bloco      TEXT NOT NULL,
  numero     TEXT NOT NULL,
  titular    TEXT,
  ativa      INTEGER NOT NULL DEFAULT 1,
  UNIQUE(bloco, numero)       -- impede duplicação de unidade
);

-- ===============================
-- TABELA: pessoa
-- Armazena moradores, visitantes e prestadores
-- tipo = MORADOR | VISITANTE | PRESTADOR
-- ===============================
CREATE TABLE pessoa (
  id_pessoa  INTEGER PRIMARY KEY AUTOINCREMENT,
  tipo       TEXT NOT NULL,
  nome       TEXT NOT NULL,
  documento  TEXT,
  telefone   TEXT,
  id_unidade INTEGER,         -- FK apenas para MORADOR
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
);

-- ===============================
-- TABELA: usuario_portaria
-- Armazena os porteiros que registram acessos
-- ===============================
CREATE TABLE usuario_portaria (
  id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
  nome       TEXT NOT NULL,
  login      TEXT NOT NULL UNIQUE,
  senha      TEXT NOT NULL,
  ativo      INTEGER NOT NULL DEFAULT 1
);

-- ===============================
-- TABELA: veiculo
-- Veículos pertencentes às pessoas
-- ===============================
CREATE TABLE veiculo (
  id_veiculo INTEGER PRIMARY KEY AUTOINCREMENT,
  placa      TEXT NOT NULL UNIQUE,
  modelo     TEXT,
  cor        TEXT,
  id_pessoa  INTEGER NOT NULL,        -- dono do veículo
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

-- ===============================
-- TABELA: autorizacao
-- Moradores autorizam visitantes/prestadores a entrar
-- ===============================
CREATE TABLE autorizacao (
  id_autorizacao INTEGER PRIMARY KEY AUTOINCREMENT,
  valido_de      TEXT NOT NULL,
  valido_ate     TEXT NOT NULL,
  observacoes    TEXT,
  id_morador     INTEGER NOT NULL,      -- quem AUTORIZA
  id_autorizado  INTEGER NOT NULL,      -- quem É autorizado
  FOREIGN KEY (id_morador)    REFERENCES pessoa(id_pessoa),
  FOREIGN KEY (id_autorizado) REFERENCES pessoa(id_pessoa)
);

-- ===============================
-- TABELA: agendamento
-- Agendamentos de visitas ou serviços
-- ===============================
CREATE TABLE agendamento (
  id_agendamento  INTEGER PRIMARY KEY AUTOINCREMENT,
  inicio_previsto TEXT NOT NULL,
  fim_previsto    TEXT,
  status          TEXT NOT NULL,        -- PENDENTE | LIBERADO | CANCELADO
  id_unidade      INTEGER NOT NULL,
  id_pessoa       INTEGER NOT NULL,     -- visitante
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  FOREIGN KEY (id_pessoa)  REFERENCES pessoa(id_pessoa)
);

-- ===============================
-- TABELA: sessao_acesso
-- Registra entrada e saída de pessoas/veículos
-- ===============================
CREATE TABLE sessao_acesso (
  id_sessao          INTEGER PRIMARY KEY AUTOINCREMENT,
  entrada_em         TEXT NOT NULL,
  saida_em           TEXT,
  origem             TEXT NOT NULL,     -- MANUAL, QR_CODE etc.
  observacoes        TEXT,
  id_pessoa          INTEGER NOT NULL,
  id_veiculo         INTEGER,
  id_usuario_entrada INTEGER NOT NULL,
  id_usuario_saida   INTEGER,
  FOREIGN KEY (id_pessoa)          REFERENCES pessoa(id_pessoa),
  FOREIGN KEY (id_veiculo)         REFERENCES veiculo(id_veiculo),
  FOREIGN KEY (id_usuario_entrada) REFERENCES usuario_portaria(id_usuario),
  FOREIGN KEY (id_usuario_saida)   REFERENCES usuario_portaria(id_usuario)
);

-- ===============================
-- TABELA: acesso_evento
-- Registro detalhado da passagem (ex: entrada/saída)
-- ===============================
CREATE TABLE acesso_evento (
  id_evento  INTEGER PRIMARY KEY AUTOINCREMENT,
  momento    TEXT NOT NULL,
  direcao    TEXT NOT NULL,       -- ENTRADA | SAIDA
  fonte      TEXT NOT NULL,       -- MANUAL | SISTEMA
  mensagem   TEXT,
  id_sessao  INTEGER NOT NULL,
  id_usuario INTEGER,
  FOREIGN KEY (id_sessao)  REFERENCES sessao_acesso(id_sessao),
  FOREIGN KEY (id_usuario) REFERENCES usuario_portaria(id_usuario)
);


-- ------------------------------------------------------------
-- 4) INSERÇÃO DE DADOS (POVOAMENTO)
-- ------------------------------------------------------------

-- UNIDADES
INSERT INTO unidade (bloco, numero, titular) VALUES 
  ('A','101','João Silva'),
  ('A','102','Maria Souza'),
  ('B','201','Carlos Lima');

-- PESSOAS: moradores
INSERT INTO pessoa (tipo, nome, documento, telefone, id_unidade) VALUES
  ('MORADOR','João Silva','11111111111','11999990001',1),
  ('MORADOR','Maria Souza','22222222222','11999990002',2),
  ('MORADOR','Carlos Lima','33333333333','11999990003',3);

-- PESSOAS: visitantes
INSERT INTO pessoa (tipo, nome, documento, telefone) VALUES
  ('VISITANTE','Pedro Visitante','44444444444','11999990004'),
  ('VISITANTE','Ana Visitante','55555555555','11999990005');

-- USUÁRIOS DA PORTARIA
INSERT INTO usuario_portaria (nome, login, senha) VALUES
  ('Porteiro 1','porteiro1','senha123'),
  ('Porteiro 2','porteiro2','senha123');

-- VEÍCULOS
INSERT INTO veiculo (placa, modelo, cor, id_pessoa) VALUES
  ('ABC1D23','Gol','Prata',1),
  ('XYZ9Z99','Onix','Preto',2);

-- AUTORIZAÇÃO (morador 1 → visitante 4)
INSERT INTO autorizacao (valido_de, valido_ate, observacoes, id_morador, id_autorizado) VALUES
  ('2025-11-27 08:00','2025-11-27 22:00','Visita ao João',1,4);

-- AGENDAMENTO (visitante 5 → unidade 3)
INSERT INTO agendamento (inicio_previsto, fim_previsto, status, id_unidade, id_pessoa) VALUES
  ('2025-11-28 09:00','2025-11-28 12:00','PENDENTE',3,5);

-- SESSÃO DE ACESSO
INSERT INTO sessao_acesso (entrada_em, origem, observacoes, id_pessoa, id_usuario_entrada) VALUES
  ('2025-11-27 10:15','MANUAL','Visitante autorizado pelo João',4,1);

-- EVENTO DA SESSÃO
INSERT INTO acesso_evento (momento,direcao,fonte,mensagem,id_sessao,id_usuario) VALUES
  ('2025-11-27 10:15','ENTRADA','MANUAL','Entrada pela portaria',1,1);


-- ------------------------------------------------------------
-- 5) CONSULTAS (SELECT) PARA TESTES E PRINTS
-- ------------------------------------------------------------

-- 5.1 Lista moradores e suas unidades
SELECT 
  p.id_pessoa,
  p.nome,
  p.telefone,
  u.bloco,
  u.numero
FROM pessoa AS p
JOIN unidade AS u ON u.id_unidade = p.id_unidade
WHERE p.tipo = 'MORADOR';

-- 5.2 Sessões de acesso em aberto
SELECT 
  s.id_sessao,
  p.nome AS pessoa,
  s.entrada_em,
  s.origem,
  u.nome AS porteiro_entrada
FROM sessao_acesso AS s
JOIN pessoa AS p ON p.id_pessoa = s.id_pessoa
JOIN usuario_portaria AS u ON u.id_usuario = s.id_usuario_entrada
WHERE s.saida_em IS NULL;

-- 5.3 Histórico da sessão 1
SELECT 
  e.id_evento,
  e.momento,
  e.direcao,
  e.fonte,
  e.mensagem
FROM acesso_evento AS e
WHERE e.id_sessao = 1
ORDER BY e.momento;

-- 5.4 Próximos agendamentos
SELECT 
  a.id_agendamento,
  a.inicio_previsto,
  a.status,
  p.nome AS visitante,
  u.bloco,
  u.numero
FROM agendamento AS a
JOIN pessoa AS p ON p.id_pessoa = a.id_pessoa
JOIN unidade AS u ON u.id_unidade = a.id_unidade
WHERE a.inicio_previsto >= '2025-01-01'
ORDER BY a.inicio_previsto
LIMIT 10;


-- ------------------------------------------------------------
-- 6) UPDATE E DELETE (MANIPULAÇÃO DE DADOS)
-- ------------------------------------------------------------

-- 6.1 Atualiza status do agendamento 1
UPDATE agendamento
SET status = 'LIBERADO'
WHERE id_agendamento = 1;

-- 6.2 Registra saída da sessão 1
UPDATE sessao_acesso
SET saida_em = '2025-11-27 12:00',
    id_usuario_saida = 2
WHERE id_sessao = 1;

-- 6.3 Remove veículo pela placa
DELETE FROM veiculo
WHERE placa = 'XYZ9Z99';

-- 6.4 Exclui agendamentos CANCELADOS
DELETE FROM agendamento
WHERE status = 'CANCELADO';


-- ================================
-- FIM DO SCRIPT COMPLETO
-- ================================
