--CRUD
--Utilizador
--Inserir Utilizador
CREATE OR REPLACE FUNCTION sp_Utilizador_CREATE(
    p_nome VARCHAR,
    p_email VARCHAR,
    p_senha VARCHAR,
    p_isAdmin BOOLEAN
) RETURNS VOID AS $$
BEGIN
    -- Verificar se o e-mail já existe
    IF EXISTS (SELECT 1 FROM utilizador WHERE email = p_email) THEN
        RAISE EXCEPTION 'Erro: O email já está em uso.';
    END IF;

    -- Tentativa de inserção na tabela utilizador
    BEGIN
        INSERT INTO utilizador (nome, email, senha, isAdmin)
        VALUES (p_nome, p_email, p_senha, p_isAdmin);
    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturar a exceção
            RAISE EXCEPTION 'Erro na inserção do utilizador: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Ler Utilizador
CREATE OR REPLACE FUNCTION sp_Utilizador_READ(
    p_utilizador_id INT
) RETURNS TABLE(utilizador_id INT, nome VARCHAR, email VARCHAR, isAdmin BOOLEAN) AS $$
BEGIN
    RETURN QUERY
    SELECT u.utilizador_id, u.nome, u.email, u.isAdmin
    FROM utilizador u
    WHERE u.utilizador_id = p_utilizador_id;
END
$$ LANGUAGE plpgsql;

