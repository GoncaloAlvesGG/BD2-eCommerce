--Utilizador
--Inserir Utilizador
CREATE OR REPLACE FUNCTION sp_Utilizador_CREATE(
    p_nome VARCHAR,
    p_email VARCHAR,
    p_senha VARCHAR,
    p_isAdmin BOOLEAN
) RETURNS VOID AS $$
BEGIN
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
    p_senha VARCHAR,
    p_isAdmin BOOLEAN
) RETURNS VOID AS $$
BEGIN
    BEGIN
        UPDATE utilizador
        SET nome = p_nome, email = p_email, senha = p_senha, isAdmin = p_isAdmin
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
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela produto
    BEGIN
        INSERT INTO produto (nome, descricao, preco, categoria_id, quantidade_em_stock)
        VALUES (p_nome, p_descricao, p_preco, p_categoria_id, p_quantidade_em_stock);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção do produto: %', SQLERRM;
    END;
END
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
