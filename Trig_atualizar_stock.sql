CREATE OR REPLACE FUNCTION atualizar_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.quantidade_em_stock < NEW.quantidade_em_stock THEN
        RAISE EXCEPTION 'Quantidade insuficiente em estoque para o produto %', OLD.produto_id;
    END IF;

    NEW.quantidade_em_stock = OLD.quantidade_em_stock - NEW.quantidade_em_stock;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_atualizar_stock
BEFORE UPDATE ON produto
FOR EACH ROW
EXECUTE FUNCTION atualizar_stock();