--Atualizar Utilizador
CREATE OR REPLACE FUNCTION sp_Utilizador_UPDATE(
    p_utilizador_id INT,
    p_nome VARCHAR,
    p_email VARCHAR,
    p_senha VARCHAR DEFAULT NULL,  
    p_isAdmin BOOLEAN DEFAULT NULL  
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE utilizador
        SET 
            nome = p_nome,
            email = p_email,
            senha = COALESCE(p_senha, senha),  
            isAdmin = COALESCE(p_isAdmin, isAdmin)  
        WHERE utilizador_id = p_utilizador_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização do utilizador: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;



--Eliminar Utilizador
CREATE OR REPLACE FUNCTION sp_Utilizador_DELETE(
    p_utilizador_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM utilizador
        WHERE utilizador_id = p_utilizador_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão do utilizador: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Categoria
--Inserir Categoria
CREATE OR REPLACE FUNCTION sp_Categoria_CREATE(
    p_nome VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela categoria
    BEGIN
        INSERT INTO categoria (nome)
        VALUES (p_nome);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturar a exceção
            RAISE EXCEPTION 'Erro na inserção da categoria: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Ler Categoria
CREATE OR REPLACE FUNCTION sp_Categoria_READ(
    p_categoria_id INT
) RETURNS TABLE(categoria_id INT, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT c.categoria_id, c.nome
    FROM categoria c
    WHERE c.categoria_id = p_categoria_id;
END
$$ LANGUAGE plpgsql;

--Update Categoria
CREATE OR REPLACE FUNCTION sp_Categoria_UPDATE(
    p_categoria_id INT,
    p_nome VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de atualização na tabela categoria
    BEGIN
        UPDATE categoria
        SET nome = p_nome
        WHERE categoria_id = p_categoria_id;

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturar a exceção
            RAISE EXCEPTION 'Erro na atualização da categoria: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Categoria
CREATE OR REPLACE FUNCTION sp_Categoria_DELETE(
    p_categoria_id INT
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de exclusão na tabela categoria
    BEGIN
        DELETE FROM categoria
        WHERE categoria_id = p_categoria_id;

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturar a exceção
            RAISE EXCEPTION 'Erro na exclusão da categoria: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Produto
--Inserir Produto
CREATE OR REPLACE FUNCTION sp_Produto_CREATE(
    p_nome VARCHAR,
    p_descricao TEXT,
    p_preco DECIMAL,
    p_categoria_id INT,
    p_quantidade_em_stock INT
) RETURNS INT AS $$
DECLARE
    v_produto_id INT;
BEGIN
    -- Tentativa de inserção na tabela produto
    BEGIN
        INSERT INTO produto (nome, descricao, preco, categoria_id, quantidade_em_stock)
        VALUES (p_nome, p_descricao, p_preco, p_categoria_id, p_quantidade_em_stock)
        RETURNING produto_id INTO v_produto_id; -- Captura o ID do produto inserido

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção do produto: %', SQLERRM;
    END;

    -- Retorna o id do produto criado
    RETURN v_produto_id;
END;
$$ LANGUAGE plpgsql;

--Selecionar Produto
CREATE OR REPLACE FUNCTION sp_Produto_READ(
    p_produto_id INT
) RETURNS TABLE(produto_id INT, nome VARCHAR, descricao TEXT, preco DECIMAL, categoria_id INT, quantidade_em_stock INT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.produto_id, p.nome, p.descricao, p.preco, p.categoria_id, p.quantidade_em_stock
    FROM produto p
    WHERE p.produto_id = p_produto_id;
END
$$ LANGUAGE plpgsql;

--Atualizar Produto
CREATE OR REPLACE FUNCTION sp_Produto_UPDATE(
    p_produto_id INT,
    p_nome VARCHAR,
    p_descricao TEXT,
    p_preco DECIMAL,
    p_categoria_id INT,
    p_quantidade_em_stock INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE produto
        SET nome = p_nome, descricao = p_descricao, preco = p_preco, categoria_id = p_categoria_id, quantidade_em_stock = p_quantidade_em_stock
        WHERE produto_id = p_produto_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização do produto: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Produto
CREATE OR REPLACE FUNCTION sp_Produto_DELETE(
    p_produto_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM produto
        WHERE produto_id = p_produto_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão do produto: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Encomenda
--Inserir Encomenda
CREATE OR REPLACE FUNCTION sp_Encomenda_CREATE(
    p_utilizador_id INT,
    p_morada VARCHAR,
    p_estado VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela encomenda
    BEGIN
        INSERT INTO encomenda (utilizador_id, morada, estado)
        VALUES (p_utilizador_id, p_morada, p_estado);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção da encomenda: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Ler encomenda
CREATE OR REPLACE FUNCTION sp_Encomenda_READ(
    p_encomenda_id INT
) RETURNS TABLE(encomenda_id INT, utilizador_id INT, morada VARCHAR, data_encomenda TIMESTAMP, estado VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT e.encomenda_id, e.utilizador_id, e.morada, e.data_encomenda, e.estado
    FROM encomenda e
    WHERE e.encomenda_id = p_encomenda_id;
END
$$ LANGUAGE plpgsql;

--Atualizar encomenda
CREATE OR REPLACE FUNCTION sp_Encomenda_UPDATE(
    p_encomenda_id INT,
    p_utilizador_id INT,
    p_morada VARCHAR,
    p_estado VARCHAR
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE encomenda
        SET utilizador_id = p_utilizador_id, morada = p_morada, estado = p_estado
        WHERE encomenda_id = p_encomenda_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização da encomenda: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Encomenda
CREATE OR REPLACE FUNCTION sp_Encomenda_DELETE(
    p_encomenda_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM encomenda
        WHERE encomenda_id = p_encomenda_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão da encomenda: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Fatura
--Inserir Fatura
CREATE OR REPLACE FUNCTION sp_Fatura_CREATE(
    p_encomenda_id INT,
    p_valor_total DECIMAL
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela fatura
    BEGIN
        INSERT INTO fatura (encomenda_id, valor_total)
        VALUES (p_encomenda_id, p_valor_total);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção da fatura: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Selecionar Fatura
CREATE OR REPLACE FUNCTION sp_Fatura_READ(
    p_fatura_id INT
) RETURNS TABLE(fatura_id INT, encomenda_id INT, data_emissao TIMESTAMP, valor_total DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT f.fatura_id, f.encomenda_id, f.data_emissao, f.valor_total
    FROM fatura f
    WHERE f.fatura_id = p_fatura_id;
END
$$ LANGUAGE plpgsql;

--Atualizar Fatura
CREATE OR REPLACE FUNCTION sp_Fatura_UPDATE(
    p_fatura_id INT,
    p_valor_total DECIMAL
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE fatura
        SET valor_total = p_valor_total
        WHERE fatura_id = p_fatura_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização da fatura: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Fatura
CREATE OR REPLACE FUNCTION sp_Fatura_DELETE(
    p_fatura_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM fatura
        WHERE fatura_id = p_fatura_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão da fatura: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Itens_Encomenda
--Inserir Itens_Encomenda

CREATE OR REPLACE FUNCTION sp_ItensEncomenda_CREATE(
    p_encomenda_id INT,
    p_produto_id INT,
    p_quantidade INT
) RETURNS VOID AS $$
DECLARE
    v_preco_unitario DECIMAL;
    v_preco_total DECIMAL;
BEGIN
    -- Obter o preço unitário do produto
    SELECT preco 
    INTO v_preco_unitario
    FROM produto
    WHERE produto_id = p_produto_id;

    -- Calcular o preço total
    v_preco_total := v_preco_unitario * p_quantidade;

    -- Inserir o item na tabela itens_encomenda
    INSERT INTO itens_encomenda (encomenda_id, produto_id, quantidade, preco_total)
    VALUES (p_encomenda_id, p_produto_id, p_quantidade, v_preco_total);

EXCEPTION
    WHEN OTHERS THEN
        -- Captura de erro genérico
        RAISE EXCEPTION 'Erro na inserção do item da encomenda: %', SQLERRM;
END
$$ LANGUAGE plpgsql;


--Selecionar Itens_Encomenda
CREATE OR REPLACE FUNCTION sp_ItensEncomenda_READ(
    p_encomenda_id INT,
    p_produto_id INT
) RETURNS TABLE(encomenda_id INT, produto_id INT, quantidade INT, preco_total DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT ie.encomenda_id, ie.produto_id, ie.quantidade, ie.preco_total
    FROM itens_encomenda ie
    WHERE ie.encomenda_id = p_encomenda_id
      AND ie.produto_id = p_produto_id;
END
$$ LANGUAGE plpgsql;

--Atualizar Itens_Encomenda
CREATE OR REPLACE FUNCTION sp_ItensEncomenda_UPDATE(
    p_encomenda_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_preco_total DECIMAL
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE itens_encomenda
        SET quantidade = p_quantidade,
            preco_total = p_preco_total
        WHERE encomenda_id = p_encomenda_id
          AND produto_id = p_produto_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização do item de encomenda: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Itens_Encomenda
CREATE OR REPLACE FUNCTION sp_ItensEncomenda_DELETE(
    p_encomenda_id INT,
    p_produto_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM itens_encomenda
        WHERE encomenda_id = p_encomenda_id
          AND produto_id = p_produto_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão do item de encomenda: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Fornecedor
--Inserir Fornecedor

CREATE OR REPLACE FUNCTION sp_Fornecedor_CREATE(
    p_nome VARCHAR,
    p_contato VARCHAR,
    p_endereco TEXT
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela fornecedor
    BEGIN
        INSERT INTO fornecedor (nome, contato, endereco)
        VALUES (p_nome, p_contato, p_endereco);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção do fornecedor: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Selecionar Fornecedor
CREATE OR REPLACE FUNCTION sp_Fornecedor_READ(
    p_fornecedor_id INT
) RETURNS TABLE(fornecedor_id INT, nome VARCHAR, contato VARCHAR, endereco TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT f.fornecedor_id, f.nome, f.contato, f.endereco
    FROM fornecedor f
    WHERE f.fornecedor_id = p_fornecedor_id;
END
$$ LANGUAGE plpgsql;

--Atualizar Fornecedor
CREATE OR REPLACE FUNCTION sp_Fornecedor_UPDATE(
    p_fornecedor_id INT,
    p_nome VARCHAR,
    p_contato VARCHAR,
    p_endereco TEXT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE fornecedor
        SET nome = p_nome,
            contato = p_contato,
            endereco = p_endereco
        WHERE fornecedor_id = p_fornecedor_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização do fornecedor: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Fornecedor
CREATE OR REPLACE FUNCTION sp_Fornecedor_DELETE(
    p_fornecedor_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM fornecedor
        WHERE fornecedor_id = p_fornecedor_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão do fornecedor: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;


--Requisicao_Produto
--Inserir Requisicao_Produto
CREATE OR REPLACE FUNCTION sp_RequisicaoProduto_CREATE(
    p_fornecedor_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_data_rececao TIMESTAMP
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela requisicao_produto
    BEGIN
        INSERT INTO requisicao_produto (fornecedor_id, produto_id, quantidade, data_rececao)
        VALUES (p_fornecedor_id, p_produto_id, p_quantidade, p_data_rececao);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção da requisição de produto: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Selecionar Requisicao_Produto
CREATE OR REPLACE FUNCTION sp_RequisicaoProduto_READ(
    p_requisicao_id INT
) RETURNS TABLE(requisicao_id INT, fornecedor_id INT, produto_id INT, quantidade INT, data_requisicao TIMESTAMP, data_rececao TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT r.requisicao_id, r.fornecedor_id, r.produto_id, r.quantidade, r.data_requisicao, r.data_rececao
    FROM requisicao_produto r
    WHERE r.requisicao_id = p_requisicao_id;
END
$$ LANGUAGE plpgsql;

--Atualizar Requisicao_Produto
CREATE OR REPLACE FUNCTION sp_RequisicaoProduto_UPDATE(
    p_requisicao_id INT,
    p_fornecedor_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_data_rececao TIMESTAMP
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE requisicao_produto
        SET fornecedor_id = p_fornecedor_id,
            produto_id = p_produto_id,
            quantidade = p_quantidade,
            data_rececao = p_data_rececao
        WHERE requisicao_id = p_requisicao_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização da requisição de produto: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Requisicao_Produto
CREATE OR REPLACE FUNCTION sp_RequisicaoProduto_DELETE(
    p_requisicao_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM requisicao_produto
        WHERE requisicao_id = p_requisicao_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão da requisição de produto: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Fatura_Fornecedor
--Inserir Fatura_Fornecedor

CREATE OR REPLACE FUNCTION sp_FaturaFornecedor_CREATE(
    p_fornecedor_id INT,
    p_valor_total DECIMAL
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela fatura_fornecedor
    BEGIN
        INSERT INTO fatura_fornecedor (fornecedor_id, valor_total)
        VALUES (p_fornecedor_id, p_valor_total);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção da fatura do fornecedor: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Selecionar Fatura_Fornecedor
CREATE OR REPLACE FUNCTION sp_FaturaFornecedor_READ(
    p_fatura_fornecedor_id INT
) RETURNS TABLE(fatura_fornecedor_id INT, fornecedor_id INT, data_emissao TIMESTAMP, valor_total DECIMAL(10, 2)) AS $$
BEGIN
    RETURN QUERY
    SELECT f.fatura_fornecedor_id, f.fornecedor_id, f.data_emissao, f.valor_total
    FROM fatura_fornecedor f
    WHERE f.fatura_fornecedor_id = p_fatura_fornecedor_id;
END
$$ LANGUAGE plpgsql;

--Atualizar FaturaFornecedor
CREATE OR REPLACE FUNCTION sp_FaturaFornecedor_UPDATE(
    p_fatura_fornecedor_id INT,
    p_fornecedor_id INT,
    p_valor_total DECIMAL(10, 2)
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE fatura_fornecedor
        SET fornecedor_id = p_fornecedor_id,
            valor_total = p_valor_total
        WHERE fatura_fornecedor_id = p_fatura_fornecedor_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na atualização da fatura do fornecedor: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Eliminar Fatura_Fornecedor
CREATE OR REPLACE FUNCTION sp_FaturaFornecedor_DELETE(
    p_fatura_fornecedor_id INT
) RETURNS VOID AS $$
BEGIN
    BEGIN
        DELETE FROM fatura_fornecedor
        WHERE fatura_fornecedor_id = p_fatura_fornecedor_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro na exclusão da fatura do fornecedor: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--FIM CRUD

--Alterar estado encomenda
CREATE OR REPLACE FUNCTION sp_Encomenda_UPDATE(
    p_encomenda_id INT,
    p_estado VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Tenta realizar a atualização
    UPDATE encomenda
    SET estado = p_estado
    WHERE encomenda_id = p_encomenda_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Encomenda com ID % não encontrada.', p_encomenda_id;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Erro na atualização da encomenda: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;


--Filtrar por categoria
CREATE OR REPLACE PROCEDURE obter_produtos_por_categoria(categoria_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    RAISE NOTICE 'Produtos da categoria com ID: %', categoria_id;
    
    FOR rec IN
        SELECT p.produto_id, p.nome, p.descricao, p.preco, p.quantidade_em_stock, p.data_adicao
        FROM produto p
        WHERE p.categoria_id = categoria_id
    LOOP
        RAISE NOTICE 'Produto ID: %, Nome: %, Preço: %', rec.produto_id, rec.nome, rec.preco;
    END LOOP;
END;
$$;

--Procura produto por nome
CREATE OR REPLACE FUNCTION procurar_produto_por_nome(produto_nome VARCHAR)
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR,
    descricao TEXT,
    preco DECIMAL(10, 2),
    quantidade_em_stock INT,
    data_adicao TIMESTAMP
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.produto_id, 
        p.nome, 
        p.descricao, 
        p.preco, 
        p.quantidade_em_stock, 
        p.data_adicao
    FROM 
        produto p
    WHERE 
        p.nome ILIKE '%' || produto_nome || '%';
END;
$$;

SELECT * FROM procurar_produto_por_nome('XPTO');

--Retornar todos os produtos
CREATE OR REPLACE FUNCTION get_all_produtos()
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR,
    descricao TEXT,
    preco DECIMAL(10, 2),
    quantidade_em_stock INT,
    data_adicao TIMESTAMP
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.produto_id, 
        p.nome, 
        p.descricao, 
        p.preco, 
        p.quantidade_em_stock, 
        p.data_adicao
    FROM 
        produto p;
END;
$$;

--Obter produtos de uma categoria
CREATE OR REPLACE FUNCTION obter_produtos_categoria(cat_id INT)
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR,
    descricao TEXT,
    preco DECIMAL(10, 2),
    quantidade_em_stock INT,
    data_adicao TIMESTAMP
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.produto_id, 
        p.nome, 
        p.descricao, 
        p.preco, 
        p.quantidade_em_stock, 
        p.data_adicao
    FROM 
        produto p
    WHERE 
        p.categoria_id = cat_id;
END;
$$;


--Obter todas as categorias
CREATE OR REPLACE FUNCTION get_all_categories()
RETURNS TABLE (categoria_id INT, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT c.categoria_id, c.nome
    FROM categoria c
    ORDER BY nome;
END;
$$ LANGUAGE plpgsql;

--Obter todos os fornecedores
CREATE OR REPLACE FUNCTION get_all_fornecedores()
RETURNS TABLE (fornecedor_id INT, nome VARCHAR, contato VARCHAR, endereco TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT f.fornecedor_id, f.nome, f.contato, f.endereco
    FROM fornecedor f
    ORDER BY nome;
END;
$$ LANGUAGE plpgsql;

--Inserção Encomenda com vários produtos (basicamente quando o utilizador acaba o seu pedido)
CREATE OR REPLACE FUNCTION sp_Encomenda_Com_Itens_CREATE(
    p_utilizador_id INT,
    p_morada VARCHAR,
    p_estado VARCHAR,
    p_itens JSON
) RETURNS VOID AS $$
DECLARE
    v_encomenda_id INT;
    item JSON;
    produto_id INT;
    quantidade INT;
BEGIN
    -- Passo 1: Inserir a encomenda e obter o ID gerado
    INSERT INTO encomenda (utilizador_id, morada, estado)
    VALUES (p_utilizador_id, p_morada, p_estado)
    RETURNING encomenda_id INTO v_encomenda_id;

    -- Passo 2: Iterar pelos itens recebidos no JSON
    FOR item IN SELECT * FROM json_array_elements(p_itens)
    LOOP
        -- Extrair os detalhes do item
        produto_id := (item->>'produto_id')::INT;
        quantidade := (item->>'quantidade')::INT;

        -- Passo 3: Inserir cada item usando o procedimento existente
        PERFORM sp_ItensEncomenda_CREATE(v_encomenda_id, produto_id, quantidade);
    END LOOP;
END
$$ LANGUAGE plpgsql;

--Verificar Email Existe
CREATE OR REPLACE FUNCTION VerificarLogin(
    p_email VARCHAR(255)
) RETURNS TABLE (
    utilizador_id INT,
    nome VARCHAR,
    email VARCHAR,
    senha VARCHAR,
    isAdmin BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT u.utilizador_id, u.nome, u.email, u.senha, u.isAdmin
    FROM utilizador u
    WHERE u.email = p_email;
END;
$$ LANGUAGE plpgsql;

--Update para IsAdmin
CREATE OR REPLACE FUNCTION sp_Utilizador_UpdateIsAdmin(
    p_utilizador_id INT,
    p_isAdmin BOOLEAN
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE utilizador
        SET isAdmin = p_isAdmin
        WHERE utilizador_id = p_utilizador_id;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Erro ao atualizar isAdmin do utilizador com ID %: %', p_utilizador_id, SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

--Ultimos 4 produtos adicionados
CREATE OR REPLACE FUNCTION ultimos_produtos_adicionados()
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR,
    descricao TEXT,
    preco DECIMAL(10, 2),
    categoria_id INT,
    quantidade_em_stock INT,
    data_adicao TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.produto_id, 
        p.nome, 
        p.descricao, 
        p.preco, 
        p.categoria_id, 
        p.quantidade_em_stock, 
        p.data_adicao
    FROM produto p
    ORDER BY data_adicao DESC
    LIMIT 4;
END;
$$ LANGUAGE plpgsql;

--Função Obter todas as categorias
CREATE OR REPLACE FUNCTION todas_categorias()
RETURNS TABLE(categoria_id INT, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY SELECT c.categoria_id, c.nome FROM categoria c;
END;
$$ LANGUAGE plpgsql;

--Função obter 4 produtos mais em stock
CREATE OR REPLACE FUNCTION get_top_4_produtos_por_stock()
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR,
    descricao TEXT,
    preco DECIMAL(10, 2),
    categoria_id INT,
    quantidade_em_stock INT,
    data_adicao TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.produto_id, p.nome, p.descricao, p.preco, p.categoria_id, p.quantidade_em_stock, p.data_adicao
    FROM produto p
    ORDER BY quantidade_em_stock DESC
    LIMIT 4;
END;
$$ LANGUAGE plpgsql;


--Obter fornecedor de um produto
CREATE OR REPLACE FUNCTION obter_fornecedor_produto(p_produto_id INT)
RETURNS TABLE (
    fornecedor_id INT,
    nome VARCHAR,
    contato VARCHAR,
    endereco TEXT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT f.fornecedor_id, f.nome, f.contato, f.endereco
    FROM requisicao_produto rp
    JOIN fornecedor f ON rp.fornecedor_id = f.fornecedor_id
    WHERE rp.produto_id = p_produto_id
    ORDER BY rp.data_requisicao DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

--Obter todos os produtos de um fornecedor
CREATE OR REPLACE FUNCTION obter_produtos_por_fornecedor(fornecedor_id_param INT)
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR(100),
    descricao TEXT,
    preco DECIMAL(10,2),
    quantidade_total INT
) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        p.produto_id, 
        p.nome, 
        p.descricao, 
        p.preco, 
        SUM(rp.quantidade)::INT AS quantidade_total
    FROM produto p
    JOIN requisicao_produto rp ON p.produto_id = rp.produto_id
    WHERE rp.fornecedor_id = fornecedor_id_param
    GROUP BY p.produto_id, p.nome, p.descricao, p.preco;
END;
$$ LANGUAGE plpgsql;

--Obter todas as faturas_fornecedores
CREATE OR REPLACE FUNCTION obter_faturas_fornecedor(fornecedor_id_param INT)
RETURNS TABLE (
    fatura_fornecedor_id INT,
    fornecedor_id INT,
    data_emissao TIMESTAMP,
    valor_total DECIMAL(10, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT f.fatura_fornecedor_id, f.fornecedor_id, f.data_emissao, f.valor_total
    FROM fatura_fornecedor f
    WHERE f.fornecedor_id = fornecedor_id_param;
END;
$$ LANGUAGE plpgsql;

--Produtos recomendados
CREATE OR REPLACE FUNCTION recomendar_produtos(p_produto_id INT, p_limite INT DEFAULT 3)
RETURNS TABLE (
    produto_id INT,
    nome VARCHAR(100),
    descricao TEXT,
    preco DECIMAL(10,2),
    categoria_id INT,
    quantidade_em_stock INT,
    data_adicao TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT p.produto_id, p.nome, p.descricao, p.preco, p.categoria_id, p.quantidade_em_stock, p.data_adicao
    FROM produto p
    WHERE p.categoria_id = (SELECT produto.categoria_id FROM produto WHERE produto.produto_id = p_produto_id)
    AND p.produto_id != p_produto_id
    ORDER BY RANDOM()
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

--Obter recomendações produtos semelhantes comprados pelo o user sem peso de cada compra
CREATE OR REPLACE FUNCTION recomendar_produtos_user_sem_peso(utilizador_id INT, limite INT DEFAULT 4)
RETURNS TABLE (produto_id INT, nome VARCHAR, descricao TEXT, preco DECIMAL, categoria_id INT, quantidade_em_stock INT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.produto_id, p.nome, p.descricao, p.preco, p.categoria_id, p.quantidade_em_stock
    FROM produto p
    WHERE p.categoria_id IN (
        SELECT DISTINCT pr.categoria_id
        FROM itens_encomenda ie
        JOIN produto pr ON ie.produto_id = pr.produto_id
        JOIN encomenda e ON ie.encomenda_id = e.encomenda_id
        WHERE e.utilizador_id = recomendar_produtos_user.utilizador_id
    )
    AND p.produto_id NOT IN (
        SELECT DISTINCT ie.produto_id
        FROM itens_encomenda ie
        JOIN encomenda e ON ie.encomenda_id = e.encomenda_id
        WHERE e.utilizador_id = recomendar_produtos_user.utilizador_id
    )
    ORDER BY RANDOM()
    LIMIT limite;
END;
$$ LANGUAGE plpgsql;

--Recomendar produtos ao utilizador tomando como base as categorias de compras anteriores. 
--Quantas mais compras em uma categoria mais peso terá essa categoria para as recomendações
--Produtos já comprados não são recomendados!
CREATE OR REPLACE FUNCTION recomendar_produtos_user(utilizador_id INT, limite INT DEFAULT 4)
RETURNS TABLE (produto_id INT, nome VARCHAR, descricao TEXT, preco DECIMAL, categoria_id INT, quantidade_em_stock INT) AS $$
BEGIN
    RETURN QUERY
    WITH categorias_com_peso AS (
        SELECT pr.categoria_id, COUNT(*) AS peso
        FROM itens_encomenda ie
        JOIN produto pr ON ie.produto_id = pr.produto_id
        JOIN encomenda e ON ie.encomenda_id = e.encomenda_id
        WHERE e.utilizador_id = recomendar_produtos_user.utilizador_id
        GROUP BY pr.categoria_id
    )
    SELECT p.produto_id, p.nome, p.descricao, p.preco, p.categoria_id, p.quantidade_em_stock
    FROM produto p
    JOIN categorias_com_peso c ON p.categoria_id = c.categoria_id
    WHERE p.produto_id NOT IN (
        SELECT ie.produto_id
        FROM itens_encomenda ie
        JOIN encomenda e ON ie.encomenda_id = e.encomenda_id
        WHERE e.utilizador_id = recomendar_produtos_user.utilizador_id
    )
    ORDER BY RANDOM() * c.peso
    LIMIT limite;
END;
$$ LANGUAGE plpgsql;


--Views
--View Encomendas
CREATE VIEW vw_encomendas_utilizador AS
SELECT 
    e.encomenda_id,
    e.utilizador_id,
	u.nome as nome_user,
    e.morada,
    e.data_encomenda,
    e.estado,
    p.produto_id,
    p.nome AS nome_produto,
    p.descricao,
    p.preco AS preco_unitario,
    i.quantidade,
    i.preco_total
FROM 
    encomenda e
JOIN 
    itens_encomenda i ON e.encomenda_id = i.encomenda_id
JOIN 
    produto p ON i.produto_id = p.produto_id
JOIN 
    utilizador u ON e.utilizador_id = u.utilizador_id; 
	
--View Utilizador
CREATE VIEW view_utilizador AS
SELECT 
    utilizador_id,
    nome,
    email,
    isAdmin,
    data_registo
FROM utilizador;

--View Produto
CREATE OR REPLACE VIEW view_produto AS
SELECT 
    p.produto_id,
    p.nome AS produto_nome,
    p.descricao,
    p.preco,
    p.quantidade_em_stock,
    p.data_adicao,
    p.categoria_id,
    c.nome AS categoria_nome
FROM 
    produto p
JOIN 
    categoria c ON p.categoria_id = c.categoria_id
	ORDER BY 
    p.produto_id; 

--View Fornecedor	
CREATE VIEW view_fornecedor AS
SELECT 
    fornecedor_id,
    nome,
    contato,
    endereco
FROM fornecedor;

--View Top 5 mais vendidos
CREATE VIEW top_5_produtos_mais_vendidos AS
SELECT 
    p.produto_id,
    p.nome,
    SUM(ie.quantidade) AS quantidade_total_vendida
FROM itens_encomenda ie
JOIN produto p ON ie.produto_id = p.produto_id
GROUP BY p.produto_id, p.nome
ORDER BY quantidade_total_vendida DESC
LIMIT 5;

--View total pendentes, enviadas na última semana e data da última encomenda pendente ou enviada
CREATE VIEW total_encomendas_por_estado AS
SELECT 
    estado,
    COUNT(*) AS total,
    (SELECT MAX(data_encomenda) FROM encomenda) AS ultima_encomenda
FROM encomenda
WHERE estado = 'pendente'
   OR (estado = 'enviada' AND data_encomenda >= CURRENT_DATE - INTERVAL '7 days')
GROUP BY estado;


--View clientes com mais compras
CREATE VIEW top_clientes AS
SELECT 
    u.utilizador_id,
    u.nome,
    COUNT(e.encomenda_id) AS total_encomendas
FROM utilizador u
JOIN encomenda e ON u.utilizador_id = e.utilizador_id
GROUP BY u.utilizador_id, u.nome
ORDER BY total_encomendas DESC
LIMIT 10;

--View categorias mais vendidas
CREATE VIEW categorias_mais_vendidas AS
SELECT 
    c.categoria_id,
    c.nome AS categoria,
    SUM(ie.quantidade) AS total_vendido
FROM itens_encomenda ie
JOIN produto p ON ie.produto_id = p.produto_id
JOIN categoria c ON p.categoria_id = c.categoria_id
GROUP BY c.categoria_id, c.nome
ORDER BY total_vendido DESC;

--View produtos nunca vendidos
CREATE VIEW produtos_nunca_vendidos AS
SELECT 
    p.produto_id,
    p.nome
FROM produto p
LEFT JOIN itens_encomenda ie ON p.produto_id = ie.produto_id
WHERE ie.produto_id IS NULL;

--Trigger
--Trigger quando uma venda é efetuada
CREATE OR REPLACE FUNCTION atualizar_stock_produto()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se há estoque suficiente
    IF (SELECT quantidade_em_stock FROM produto WHERE produto_id = NEW.produto_id) < NEW.quantidade THEN
        RAISE EXCEPTION 'Estoque insuficiente para o produto %', NEW.produto_id;
    END IF;

    -- Atualizar o estoque do produto
    UPDATE produto
    SET quantidade_em_stock = quantidade_em_stock - NEW.quantidade
    WHERE produto_id = NEW.produto_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_stock_itens
AFTER INSERT ON itens_encomenda
FOR EACH ROW
EXECUTE FUNCTION atualizar_stock_produto();

--Encomenda passa para enviada, é criada uma fatura automaticamente
CREATE OR REPLACE FUNCTION criar_fatura()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se o novo estado é "enviada"
    IF NEW.estado = 'enviada' THEN
        INSERT INTO fatura (encomenda_id, valor_total)
        VALUES (
            NEW.encomenda_id,
            (SELECT SUM(preco_total) 
             FROM itens_encomenda 
             WHERE encomenda_id = NEW.encomenda_id)
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_criar_fatura
AFTER UPDATE OF estado ON encomenda
FOR EACH ROW
WHEN (OLD.estado IS DISTINCT FROM NEW.estado)
EXECUTE FUNCTION criar_fatura();


--Adicioanr stock fornecedor
CREATE OR REPLACE FUNCTION atualizar_stock_produto_requisicao()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE produto
    SET quantidade_em_stock = quantidade_em_stock + NEW.quantidade
    WHERE produto_id = NEW.produto_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_stock_requisicao
AFTER INSERT ON requisicao_produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_stock_produto_requisicao();


--Indices
--Chaves Estrangeiras usadas com frequência
CREATE INDEX idx_produto_categoria ON produto(categoria_id);
CREATE INDEX idx_encomenda_utilizador ON encomenda(utilizador_id);
CREATE INDEX idx_encomenda_estado ON encomenda(estado);

--Irá ser utilizado com frequência para o login
CREATE INDEX idx_utilizador_email ON utilizador(email);