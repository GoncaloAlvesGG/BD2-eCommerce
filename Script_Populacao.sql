--Utilizadores
SELECT sp_Utilizador_CREATE('ADMIN', 'admin@email.com', '$2b$12$/BUdwox8/uCqXzUEcNEXRuC7AYha.yRROaOpUwJxWPVRC28SRZX7W', TRUE);
SELECT sp_Utilizador_CREATE('Maria Oliveira', 'maria.oliveira@email.com', '$2b$12$IanHwoPLyQEVPKtEhKEkL.Id7VhSDnjwqFgYfaC/v6JdCDnWXW5V.', FALSE);
SELECT sp_Utilizador_CREATE('Carlos Santos', 'carlos.santos@email.com', '$2b$12$FUoFiAgdG3cbfVPzn9zmJevo1RJP2LV/qCfIErgcdf36QnHI/uALm', FALSE);
SELECT sp_Utilizador_CREATE('Ana Ferreira', 'ana.ferreira@email.com', '$2b$12$ReRoGwuL26ub8qApk9PAw.TOHfYDnlyGbYiODVY06BPjdOOZCamD6', FALSE);
SELECT sp_Utilizador_CREATE('Bruno Costa', 'bruno.costa@email.com', '$2b$12$X1gJjIELs8n6Itq0trCOV.K3CQ9m2EsRfbm1IT8Sm4wTWMWzovYDW', FALSE);
SELECT sp_Utilizador_CREATE('Carla Mendes', 'carla.mendes@email.com', '$2b$12$9xYNjGDT4FWkM9Z41OYzguuyhs8i7cDx4q/jBs/3CM80.zNOxiFB2', FALSE);

--Categorias
SELECT sp_Categoria_CREATE('Smartphones');
SELECT sp_Categoria_CREATE('Laptops');
SELECT sp_Categoria_CREATE('Periféricos');
SELECT sp_Categoria_CREATE('Componentes de PC');
SELECT sp_Categoria_CREATE('Monitores');

--Produtos
SELECT sp_Produto_CREATE('iPhone 14', 'Smartphone da Apple com 128GB', 999.99, 1, 50);
SELECT sp_Produto_CREATE('Samsung Galaxy S23', 'Smartphone Android com 256GB', 899.99, 1, 40);
SELECT sp_Produto_CREATE('MacBook Air M2', 'Laptop ultraleve da Apple', 1299.99, 2, 20);
SELECT sp_Produto_CREATE('Dell XPS 13', 'Ultrabook com processador Intel i7', 1399.99, 2, 15);
SELECT sp_Produto_CREATE('Teclado Mecânico RGB', 'Teclado mecânico para gamers', 79.99, 3, 100);
SELECT sp_Produto_CREATE('RTX 4080', 'Placa gráfica de alto desempenho', 1499.99, 4, 10);
SELECT sp_Produto_CREATE('Monitor LG Ultrawide', 'Monitor 34 polegadas 144Hz', 499.99, 5, 25);
SELECT sp_Produto_CREATE('Google Pixel 7', 'Smartphone Google com Android puro', 799.99, 1, 30);
SELECT sp_Produto_CREATE('Xiaomi Mi 13', 'Smartphone Xiaomi com Snapdragon 8 Gen 2', 699.99, 1, 50);
SELECT sp_Produto_CREATE('Lenovo ThinkPad X1 Carbon', 'Ultrabook empresarial leve e potente', 1499.99, 2, 20);
SELECT sp_Produto_CREATE('Acer Predator Helios 300', 'Laptop gamer com RTX 4060', 1399.99, 2, 15);
SELECT sp_Produto_CREATE('Mouse Logitech G Pro', 'Mouse gamer sem fio ultraleve', 129.99, 3, 60);
SELECT sp_Produto_CREATE('Cadeira Gamer DXRacer', 'Cadeira ergonômica para longas sessões de jogo', 249.99, 3, 20);
SELECT sp_Produto_CREATE('Intel Core i9-13900K', 'Processador topo de linha da Intel', 599.99, 4, 15);
SELECT sp_Produto_CREATE('Corsair Vengeance 32GB DDR5', 'Memória RAM DDR5 para alto desempenho', 169.99, 4, 40);
SELECT sp_Produto_CREATE('ASUS ROG Swift 360Hz', 'Monitor gamer 24.5" 360Hz para eSports', 699.99, 5, 10);
SELECT sp_Produto_CREATE('Dell UltraSharp U2723QE', 'Monitor 27" 4K IPS com cores precisas', 599.99, 5, 15);
SELECT sp_Produto_CREATE('Samsung Odyssey G9', 'Monitor ultrawide curvo 49" QHD 240Hz', 1499.99, 5, 5);
SELECT sp_Produto_CREATE('AOC 24G2', 'Monitor gamer 24" 144Hz acessível', 199.99, 5, 30);


