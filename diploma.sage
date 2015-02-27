k = 5
R.<x,y> = GF(k)[]
flist, glist = [], []
var('f_n g_n')
# f_n, g_n = GF(k)['f_n', 'g_n'].gens()
#j = 1 - (y-x)^(k-1)
#p = j(0,x)*f_n + j(1,x)*g_n - j(2,x)*f_n - j(3,x)*g_n + j(4,x)*f_n

def shift(seq, n):
    n = n % len(seq)
    return seq[n:] + seq[:n]
# '''
def modcoeffs(s,k):
    unit = 1
    l = s.split(' ')
    o = []
    for x in l:
        if (x=='+'):
            unit = 1
        elif (x=='-'):
            unit = -1
        else:
            muls = x.split('*')
            if (len(muls) == 2):
                unit = (unit * int(muls[0]))%k
                if unit == 1:
                    ms = ''
                else:
                    ms = str(unit) + '*'
                o.append(ms + muls[1])
            else:
                o.append(x)
    return ' + '.join(o)
# '''
z1,z2 = GF(5)['z1, z2'].gens()
# print '$ f_{n+1} = j_0(x_{n+1})f_n + j_1(x_{n+1})g_n - j_2(x_{n+1})f_n - j_3(x_{n+1})g_n + j_4(x_{n+1})f_n'
for i in range(k):
    z1 = z2 - i
    p = (1-z1^(k-1))*f_n + (1-(z1-1)^(k-1))*g_n - (1-(z1-2)^(k-1))*f_n - (1-(z1-3)^4)*g_n + (1-(z1-4)^4)*f_n
    flist.append(p.expand().collect(z2).subs(z2=x+i))
    # print ' = ' + latex(flist[i]).replace('x','x_{n+1}')
# print '$\n'

# print '$ g_{n+1} = j_0(x_{n+1})g_n - j_1(x_{n+1})f_n - j_2(x_{n+1})g_n + j_3(x_{n+1})f_n + j_4(x_{n+1})g_n'
for i in range(k):
    z1 = z2 - i
    p = (1-z1^(k-1))*g_n - (1-(z1-1)^(k-1))*f_n - (1-(z1-2)^(k-1))*g_n + (1-(z1-3)^4)*f_n + (1-(z1-4)^4)*g_n
    glist.append(p.expand().collect(z2).subs(z2=x+i))
    # print ' = ' + latex(glist[i]).replace('x','x_{n+1}')
# print '$\n'

# #s = ''
# print flist[0]
def proof(functionList):
    s = ''
    z1,z2 = GF(5)['z1, z2'].gens()
    for l in range(k):
        # z1,z2 = GF(5)['z1, z2'].gens()
        z2 = z1 - l
        q = functionList[l](x = z2)
        # print q
        # s = q.coefficients(z1)
        s += '\n'.join([modcoeffs(' + '.join([str(q.coeff(z1,j) * ((i+l)%k)^j) for j in shift(range(k-1,-1,-1),l)]), k) + \
        ' = ' + str(q(z1=i+l)) for i in range(k)]) + '\n\n'
        # s = modcoeffs(s,k)
    
    return s

# print flist[1]
print proof(glist)
# print modcoeffs('4*f_n + 3*g_n + 32*f_n + 3*g_n + 4*f_n',k)

'''
for i in range(k):
    strMyOne = ''
    for j in range(k):
        print flist[0].coeff(x,j) * i^j, 
    print
'''
#print (flist[0] + glist[0]).collect(x)
