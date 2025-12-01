-- 03_select_consultas.sql - SQLite
-- Consultas para análise e demonstração do banco da portaria

-- 1) Listar todos os moradores com sua unidade (bloco e número)
SELECT 
  p.id_pessoa,
  p.nome,
  p.telefone,
  u.bloco,
  u.numero
FROM pessoa p
JOIN unidade u ON u.id_unidade = p.id_unidade
WHERE p.tipo = 'MORADOR';

-- 2) Listar todas as sessões de acesso em aberto (sem data de saída)
SELECT 
  s.id_sessao,
  p.nome     AS pessoa,
  s.entrada_em,
  s.origem,
  u.nome     AS porteiro_entrada
FROM sessao_acesso s
JOIN pessoa          p ON p.id_pessoa = s.id_pessoa
JOIN usuario_portaria u ON u.id_usuario = s.id_usuario_entrada
WHERE s.saida_em IS NULL;

-- 3) Histórico de eventos de uma sessão específica (ex.: sessão 1)
SELECT 
  e.id_evento,
  e.momento,
  e.direcao,
  e.fonte,
  e.mensagem
FROM acesso_evento e
WHERE e.id_sessao = 1
ORDER BY e.momento;

-- 4) Próximos agendamentos a partir de uma data de corte
SELECT 
  a.id_agendamento,
  a.inicio_previsto,
  a.status,
  p.nome AS visitante,
  u.bloco,
  u.numero
FROM agendamento a
JOIN pessoa  p ON p.id_pessoa   = a.id_pessoa
JOIN unidade u ON u.id_unidade  = a.id_unidade
WHERE a.inicio_previsto >= '2025-01-01'
ORDER BY a.inicio_previsto
LIMIT 10;