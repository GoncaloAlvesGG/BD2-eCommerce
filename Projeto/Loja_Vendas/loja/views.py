from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from .models import *
from django.contrib.auth.forms import UserChangeForm
from .forms import UserSettingsForm
from django.db import connection
from django.http import Http404, JsonResponse
from django.contrib import messages
from collections import defaultdict
import bcrypt


#dados ficticios
produtos = [
    {'id': 1, 'nome': 'Produto 1', 'preco': 99.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 2, 'nome': 'Produto 2', 'preco': 149.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 3, 'nome': 'Produto 3', 'preco': 199.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 4, 'nome': 'Produto 4', 'preco': 129.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 5, 'nome': 'Produto 5', 'preco': 299.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 6, 'nome': 'Produto 6', 'preco': 99.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 7, 'nome': 'Produto 7', 'preco': 79.99, 'descricao': 'Descrição breve do produto.'},
    {'id': 8, 'nome': 'Produto 8', 'preco': 49.99, 'descricao': 'Descrição breve do produto.'},
]


def produto_detalhe(request, produto_id):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM sp_Produto_READ(%s)", [produto_id])
        columns = [col[0] for col in cursor.description]
        result = cursor.fetchone()
    
    # Se o produto não for encontrado, levantar erro 404
    if not result:
        raise Http404("Produto não encontrado")
    
    # Formatar o resultado como dicionário
    produto = dict(zip(columns, result))
    
    # Renderizar o template e passar os dados
    return render(request, 'produto_detalhe.html', {'produto': produto})

def encomenda(request, encomenda_id):
    encomenda_list = obter_encomenda(encomenda_id)  # Assuming this returns a list
    encomenda = encomenda_list[0] if encomenda_list else None  # Extract the first item
    return render(request, 'detalhe_encomenda.html', {'encomenda': encomenda})


def admin_dashboard(request):
    return render(request, 'dashboard.html')



def registo(request):
    if request.method == "POST":
        nome = request.POST['nome']
        email = request.POST['email']
        password = request.POST['password']
        isAdmin = False  # Supondo que a flag seja False por padrão

        # Gerar o hash da senha com bcrypt
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
        
        # Chamar a stored procedure
        with connection.cursor() as cursor:
            cursor.callproc('sp_Utilizador_CREATE', [nome, email, password_hash, isAdmin])
        
        messages.success(request, "Utilizador registado com sucesso!")
        return redirect('login')
    
    return render(request, 'registo.html')

def login(request):
    if request.method == "POST":
        email = request.POST['email']
        password = request.POST['password']

        # Chamar a função para obter os dados do utilizador
        with connection.cursor() as cursor:
            cursor.callproc('VerificarLogin', [email])
            result = cursor.fetchone()

        if result is None:
            # Email não encontrado
            return render(request, 'login.html', {'login_error': 'Email ou senha inválidos.'})

        # Extrair dados retornados pela função
        utilizador_id, nome, email, stored_password_hash, is_admin = result

        # Verificar a senha fornecida com o hash armazenado
        if bcrypt.checkpw(password.encode('utf-8'), stored_password_hash.encode('utf-8')):
            # Configurar sessão ou redirecionar
            request.session['utilizador_id'] = utilizador_id
            request.session['nome'] = nome
            request.session['email'] = email
            request.session['is_admin'] = is_admin
            messages.success(request, f"Bem-vindo(a), {nome}!")
            return redirect('index')
        else:
            return render(request, 'login.html', {'login_error': 'Email ou senha inválidos.'})

    return render(request, 'login.html')

def logout_view(request):
    # Página inicial com a lista de produtos
    logout(request)
    return render(request, "login.html")

def index(request):
    produtos = produtos_4recentes()
    return render(request, 'index.html', {'produtos': produtos})

def carrinho(request):
    # Página do carrinho (vazia por enquanto)
    return render(request, 'carrinho.html')

def checkout(request):
    # Página de checkout (vazia por enquanto)
    return render(request, 'checkout.html')

def user_profile(request):
    if request.method == 'POST':
        form = UserSettingsForm(request.POST)
        if form.is_valid():
            # Salve as definições do utilizador aqui
            pass
    else:
        form = UserSettingsForm()  # Pode preencher com dados existentes, se necessário

    compras = []  # Suponha que você tenha uma forma de obter compras do utilizador

    return render(request, 'seu_template.html', {'form': form, 'compras': compras})

# @login_required
def perfil(request):
        # O utilizador está autenticado
        utilizador_id = request.session.get('utilizador_id')
        encomendas = obter_encomendas_utilizador(utilizador_id)
        form = UserChangeForm()
    # Passar os dados para o template
        return render(request, 'perfil.html', {'form': form, 'encomendas': encomendas})

def dashboard_encomendas(request):
    encomendas = obter_encomendas()
    return render(request, 'dashboard_encomendas.html', {'encomendas': encomendas})

