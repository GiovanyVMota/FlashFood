require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// --- Conexão com Banco de Dados Segura (via .env) ---
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect(err => {
    if (err) console.error('Erro no MySQL:', err);
    else {
        console.log('MySQL Conectado!');
        initTables();
    }
});

// Inicializa as tabelas do sistema
function initTables() {
    // 1. Tabela de Usuários (Para Login)
    const tableUsers = `
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(255) NOT NULL,
            email VARCHAR(255) NOT NULL UNIQUE,
            senha VARCHAR(255) NOT NULL,
            foto VARCHAR(500)
        )
    `;
    
    // 2. Tabela de Restaurantes (Cadastro de Parceiros)
    const tableRestaurants = `
        CREATE TABLE IF NOT EXISTS restaurants (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(255) NOT NULL,
            categoria VARCHAR(255) NOT NULL,
            email_proprietario VARCHAR(255) NOT NULL,
            imagemUrl VARCHAR(500),
            nota DOUBLE DEFAULT 5.0
        )
    `;

    // 3. Tabela de Produtos (Se não existir)
    const tableProducts = `
        CREATE TABLE IF NOT EXISTS products (
            id INT AUTO_INCREMENT PRIMARY KEY,
            nome VARCHAR(255) NOT NULL,
            descricao TEXT,
            preco DECIMAL(10,2) NOT NULL,
            categoria VARCHAR(255),
            imagemUrl VARCHAR(500),
            data_atualizado DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    `;

    db.query(tableUsers);
    db.query(tableRestaurants);
    db.query(tableProducts);
}

// --- ROTAS DE AUTENTICAÇÃO (USUÁRIOS) ---

// Registro de Usuário
app.post('/register', (req, res) => {
    const { nome, email, senha } = req.body;
    const sql = 'INSERT INTO users (nome, email, senha) VALUES (?, ?, ?)';
    db.query(sql, [nome, email, senha], (err, result) => {
        if (err) return res.status(500).send({ error: 'Erro ao registrar. Email pode já existir.' });
        res.json({ id: result.insertId, nome, email });
    });
});

// Login de Usuário
app.post('/login', (req, res) => {
    const { email, senha } = req.body;
    const sql = 'SELECT id, nome, email, foto FROM users WHERE email = ? AND senha = ?';
    db.query(sql, [email, senha], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length > 0) {
            res.json(results[0]); // Retorna os dados do usuário
        } else {
            res.status(401).json({ error: 'Credenciais inválidas' });
        }
    });
});

// --- ROTAS DE RESTAURANTES ---

app.get('/restaurants', (req, res) => {
    db.query('SELECT * FROM restaurants', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results.map(r => ({...r, id: r.id.toString()})));
    });
});

app.post('/restaurants', (req, res) => {
    const { nome, categoria, email, imagemUrl } = req.body;
    // Define imagem padrão se vazia
    const imgFinal = imagemUrl || 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=500&q=80';
    
    const sql = 'INSERT INTO restaurants (nome, categoria, email_proprietario, imagemUrl) VALUES (?, ?, ?, ?)';
    db.query(sql, [nome, categoria, email, imgFinal], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ id: result.insertId.toString(), nome, categoria, email, imagemUrl: imgFinal });
    });
});

// --- ROTAS DE PRODUTOS ---

app.get('/products', (req, res) => {
    db.query('SELECT * FROM products', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results.map(p => ({...p, id: p.id.toString()})));
    });
});

app.post('/products', (req, res) => {
    const { nome, descricao, preco, categoria, imagemUrl } = req.body;
    const sql = 'INSERT INTO products (nome, descricao, preco, categoria, imagemUrl) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [nome, descricao, preco, categoria, imagemUrl], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ id: result.insertId.toString(), ...req.body });
    });
});

app.put('/products/:id', (req, res) => {
    const { id } = req.params;
    const { nome, descricao, preco, categoria, imagemUrl } = req.body;
    const sql = 'UPDATE products SET nome=?, descricao=?, preco=?, categoria=?, imagemUrl=? WHERE id=?';
    db.query(sql, [nome, descricao, preco, categoria, imagemUrl, id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Produto atualizado' });
    });
});

app.delete('/products/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM products WHERE id=?', [id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Produto removido' });
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT} 🚀`);
});