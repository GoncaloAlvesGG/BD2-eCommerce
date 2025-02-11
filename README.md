# Projeto BD2: Loja de Vendas

## Funções

- **Utilizadores**
    - Registo, login e wishlist
    - Consulta e compra de produtos com filtros
    - Acompanhamento e histórico de encomendas
- **Administração**
    - Dashboard: Dados da loja, encomendas e estado
    - Gestão de Clientes: Dados e encomendas dos clientes
    - Gestão de Produtos: Inserção, consulta, edição e remoção
    - Gestão de Fornecedores: Consultar e gerir fornecedores e stocks

## Tecnologias

- **Backend Framework:** Django
- **Base de Dados:**
  - PostgreSQL 
  - MongoDB 
- **Frontend:** HTML, CSS, JavaScript

## Pré-Requisitos
- Python 3.x
- PostgreSQL
- MongoDB
- pip (Python package manager)

## Instalação

1. **Clonar o repositório**
   https://github.com/GoncaloAlvesGG/BD2


2. **Instalar depedências necessárias**
pip install -r requirements.txt

3. **Base de Dados**
A base de dados PostgreSQL encontra-se hospedada na cloud
A base de dados em MongoDB é necessários criar com o nome "Loja_online" e uma coleção "wishlist" localmente


## Rodar a aplicação

1. **Começar o servidor**
   ```bash
   python manage.py runserver
   ```

2. **Access the Application**
   - Abrir o no navegador `http://localhost:8000`
   - Conta user:
     ```
     Email: maria.oliveira@email.com
     Password: senha456
     ```
   - Conta Admin:
     ```
     Email: admin@email.com
     Password: senha123
     ```


