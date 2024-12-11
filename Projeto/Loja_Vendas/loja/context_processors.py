def user_info(request):
    return {
        'nome': request.session.get('nome', 'Visitante'),
        'email': request.session.get('email', 'Sem email'),
        'is_admin': request.session.get('is_admin', 'False'),
    }