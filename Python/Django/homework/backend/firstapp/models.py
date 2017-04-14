from django.db import models

from django.contrib.auth.models import User

# Create your models here.


class Article(models.Model):
    title = models.CharField(max_length=500)
    img = models.CharField(null=True, blank=True, max_length=250)
    content = models.TextField(null=True, blank=True)
    views = models.IntegerField(default=0)
    likes = models.IntegerField(default=0)
    createtime = models.DateField()

    def __str__(self):
        return self.title


class UserProfile(models.Model):

    # 用户姓名
    user = models.ForeignKey(User, related_name="profile")
    # 用户头像
    # photo = models.ImageField(
    #     upload_to='profile_image', blank=True, null=True)  # 用户性别
    # GENDER_CHOICES = (
    #     (u'M', u'Male'),
    #     (u'F', u'Female'),
    # )
    # gender = models.CharField(max_length=2, choices=GENDER_CHOICES)

    def __str__(self):
        return self.user


class Comment(models.Model):
    name = models.CharField(max_length=500)
    avatar = models.CharField(
        max_length=250, default="static/images/default.png")
    comment = models.TextField(null=True, blank=True)
    createtime = models.DateField(auto_now=True)

    belong_to = models.ForeignKey(
        to=Article, related_name="under_comments", null=True, blank=True)

    def __str__(self):
        return self.name


class Ticket(models.Model):
    voter = models.ForeignKey(to=User, related_name="user_tickets")
    article = models.ForeignKey(to=Article, related_name="article_tickets")

    ARTICLE_CHOICES = {
        ("like", "like"),
        ("dislike", "dislike"),
        ("normal", "normal")
    }
    choice = models.CharField(choices=ARTICLE_CHOICES, max_length=10)

    def __str__(self):
        return str(self.id)
