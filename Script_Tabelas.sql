CREATE TABLE utilizador (
    utilizador_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    isAdmin Boolean NOT NULL,
    data_registo TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categoria (
    categoria_id SERIAL PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE produto (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    categoria_id INT NOT NULL,
    quantidade_em_stock INT NOT NULL,
    data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categoria(categoria_id)
);

CREATE TABLE encomenda (
    encomenda_id SERIAL PRIMARY KEY,
    utilizador_id INT NOT NULL,
	morada VARCHAR(100)NOT NULL,
    data_encomenda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL,  -- "pendente", "enviada", "entregue"
    FOREIGN KEY (utilizador_id) REFERENCES utilizador(utilizador_id)
);

CREATE TABLE fatura (
    fatura_id SERIAL PRIMARY KEY,
    encomenda_id INT NOT NULL,
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (encomenda_id) REFERENCES encomenda(encomenda_id)
);

CREATE TABLE itens_encomenda (
    encomenda_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_total DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (encomenda_id, produto_id),
    FOREIGN KEY (encomenda_id) REFERENCES encomenda(encomenda_id),
    FOREIGN KEY (produto_id) REFERENCES produto(produto_id)
);

CREATE TABLE fornecedor (
    fornecedor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100),
    endereco TEXT
);

CREATE TABLE requisicao_produto (
    requisicao_id SERIAL PRIMARY KEY,
    fornecedor_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    data_requisicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_rececao TIMESTAMP,
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(fornecedor_id),
    FOREIGN KEY (produto_id) REFERENCES produto(produto_id)
);

CREATE TABLE fatura_fornecedor (
    fatura_fornecedor_id SERIAL PRIMARY KEY,
    fornecedor_id INT NOT NULL,
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(fornecedor_id)
);
