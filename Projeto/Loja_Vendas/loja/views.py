from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Compra
from django.contrib.auth.forms import UserChangeForm
from .forms import UserSettingsForm

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

def produto_detalhe(request, id):
    produto = next((p for p in produtos if p['id'] == id), None)
    if produto:
        return render(request, 'produto_detalhe.html', {'produto': produto})
    else:
        return render(request, '404.html', status=404)

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