def dashboard_produtos(request):
    produtos = ProdutoView.objects.all()
    categorias = get_categorias() 

    categoria_dict = {categoria['categoria_id']: categoria['nome'] for categoria in categorias}

    # Add the category name to each produto
    for produto in produtos:
        # Look up the category name based on categoria_id
        categoria_nome = categoria_dict.get(produto.categoria_id, 'Categoria desconhecida')
        # Add the category name to the produto object
        produto.categoria_nome = categoria_nome
    
    return render(request, 'dashboard_produtos.html', {'produtos': produtos, 'categorias': categorias})

def dashboard_configuracoes(request):
    return render(request, 'dashboard_configuracoes.html')

def dashboard_clientes(request):
    utilizadores = UtilizadorView.objects.all()
    return render(request, 'dashboard_clientes.html', {'utilizadores': utilizadores})

def dashboard_fornecedores(request):
    fornecedores = FornecedorView.objects.all()
    return render(request, 'dashboard_fornecedores.html', {'fornecedores': fornecedores})

def recuperar_senha(request):
    return render(request, 'recuperar_pass.html')

def perfil_admin(request):
    admin_info = {
        'nome': 'Admin Nome',
        'email': 'admin@example.com',
        'data_registro': '01/01/2023'
    }
    return render(request, 'perfil_admin.html', {'admin': admin_info})

def produtos_4recentes():
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM ultimos_produtos_adicionados()")
        colunas = [col[0] for col in cursor.description]
        resultados = [dict(zip(colunas, row)) for row in cursor.fetchall()]
    return resultados

def get_categorias():
    # Calling the stored procedure using raw SQL
    with connection.cursor() as cursor:
        cursor.callproc('todas_categorias')  # Calling the stored procedure
        rows = cursor.fetchall()  # Fetch all rows returned by the procedure
    
    # Prepare the categories data
    categorias = [{'categoria_id': row[0], 'nome': row[1]} for row in rows]
    
    return categorias

def obter_encomendas():
    encomendas = EncomendaView.objects.all()
    
    # Dicionário para armazenar as encomendas agrupadas
    grouped_encomendas = defaultdict(lambda: {
        "encomenda_id": None,
        "morada": None,
        "data_encomenda": None,
        "estado": None,
        "produto": [],
        "preco_total": 0,
        "nome_user": None
    })
    
    # Agrupar as encomendas e calcular o total
    for encomenda in encomendas:
        encomenda_id = encomenda.encomenda_id
        encomenda.nome_user = encomenda.nome_user
        item_data = {
            "produto_id": encomenda.produto_id,
            "nome": encomenda.nome_produto,
            "descricao": encomenda.descricao,
            "preco_unitario": encomenda.preco_unitario,
            "quantidade": encomenda.quantidade,
            "preco_total": encomenda.preco_total,
        }
        
        # Adiciona o item à encomenda correspondente
        grouped_encomendas[encomenda_id]["produto"].append(item_data)
        grouped_encomendas[encomenda_id]["preco_total"] += encomenda.preco_total
        
        # A primeira vez que encontramos uma encomenda, salvamos os outros dados
        if grouped_encomendas[encomenda_id]["encomenda_id"] is None:
            grouped_encomendas[encomenda_id]["encomenda_id"] = encomenda.encomenda_id
            grouped_encomendas[encomenda_id]["nome_user"] = encomenda.nome_user
            grouped_encomendas[encomenda_id]["morada"] = encomenda.morada
            grouped_encomendas[encomenda_id]["data_encomenda"] = encomenda.data_encomenda
            grouped_encomendas[encomenda_id]["estado"] = encomenda.estado
    
    # Transformar o dicionário em uma lista para retorno
    data = list(grouped_encomendas.values())
    
    return data

def add_fornecedor(request):

    nome = request.POST['nome']
    contacto = request.POST['contacto']
    endereco = request.POST['endereco']
    with connection.cursor() as cursor:
            cursor.callproc('sp_Fornecedor_CREATE', [nome, contacto, endereco])
            messages.success(request, "Utilizador registado com sucesso!")
            return JsonResponse({"success": True})

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

def update_fornecedor(request):
    if request.method == 'POST':
        fornecedor_id = request.POST['fornecedor_id']
        nome = request.POST['nome']
        contacto = request.POST['contacto']
        endereco = request.POST['endereco']

        try:
            with connection.cursor() as cursor:
                cursor.callproc('sp_Fornecedor_UPDATE', [fornecedor_id, nome, contacto, endereco])
            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=400)

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

def delete_fornecedor(request):
    if request.method == 'POST':
        try:
            print(request.POST) 
            fornecedor_id = request.POST['fornecedor_id']

            with connection.cursor() as cursor:
                cursor.callproc('sp_Fornecedor_DELETE', [fornecedor_id])
            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=400)

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

def delete_cliente(request):
    if request.method == 'POST':
        try:
            print(request.POST) 
            cliente_id = request.POST['cliente_id']

            if not cliente_id:
                return JsonResponse({"success": False, "error": "Cliente ID não fornecido"}, status=400)

            with connection.cursor() as cursor:
                cursor.callproc('sp_Utilizador_DELETE', [cliente_id])
            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=400)

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

from django.http import JsonResponse

