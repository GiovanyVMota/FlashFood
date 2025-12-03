# FlashFood App 🍔🍟

**Disciplina:** Desenvolvimento Mobile II
**Entrega:** Desafio Final

---

## 👨‍💻 Integrantes do Grupo
* **Hiago**
* **Tallis**
* **Marcos**
* **Giovany**

---

## 📱 Sobre o Projeto
O **FlashFood** é uma aplicação de delivery desenvolvida em Flutter, criada para demonstrar uma arquitetura robusta (MVC) e a integração completa entre um aplicativo móvel e uma API RESTful.

O objetivo principal é permitir a gestão de restaurantes e seus cardápios, oferecendo funcionalidades de **CRUD completo** (Criar, Ler, Atualizar e Deletar) para as entidades principais, além de um sistema de autenticação e uma interface moderna focada na experiência do usuário (UX).

---

## 🚀 Funcionalidades

O projeto atende a todos os requisitos do desafio final:

### 1. Gestão de Restaurantes (CRUD)
* **Listagem:** Visualização dos restaurantes disponíveis na tela principal.
* **Cadastro:** Adição de novos estabelecimentos com validação de formulário.
* **Edição:** Atualização de dados cadastrais (nome, categoria, imagem).
* **Remoção:** Exclusão de restaurantes do banco de dados.

### 2. Gestão de Produtos (CRUD)
* **Cardápio Dinâmico:** Os produtos são filtrados e exibidos especificamente para o restaurante selecionado.
* **Cadastro de Itens:** Adição de produtos com foto, descrição e preço.
* **Atualização:** Edição de detalhes do produto.
* **Exclusão:** Remoção de itens do cardápio.
* **Atualização Automática:** O campo `data_atualizado` é gerido automaticamente pelo banco de dados (Timestamp).

### 3. Integração Backend & Banco de Dados
* **API REST:** Comunicação via HTTP (GET, POST, PUT, DELETE).
* **Persistência:** Banco de dados MySQL para armazenar usuários, restaurantes e produtos.
* **Autenticação:** Fluxo de Login e Cadastro de usuários.

### 4. Interface (UI/UX)
* **Design Moderno:** Interface inspirada em apps de mercado (ex: iFood).
* **Feedback Visual:** Indicadores de carregamento, mensagens de sucesso/erro e diálogos de confirmação.
* **Navegação Fluida:** Uso de rotas nomeadas e barra de navegação inferior.

---

## 🛠️ Tecnologias Utilizadas

* **Mobile:** Flutter (Dart)
* **Gerência de Estado:** Provider
* **Backend:** Node.js (Express)
* **Banco de Dados:** MySQL
* **Http Client:** Pacote `http`

---

## ⚙️ Como Executar o Projeto

Siga os passos abaixo para rodar a aplicação em seu ambiente local.

### Passo 1: Configurar o Banco de Dados
1. Abra o **MySQL Workbench** (ou seu terminal MySQL).
2. Crie o banco de dados e as tabelas executando o script SQL completo abaixo:

```sql
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
Passo 2: Iniciar o Backend
Abra o terminal e navegue até a pasta do servidor:

Bash

cd backend-flashfood
Instale as dependências:

Bash

npm install
Crie um arquivo chamado .env dentro da pasta backend-flashfood com as configurações do seu MySQL:

Snippet de código

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=SUA_SENHA_DO_MYSQL
DB_NAME=flashfood_db
PORT=3000
Inicie o servidor:

Bash

node server.js
Você deve ver a mensagem: "Servidor rodando na porta 3000 🚀"

Passo 3: Executar o Aplicativo Mobile
Em outro terminal, navegue para a raiz do projeto Flutter:

Bash

cd ..
Instale as dependências do Flutter:

Bash

flutter pub get
Execute o aplicativo (certifique-se de ter um emulador aberto ou dispositivo conectado):

Bash

flutter run
🧪 Roteiro de Teste (Para Avaliação)
Autenticação: Na tela inicial, clique no ícone de perfil e crie uma conta ou faça login.

Criar Restaurante: Vá na aba "Restaurantes", clique no + e adicione um novo local.

Gerenciar Cardápio: Clique no restaurante criado. Dentro dele, adicione novos produtos.

Editar/Excluir: Utilize os botões de lápis e lixeira para testar a edição e remoção tanto de restaurantes quanto de produtos.

Verificação: Confira no MySQL Workbench se os dados foram persistidos corretamente.

Projeto desenvolvido para fins acadêmicos.
