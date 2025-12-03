require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '30042005gio',
    database: process.env.DB_NAME || 'flashfood_db'
});

db.connect(err => {
    if (err) console.error('Erro no MySQL:', err);
    else console.log('MySQL Conectado!');
});

// --- RESTAURANTES ---
app.get('/restaurants', (req, res) => {
    db.query('SELECT * FROM restaurants', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results.map(r => ({...r, id: r.id.toString()})));
    });
});

app.post('/restaurants', (req, res) => {
    const { nome, categoria, email, imagemUrl } = req.body;
    const nota = 5.0; 
    const sql = 'INSERT INTO restaurants (nome, categoria, email_proprietario, imagemUrl, nota) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [nome, categoria, email, imagemUrl, nota], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ id: result.insertId.toString(), ...req.body, nota });
    });
});

// --- PRODUTOS ---

// GET Products: Agora aceita ?restaurant_id=X para filtrar
app.get('/products', (req, res) => {
    const { restaurant_id } = req.query;
    let sql = 'SELECT * FROM products';
    let params = [];

    if (restaurant_id) {
        sql += ' WHERE restaurant_id = ?';
        params.push(restaurant_id);
    }

    db.query(sql, params, (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results.map(p => ({...p, id: p.id.toString()})));
    });
});

// POST Products: Agora exige restaurant_id
app.post('/products', (req, res) => {
    const { nome, descricao, preco, categoria, imagemUrl, restaurant_id } = req.body;
    const sql = 'INSERT INTO products (nome, descricao, preco, categoria, imagemUrl, restaurant_id) VALUES (?, ?, ?, ?, ?, ?)';
    db.query(sql, [nome, descricao, preco, categoria, imagemUrl, restaurant_id], (err, result) => {
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
        res.json({ message: 'Produto deletado' });
    });
});


// ==========================================
// --- ROTAS DE AUTENTICAÇÃO (USERS) ---
// ==========================================

// Registrar Usuário
app.post('/register', (req, res) => {
    const { nome, email, senha } = req.body;
    
    // Verifica se email já existe
    db.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length > 0) return res.status(400).json({ message: 'Email já cadastrado!' });

        // Insere novo usuário
        const sql = 'INSERT INTO users (nome, email, senha) VALUES (?, ?, ?)';
        db.query(sql, [nome, email, senha], (err, result) => {
            if (err) return res.status(500).send(err);
            res.json({ 
                id: result.insertId.toString(), 
                nome, 
                email,
                token: 'fake-jwt-token-123'
            });
        });
    });
});

// Fazer Login
app.post('/login', (req, res) => {
    const { email, senha } = req.body;
    
    const sql = 'SELECT * FROM users WHERE email = ? AND senha = ?';
    db.query(sql, [email, senha], (err, results) => {
        if (err) return res.status(500).send(err);
        
        if (results.length > 0) {
            const user = results[0];
            res.json({
                id: user.id.toString(),
                nome: user.nome,
                email: user.email,
                token: 'fake-jwt-token-123'
            });
        } else {
            res.status(401).json({ message: 'Email ou senha inválidos' });
        }
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT} 🚀`);
});