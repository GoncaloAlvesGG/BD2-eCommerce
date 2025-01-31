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
from decimal import Decimal
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from django.http import HttpResponse
from io import BytesIO
from datetime import datetime, timedelta
import json, random, bcrypt, pandas as pd
from .models import EncomendaView
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment
from openpyxl.utils import get_column_letter

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

        categorias = get_all_categories()

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
            request.session['categorias'] = categorias
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
    produtos_stock = produtos_mais_stock()
    return render(request, 'index.html', {'produtos': produtos, 'produtos_stock': produtos_stock})

def procurar_produto(request):
    titulo = 'Resultados da sua pesquisa'
    texto = request.GET['nome']
    produtos = procurar_produto_nome(texto)
    return render(request, 'mostrar_produtos.html', {'produtos': produtos, "titulo": titulo})

def mostrar_todos_produtos(request):
    titulo = 'todos'
    produtos = get_all_produtos()
    return render(request, 'mostrar_produtos.html', {'produtos': produtos, "titulo": titulo})

def produtos_categoria(request, categoria_id):
    titulo = 'Produtos da categoria:'
    produtos = obter_produtos_categoria(categoria_id)
    with connection.cursor() as cursor:
        # Call the stored function sp_Produto_READ with produto_id
        cursor.execute("SELECT * FROM sp_Categoria_READ(%s);", [categoria_id])
        
        # Fetch the result (this function returns a table, so fetchone is appropriate for a single product)
        result = cursor.fetchone()
        
        # If result is None, no product was found
        if result:
            categoria_data = {
                'categoria_id': result[0],
                'nome': result[1],
            }
            titulo = "Produtos da categoria: " + categoria_data['nome']
        else:
            return None
    return render(request, 'mostrar_produtos.html', {'produtos': produtos, "titulo": titulo})

def checkout(request):
    # Página de checkout (vazia por enquanto)
    return render(request, 'checkout.html')

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

def filtrar_encomendas(request):
    data_inicio = request.GET.get('data_inicio')
    data_fim = request.GET.get('data_fim')
    encomendas = obter_encomendas_por_data(data_inicio, data_fim)
    return render(request, 'dashboard_encomendas.html', {'encomendas': encomendas})

def dashboard_produtos(request):
    produtos = ProdutoView.objects.all()
    categorias = get_categorias() 
    fornecedores = get_fornecedores()

    categoria_dict = {categoria['categoria_id']: categoria['nome'] for categoria in categorias}

    # Add the category name to each produto
    for produto in produtos:
        # Look up the category name based on categoria_id
        categoria_nome = categoria_dict.get(produto.categoria_id, 'Categoria desconhecida')
        # Add the category name to the produto object
        produto.categoria_nome = categoria_nome
    
    return render(request, 'dashboard_produtos.html', {'produtos': produtos, 'categorias': categorias, 'fornecedores': fornecedores})

def get_product_data(produto_id):
    with connection.cursor() as cursor:
        # Call the stored function sp_Produto_READ with produto_id
        cursor.execute("SELECT * FROM sp_Produto_READ(%s);", [produto_id])
        
        # Fetch the result (this function returns a table, so fetchone is appropriate for a single product)
        result = cursor.fetchone()
        
        # If result is None, no product was found
        if result:
            produto_data = {
                'produto_id': result[0],
                'nome': result[1],
                'descricao': result[2],
                'preco': result[3],
                'categoria_id': result[4],
                'quantidade_em_stock': result[5],
            }
            return produto_data
        else:
            return None
        


def carrinho(request):
    # Get the cart from the session
    cart = request.session.get('cart', {})

    # Calculate the total for the cart and subtotals for each item
    for item in cart.values():
        item['subtotal'] = item['price'] * item['quantity']
    
    # Calculate the overall total
    carrinho_total = sum(item['subtotal'] for item in cart.values())

    # Pass cart and total to the template
    return render(request, 'carrinho.html', {
        'carrinho': cart.items(),
        'carrinho_total': carrinho_total
    })


def add_to_cart(request, produto_id):
    # Get the product data from the stored procedure
    produto_data = get_product_data(produto_id)
    
    if produto_data is None:
        return JsonResponse({'error': 'Produto não encontrado'}, status=404)
    
    # Get quantity from POST (default to 1 if not provided)
    quantity = request.POST.get('quantity', 1)
    
    # Initialize the cart if it's not already in the session
    if 'cart' not in request.session:
        request.session['cart'] = {}
    
    cart = request.session['cart']

    produto_id = str(produto_id)
    
    # If the item is already in the cart, update the quantity
    if produto_id in cart:
        cart[produto_id]['quantity'] += int(quantity)
    else:
        cart[produto_id] = {
            'name': produto_data['nome'],
            'price': float(produto_data['preco']),  # Convert Decimal to float
            'quantity': int(quantity)
        }
    
    # Save the session
    request.session.modified = True
    
    # Return the product details in the response
    return JsonResponse({"success": True})


