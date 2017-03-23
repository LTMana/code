from django.shortcuts import render
from fristapp.models import People
# Create your views here.


def first_try(request):
    person = People(name='Spork', job="officer")
    return
