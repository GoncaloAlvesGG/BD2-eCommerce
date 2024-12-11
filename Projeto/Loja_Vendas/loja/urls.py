from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('', auth_views.LoginView.as_view(template_name='login.html'), name='login'),  # Página de login
    path('login/', views.login, name='login'),
    path('logout/', views.logout_view, name='logout_view'),  # Página de logout
    path('registo/', views.registo, name='registo'),
    path('index/', views.index, name='index'),  # Página inicial
    path('produto/<int:produto_id>/', views.produto_detalhe, name='produto_detalhe'),  # Detalhe do produto
    path('encomenda/<int:encomenda_id>/', views.encomenda, name='encomenda'),
    path('carrinho/', views.carrinho, name='carrinho'),  # Carrinho de compras
    path('checkout/', views.checkout, name='checkout'),  # Finalização da compra
    path('perfil/', views.perfil, name='perfil'), # Perfil do usuário
    path('recuperar_senha/', views.recuperar_senha, name='recuperar_senha'),  # Recuperar senha
    path('admin/perfil/', views.perfil_admin, name='perfil_admin'), # Perfil do admin
    path('dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('dashboard_encomendas/', views.dashboard_encomendas, name='dashboard_encomendas'),

]
