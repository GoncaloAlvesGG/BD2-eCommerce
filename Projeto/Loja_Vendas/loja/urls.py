from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', auth_views.LoginView.as_view(template_name='login.html'), name='login'),  # Página de login
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),  # Página de logout
    path('index/', views.index, name='index'),  # Página inicial
    path('produto/<int:id>/', views.produto_detalhe, name='produto_detalhe'),  # Detalhe do produto
    path('carrinho/', views.carrinho, name='carrinho'),  # Carrinho de compras
    path('checkout/', views.checkout, name='checkout'),  # Finalização da compra
    path('perfil/', views.perfil, name='perfil'), # Perfil do usuário
    path('recuperar_senha/', views.recuperar_senha, name='recuperar_senha'),  # Recuperar senha
    path('admin/perfil/', views.perfil_admin, name='perfil_admin'), # Perfil do admin
]
