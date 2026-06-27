CREATE TABLE IF NOT EXISTS `whatsapp_config` (
  `id`           INT(11) AUTO_INCREMENT PRIMARY KEY,
  `instancia`    VARCHAR(80) NOT NULL,
  `apikey`       VARCHAR(200) NOT NULL,
  `base_url`     VARCHAR(200) NOT NULL,
  `status`       ENUM('conectado','desconectado','pendente') DEFAULT 'pendente',
  `atualizado`   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `msg_templates` (
  `id`          INT(11) AUTO_INCREMENT PRIMARY KEY,
  `titulo`      VARCHAR(100) NOT NULL,
  `categoria`   ENUM('Promocao','Informativo','Cobranca','Confirmacao','Lembrete','Satisfacao') NOT NULL,
  `mensagem`    TEXT NOT NULL,
  `variaveis`   VARCHAR(500) NULL,
  `criado_em`   DATETIME DEFAULT CURRENT_TIMESTAMP,
  `atualizado`  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `campanhas` (
  `id`              INT(11) AUTO_INCREMENT PRIMARY KEY,
  `titulo`          VARCHAR(150) NOT NULL,
  `template_id`     INT(11) NOT NULL,
  `segmento`        ENUM('Todos','Grupo') DEFAULT 'Todos',
  `grupo_filtro`    VARCHAR(100) NULL,
  `agendado_para`   DATETIME NULL,
  `status`          ENUM('rascunho','agendado','enviando','concluido','erro') DEFAULT 'rascunho',
  `total_alvos`     INT(11) DEFAULT 0,
  `total_enviados`  INT(11) DEFAULT 0,
  `total_erros`     INT(11) DEFAULT 0,
  `criado_em`       DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `campanhas_log` (
  `id`           INT(11) AUTO_INCREMENT PRIMARY KEY,
  `campanha_id`  INT(11) NOT NULL,
  `cliente_id`   INT(11) NOT NULL,
  `telefone`     VARCHAR(20) NOT NULL,
  `status`       ENUM('enviado','erro') NOT NULL,
  `resposta`     TEXT NULL,
  `enviado_em`   DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `informativos` (
  `id`           INT(11) AUTO_INCREMENT PRIMARY KEY,
  `titulo`       VARCHAR(150) NOT NULL,
  `mensagem`     TEXT NOT NULL,
  `tipo`         ENUM('horario','novo_servico','manutencao','aviso','evento') NOT NULL,
  `agendado`     DATETIME NULL,
  `enviado`      TINYINT(1) DEFAULT 0,
  `criado_em`    DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
