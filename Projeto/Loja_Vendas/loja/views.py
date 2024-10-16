from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Compra
from django.contrib.auth.forms import UserChangeForm

# Dados fictícios
produtos = [
    {'id': 1, 'nome': 'Produto 1', 'preco': 19.99, 'descricao': 'Descrição do produto 1'},
    {'id': 2, 'nome': 'Produto 2', 'preco': 29.99, 'descricao': 'Descrição do produto 2'},
    {'id': 3, 'nome': 'Produto 3', 'preco': 39.99, 'descricao': 'Descrição do produto 3'},
]

def index(request):
    # Página inicial com a lista de produtos
    return render(request, 'index.html', {'produtos': produtos})

def produto_detalhe(request, id):
    # Detalhes do produto
    produto = next((p for p in produtos if p['id'] == id), None)
    return render(request, 'produto_detalhe.html', {'produto': produto})

def carrinho(request):
    # Página do carrinho (vazia por enquanto)
    return render(request, 'carrinho.html')

def checkout(request):
    # Página de checkout (vazia por enquanto)
    return render(request, 'checkout.html')

@login_required
def perfil(request):
    compras = Compra.objects.filter(utilizador=request.user).order_by('-data_compra')
    
    if request.method == 'POST':
        form = UserChangeForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect('perfil')
    else:
        form = UserChangeForm(instance=request.user)
    
    return render(request, 'perfil.html', {'compras': compras, 'form': form})