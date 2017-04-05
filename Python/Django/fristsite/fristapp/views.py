from django.shortcuts import render
from fristapp.models import People, Aritcle
from django.http import HttpResponse
from django.template import Context, Template
# Create your views here.


def first_try(request):
    person = People(name='Spork', job="officer")
    html_string = '''
     <html lang="en">

<head>
    <title>firstApp</title>
    <meta charset="UTF-8">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.4/semantic.css" rel="stylesheet">
</head>

<body>

    <h1 class="ui center aligned icon header">
        <i class="hand spock icon"></i> Hello,{{person.name}}
    </h1>



</body>

</html>
    '''
    t = Template(html_string)
    c = Context({'person': person})
    web_page = t.render(c)

    return HttpResponse(web_page)


def index(request):
    Context = {}
    article_list = Aritcle.objects.all()
    Context['article_list'] = article_list
    index_page = render(request, 'firstweb.html', Context)
    return index_page