def ver_encomendas_clientes(request, utilizador_id):
    encomendas = obter_encomendas_utilizador(utilizador_id)  # Function to get orders by user
    return render(request, 'encomendas_table.html', {'encomendas': encomendas})


def add_produto(request):
    # Retrieve data from the POST request
    nome = request.POST['nome']
    descricao = request.POST.get('descricao', '')
    preco = request.POST['preco']
    categoria_id = request.POST['categoria']
    quantidade = request.POST['quantidade']

    # Use a stored procedure to insert the product data (replace with actual procedure if needed)
    with connection.cursor() as cursor:
        cursor.callproc('sp_Produto_CREATE', [nome, descricao, preco, categoria_id, quantidade])

    # Send success message
    messages.success(request, "Produto adicionado com sucesso!")

    return JsonResponse({"success": True})

def add_categoria(request):
    # Retrieve data from the POST request
    nome = request.POST['nome']

    # Use a stored procedure to insert the product data (replace with actual procedure if needed)
    with connection.cursor() as cursor:
        cursor.callproc('sp_Categoria_CREATE', [nome])

    # Send success message
    messages.success(request, "Categoria adicionadoa com sucesso!")

    return JsonResponse({"success": True})

    

def update_cliente(request):
    if request.method == 'POST':
        try:
            cliente_id = request.POST['cliente_id']
            nome = request.POST['nome']
            email = request.POST['email']
            isAdmin = request.POST.get('isAdmin', 'false') == 'true'
            senha = request.POST.get('senha', None) 

            
            with connection.cursor() as cursor:
                cursor.callproc('sp_Utilizador_UPDATE', [cliente_id, nome, email, senha, isAdmin])
            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=400)

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

def obter_encomendas_utilizador(utilizador_id):
    # Filtra as encomendas da view com base no utilizador_id
    encomendas = EncomendaView.objects.filter(utilizador_id=utilizador_id)
    
    # Dicionário para armazenar as encomendas agrupadas
    grouped_encomendas = defaultdict(lambda: {
        "encomenda_id": None,
        "morada": None,
        "data_encomenda": None,
        "estado": None,
        "produto": [],
        "preco_total": 0,
    })
    
    # Agrupar as encomendas e calcular o total
    for encomenda in encomendas:
        encomenda_id = encomenda.encomenda_id
        item_data = {
            "produto_id": encomenda.produto_id,
            "nome": encomenda.nome_produto,
            "descricao": encomenda.descricao,
            "preco_unitario": encomenda.preco_unitario,
            "quantidade": encomenda.quantidade,
            "preco_total": encomenda.preco_total,
        }
        
        # Adiciona o item à encomenda correspondente
        grouped_encomendas[encomenda_id]["produto"].append(item_data)
        grouped_encomendas[encomenda_id]["preco_total"] += encomenda.preco_total
        
        # A primeira vez que encontramos uma encomenda, salvamos os outros dados
        if grouped_encomendas[encomenda_id]["encomenda_id"] is None:
            grouped_encomendas[encomenda_id]["encomenda_id"] = encomenda.encomenda_id
            grouped_encomendas[encomenda_id]["morada"] = encomenda.morada
            grouped_encomendas[encomenda_id]["data_encomenda"] = encomenda.data_encomenda
            grouped_encomendas[encomenda_id]["estado"] = encomenda.estado
    
    # Transformar o dicionário em uma lista para retorno
    data = list(grouped_encomendas.values())
    
    return data

def obter_encomenda(encomenda_id):
    encomendas = EncomendaView.objects.filter(encomenda_id=encomenda_id)
    
    # Dicionário para armazenar as encomendas agrupadas
    grouped_encomendas = defaultdict(lambda: {
        "encomenda_id": None,
        "morada": None,
        "data_encomenda": None,
        "estado": None,
        "produto": [],
        "preco_total": 0,
        "nome_user": None
    })
    
    # Agrupar as encomendas e calcular o total
    for encomenda in encomendas:
        encomenda_id = encomenda.encomenda_id
        item_data = {
            "produto_id": encomenda.produto_id,
            "nome": encomenda.nome_produto,
            "descricao": encomenda.descricao,
            "preco_unitario": encomenda.preco_unitario,
            "quantidade": encomenda.quantidade,
            "preco_total": encomenda.preco_total,
        }
        
        # Adiciona o item à encomenda correspondente
        grouped_encomendas[encomenda_id]["produto"].append(item_data)
        grouped_encomendas[encomenda_id]["preco_total"] += encomenda.preco_total
        
        # A primeira vez que encontramos uma encomenda, salvamos os outros dados
        if grouped_encomendas[encomenda_id]["encomenda_id"] is None:
            grouped_encomendas[encomenda_id]["encomenda_id"] = encomenda.encomenda_id
            grouped_encomendas[encomenda_id]["nome_user"] = encomenda.nome_user
            grouped_encomendas[encomenda_id]["morada"] = encomenda.morada
            grouped_encomendas[encomenda_id]["data_encomenda"] = encomenda.data_encomenda
            grouped_encomendas[encomenda_id]["estado"] = encomenda.estado
    
    # Transformar o dicionário em uma lista para retorno
    data = list(grouped_encomendas.values())
    
    return data

