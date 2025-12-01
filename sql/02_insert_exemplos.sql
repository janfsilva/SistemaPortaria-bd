-- 02_insert_exemplos.sql - SQLite
-- População inicial de dados para testes do sistema de portaria

-- Inserindo unidades do condomínio
INSERT INTO unidade (bloco, numero, titular) VALUES 
  ('A','101','João Silva'),
  ('A','102','Maria Souza'),
  ('B','201','Carlos Lima');

-- Inserindo pessoas do tipo MORADOR, já associadas às unidades
INSERT INTO pessoa (tipo, nome, documento, telefone, id_unidade) VALUES
  ('MORADOR','João Silva','11111111111','11999990001',1),
  ('MORADOR','Maria Souza','22222222222','11999990002',2),
  ('MORADOR','Carlos Lima','33333333333','11999990003',3);

-- Inserindo pessoas do tipo VISITANTE (sem unidade vinculada)
INSERT INTO pessoa (tipo, nome, documento, telefone) VALUES
  ('VISITANTE','Pedro Visitante','44444444444','11999990004'),
  ('VISITANTE','Ana Visitante','55555555555','11999990005');

-- Inserindo usuários do sistema (porteiros)
INSERT INTO usuario_portaria (nome, login, senha) VALUES
  ('Porteiro 1','porteiro1','senha123'),
  ('Porteiro 2','porteiro2','senha123');

-- Inserindo veículos cadastrados (associados a moradores)
INSERT INTO veiculo (placa, modelo, cor, id_pessoa) VALUES
  ('ABC1D23','Gol','Prata',1),   -- veículo do João
  ('XYZ9Z99','Onix','Preto',2);  -- veículo da Maria

-- Inserindo uma autorização (João autoriza Pedro a entrar no condomínio)
INSERT INTO autorizacao (valido_de, valido_ate, observacoes, id_morador, id_autorizado) VALUES
  ('2025-11-27 08:00','2025-11-27 22:00','Visita ao João',1,4);

-- Inserindo um agendamento de visita (técnico indo à unidade 201)
INSERT INTO agendamento (inicio_previsto, fim_previsto, status, id_unidade, id_pessoa) VALUES
  ('2025-11-28 09:00','2025-11-28 12:00','PENDENTE',3,5);

-- Inserindo uma sessão de acesso (Pedro entrando para visitar João)
INSERT INTO sessao_acesso (entrada_em, origem, observacoes, id_pessoa, id_usuario_entrada) VALUES
  ('2025-11-27 10:15','MANUAL','Visitante autorizado pelo João',4,1);

-- Inserindo um evento de acesso para essa sessão (registro de entrada)
INSERT INTO acesso_evento (momento, direcao, fonte, mensagem, id_sessao, id_usuario) VALUES
  ('2025-11-27 10:15','ENTRADA','MANUAL','Entrada pela portaria',1,1);