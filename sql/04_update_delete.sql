-- 04_update_delete.sql - SQLite
-- Comandos de atualização e exclusão para testes

-- 1) Atualizar o status de um agendamento para LIBERADO
--    (Exemplo: após o porteiro confirmar a entrada do prestador/visitante)
UPDATE agendamento
SET status = 'LIBERADO'
WHERE id_agendamento = 1;

-- 2) Registrar a saída de uma sessão de acesso
--    (Define a hora de saída e o usuário que registrou)
UPDATE sessao_acesso
SET saida_em = '2025-11-27 12:00',
    id_usuario_saida = 2
WHERE id_sessao = 1;

-- 3) Excluir um veículo específico do cadastro
--    (Por exemplo, se o morador vendeu o carro)
DELETE FROM veiculo
WHERE placa = 'XYZ9Z99';

-- 4) Excluir agendamentos com status CANCELADO
--    (Limpeza de registros que não serão mais usados)
DELETE FROM agendamento
WHERE status = 'CANCELADO';