def finalizar_compra(request):
    if request.method == 'POST':
        try:
            # Recuperar dados do utilizador e do carrinho da sessão
            utilizador_id = request.session.get('utilizador_id')
            cart = request.session.get('cart', {})
            
            if not cart:
                return JsonResponse({'status': 'error', 'message': 'Carrinho vazio.'}, status=400)

            # Dados do formulário (morada)
            morada = request.POST.get('morada')
            estado = 'pendente'  # Estado inicial da encomenda

            # Converter o carrinho no formato esperado
            itens = [
                {'produto_id': int(produto_id), 'quantidade': item['quantity']}
                for produto_id, item in cart.items()
            ]

            # Chamar a função no banco de dados
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT sp_Encomenda_Com_Itens_CREATE(%s, %s, %s, %s);
                """, [utilizador_id, morada, estado, json.dumps(itens)])

            # Limpar o carrinho após finalizar a compra
            request.session['cart'] = {}

            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": "Invalid request"}, status=500)
    return JsonResponse({"success": False, "error": "Invalid request"}, status=405)

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

def produtos_4recentes():
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM ultimos_produtos_adicionados()")
        colunas = [col[0] for col in cursor.description]
        resultados = [dict(zip(colunas, row)) for row in cursor.fetchall()]
    return resultados

def produtos_mais_stock():
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM get_top_4_produtos_por_stock()")
        colunas = [col[0] for col in cursor.description]
        resultados = [dict(zip(colunas, row)) for row in cursor.fetchall()]
    return resultados

def get_all_produtos():
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM get_all_produtos()")
        colunas = [col[0] for col in cursor.description]
        resultados = [dict(zip(colunas, row)) for row in cursor.fetchall()]
    return resultados

def get_all_categories():
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM get_all_categories()")
        colunas = [col[0] for col in cursor.description]
        resultados = [dict(zip(colunas, row)) for row in cursor.fetchall()]
    return resultados

def obter_produtos_categoria(id):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM obter_produtos_categoria(%s)", [id])
        colunas = [col[0] for col in cursor.description]
        resultados = [dict(zip(colunas, row)) for row in cursor.fetchall()]
    return resultados


def procurar_produto_nome(texto):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM procurar_produto_por_nome(%s)", [texto])
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

def get_fornecedores():
    # Calling the stored procedure using raw SQL
    with connection.cursor() as cursor:
        cursor.callproc('get_all_fornecedores')  # Calling the stored procedure
        rows = cursor.fetchall()  # Fetch all rows returned by the procedure
    
    # Prepare the categories data
    fornecedores = [{'fornecedor_id': row[0], 'nome': row[1]} for row in rows]
    
    return fornecedores

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

def exportar_relatorio(request):
    data_inicio = request.GET.get('data_inicio')
    data_fim = request.GET.get('data_fim')

    if not data_inicio or not data_fim:
        return HttpResponse("Datas inválidas", status=400)

    encomendas = EncomendaView.objects.filter(data_encomenda__range=[data_inicio, data_fim])

    # Separar encomendas por estado
    enviadas = []
    pendentes = []

    for encomenda in encomendas:
        data_formatada = encomenda.data_encomenda.strftime('%Y-%m-%d')
        item = {
            "Encomenda ID": encomenda.encomenda_id,
            "Nome do Cliente": encomenda.nome_user,
            "Morada": encomenda.morada,
            "Data da Encomenda": data_formatada,
            "Estado": encomenda.estado,
            "Produto": encomenda.nome_produto,
            "Preço Total": encomenda.preco_total
        }

        if encomenda.estado.lower() == "enviada":
            enviadas.append(item)
        else:
            pendentes.append(item)

    # Criar ficheiro Excel
    wb = Workbook()
    ws = wb.active
    ws.title = "Relatório"

    # Adicionar Título
    titulo = f"Relatório de Vendas - {data_inicio} a {data_fim}"
    ws.append([titulo])
    ws.merge_cells(start_row=1, start_column=1, end_row=1, end_column=7)
    ws["A1"].font = Font(size=14, bold=True)
    ws["A1"].alignment = Alignment(horizontal="center")

    # Criar função para adicionar tabelas formatadas
    def adicionar_tabela(nome, dados, linha_inicial):
        ws.append([])
        ws.append([nome])
        ws["A{}".format(linha_inicial + 1)].font = Font(bold=True, size=12)

        if dados:
            df = pd.DataFrame(dados)

            # Adicionar cabeçalhos com formatação
            ws.append(df.columns.tolist())
            ultima_linha = ws.max_row
            for col_num, col_nome in enumerate(df.columns, start=1):
                cell = ws.cell(row=ultima_linha, column=col_num)
                cell.font = Font(bold=True)
                cell.alignment = Alignment(horizontal="center")

            # Adicionar os dados
            for r in df.itertuples(index=False, name=None):
                ws.append(r)

            # Adicionar somatório final
            total = sum(item["Preço Total"] for item in dados)
            ws.append([])
            ws.append(["Total", "", "", "", "", "", total])
            ws["G{}".format(ws.max_row)].font = Font(bold=True)

            # Ajustar a largura das colunas automaticamente
            for col in range(1, ws.max_column + 1):
                max_length = 0
                col_letter = get_column_letter(col)
                for cell in ws[col_letter]:
                    try:
                        if cell.value:
                            max_length = max(max_length, len(str(cell.value)))
                    except:
                        pass
                ws.column_dimensions[col_letter].width = max_length + 2  # Adiciona um pouco de espaço extra

        else:
            ws.append(["Sem dados"])

    # Adicionar tabela "Enviadas"
    adicionar_tabela("📦 Encomendas Enviadas", enviadas, ws.max_row + 2)

    # Adicionar tabela "Pendentes"
    adicionar_tabela("⌛ Encomendas Pendentes", pendentes, ws.max_row + 2)

    # Enviar ficheiro como resposta
    response = HttpResponse(content_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    response["Content-Disposition"] = f'attachment; filename="relatorio_vendas {data_inicio} a {data_fim}.xlsx"'
    wb.save(response)

    return response


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

def ver_encomendas_clientes(request, utilizador_id):
    encomendas = obter_encomendas_utilizador(utilizador_id)  # Function to get orders by user
    return render(request, 'encomendas_table.html', {'encomendas': encomendas})

def enviar_encomenda(request, encomenda_id):
    if request.method == 'POST':

        try:
            with connection.cursor() as cursor:
                cursor.callproc('sp_Encomenda_UPDATE', [encomenda_id, 'enviada'])
            return JsonResponse({"success": True})
        except Exception as e:
            return JsonResponse({"success": False, "error": str(e)}, status=400)

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

def requerir_produto(request):
            data = json.loads(request.body)
            produto_id = data.get('produto_id')
            quantidade = data.get('quantidade')
            preco = data.get('preco')
            preco = (float(preco) * int(quantidade)) * 0.75 #Vamos assumir que os produtos são vendidos todos com uma margem de 25% de lucro
            horas_adicionais = random.randint(12, 24)
            data_rececao = datetime.now() + timedelta(hours=horas_adicionais)
            data_rececao_str = data_rececao.strftime('%Y-%m-%d %H:%M:%S')
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM obter_fornecedor_produto(%s)", [produto_id])
                result = cursor.fetchone()  # Retorna apenas um fornecedor
                cursor.callproc('sp_RequisicaoProduto_CREATE', [result[0], produto_id, quantidade, data_rececao_str])
                cursor.callproc('sp_FaturaFornecedor_CREATE', [result[0], preco])

            messages.success(request, "Stock adicionado com sucesso!")

            return JsonResponse({"success": True})

def add_produto(request):
    # Gerar hora random para a receção do produto
    horas_adicionais = random.randint(12, 24)
    data_rececao = datetime.now() + timedelta(hours=horas_adicionais)
    data_rececao_str = data_rececao.strftime('%Y-%m-%d %H:%M:%S')

    nome = request.POST['nome']
    descricao = request.POST.get('descricao', '')
    preco = request.POST['preco']
    categoria_id = request.POST['categoria']
    fornecedor_id = request.POST['fornecedor']
    quantidade = request.POST['quantidade']
    preco_fatura = (float(preco) * int(quantidade)) * 0.75 #Vamos assumir que os produtos são vendidos todos com uma margem de 25% de lucro

    # Use a stored procedure to insert the product data (replace with actual procedure if needed)
    with connection.cursor() as cursor:
        cursor.callproc('sp_Produto_CREATE', [nome, descricao, preco, categoria_id, 0])
        produto_id = cursor.fetchone()[0]
        cursor.callproc('sp_RequisicaoProduto_CREATE', [fornecedor_id, produto_id, quantidade, data_rececao_str])
        cursor.callproc('sp_FaturaFornecedor_CREATE', [fornecedor_id, preco_fatura])

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

from datetime import datetime

def obter_encomendas_por_data(data_inicio, data_fim):
    # Convertendo as datas de string para o formato datetime, se necessário
    data_inicio = datetime.strptime(data_inicio, "%Y-%m-%d")
    data_fim = datetime.strptime(data_fim, "%Y-%m-%d")
    
    # Obter todas as encomendas
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
    
    # Filtrar as encomendas com base na data
    for encomenda in encomendas:
        # Verificar se a encomenda está dentro do intervalo de datas
        if data_inicio <= encomenda.data_encomenda <= data_fim:
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

def gerar_pdf_encomenda(request, encomenda_id):
    encomenda_list = obter_encomenda(encomenda_id)  # Obtenção dos dados da encomenda
    encomenda = encomenda_list[0] if encomenda_list else None  # Apenas uma encomenda

    # Caso a encomenda não exista
    if encomenda is None:
        return HttpResponse("Encomenda não encontrada", status=404)

    # Preparando a resposta HTTP com o tipo de conteúdo PDF
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="fatura_{encomenda["encomenda_id"]}.pdf"'  # Acessando o valor do dicionário

    # Criando o buffer para o PDF
    buffer = BytesIO()
    p = canvas.Canvas(buffer, pagesize=letter)

    # Definindo margens
    margem_esquerda = 50
    margem_topo = 750

    # Adicionando o nome da empresa no topo
    p.setFont("Helvetica-Bold", 18)
    p.drawString(margem_esquerda, margem_topo, "A Minha Loja")
    p.setFont("Helvetica", 10)
    p.drawString(margem_esquerda, margem_topo - 20, "Rua do Fundo, Viseu")
    p.drawString(margem_esquerda, margem_topo - 35, "Telefone: +351 123 456 789 | Email: info@vendas.com")
    
    # Adicionando título "Fatura"
    p.setFont("Helvetica-Bold", 14)
    p.drawString(400, margem_topo, f"Fatura # {encomenda['encomenda_id']}")

    # Adicionando dados da encomenda
    p.setFont("Helvetica", 10)
    p.drawString(50, margem_topo - 70, f"Fatura # {encomenda['encomenda_id']}")
    p.drawString(50, margem_topo - 85, f"Data: {encomenda['data_encomenda'].strftime('%d/%m/%Y')}")
    p.drawString(50, margem_topo - 100, f"Cliente: {encomenda['nome_user']}")
    p.drawString(50, margem_topo - 115, f"Morada: {encomenda['morada']}")

    # Adicionando tabela de produtos
    margem_topo_produtos = margem_topo - 160
    p.setFont("Helvetica-Bold", 10)
    p.drawString(margem_esquerda, margem_topo_produtos, "Produto")
    p.drawString(250, margem_topo_produtos, "Quantidade")
    p.drawString(350, margem_topo_produtos, "Preço Unitário")
    p.drawString(450, margem_topo_produtos, "Preço Total")

    # Linha horizontal
    p.setLineWidth(0.5)
    p.line(margem_esquerda, margem_topo_produtos - 5, 550, margem_topo_produtos - 5)

    # Adicionando os itens da encomenda
    y_position = margem_topo_produtos - 20
    p.setFont("Helvetica", 10)
    for item in encomenda['produto']:
        p.drawString(margem_esquerda, y_position, item['nome'])
        p.drawString(250, y_position, str(item['quantidade']))
        p.drawString(350, y_position, f"€{item['preco_unitario']:,.2f}")
        p.drawString(450, y_position, f"€{item['preco_total']:,.2f}")
        y_position -= 20

    # Linha horizontal após os produtos
    p.line(margem_esquerda, y_position, 550, y_position)

    # Total da encomenda
    p.setFont("Helvetica-Bold", 12)
    p.drawString(350, y_position - 20, "Total:")
    p.setFont("Helvetica", 12)
    preco_total = f"€{encomenda['preco_total']:,.2f}"
    p.drawString(450, y_position - 20, preco_total)

    # Finalizando o PDF
    p.showPage()
    p.save()

    # Retornando o PDF gerado
    buffer.seek(0)
    response.write(buffer.read())
    return response
