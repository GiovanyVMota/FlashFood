const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// --- Conexão com Banco ---
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',      
    password: '30042005gio',     
    database: 'flashfood_db'
});

db.connect(err => {
    if (err) console.error('Erro no MySQL:', err);
    else console.log('MySQL Conectado!');
});

// --- ROTAS DE PRODUTOS ---

// GET (Listar)
app.get('/products', (req, res) => {
    db.query('SELECT * FROM products', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results.map(p => ({...p, id: p.id.toString()})));
    });
});

// POST (Criar)
app.post('/products', (req, res) => {
    const { nome, descricao, preco, categoria, imagemUrl } = req.body;
    const sql = 'INSERT INTO products (nome, descricao, preco, categoria, imagemUrl) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [nome, descricao, preco, categoria, imagemUrl], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ id: result.insertId.toString(), ...req.body });
    });
});

// PUT (Atualizar) - Requisito do PDF
app.put('/products/:id', (req, res) => {
    const { id } = req.params;
    const { nome, descricao, preco, categoria, imagemUrl } = req.body;
    const sql = 'UPDATE products SET nome=?, descricao=?, preco=?, categoria=?, imagemUrl=? WHERE id=?';
    db.query(sql, [nome, descricao, preco, categoria, imagemUrl, id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Atualizado com sucesso' });
    });
});

// DELETE (Remover)
app.delete('/products/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM products WHERE id=?', [id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Deletado com sucesso' });
    });
});

// --- ROTAS DE CLIENTES (Requisito do PDF) ---

// GET Clientes
app.get('/clients', (req, res) => {
    db.query('SELECT * FROM clients', (err, results) => {
        if (err) return res.status(500).send(err);
        res.json(results.map(c => ({...c, id: c.id.toString()})));
    });
});

// POST Clientes
app.post('/clients', (req, res) => {
    const { nome, sobrenome, email, idade, foto } = req.body;
    const sql = 'INSERT INTO clients (nome, sobrenome, email, idade, foto) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [nome, sobrenome, email, idade, foto], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ id: result.insertId.toString(), ...req.body });
    });
});

// PUT Clientes
app.put('/clients/:id', (req, res) => {
    const { id } = req.params;
    const { nome, sobrenome, email, idade, foto } = req.body;
    const sql = 'UPDATE clients SET nome=?, sobrenome=?, email=?, idade=?, foto=? WHERE id=?';
    db.query(sql, [nome, sobrenome, email, idade, foto, id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Cliente atualizado' });
    });
});

// DELETE Clientes
app.delete('/clients/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM clients WHERE id=?', [id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.json({ message: 'Cliente deletado' });
    });
});

app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000 🚀');
});