# Generated by Django 4.2.16 on 2025-01-05 20:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('loja', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='EncomendaView',
            fields=[
                ('encomenda_id', models.IntegerField(primary_key=True, serialize=False)),
                ('utilizador_id', models.IntegerField()),
                ('nome_user', models.CharField(max_length=100)),
                ('morada', models.CharField(max_length=100)),
                ('data_encomenda', models.DateTimeField()),
                ('estado', models.CharField(max_length=20)),
                ('produto_id', models.IntegerField()),
                ('nome_produto', models.CharField(max_length=100)),
                ('descricao', models.TextField()),
                ('preco_unitario', models.DecimalField(decimal_places=2, max_digits=10)),
                ('quantidade', models.IntegerField()),
                ('preco_total', models.DecimalField(decimal_places=2, max_digits=10)),
            ],
            options={
                'db_table': 'vw_encomendas_utilizador',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='FornecedorView',
            fields=[
                ('fornecedor_id', models.AutoField(primary_key=True, serialize=False)),
                ('nome', models.CharField(max_length=100)),
                ('contato', models.CharField(blank=True, max_length=100, null=True)),
                ('endereco', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'view_fornecedor',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='ProdutoView',
            fields=[
                ('produto_id', models.AutoField(primary_key=True, serialize=False)),
                ('produto_nome', models.CharField(max_length=100)),
                ('descricao', models.TextField(blank=True, null=True)),
                ('preco', models.DecimalField(decimal_places=2, max_digits=10)),
                ('quantidade_em_stock', models.IntegerField()),
                ('data_adicao', models.DateTimeField()),
                ('categoria_id', models.IntegerField()),
                ('categoria_nome', models.CharField(max_length=50)),
            ],
            options={
                'db_table': 'view_produto',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='UtilizadorView',
            fields=[
                ('utilizador_id', models.AutoField(primary_key=True, serialize=False)),
                ('nome', models.CharField(max_length=100)),
                ('email', models.CharField(max_length=100, unique=True)),
                ('isadmin', models.BooleanField()),
                ('data_registo', models.DateTimeField()),
            ],
            options={
                'db_table': 'view_utilizador',
                'managed': False,
            },
        ),
    ]
