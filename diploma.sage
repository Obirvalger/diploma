# -*- coding: utf-8 -*-
k = 5
R.<x,y> = GF(k)[]
flist, glist = [], []
var('f_n g_n')
sdict = {}
for i in range(k-1):
    var('s'+str(i), latex_name='s_n^'+str(i))

def shift(seq, n):
    n = n % len(seq)
    return seq[n:] + seq[:n]
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

def polymod(p1, x, polar, k):
    s ,q ,v = '', 0, 0
    z1,z2 = GF(5)['z1, z2'].gens()
    z1 = z2 - polar
    p = p1(x = z1)
    for pairs in p.coefficients(z2):
        l = [(pairs[0].coeff(y) % k , y) for y in pairs[0].variables()]
        v = 0
        for elem in l:
            v += elem[1] * elem[0]
        q += v * z2 ^ pairs[1]
    return q(z2 = x + polar)
        
def proof(functionList, fname, ifunc = -1):
    s = ''
    s += r'\begin{proof}' + '\n' + '\nПервое равенство следует из теоремы 1.\n\n'
    z1,z2 = GF(5)['z1, z2'].gens()
    for l in range(k):
        z2 = z1 - l
        q = functionList[l](x = z2)
        s += 'При поляризации $x_{n+1}$, когда $d_{n+1} = ' + str(l) + '$\n'
        s += '$$\\begin{array}{l}\n'
        if (ifunc == -1):
            sq = [str(q(z1=i+l)) for i in range(k)]
        else:
            sq = [modcoeffs(str(flist[l](x=i-0)+ifunc*glist[l](x=i-0)),k) for i in range(k)]
            if (l != 3):
                sq1 = [modcoeffs(str(q(z1=i+l)),k) for i in range(k)]
                if (sq1 != sq):
                    raise Exception(l,ifunc,sq1,sq)
        s += ' \\\\\n'.join([fname + r'(\bar{x}_n, ' + str(i) + ') = ' + modcoeffs(' + '.join([str(q.coeff(z1,j) * ((i+l)%k)^j) \
        for j in range(k-1,-1,-1)]), k) + ' = ' + sq[i] for i in range(k)]) + ' \\\\\n'
        s = s.replace('*', '\,')
        s += '\\end{array}$$\n'
    return s + '\n' + r'\end{proof}' + '\n'

z1,z2 = GF(5)['z1, z2'].gens()
s = r'''\begin{myth} При $n \geqslant 1 $ для периодических функций пятизначной логики $f_n = f^{\left(n\right)}_{\left(1144\right)}$,
$g_n = f^{\left(n\right)}_{\left(1441\right)}$ верны следующие равенства:'''
s += '\n$$\\begin{array}{l}'
s += '\n f_{n+1} = j_0(x_{n+1})f_n + j_1(x_{n+1})g_n + 4\,j_2(x_{n+1})f_n + 4\,j_3(x_{n+1})g_n + j_4(x_{n+1})f_n =\\\\\n'
for i in range(k):
    z1 = z2 - i
    p = (1-z1^(k-1))*f_n + (1-(z1-1)^(k-1))*g_n - (1-(z1-2)^(k-1))*f_n - (1-(z1-3)^4)*g_n + (1-(z1-4)^4)*f_n
    flist.append(p.expand().collect(z2).subs(z2=x+i))
    s += '' + latex(polymod(flist[i], x, i, k)).replace('x','x_{n+1}') + '=\\\\\n'
s += '\\end{array}$$\n\\end{myth}\n\n'
s += proof(flist, 'f_{n+1}')
print s

s = r'''\begin{myth} При $n \geqslant 1 $ для периодических функций пятизначной логики $f_n = f^{\left(n\right)}_{\left(1144\right)}$,
$g_n = f^{\left(n\right)}_{\left(1441\right)}$ верны следующие равенства:'''
s += '\n$$\\begin{array}{l}'
s += '\n g_{n+1} = j_0(x_{n+1})g_n + 4\,j_1(x_{n+1})f_n + 4\,j_2(x_{n+1})g_n + j_3(x_{n+1})f_n + j_4(x_{n+1})g_n=\\\\\n'
for i in range(k):
    z1 = z2 - i
    p = (1-z1^(k-1))*g_n - (1-(z1-1)^(k-1))*f_n - (1-(z1-2)^(k-1))*g_n + (1-(z1-3)^4)*f_n + (1-(z1-4)^4)*g_n
    glist.append(p.expand().collect(z2).subs(z2=x+i))
    s += '' + latex(polymod(glist[i], x, i , k)).replace('x','x_{n+1}') + '=\\\\\n'
s += '\\end{array}$$\n\\end{myth}\n\n'
s += proof(glist, 'g_{n+1}')
print s

for i in range(1, k):
    l = []
    si = str(i)
    s = r'''\begin{myth} При $n \geqslant 1 $ для периодических функций пятизначной логики $f_n = f^{\left(n\right)}_{\left(1144\right)}$,
$g_n = f^{\left(n\right)}_{\left(1441\right)}$ верны следующие равенства:'''
    s += '\n$$\\begin{array}{l}'
    s +=  '\ns_{n+1}^'+si + ' = f_{n+1} +' + (i==1 and ' ' or ' '+si+'\,')+ 'g_{n+1}=\\\\\n' 
    for j in range(k):
        z1 = z2 - j
        p = (flist[j](x=z1) + i * glist[j](x=z1)).collect(z2)(z2=x+j)
        s += '' + latex(p) + '=\\\\\n'
        l.append(p)
    s += '\\end{array}$$\n\\end{myth}\n\n'
    s += proof(l, 's_{n+1}^'+si, i)
    print s
    sdict['s_{n+1}^'+si] = l

