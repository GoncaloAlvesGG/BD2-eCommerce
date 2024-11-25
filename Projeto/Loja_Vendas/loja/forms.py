from django import forms

class UserSettingsForm(forms.Form):
    username = forms.CharField(max_length=150, label='Nome de Utilizador')
    email = forms.EmailField(label='Email')
    first_name = forms.CharField(max_length=30, label='Nome')
    last_name = forms.CharField(max_length=30, label='Sobrenome')
