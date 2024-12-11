--Utilizador
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
SELECT TEST_Utilizador_CREATE('ADMIN', 'joao.silva123@email.com', 'senha123', true);

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
SELECT TEST_Produto_CREATE('Xiaomi SmartWatch', 'Xiaomi SmartWatch Pro', 199.99, 1, 100);
SELECT TEST_Produto_CREATE('Xiaomi Earbuds', 'Xiaomi Wireless Earbuds com Noise Canceling', 79.99, 1, 200);
SELECT TEST_Produto_CREATE('Xiaomi Mi Band', 'Xiaomi Mi Band 7 com Display AMOLED', 49.99, 1, 300);
SELECT TEST_Produto_CREATE('Xiaomi Scooter', 'Xiaomi Electric Scooter Pro 2', 599.99, 1, 25);


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