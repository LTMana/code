from django import forms


def word_validator(comment):
    if len(comment) < 4:
        raise ValidationError("not enough words")


def comment_validator(comment):
    keywords = [u"发票", u"钱"]
    for keyword in keywords:
        if keyword in comment:
            raise ValidationError(
                "Your comment contains invalid words,please check it again.")


class CommentForm(forms.Form):
    name = forms.CharField(max_length=50)
    comment = forms.CharField(
        widget=forms.Textarea(),
        error_messages={
            "required": 'wow, such words'
        },
        validators=[word_validator, comment_validator]
    )


# class UserProfileForm(forms.ModelForm):
#     GENDER_CHOICES = (
#         (u'M', u'Male'),
#         (u'F', u'Female'),
#     )
#     gender = forms.ChoiceField(label=u'性别', choices=GENDER_CHOICES,
#                                widget=forms.RadioSelect())
#     photo = forms.ImageField(label=u'上传你喜欢的头像')

#     class Meta:
#     model = UserProfile
#     exclude = ['user', 'usermail', ]
