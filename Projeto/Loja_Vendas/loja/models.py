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

class Compra(models.Model):
    utilizador = models.ForeignKey(User, on_delete=models.CASCADE)
    produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    quantidade = models.PositiveIntegerField(default=1)
    data_compra = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.produto.nome} ({self.quantidade}) - {self.utilizador.username}'
