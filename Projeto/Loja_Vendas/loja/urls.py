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
    path('dashboard/encomendas/', views.dashboard_encomendas, name='dashboard_encomendas'),
    path('add_to_cart/<int:produto_id>/', views.add_to_cart, name='add_to_cart'),
    #Produtos
    path('dashboard/produtos/', views.dashboard_produtos, name='dashboard_produtos'),
    path('dashboard/produtos/add', views.add_produto, name='add_produto'),
    path('dashboard/produtos/add_categoria', views.add_categoria, name='add_categoria'),

    #Clientes
    path('dashboard/clientes/', views.dashboard_clientes, name='dashboard_clientes'),
    path('dashboard/clientes/update', views.update_cliente, name='update_cliente'),
    path('dashboard/clientes/delete', views.delete_cliente, name='delete_cliente'),
    path('dashboard/encomendas_cliente/<int:utilizador_id>/', views.ver_encomendas_clientes, name='ver_encomendas'),
    
    #Fornecedores
    path('dashboard/fornecedores/', views.dashboard_fornecedores, name='dashboard_fornecedores'),
    path('dashboard/fornecedores/add', views.add_fornecedor, name='add_fornecedor'),
    path('dashboard/fornecedores/update', views.update_fornecedor, name='update_fornecedor'),
    path('dashboard/fornecedores/delete', views.delete_fornecedor, name='delete_fornecedor'),
    path('dashboard/configuracoes/', views.dashboard_configuracoes, name='dashboard_configuracoes'),

]
