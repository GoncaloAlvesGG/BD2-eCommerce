from django.shortcuts import redirect
from django.urls import reverse

class AuthAndAdminMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response
        self.admin_paths = [
            '/dashboard/',
            '/dashboard/encomendas/',
            '/dashboard/encomendas/enviar/',
            '/dashboard/encomendas/filtrar/',
            '/exportar-relatorio/',
            '/dashboard/produtos/',
            '/dashboard/produtos/add',
            '/dashboard/produtos/add_categoria',
            '/dashboard/produtos/requerir',
            '/dashboard/clientes/',
            '/dashboard/clientes/update',
            '/dashboard/clientes/delete',
            '/dashboard/encomendas_cliente/',
            '/dashboard/fornecedores/',
            '/dashboard/fornecedores/add',
            '/dashboard/fornecedores/update',
            '/dashboard/fornecedores/delete',
            '/fornecedores/',
        ]
        self.allowed_paths = [
            '/login/', '/registo/'  # Apenas login e registo acessíveis sem autenticação
        ]

    def __call__(self, request):
        path = request.path

        # Permitir acesso direto a login e registo
        if path in self.allowed_paths:
            return self.get_response(request)

        # Verificar se o utilizador está autenticado
        if not request.session.get('utilizador_id'):
            return redirect('login')  # Redirecionar para login se não estiver autenticado

        # Restringir acesso às páginas admin apenas para admins
        if any(path.startswith(admin_path) for admin_path in self.admin_paths):
            if not request.session.get('is_admin'):
                return redirect('index')  # Redirecionar para index se não for admin

        return self.get_response(request)