--Fornecedores
SELECT sp_Fornecedor_CREATE('TechSupplier', '+351912345678', 'Rua da Tecnologia, 123, Lisboa');
SELECT sp_Fornecedor_CREATE('GadgetWorld', '+351967891234', 'Avenida dos Eletrónicos, Porto');
SELECT sp_Fornecedor_CREATE('PC Parts Inc.', '+351923456789', 'Rua dos Computadores, Braga');
SELECT sp_Fornecedor_CREATE('TechDistribuidora', 'tech@distribuidora.com', 'Rua Tecnológica, 101, Lisboa');
SELECT sp_Fornecedor_CREATE('PC Parts Express', 'contacto@pcparts.com', 'Avenida Hardware, 202, Porto');
SELECT sp_Fornecedor_CREATE('Gamer Supply', 'suporte@gamersupply.com', 'Rua dos Gamers, 303, Braga');
SELECT sp_Fornecedor_CREATE('Smartphone World', 'info@smartworld.com', 'Centro Empresarial, 404, Coimbra');

--Requisição de Produtos
SELECT sp_RequisicaoProduto_CREATE(1, 1, 20, '2024-02-08 10:00:00');
SELECT sp_RequisicaoProduto_CREATE(2, 3, 10, '2024-02-07 15:30:00');
SELECT sp_RequisicaoProduto_CREATE(3, 6, 5, '2024-02-06 12:45:00');
SELECT sp_RequisicaoProduto_CREATE(1, 1, 20, '2025-02-10 10:00:00'); -- Google Pixel 7
SELECT sp_RequisicaoProduto_CREATE(1, 2, 15, '2025-02-10 10:30:00'); -- Xiaomi Mi 13
SELECT sp_RequisicaoProduto_CREATE(2, 6, 25, '2025-02-11 09:00:00'); -- Headset HyperX Cloud II
SELECT sp_RequisicaoProduto_CREATE(2, 9, 10, '2025-02-11 09:15:00'); -- Intel Core i9-13900K
SELECT sp_RequisicaoProduto_CREATE(3, 10, 12, '2025-02-12 14:00:00'); -- AMD Ryzen 9 7950X
SELECT sp_RequisicaoProduto_CREATE(3, 12, 30, '2025-02-12 14:30:00'); -- Corsair Vengeance 32GB DDR5
SELECT sp_RequisicaoProduto_CREATE(4, 3, 18, '2025-02-13 11:00:00'); -- OnePlus 11
SELECT sp_RequisicaoProduto_CREATE(4, 15, 8, '2025-02-13 11:20:00'); -- Samsung Odyssey G9


--Faturas Fornecedores
SELECT sp_FaturaFornecedor_CREATE(1, 19999.80);
SELECT sp_FaturaFornecedor_CREATE(2, 12999.90);
SELECT sp_FaturaFornecedor_CREATE(4, 7499.95);
SELECT sp_FaturaFornecedor_CREATE(1, 15999.80); -- Pixel 7 + Xiaomi Mi 13
SELECT sp_FaturaFornecedor_CREATE(1, 5249.85); -- Xiaomi Mi 13
SELECT sp_FaturaFornecedor_CREATE(2, 2499.75); -- Headset HyperX Cloud II
SELECT sp_FaturaFornecedor_CREATE(2, 5999.90); -- Intel Core i9-13900K
SELECT sp_FaturaFornecedor_CREATE(3, 6599.88); -- AMD Ryzen 9 7950X
SELECT sp_FaturaFornecedor_CREATE(3, 5099.70); -- Corsair Vengeance 32GB DDR5
SELECT sp_FaturaFornecedor_CREATE(4, 13139.82); -- OnePlus 11
SELECT sp_FaturaFornecedor_CREATE(4, 11999.92); -- Samsung Odyssey G9

