--Utilizador
--Inserir Utilizador

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

--ItensEncomenda
--Inserir ItensEncomenda

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

--RequisicaoProduto
--Inserir RequisicaoProduto

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

--FaturaFornecedor
--Inserir FaturaFornecedor

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
