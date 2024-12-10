from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth import logout
from .models import Compra
from django.contrib.auth.forms import UserChangeForm
from .forms import UserSettingsForm
from django.db import connection
from django.http import Http404
from django.contrib import messages
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
    if request.user.is_authenticated:
        compras = Compra.objects.filter(utilizador=request.user).order_by('-data_compra')

        if request.method == 'POST':
            form = UserChangeForm(request.POST, instance=request.user)
            if form.is_valid():
                form.save()
                return redirect('perfil')
        else:
            form = UserChangeForm(instance=request.user)
    else:
        # Se o utilizador não estiver autenticado, define variáveis vazias
        compras = None
        form = None
    
    return render(request, 'perfil.html', {'compras': compras, 'form': form})


def recuperar_senha(request):
    return render(request, 'recuperar_pass.html')

def perfil_admin(request):
    admin_info = {
        'nome': 'Admin Nome',
        'email': 'admin@example.com',
        'data_registro': '01/01/2023'
    }
    return render(request, 'perfil_admin.html', {'admin': admin_info})