from django.db import models
from django.contrib.auth.models import User

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
