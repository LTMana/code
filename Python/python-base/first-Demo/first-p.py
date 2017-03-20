a='dfdsdf'
b="你好吗" * 3
c='etrte'

d=a+b+c


print(b)

print(type(a))

print(d)


# 字符串截取（前闭后开）
word = 'friends'

find = word[0] + word[2:4] + word[-3:-1]
print(find)

phone = '1360-248-4753'

hide_phone=phone.replace(phone[:-4],'*' * 9)

print(hide_phone)

print(hide_phone.find('47'))

print('liu{}'.format(a))

def area_ddd(base_up,base_down,height=5):
    return 1/2 * (base_up + base_down) * height

print(area_ddd(1,2))
print(area_ddd(1,2,3))
print(area_ddd(height=3,base_up=1,base_down=2))


def s(a,b):
    sum = a+b
    return sum
    
print(s(13,24)) 


 