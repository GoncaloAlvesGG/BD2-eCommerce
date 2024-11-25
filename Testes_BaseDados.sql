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

-- Função de teste para verificar se o utilizador foi inserido corretamente
CREATE OR REPLACE FUNCTION TEST_Utilizador_CREATE(
    p_nome VARCHAR,
    p_email VARCHAR,
    p_senha VARCHAR,
    p_isAdmin BOOLEAN
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_Utilizador_CREATE(p_nome, p_email, p_senha, p_isAdmin);

    -- Verificar se o valor foi inserido corretamente
    SELECT COUNT(*)
    INTO contador
    FROM utilizador
    WHERE email = p_email;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Utilizador_CREATE('João Silva', 'joao.silva123@email.com', 'senha123', true);

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

CREATE OR REPLACE FUNCTION TEST_Utilizador_READ(
    p_utilizador_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_Utilizador_READ(p_utilizador_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Utilizador_READ(1);

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

CREATE OR REPLACE FUNCTION TEST_Utilizador_UPDATE(
    p_utilizador_id INT,
    p_nome VARCHAR,
    p_email VARCHAR,
    p_senha VARCHAR,
    p_isAdmin BOOLEAN
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Utilizador_UPDATE(p_utilizador_id, p_nome, p_email, p_senha, p_isAdmin);

    SELECT COUNT(*)
    INTO contador
    FROM utilizador
    WHERE utilizador_id = p_utilizador_id
      AND nome = p_nome
      AND email = p_email
      AND senha = p_senha
      AND isAdmin = p_isAdmin;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Utilizador_UPDATE(1, 'João Silva', 'joao.silva@email.com', 'novaPasse123', true);

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

CREATE OR REPLACE FUNCTION TEST_Utilizador_DELETE(
    p_utilizador_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Utilizador_DELETE(p_utilizador_id);

    SELECT COUNT(*)
    INTO contador
    FROM utilizador
    WHERE utilizador_id = p_utilizador_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
-- Atenção as chaves estrangeiras!
SELECT TEST_Utilizador_DELETE(1);

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

-- Função de teste para verificar se a categoria foi inserida corretamente
CREATE OR REPLACE FUNCTION TEST_Categoria_CREATE(
    p_nome VARCHAR
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_Categoria_CREATE(p_nome);

    -- Verificar se o valor foi inserido corretamente
    SELECT COUNT(*)
    INTO contador
    FROM categoria
    WHERE nome = p_nome;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Categoria_CREATE('Informática');

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

-- Função de teste para verificar se a leitura da categoria foi bem-sucedida
CREATE OR REPLACE FUNCTION TEST_Categoria_READ(
    p_categoria_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de leitura
    PERFORM sp_Categoria_READ(p_categoria_id);

    -- Verificar se a categoria foi encontrada
    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Categoria_READ(1);

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

-- Função de teste para verificar se a categoria foi atualizada corretamente
CREATE OR REPLACE FUNCTION TEST_Categoria_UPDATE(
    p_categoria_id INT,
    p_nome VARCHAR
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de atualização
    PERFORM sp_Categoria_UPDATE(p_categoria_id, p_nome);

    -- Verificar se o nome foi atualizado corretamente
    SELECT COUNT(*)
    INTO contador
    FROM categoria
    WHERE categoria_id = p_categoria_id
      AND nome = p_nome;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Categoria_UPDATE(1, 'Tecnologia');

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

-- Função de teste para verificar se a categoria foi excluída corretamente
CREATE OR REPLACE FUNCTION TEST_Categoria_DELETE(
    p_categoria_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de exclusão
    PERFORM sp_Categoria_DELETE(p_categoria_id);

    -- Verificar se a categoria foi excluída corretamente
    SELECT COUNT(*)
    INTO contador
    FROM categoria
    WHERE categoria_id = p_categoria_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
-- Atenção as chaves estrangeiras!
SELECT TEST_Categoria_DELETE(1);


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

-- Função de teste para verificar se o produto foi inserido corretamente
CREATE OR REPLACE FUNCTION TEST_Produto_CREATE(
    p_nome VARCHAR,
    p_descricao TEXT,
    p_preco DECIMAL,
    p_categoria_id INT,
    p_quantidade_em_stock INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_Produto_CREATE(p_nome, p_descricao, p_preco, p_categoria_id, p_quantidade_em_stock);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM produto
    WHERE nome = p_nome
      AND descricao = p_descricao
      AND preco = p_preco
      AND categoria_id = p_categoria_id
      AND quantidade_em_stock = p_quantidade_em_stock;

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Produto_CREATE('Xiaomi XPTO', 'Xiaomi XPTO 512GB', 999.99, 1, 50);

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

CREATE OR REPLACE FUNCTION TEST_Produto_READ(
    p_produto_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_Produto_READ(p_produto_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Produto_READ(1);

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

CREATE OR REPLACE FUNCTION TEST_Produto_UPDATE(
    p_produto_id INT,
    p_nome VARCHAR,
    p_descricao TEXT,
    p_preco DECIMAL,
    p_categoria_id INT,
    p_quantidade_em_stock INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Produto_UPDATE(p_produto_id, p_nome, p_descricao, p_preco, p_categoria_id, p_quantidade_em_stock);

    SELECT COUNT(*)
    INTO contador
    FROM produto
    WHERE produto_id = p_produto_id
      AND nome = p_nome
      AND descricao = p_descricao
      AND preco = p_preco
      AND categoria_id = p_categoria_id
      AND quantidade_em_stock = p_quantidade_em_stock;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Produto_UPDATE(1, 'Xiaomi XPTO 2', 'Xiaomi XPTO 2 512GB', 1099.99, 1, 30);

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

CREATE OR REPLACE FUNCTION TEST_Produto_DELETE(
    p_produto_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Produto_DELETE(p_produto_id);

    SELECT COUNT(*)
    INTO contador
    FROM produto
    WHERE produto_id = p_produto_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
-- Atenção às chaves estrangeiras!
SELECT TEST_Produto_DELETE(1);

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

-- Função de teste para verificar se a encomenda foi inserida corretamente
CREATE OR REPLACE FUNCTION TEST_Encomenda_CREATE(
    p_utilizador_id INT,
    p_morada VARCHAR,
    p_estado VARCHAR
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_Encomenda_CREATE(p_utilizador_id, p_morada, p_estado);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM encomenda
    WHERE utilizador_id = p_utilizador_id
      AND morada = p_morada
      AND estado = p_estado;

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Encomenda_CREATE(1, 'Rua das Flores, 123', 'pendente');

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

CREATE OR REPLACE FUNCTION TEST_Encomenda_READ(
    p_encomenda_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_Encomenda_READ(p_encomenda_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Encomenda_READ(3);

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

CREATE OR REPLACE FUNCTION TEST_Encomenda_UPDATE(
    p_encomenda_id INT,
    p_utilizador_id INT,
    p_morada VARCHAR,
    p_estado VARCHAR
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Encomenda_UPDATE(p_encomenda_id, p_utilizador_id, p_morada, p_estado);

    SELECT COUNT(*)
    INTO contador
    FROM encomenda
    WHERE encomenda_id = p_encomenda_id
      AND utilizador_id = p_utilizador_id
      AND morada = p_morada
      AND estado = p_estado;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Encomenda_UPDATE(3, 1, 'Rua Nova, 456', 'enviada');

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

CREATE OR REPLACE FUNCTION TEST_Encomenda_DELETE(
    p_encomenda_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Encomenda_DELETE(p_encomenda_id);

    SELECT COUNT(*)
    INTO contador
    FROM encomenda
    WHERE encomenda_id = p_encomenda_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
-- Atenção às chaves estrangeiras!
SELECT TEST_Encomenda_DELETE(3);

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

-- Função de teste para verificar se a fatura foi inserida corretamente
CREATE OR REPLACE FUNCTION TEST_Fatura_CREATE(
    p_encomenda_id INT,
    p_valor_total DECIMAL
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_Fatura_CREATE(p_encomenda_id, p_valor_total);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM fatura
    WHERE encomenda_id = p_encomenda_id
      AND valor_total = p_valor_total;

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fatura_CREATE(3, 150.00);

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

CREATE OR REPLACE FUNCTION TEST_Fatura_READ(
    p_fatura_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_Fatura_READ(p_fatura_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fatura_READ(3);

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

CREATE OR REPLACE FUNCTION TEST_Fatura_UPDATE(
    p_fatura_id INT,
    p_valor_total DECIMAL
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Fatura_UPDATE(p_fatura_id, p_valor_total);

    SELECT COUNT(*)
    INTO contador
    FROM fatura
    WHERE fatura_id = p_fatura_id
      AND valor_total = p_valor_total;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fatura_UPDATE(3, 250.50);

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

CREATE OR REPLACE FUNCTION TEST_Fatura_DELETE(
    p_fatura_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Fatura_DELETE(p_fatura_id);

    SELECT COUNT(*)
    INTO contador
    FROM fatura
    WHERE fatura_id = p_fatura_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
-- Atenção às chaves estrangeiras!
SELECT TEST_Fatura_DELETE(3);

--Itens_Encomenda
--Inserir Itens_Encomenda

CREATE OR REPLACE FUNCTION sp_ItensEncomenda_CREATE(
    p_encomenda_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_preco_total DECIMAL
) RETURNS VOID AS $$
BEGIN
    -- Tentativa de inserção na tabela itens_encomenda
    BEGIN
        INSERT INTO itens_encomenda (encomenda_id, produto_id, quantidade, preco_total)
        VALUES (p_encomenda_id, p_produto_id, p_quantidade, p_preco_total);

    EXCEPTION
        WHEN OTHERS THEN
            -- Em caso de erro, capturamos a exceção e lançamos um erro genérico
            RAISE EXCEPTION 'Erro na inserção do item da encomenda: %', SQLERRM;
    END;
END
$$ LANGUAGE plpgsql;

-- Função de teste para verificar se o item foi inserido corretamente
CREATE OR REPLACE FUNCTION TEST_ItensEncomenda_CREATE(
    p_encomenda_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_preco_total DECIMAL
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_ItensEncomenda_CREATE(p_encomenda_id, p_produto_id, p_quantidade, p_preco_total);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM itens_encomenda
    WHERE encomenda_id = p_encomenda_id
      AND produto_id = p_produto_id
      AND quantidade = p_quantidade
      AND preco_total = p_preco_total;

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_ItensEncomenda_CREATE(3, 1, 3, 299.97);

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

CREATE OR REPLACE FUNCTION TEST_ItensEncomenda_READ(
    p_encomenda_id INT,
    p_produto_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_ItensEncomenda_READ(p_encomenda_id, p_produto_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_ItensEncomenda_READ(3, 1);

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

CREATE OR REPLACE FUNCTION TEST_ItensEncomenda_UPDATE(
    p_encomenda_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_preco_total DECIMAL
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_ItensEncomenda_UPDATE(p_encomenda_id, p_produto_id, p_quantidade, p_preco_total);

    SELECT COUNT(*)
    INTO contador
    FROM itens_encomenda
    WHERE encomenda_id = p_encomenda_id
      AND produto_id = p_produto_id
      AND quantidade = p_quantidade
      AND preco_total = p_preco_total;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_ItensEncomenda_UPDATE(1, 1, 3, 59.97);

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

CREATE OR REPLACE FUNCTION TEST_ItensEncomenda_DELETE(
    p_encomenda_id INT,
    p_produto_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_ItensEncomenda_DELETE(p_encomenda_id, p_produto_id);

    SELECT COUNT(*)
    INTO contador
    FROM itens_encomenda
    WHERE encomenda_id = p_encomenda_id
      AND produto_id = p_produto_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_ItensEncomenda_DELETE(1, 1);


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

-- Função de teste para verificar se o fornecedor foi inserido corretamente
CREATE OR REPLACE FUNCTION TEST_Fornecedor_CREATE(
    p_nome VARCHAR,
    p_contato VARCHAR,
    p_endereco TEXT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_Fornecedor_CREATE(p_nome, p_contato, p_endereco);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM fornecedor
    WHERE nome = p_nome
      AND contato = p_contato
      AND endereco = p_endereco;

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fornecedor_CREATE('Fornecedor A', '1234-5678', 'Rua das Compras, 100');

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

CREATE OR REPLACE FUNCTION TEST_Fornecedor_READ(
    p_fornecedor_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_Fornecedor_READ(p_fornecedor_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fornecedor_READ(1);

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

CREATE OR REPLACE FUNCTION TEST_Fornecedor_UPDATE(
    p_fornecedor_id INT,
    p_nome VARCHAR,
    p_contato VARCHAR,
    p_endereco TEXT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Fornecedor_UPDATE(p_fornecedor_id, p_nome, p_contato, p_endereco);

    SELECT COUNT(*)
    INTO contador
    FROM fornecedor
    WHERE fornecedor_id = p_fornecedor_id
      AND nome = p_nome
      AND contato = p_contato
      AND endereco = p_endereco;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fornecedor_UPDATE(1, 'Fornecedor Y', '9876-5432', 'Avenida das Empresas, 200');

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

CREATE OR REPLACE FUNCTION TEST_Fornecedor_DELETE(
    p_fornecedor_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_Fornecedor_DELETE(p_fornecedor_id);

    SELECT COUNT(*)
    INTO contador
    FROM fornecedor
    WHERE fornecedor_id = p_fornecedor_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_Fornecedor_DELETE(1);

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

-- Função de teste para verificar se a requisição foi inserida corretamente
CREATE OR REPLACE FUNCTION TEST_RequisicaoProduto_CREATE(
    p_fornecedor_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_data_rececao TIMESTAMP
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_RequisicaoProduto_CREATE(p_fornecedor_id, p_produto_id, p_quantidade, p_data_rececao);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM requisicao_produto
    WHERE fornecedor_id = p_fornecedor_id
      AND produto_id = p_produto_id
      AND quantidade = p_quantidade
      AND (p_data_rececao IS NULL OR data_rececao = p_data_rececao);

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_RequisicaoProduto_CREATE(1, 1, 50, NULL);

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

CREATE OR REPLACE FUNCTION TEST_RequisicaoProduto_READ(
    p_requisicao_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_RequisicaoProduto_READ(p_requisicao_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_RequisicaoProduto_READ(2);

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

CREATE OR REPLACE FUNCTION TEST_RequisicaoProduto_UPDATE(
    p_requisicao_id INT,
    p_fornecedor_id INT,
    p_produto_id INT,
    p_quantidade INT,
    p_data_rececao TIMESTAMP
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_RequisicaoProduto_UPDATE(p_requisicao_id, p_fornecedor_id, p_produto_id, p_quantidade, p_data_rececao);

    SELECT COUNT(*)
    INTO contador
    FROM requisicao_produto
    WHERE requisicao_id = p_requisicao_id
      AND fornecedor_id = p_fornecedor_id
      AND produto_id = p_produto_id
      AND quantidade = p_quantidade
      AND data_rececao = p_data_rececao;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_RequisicaoProduto_UPDATE(2, 1, 1, 150, '2024-11-10 12:00:00');

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

CREATE OR REPLACE FUNCTION TEST_RequisicaoProduto_DELETE(
    p_requisicao_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_RequisicaoProduto_DELETE(p_requisicao_id);

    SELECT COUNT(*)
    INTO contador
    FROM requisicao_produto
    WHERE requisicao_id = p_requisicao_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_RequisicaoProduto_DELETE(1);


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

-- Função de teste para verificar se a fatura foi inserida corretamente
CREATE OR REPLACE FUNCTION TEST_FaturaFornecedor_CREATE(
    p_fornecedor_id INT,
    p_valor_total DECIMAL
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    -- Chamar o procedimento de inserção
    PERFORM sp_FaturaFornecedor_CREATE(p_fornecedor_id, p_valor_total);

    -- Verificar se o valor foi corretamente inserido
    SELECT COUNT(*)
    INTO contador
    FROM fatura_fornecedor
    WHERE fornecedor_id = p_fornecedor_id
      AND valor_total = p_valor_total;

    -- Se o número de registros for maior que 0, inserção foi bem-sucedida
    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    -- Retorna o resultado do teste
    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_FaturaFornecedor_CREATE(1, 1200.50);

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

CREATE OR REPLACE FUNCTION TEST_FaturaFornecedor_READ(
    p_fatura_fornecedor_id INT
) RETURNS TEXT AS $$
DECLARE
    resultado TEXT;
BEGIN
    PERFORM sp_FaturaFornecedor_READ(p_fatura_fornecedor_id);

    IF FOUND THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_FaturaFornecedor_READ(1);

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

CREATE OR REPLACE FUNCTION TEST_FaturaFornecedor_UPDATE(
    p_fatura_fornecedor_id INT,
    p_fornecedor_id INT,
    p_valor_total DECIMAL(10, 2)
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_FaturaFornecedor_UPDATE(p_fatura_fornecedor_id, p_fornecedor_id, p_valor_total);

    SELECT COUNT(*)
    INTO contador
    FROM fatura_fornecedor
    WHERE fatura_fornecedor_id = p_fatura_fornecedor_id
      AND fornecedor_id = p_fornecedor_id
      AND valor_total = p_valor_total;

    IF contador > 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_FaturaFornecedor_UPDATE(1, 1, 600.00);

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

CREATE OR REPLACE FUNCTION TEST_FaturaFornecedor_DELETE(
    p_fatura_fornecedor_id INT
) RETURNS TEXT AS $$
DECLARE
    contador INTEGER;
    resultado TEXT;
BEGIN
    PERFORM sp_FaturaFornecedor_DELETE(p_fatura_fornecedor_id);

    SELECT COUNT(*)
    INTO contador
    FROM fatura_fornecedor
    WHERE fatura_fornecedor_id = p_fatura_fornecedor_id;

    IF contador = 0 THEN
        resultado := 'OK';
    ELSE
        resultado := 'NOK';
    END IF;

    RETURN resultado;
END
$$ LANGUAGE plpgsql;

-- Exemplo de chamada para a função de teste
SELECT TEST_FaturaFornecedor_DELETE(1);