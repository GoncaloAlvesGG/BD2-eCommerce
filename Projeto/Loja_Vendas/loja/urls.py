from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [

    #Wishlist
    path('wishlist/', views.wishlist, name='wishlist'),
    path('wishlist/add/<int:produto_id>/', views.add_to_wishlist, name='add_to_wishlist'),
    path('wishlist/remove/<int:produto_id>/', views.remove_from_wishlist, name='remove_from_wishlist'),
    path('wishlist/add-to-cart/<int:produto_id>/', views.add_to_cart, name='add_to_cart'),

    #AUTH
    path('', auth_views.LoginView.as_view(template_name='login.html'), name='login'),  # Página de login
    path('login/', views.login, name='login'),
    path('logout/', views.logout_view, name='logout_view'),  # Página de logout
    path('registo/', views.registo, name='registo'),
    path('recuperar/', views.recuperar_senha, name="recuperar"),

    #PÁGINAS LOJA
    path('index/', views.index, name='index'),  # Página inicial
    path('alterar_senha/', views.alterar_senha, name='alterar_senha'),
    path('produto/<int:produto_id>/', views.produto_detalhe, name='produto_detalhe'),  # Detalhe do produto
    path('procurar/', views.procurar_produto, name='procurar_produto'),
    path('loja/', views.mostrar_todos_produtos, name='loja'),
    path('loja/categoria/<int:categoria_id>/', views.produtos_categoria, name='loja_categoria'),
    path('carrinho/', views.carrinho, name='carrinho'),  # Carrinho de compras
    path('checkout/', views.checkout, name='checkout'),  # Finalização da compra
    path('finalizar_compra/', views.finalizar_compra, name='finalizar_compra'),  # Finalização da compra
    path('add_to_cart/<int:produto_id>/', views.add_to_cart, name='add_to_cart'),

    #USER
    path('encomenda/<int:encomenda_id>/', views.encomenda, name='encomenda'),
    path('encomenda/<int:encomenda_id>/pdf/', views.gerar_pdf_encomenda, name='gerar_pdf_encomenda'),
    path('perfil/', views.perfil, name='perfil'), 
    path('recuperar_senha/', views.recuperar_senha, name='recuperar_senha'),  # Recuperar senha
    
    #DASHBOARD
    #ENCOMENDAS
    path('dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('dashboard/encomendas/', views.dashboard_encomendas, name='dashboard_encomendas'),
    path('dashboard/encomendas/enviar/<int:encomenda_id>/', views.enviar_encomenda, name='enviar_encomenda'),
    path('dashboard/encomendas/filtrar/', views.filtrar_encomendas, name='filtrar_encomendas'),
    path('exportar-relatorio/', views.exportar_relatorio, name='exportar_relatorio'),
    path('total_encomendas_por_estado/', views.total_encomendas_por_estado, name='total_encomendas_por_estado'),
    
    #PRODUTOS
    path('dashboard/produtos/', views.dashboard_produtos, name='dashboard_produtos'),
    path('dashboard/produtos/add', views.add_produto, name='add_produto'),
    path('dashboard/produtos/add_categoria', views.add_categoria, name='add_categoria'),
    path('dashboard/produtos/update', views.update_produto, name='update_produto'),
    path('dashboard/produtos/requerir', views.requerir_produto, name='requerir_produto'),
    path('produtos_nunca_vendidos/', views.produtos_nunca_vendidos, name='produtos_nunca_vendidos'),
    path('top_5_produtos_mais_vendidos/', views.top_5_produtos_mais_vendidos, name='top_5_produtos_mais_vendidos'),
    path('categorias_mais_vendidas/', views.categorias_mais_vendidas, name='categorias_mais_vendidas'),

    #CLIENTES
    path('dashboard/clientes/', views.dashboard_clientes, name='dashboard_clientes'),
    path('dashboard/clientes/update', views.update_cliente, name='update_cliente'),
    path('dashboard/clientes/delete', views.delete_cliente, name='delete_cliente'),
    path('dashboard/encomendas_cliente/<int:utilizador_id>/', views.ver_encomendas_clientes, name='ver_encomendas'),
    path('top_clientes/', views.top_clientes, name='top_clientes'),
    
    #FORNECEDORES
    path('dashboard/fornecedores/', views.dashboard_fornecedores, name='dashboard_fornecedores'),
    path('dashboard/fornecedores/add', views.add_fornecedor, name='add_fornecedor'),
    path('dashboard/fornecedores/update', views.update_fornecedor, name='update_fornecedor'),
    path('dashboard/fornecedores/delete', views.delete_fornecedor, name='delete_fornecedor'),
    path('fornecedores/<int:fornecedor_id>/produtos/', views.produtos_fornecedor, name='produtos_fornecedor'),
    path('fornecedores/<int:fornecedor_id>/faturas/', views.obter_faturas_fornecedor, name='obter_faturas_fornecedor'),   
    
]
