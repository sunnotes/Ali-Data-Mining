'''
Created on 2014年5月25日

@author: EASON
'''
import codecs 
def loadResults(path=''):

    #
    # first load movie ratings
    #
    i = 0
    #
    # First load book ratings into self.data
    #
    # f = codecs.open(path + "u.data", 'r', 'utf8')
    f = codecs.open(path + "result3.txt", 'r', 'ascii')
    #  f = open(path + "u.data")
    recomender = {}
    for line in f:
       i += 1
       # separate line into fields
       fields = line.split('\t')
       user = fields[0]      
       brands = fields[1].strip().split(',')
       recomender[user] = brands
    f.close()
    sorted(recomender)
    print(len(recomender))
    return recomender

def loadReal(path=''):

    #
    # first load movie ratings
    #
    i = 0
    #
    # First load book ratings into self.data
    #
    # f = codecs.open(path + "u.data", 'r', 'utf8')
    f = codecs.open(path + "real3.csv", 'r', 'ascii')
    #  f = open(path + "u.data")
    real = {}
    for line in f:
       i += 1
       # separate line into fields
       fields = line.split('\t')
       user = fields[0]      
       brands = fields[1].strip().split(',')
       real[user] = brands
    f.close()
    print(len(real))
    return real

def precision(rec, real):
    pBrands = 0
    hitBrands = 0
    for (k, v) in rec.items():
        pBrands = pBrands + len(v)
        # 该用户确实购买
        if k in real:
            for item in v:
                if item in real[k]:
                    hitBrands = hitBrands + 1 
    precision = hitBrands / pBrands
    print("precision:" + str(precision) , hitBrands, pBrands)
    return precision 

def recall(rec, real):
    bBrands = 0
    hitBrands = 0
    for (k, v) in real.items():
        bBrands = bBrands + len(v)
        # 该用户确实购买
        if k in rec:
            for item in v:
                if item in rec[k]:
                    hitBrands = hitBrands + 1 
    recall = hitBrands / bBrands
    print("recall:" + str(recall) , hitBrands, bBrands)
    return recall   

def F(rec, real):
    prec = precision(rec, real)
    re = recall(rec, real)
    F = 2 * prec * re / (prec + re)
    return F  
    

if __name__ == '__main__':
    recommender = loadResults('C:\DEV\WorkSpaces\Ali-Data-Mining\python\data\\')
    real = loadReal('C:\DEV\WorkSpaces\Ali-Data-Mining\python\data\\')
    # print(recommender)
    # print(real)
    print(F(recommender, real))
    
