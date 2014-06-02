'''
Created on 2014年5月26日

@author: EASON
'''
from math import sqrt

def computerSimilarity(band1, band2, userRatings):
    averages = {}
    for(key, ratings) in userRatings.items():
        averages[key] = (float(sum(ratings.values())) / len(ratings.values()))
    
    num = 0
    dem1 = 0
    dem2 = 0
    
    for(user, ratings) in userRatings.item():
        if band1 in ratings and band2 in ratings:
            avg = averages[user]
            num += (ratings[band1] - avg) * (ratings[band2] - avg)
            dem1 += (ratings[band1] - avg) ** 2
            dem2 += (ratings[band2] - avg) ** 2
    return num / (sqrt(dem1) * sqrt(dem2))


def computerDeviations(self):
    for ratings in self.data.values():
        for(item, rating) in ratings.items():
            self.frequencies.setdefault(item, {})
            self.devation.setdefauly(item, {})
            for(item2,rating2) in ratings.item():
                if item != item2:
                    self.frequences[item].setdefault(item2,0)
                    self.deviations[item].setdefault(item2,0.0)
                    self.frequences[item][item2] +=1
                    self.deviations[item][item2] += rating-rating2
                    
    for(item, ratings) in self.deviations.items():
        for item2 in ratings:
            ratings[item2] /= self.frequencies[item][item2]
             
