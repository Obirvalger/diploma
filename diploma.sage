k = 5
R.<x,y> = GF(k)[]
flist, glist = [], []
var('f_n g_n')
#j = 1 - (y-x)^(k-1)
#p = j(0,x)*f_n + j(1,x)*g_n - j(2,x)*f_n - j(3,x)*g_n + j(4,x)*f_n

z1,z2 = GF(5)['z1, z2'].gens()
print '$ f_{n+1} = j_0(x_{n+1})f_n + j_1(x_{n+1})g_n - j_2(x_{n+1})f_n - j_3(x_{n+1})g_n + j_4(x_{n+1})f_n'
for i in range(k):
    z1 = z2 - i
    p = (1-z1^(k-1))*f_n + (1-(z1-1)^(k-1))*g_n - (1-(z1-2)^(k-1))*f_n - (1-(z1-3)^4)*g_n + (1-(z1-4)^4)*f_n
    flist.append(p.expand().collect(z2).subs(z2=x+i))
    print ' = ' + latex(flist[i]).replace('x','x_{n+1}')
print '$\n'

print '$ g_{n+1} = j_0(x_{n+1})g_n - j_1(x_{n+1})f_n - j_2(x_{n+1})g_n + j_3(x_{n+1})f_n + j_4(x_{n+1})g_n'
for i in range(k):
    z1 = z2 - i
    p = (1-z1^(k-1))*g_n - (1-(z1-1)^(k-1))*f_n - (1-(z1-2)^(k-1))*g_n + (1-(z1-3)^4)*f_n + (1-(z1-4)^4)*g_n
    glist.append(p.expand().collect(z2).subs(z2=x+i))
    print ' = ' + latex(glist[i]).replace('x','x_{n+1}')
print '$\n'

# #s = ''
# print flist[0]
# print '\n'.join([' + '.join([str(flist[0].coeff(x,j) * i^j) for j in range(k-1,-1,-1)]) +' = '+str(flist[0](x=i)) for i in range(k)])
'''
for i in range(k):
    strMyOne = ''
    for j in range(k):
        print flist[0].coeff(x,j) * i^j
    print strMyOne
'''
#print (flist[0] + glist[0]).collect(x)
