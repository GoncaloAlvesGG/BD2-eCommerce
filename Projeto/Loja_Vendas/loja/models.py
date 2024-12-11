from django.db import models
from django.contrib.auth.models import User

class EncomendaView(models.Model):
    encomenda_id = models.IntegerField(primary_key=True)
    utilizador_id = models.IntegerField()
    nome_user = models.CharField(max_length=100)
    morada = models.CharField(max_length=100)
    data_encomenda = models.DateTimeField()
    estado = models.CharField(max_length=20)
    produto_id = models.IntegerField()
    nome_produto = models.CharField(max_length=100)
    descricao = models.TextField()
    preco_unitario = models.DecimalField(max_digits=10, decimal_places=2)
    quantidade = models.IntegerField()
    preco_total = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'vw_encomendas_utilizador'

class Produto(models.Model):
    nome = models.CharField(max_length=100)
    descricao = models.TextField()
    preco = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.nome
    

class ProdutoView(models.Model):
    produto_id = models.AutoField(primary_key=True)
    produto_nome = models.CharField(max_length=100)
    descricao = models.TextField(null=True, blank=True)
    preco = models.DecimalField(max_digits=10, decimal_places=2)
    quantidade_em_stock = models.IntegerField()
    data_adicao = models.DateTimeField()
    categoria_id = models.IntegerField()
    categoria_nome = models.CharField(max_length=50)

    class Meta:
        managed = False  # Evita que o Django tente criar ou alterar a view
        db_table = 'view_produto'  # Nome exato da view no banco de dados


class UtilizadorView(models.Model):
    utilizador_id = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    email = models.CharField(max_length=100, unique=True)
    isadmin = models.BooleanField()
    data_registo = models.DateTimeField()

    class Meta:
        managed = False  # Evita que o Django tente criar ou modificar a view
        db_table = 'view_utilizador'  # Nome exato da view no banco de dados


class FornecedorView(models.Model):
    fornecedor_id = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=100)
    contato = models.CharField(max_length=100, null=True, blank=True)
    endereco = models.TextField(null=True, blank=True)

    class Meta:
        managed = False
        db_table = 'view_fornecedor'


class Compra(models.Model):
    utilizador = models.ForeignKey(User, on_delete=models.CASCADE)
    produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    quantidade = models.PositiveIntegerField(default=1)
    data_compra = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.produto.nome} ({self.quantidade}) - {self.utilizador.username}'
