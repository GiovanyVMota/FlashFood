🍔 FlashFood App — Delivery em Flutter

Disciplina: Desenvolvimento Mobile II
Projeto: Desafio Final

👨‍💻 Integrantes do Grupo

Hiago

Tallis

Marcos

Giovany

📱 Sobre o Projeto

O FlashFood é um aplicativo de delivery desenvolvido em Flutter, utilizando arquitetura MVC, integração completa com API REST e um fluxo completo de autenticação.

A proposta é permitir o gerenciamento de restaurantes e seus produtos, com operações de CRUD para todas as entidades. O app também traz uma interface moderna e focada no usuário, inspirado em grandes apps do mercado como iFood.

🚀 Funcionalidades
🔐 Autenticação

Cadastro e login de usuários

Validação de dados

Persistência no MySQL

🏪 CRUD de Restaurantes

Listagem de restaurantes

Cadastro com validação

Edição completa

Exclusão com confirmação

Exibição em cards com imagem, nota e categoria

🍔 CRUD de Produtos

Produtos filtrados por restaurante

Cadastro com descrição, foto e preço

Atualização de dados

Remoção com confirmação

Campo data_atualizado gerenciado automaticamente pelo banco (timestamp)

🔗 Integração Backend + Banco

API REST em Node.js + Express

Banco MySQL

Rotas GET, POST, PUT, DELETE

Tratamento de erros e respostas padronizadas

🎨 UI/UX

Design moderno e responsivo

Navegação fluida com rotas nomeadas

Animações e feedback visual

Barra inferior de navegação

Componentização das telas

🛠️ Tecnologias Utilizadas
Mobile

Flutter (Dart)

Provider (Gerência de estado)

http

Backend

Node.js

Express

MySQL

Dotenv

⚙️ Como Rodar o Projeto
1️⃣ Configurar o Banco de Dados (MySQL)

No MySQL Workbench ou terminal, execute:

CREATE DATABASE IF NOT EXISTS flashfood_db;
USE flashfood_db;

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);

-- Tabela de Restaurantes
CREATE TABLE IF NOT EXISTS restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    categoria VARCHAR(100),
    email_proprietario VARCHAR(255),
    imagemUrl TEXT,
    nota DECIMAL(2,1) DEFAULT 5.0
);

-- Tabela de Produtos
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(100),
    imagemUrl TEXT,
    restaurant_id INT,
    data_atualizado TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

2️⃣ Iniciar o Backend
cd backend-flashfood
npm install


Crie o arquivo .env:

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=SUA_SENHA_AQUI
DB_NAME=flashfood_db
PORT=3000


Depois execute:

node server.js


Se tudo der certo, aparecerá:

Servidor rodando na porta 3000 🚀

3️⃣ Rodar o App Flutter
flutter pub get
flutter run


Certifique-se de que seu emulador/dispositivo está ativo.

🧪 Roteiro de Teste

Login / Cadastro: Acesse pelo ícone de perfil na Home.

Criar Restaurante: Vá na aba “Restaurantes” → clique no +.

Gerenciar Produtos: Entre no restaurante criado → adicione produtos.

Editar / Excluir: Teste lápis e lixeira para ambos.

Validação: Confira a persistência de dados pelo MySQL Workbench.

📌 Observações

Projeto desenvolvido para fins acadêmicos, cumprindo todos os requisitos da disciplina Desenvolvimento Mobile II.
