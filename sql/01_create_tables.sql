-- 01_create_tables.sql - SQLite
-- Criação das tabelas do sistema de controle de acesso da portaria

-- Tabela de unidades do condomínio (apartamentos / casas)
CREATE TABLE unidade (
  id_unidade INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador único da unidade
  bloco      TEXT NOT NULL,                     -- bloco ou torre (ex: A, B, Torre 1)
  numero     TEXT NOT NULL,                     -- número da unidade (ex: 101, 202)
  titular    TEXT,                              -- nome do morador titular da unidade
  ativa      INTEGER NOT NULL DEFAULT 1,        -- 1 = unidade ativa, 0 = inativa
  UNIQUE(bloco, numero)                         -- garante que não existam duas unidades iguais (bloco+numero)
);

-- Tabela de pessoas (moradores, visitantes, prestadores)
CREATE TABLE pessoa (
  id_pessoa  INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador único da pessoa
  tipo       TEXT NOT NULL,                     -- tipo da pessoa: MORADOR, VISITANTE, PRESTADOR
  nome       TEXT NOT NULL,                     -- nome completo da pessoa
  documento  TEXT,                              -- RG / CPF / documento da pessoa
  telefone   TEXT,                              -- telefone de contato
  id_unidade INTEGER,                           -- unidade associada (para moradores)
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade) -- vínculo com a tabela UNIDADE
);

-- Tabela de usuários do sistema (porteiros / funcionários)
CREATE TABLE usuario_portaria (
  id_usuario INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador do usuário do sistema
  nome       TEXT NOT NULL,                     -- nome do porteiro/funcionário
  login      TEXT NOT NULL UNIQUE,              -- login utilizado no sistema (não pode repetir)
  senha      TEXT NOT NULL,                     -- senha (texto simples aqui para fins acadêmicos)
  ativo      INTEGER NOT NULL DEFAULT 1         -- 1 = ativo, 0 = desativado
);

-- Tabela de veículos cadastrados na portaria
CREATE TABLE veiculo (
  id_veiculo INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador do veículo
  placa      TEXT NOT NULL UNIQUE,              -- placa do veículo (deve ser única)
  modelo     TEXT,                              -- modelo (ex: Gol, Onix)
  cor        TEXT,                              -- cor do veículo
  id_pessoa  INTEGER NOT NULL,                  -- dono do veículo (referência à tabela PESSOA)
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

-- Tabela de autorizações de entrada (morador autoriza outra pessoa)
CREATE TABLE autorizacao (
  id_autorizacao INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador da autorização
  valido_de      TEXT NOT NULL,                     -- data/hora de início da validade
  valido_ate     TEXT NOT NULL,                     -- data/hora de fim da validade
  observacoes    TEXT,                              -- campo livre para observações gerais
  id_morador     INTEGER NOT NULL,                  -- morador que autorizou
  id_autorizado  INTEGER NOT NULL,                  -- pessoa autorizada (visitante/prestador)
  FOREIGN KEY (id_morador)    REFERENCES pessoa(id_pessoa),
  FOREIGN KEY (id_autorizado) REFERENCES pessoa(id_pessoa)
);

-- Tabela de agendamentos de visitas e serviços
CREATE TABLE agendamento (
  id_agendamento  INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador do agendamento
  inicio_previsto TEXT NOT NULL,                     -- data/hora prevista de início
  fim_previsto    TEXT,                              -- data/hora prevista de fim
  status          TEXT NOT NULL,                     -- status: PENDENTE, LIBERADO, CANCELADO...
  id_unidade      INTEGER NOT NULL,                  -- unidade que receberá a visita/serviço
  id_pessoa       INTEGER NOT NULL,                  -- visitante/prestador agendado
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  FOREIGN KEY (id_pessoa)  REFERENCES pessoa(id_pessoa)
);

-- Tabela de sessões de acesso (entrada e saída de uma pessoa)
CREATE TABLE sessao_acesso (
  id_sessao          INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador da sessão
  entrada_em         TEXT NOT NULL,                     -- data/hora da entrada
  saida_em           TEXT,                              -- data/hora da saída (pode ser nulo se ainda estiver dentro)
  origem             TEXT NOT NULL,                     -- origem do registro (MANUAL, QR, etc.)
  observacoes        TEXT,                              -- observações sobre a sessão
  id_pessoa          INTEGER NOT NULL,                  -- pessoa que entrou
  id_veiculo         INTEGER,                           -- veículo usado (se houver)
  id_usuario_entrada INTEGER NOT NULL,                  -- usuário que registrou a entrada
  id_usuario_saida   INTEGER,                           -- usuário que registrou a saída
  FOREIGN KEY (id_pessoa)          REFERENCES pessoa(id_pessoa),
  FOREIGN KEY (id_veiculo)         REFERENCES veiculo(id_veiculo),
  FOREIGN KEY (id_usuario_entrada) REFERENCES usuario_portaria(id_usuario),
  FOREIGN KEY (id_usuario_saida)   REFERENCES usuario_portaria(id_usuario)
);

-- Tabela de eventos dentro de uma sessão (entradas/saídas, logs)
CREATE TABLE acesso_evento (
  id_evento  INTEGER PRIMARY KEY AUTOINCREMENT, -- identificador do evento
  momento    TEXT NOT NULL,                     -- data/hora do evento
  direcao    TEXT NOT NULL,                     -- ENTRADA, SAIDA, OUTRO
  fonte      TEXT NOT NULL,                     -- origem (MANUAL, QR, etc.)
  mensagem   TEXT,                              -- descrição do que aconteceu
  id_sessao  INTEGER NOT NULL,                  -- sessão à qual o evento pertence
  id_usuario INTEGER,                           -- usuário que registrou este evento (opcional)
  FOREIGN KEY (id_sessao)  REFERENCES sessao_acesso(id_sessao),
  FOREIGN KEY (id_usuario) REFERENCES usuario_portaria(id_usuario)
);