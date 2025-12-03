# FlashFood App

**Disciplina:** Desenvolvimento Mobile II
**Entrega:** Desafio Final

## 👨‍💻 Integrantes do Grupo
* **Hiago**
* **Tallis**
* **Marcos**
* **Giovany**

---

## 📱 Sobre o Projeto
O **FlashFood** é um aplicativo de delivery desenvolvido em Flutter, projetado para demonstrar uma arquitetura robusta e integração completa com um backend. O projeto permite a gestão de múltiplos restaurantes e seus respectivos cardápios, oferecendo uma experiência visual moderna e fluida.

O aplicativo cumpre todos os requisitos do desafio final, implementando um modelo MVC, gerência de estado com Provider e persistência de dados em MySQL.

---

## 🚀 Funcionalidades

### 1. CRUD de Restaurantes (Clientes)
Substituímos a entidade "Clientes" por "Restaurantes" para melhor se adequar ao contexto de um app de delivery, mantendo a complexidade exigida.
* **Criar:** Cadastro de novos restaurantes com validação de campos.
* **Ler:** Listagem visual de restaurantes na aba principal.
* **Editar:** Atualização de dados (nome, categoria, imagem) existente.
* **Excluir:** Remoção física do registro no banco de dados.

### 2. CRUD de Produtos
Gestão completa dos itens do cardápio dentro de cada restaurante.
* **Criar:** Adição de novos pratos vinculados automaticamente ao restaurante.
* **Ler:** Filtragem automática de produtos por restaurante.
* **Editar:** Alteração de preço, descrição e imagem.
* **Excluir:** Remoção de itens do cardápio.
* **Campo Automático:** O campo `data_atualizado` é gerido automaticamente pelo banco de dados (MySQL Timestamp).

### 3. Interface e UX
* **Home Page Moderna:** Banner estilo "iFood", carrossel de ofertas e seletor de "Entrega/Retirada".
* **Navegação:** Uso de `BottomNavigationBar` e rotas nomeadas.
* **Feedback:** Indicadores de carregamento (`CircularProgressIndicator`) e mensagens de sucesso/erro (`SnackBars` e `Dialogs`).

---

## 🛠️ Tecnologias Utilizadas
* **Frontend:** Flutter (Dart)
* **Backend:** Node.js (Express)
* **Banco de Dados:** MySQL
* **Gerência de Estado:** Provider
* **Comunicação API:** Http

---

## ⚙️ Como Executar o Projeto

Siga os passos abaixo para rodar a aplicação em seu ambiente local.

### Passo 1: Configurar o Banco de Dados
1. Abra o **MySQL Workbench** ou seu terminal MySQL.
2. Crie o banco de dados e as tabelas executando o script SQL abaixo:

```sql
CREATE DATABASE IF NOT EXISTS flashfood_db;
USE flashfood_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    categoria VARCHAR(100),
    email_proprietario VARCHAR(255),
    imagemUrl TEXT,
    nota DECIMAL(2,1) DEFAULT 5.0
);

CREATE TABLE products (
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
Passo 2: Iniciar o Backend (Servidor)
Navegue até a pasta do servidor:

Bash

cd backend-flashfood
Instale as dependências (caso ainda não tenha feito):

Bash

npm install
Crie um arquivo .env na pasta backend-flashfood com suas credenciais:

Snippet de código

DB_HOST=localhost
DB_USER=root
DB_PASSWORD=SUA_SENHA_AQUI
DB_NAME=flashfood_db
PORT=3000
Inicie o servidor:

Bash

node server.js
Você verá a mensagem: "Servidor rodando na porta 3000 🚀"

Passo 3: Executar o App Mobile
Volte para a raiz do projeto e instale as dependências do Flutter:

Bash

flutter pub get
Execute o aplicativo (Chrome, Emulador Android ou iOS):

Bash

flutter run