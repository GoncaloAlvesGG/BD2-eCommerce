from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from .models import Compra, EncomendaView
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
    # Página inicial com a lista de produtos
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


def recuperar_senha(request):
    return render(request, 'recuperar_pass.html')

def perfil_admin(request):
    admin_info = {
        'nome': 'Admin Nome',
        'email': 'admin@example.com',
        'data_registro': '01/01/2023'
    }
    return render(request, 'perfil_admin.html', {'admin': admin_info})

##Funções úteis

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
