# MAPOS-ORIXIOS

Fork do [Map-OS](https://github.com/RamonSilva20/mapos) v4.53.2 com integrações de pagamento via Mercado Pago e notificações WhatsApp via Whaapi.

## Funcionalidades Adicionais

### Pagamentos
- **Mercado Pago Checkout Pro** — Geração de preferências de pagamento via SDK oficial `PreferenceClient`. Suporte a PIX, Cartão de Crédito e Boleto em uma única tela de checkout.
- **Boleto direto** — Geração de boleto sem redirecionamento.
- **Confirmação manual** — Botão "Atualizar" na tela da cobrança para confirmar pagamento (sem webhook IPN).

### WhatsApp (Whaapi)
- Notificações automáticas via [Whaapi](https://whaapi.com) self-hosted em Docker.
- **Templates disponíveis:**
  | ID | Template | Gatilho |
  |----|----------|---------|
  | 7 | Cadastro de Cliente | Manual no cadastro |
  | 8 | OS Iniciada | Manual na tela da OS |
  | 9 | OS Finalizada | Automático ao gerar cobrança |
  | 12 | Lembrete de Cobrança | Manual na cobrança |
  | 13 | Pagamento Confirmado | Automático ao confirmar |
- Todos os templates em português (PT-BR UTF-8), sem emojis.

### Módulos Novos
- **Campanhas em Massa** — Disparo de campanhas promocionais segmentadas por cidade ou para todos os clientes. Suporte a agendamento.
- **Módulo de Técnicos** — Cadastro de técnicos/colaboradores com histórico de ordens de serviço.
- **Módulo de Informativos** — Envio de comunicados em lote.

### Melhorias
- **CPF no Emitente** — Campo `cpf` adicionado à tabela `emitente`. Aceita CPF ou CNPJ.
- **Razão Social opcional** — Não obrigatório no cadastro do emitente.
- **CPF nas impressões** — 13 telas de impressão exibem CPF quando CNPJ está vazio.
- **Ícones SVG** — Boxicons nos cabeçalhos das views (ícones vetoriais modernos).
- **CSRF reforçado** — Proteção habilitada por padrão, tokens regenerados a cada requisição.

## Requisitos

- PHP >= 8.4 (testado com 8.4.22)
- MySQL >= 5.7 ou MariaDB >= 10.3
- Composer >= 2
- Docker (para o Whaapi)
- XAMPP ou outro servidor local

## Instalação

### 1. Clonar e configurar

```bash
git clone https://github.com/FelipeMzero/MAPOS-ORIXIOS.git
cd MAPOS-ORIXIOS
composer install --no-dev
```

### 2. Configurar ambiente

```bash
cp application/.env.example application/.env
```

Edite `application/.env` com suas credenciais:

```env
APP_BASEURL="http://localhost:8080/"
APP_ENCRYPTION_KEY="sua-chave-aqui"
APP_ENVIRONMENT="development"

DB_HOSTNAME="localhost"
DB_USERNAME="root"
DB_PASSWORD=""
DB_DATABASE="mapos"

MERCADO_PAGTO_ACCESS_TOKEN="APP_USR-xxxxxxxx"
MERCADO_PAGTO_PUBLIC_KEY="APP_USR-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

### 3. Instalar via navegador

Acesse `http://localhost:8080/` e siga o assistente de instalação.

### 4. Configurar CSRF

Em **Configurações > Sistema**:
- CSRF Protection: **Sim**
- Regenerar Token: **Sim**

## WhatsApp (Whaapi)

### Subir o Docker

```bash
cd docker
cp .env.whaapi.example .env.whaapi
# Edite o .env.whaapi se necessário (padrão já funciona para local)
docker compose -f docker-compose.whaapi.yml up -d
```

O Whaapi ficará em `http://localhost:3005`.

### Criar instância no sistema

1. Acesse **Configurações > WhatsApp**.
2. Preencha:
   - **Base URL:** `http://localhost:3005`
   - **Instância:** `Loja`
   - **API Key:** `mapos-whaapi-local-key`
3. Clique em **Salvar Configurações**.
4. Na seção "Criar Instância", clique em **Criar Instância**.
5. Escaneie o QR Code exibido com o WhatsApp do seu negócio.

> **Importante:** Se o container Docker for reiniciado, a sessão do WhatsApp é perdida. Será necessário recriar a instância e escanear o QR Code novamente. Os dados de sessão ficam em volumes Docker (`whaapi_instances`).

### Templates de mensagem

Os templates são gerenciados em **Configurações > Templates Msg**. O sistema já vem com 7 templates pré-cadastrados (IDs 7 a 13).

**Placeholders disponíveis:**
- `{nome_cliente}` — Nome do cliente
- `{empresa}` — Nome da empresa (emitente)
- `{num_os}` — Número da OS
- `{tecnico}` — Nome do técnico
- `{data_hora}` — Data/hora de abertura
- `{valor}` — Valor total
- `{link_cobranca}` — Link de pagamento

**Nota:** Para campanhas em massa (template 11 - Promoção), use apenas `{nome_cliente}` e `{empresa}`.

## Mercado Pago

### Credenciais

1. Acesse [Mercado Pago Developers](https://www.mercadopago.com.br/developers).
2. Crie ou acesse sua aplicação.
3. Copie o **Access Token** (production) e a **Public Key**.
4. Adicione ao `.env`:

```env
MERCADO_PAGTO_ACCESS_TOKEN=APP_USR-1234567890-123456
MERCADO_PAGTO_PUBLIC_KEY=APP_USR-12345678-1234-1234-1234-123456789012
```

### Configurar gateway

1. Acesse **Configurações > Pagamentos**.
2. Marque apenas **MercadoPago** como ativo.
3. Configure os métodos de pagamento:
   - **Checkout (PIX / Cartão / Boleto)** — Redireciona para o checkout do Mercado Pago
   - **Boleto** — Gera boleto direto (sem redirect)

### Como usar

1. Crie uma Ordem de Serviço.
2. Na tela da OS, clique em **Faturar**.
3. O sistema gera uma cobrança no Mercado Pago e exibe o link de pagamento.
4. O link é enviado automaticamente por WhatsApp ao cliente (template OS Finalizada).
5. Para confirmar o pagamento, vá em **Cobranças**, clique em **Atualizar** na cobrança desejada.
6. Ao confirmar, o sistema envia notificação de **Pagamento Confirmado** por WhatsApp.

> **Nota:** Não há webhook IPN configurado. A confirmação é manual pelo botão "Atualizar".

## Estrutura do Projeto

```
application/
├── .env                    # Configurações locais (gitignorado)
├── config/
│   ├── payment_gateways.php  # Gateways ativos
│   ├── config.php
│   └── database.php
├── controllers/
│   ├── Campanhas.php         # Campanhas em massa
│   ├── Cobrancas.php         # Cobranças + Mercado Pago
│   ├── Cron.php              # Tarefas agendadas
│   ├── Informativos.php      # Informativos
│   ├── Tecnicos.php          # Técnicos
│   ├── Templates.php         # Templates WhatsApp
│   └── Whatsapp.php          # Configuração Whaapi
├── libraries/
│   ├── Gateways/
│   │   ├── BasePaymentGateway.php
│   │   ├── MercadoPago.php
│   │   └── Contracts/PaymentGateway.php
│   └── Whaapi.php            # Cliente Whaapi
├── models/
│   ├── Campanhas_model.php
│   ├── Cobrancas_model.php
│   ├── Tecnicos_model.php
│   ├── Templates_model.php
│   └── Whatsapp_model.php
└── views/
    ├── campanhas/            # Views de campanhas
    ├── informativos/         # Views de informativos
    ├── tecnicos/             # Views de técnicos
    ├── templates/            # Views de templates
    └── whatsapp/             # Configuração Whaapi
docker/
├── docker-compose.whaapi.yml   # Docker Compose do Whaapi
├── .env.whaapi.example         # Template de config
└── whaapi/                     # Submodule Whaapi
```

## Comandos Úteis

### Docker Whaapi

```bash
# Iniciar
docker compose -f docker-compose.whaapi.yml up -d

# Parar
docker compose -f docker-compose.whaapi.yml down

# Ver logs
docker compose -f docker-compose.whaapi.yml logs -f

# Reiniciar
docker compose -f docker-compose.whaapi.yml restart
```

### Git

```bash
# Clonar com submódulos
git clone --recurse-submodules https://github.com/FelipeMzero/MAPOS-ORIXIOS.git

# Atualizar submódulo Whaapi
git submodule update --init --recursive
```

### PHP / Composer

```bash
# Instalar dependências
composer install --no-dev

# Atualizar banco de dados
php index.php tools migrate
```

## Licença

Apache 2.0 — veja o arquivo [LICENSE](LICENSE) para detalhes.

---

*Projeto baseado no [Map-OS](https://github.com/RamonSilva20/mapos) v4.53.2 de Ramon Silva.*