--Encomendas
SELECT sp_Encomenda_Com_Itens_CREATE(
    2, 
    'Rua das Flores, 123, Porto',
    'pendente',
    '[{"produto_id": 1, "quantidade": 2}, {"produto_id": 3, "quantidade": 1}]'::JSON
);

SELECT sp_Encomenda_Com_Itens_CREATE(
    3, 
    'Avenida Central, 456, Braga',
    'enviada',
    '[{"produto_id": 2, "quantidade": 1}, {"produto_id": 5, "quantidade": 3}, {"produto_id": 6, "quantidade": 1}]'::JSON
);

SELECT sp_Encomenda_Com_Itens_CREATE(
    1,
    'Praça do Comércio, 789, Lisboa',
    'pendente',
    '[{"produto_id": 4, "quantidade": 1}, {"produto_id": 7, "quantidade": 2}]'::JSON
);
-- Encomenda 1 (2 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(1, 'Rua das Flores, 123, Lisboa', 'enviada', 
    '[{"produto_id": 1, "quantidade": 1}, {"produto_id": 6, "quantidade": 2}]');

-- Encomenda 2 (1 produto)
SELECT sp_Encomenda_Com_Itens_CREATE(2, 'Avenida Central, 456, Porto', 'pendente', 
    '[{"produto_id": 2, "quantidade": 1}]');

-- Encomenda 3 (3 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(3, 'Travessa do Comércio, 789, Braga', 'enviada', 
    '[{"produto_id": 3, "quantidade": 2}, {"produto_id": 12, "quantidade": 1}, {"produto_id": 9, "quantidade": 1}]');

-- Encomenda 4 (1 produto)
SELECT sp_Encomenda_Com_Itens_CREATE(1, 'Rua da Liberdade, 321, Coimbra', 'pendente', 
    '[{"produto_id": 9, "quantidade": 1}]');

-- Encomenda 5 (4 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(2, 'Estrada Nova, 555, Faro', 'enviada', 
    '[{"produto_id": 6, "quantidade": 3}, {"produto_id": 9, "quantidade": 1}, {"produto_id": 10, "quantidade": 1}, {"produto_id": 3, "quantidade": 2}]');

-- Encomenda 6 (2 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(3, 'Alameda das Tecnologias, 678, Lisboa', 'pendente', 
    '[{"produto_id": 10, "quantidade": 2}, {"produto_id": 12, "quantidade": 2}]');

-- Encomenda 7 (3 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(1, 'Praça do Comércio, 987, Porto', 'enviada', 
    '[{"produto_id": 1, "quantidade": 1}, {"produto_id": 5, "quantidade": 2}, {"produto_id": 7, "quantidade": 1}]');

-- Encomenda 8 (1 produto)
SELECT sp_Encomenda_Com_Itens_CREATE(2, 'Rua do Comércio, 222, Braga', 'pendente', 
    '[{"produto_id": 15, "quantidade": 1}]');

-- Encomenda 9 (4 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(3, 'Avenida Digital, 333, Coimbra', 'enviada', 
    '[{"produto_id": 4, "quantidade": 2}, {"produto_id": 11, "quantidade": 1}, {"produto_id": 14, "quantidade": 3}, {"produto_id": 13, "quantidade": 1}]');

-- Encomenda 10 (2 produtos)
SELECT sp_Encomenda_Com_Itens_CREATE(1, 'Largo dos Eletrônicos, 444, Faro', 'pendente', 
    '[{"produto_id": 8, "quantidade": 2}, {"produto_id": 9, "quantidade": 1}]');





