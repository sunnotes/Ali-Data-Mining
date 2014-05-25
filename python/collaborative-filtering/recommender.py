import codecs 
from math import sqrt



class recommender:

   def __init__(self, data, k=1, metric='pearson', n=5):
      """ initialize recommender
      currently, if data is dictionary the recommender is initialized
      to it.
      For all other data types of data, no initialization occurs
      k is the k value for k nearest neighbor
      metric is which distance formula to use
      n is the maximum number of recommendations to make"""
      self.k = k
      self.n = n
      self.user = {}
      self.brand = {}
     
      #
      # The following two variables are used for Slope One
      # 
      self.frequencies = {}
      self.deviations = {}
      # for some reason I want to save the name of the metric
      self.metric = metric
      if self.metric == 'pearson':
         self.fn = self.pearson
      #
      # if data is dictionary set recommender data to it
      #
      if type(data).__name__ == 'dict':
         self.data = data

   def convertProductID2name(self, id):
      """Given product id number return product name"""
      return id


   def userRatings(self, id, n):
      """Return n top ratings for user with id"""
      print ("Ratings for " + self.id)
      ratings = self.data[id]
      print(len(ratings))
      ratings = list(ratings.items())[:n]
      ratings = [(self.convertProductID2name(k), v)
                 for (k, v) in ratings]
      # finally sort and return
      ratings.sort(key=lambda artistTuple: artistTuple[1],
                   reverse=True)      
      for rating in ratings:
         print("%s\t%i" % (rating[0], rating[1]))


   def showUserTopItems(self, user, n):
      """ show top n items for user"""
      items = list(self.data[user].items())
      items.sort(key=lambda itemTuple: itemTuple[1], reverse=True)
      for i in range(n):
         print("%s" % (items[i][1]))
            
   def loadMovieLens(self, path=''):
      self.data = {}
      #
      # first load movie ratings
      #
      i = 0
      #
      # First load book ratings into self.data
      #
      # f = codecs.open(path + "u.data", 'r', 'utf8')
      f = codecs.open(path + "user_brand_score.csv", 'r', 'ascii')
      #  f = open(path + "u.data")
      for line in f:
         i += 1
         # separate line into fields
         fields = line.split(',')
         user = fields[1]
         brand = fields[2]
         score = fields[3].strip()
         if user in self.data:
            currentRatings = self.data[user]
         else:
            currentRatings = {}
         currentRatings[brand] = score
         self.data[user] = currentRatings
      f.close()
       #
      # Now load movie into self.productid2name
      # the file u.item contains movie id, title, release date among
      # other fields
      #
      # f = codecs.open(path + "u.item", 'r', 'utf8')
      f = codecs.open(path + "brand.csv", 'r', 'iso8859-1', 'ignore')
      # f = open(path + "u.item")
      for line in f:
         i += 1
         # separate line into fields
         fields = line.split(',')
         brandid = fields[1].strip()
         self.brand[brandid] = brandid
      f.close()
      #
      #  Now load user info into both self.userid2name
      #  and self.username2id
      #
      # f = codecs.open(path + "u.user", 'r', 'utf8')
      f = open(path + "user.csv")
      for line in f:
         i += 1
         fields = line.split(',')
         userid = fields[1].strip('"')
         self.user[userid] = userid
      f.close()
      print(i)

        
   def computeDeviations(self):
      # for each person in the data:
      #    get their ratings
      for ratings in self.data.values():
         # for each item & rating in that set of ratings:
         for (item, rating) in ratings.items():
            self.frequencies.setdefault(item, {})
            self.deviations.setdefault(item, {})                    
            # for each item2 & rating2 in that set of ratings:
            for (item2, rating2) in ratings.items():
               if item != item2:
                  # add the difference between the ratings to our
                  # computation
                  self.frequencies[item].setdefault(item2, 0)
                  self.deviations[item].setdefault(item2, 0.0)
                  self.frequencies[item][item2] += 1
                  self.deviations[item][item2] += int(rating) - int(rating2)
        
      for (item, ratings) in self.deviations.items():
         for item2 in ratings:
            ratings[item2] /= self.frequencies[item][item2]


   def slopeOneRecommendations(self, userRatings):
      recommendations = {}
      frequencies = {}
      # for every item and rating in the user's recommendations
      for (userItem, userRating) in userRatings.items():
         # for every item in our dataset that the user didn't rate
         for (diffItem, diffRatings) in self.deviations.items():
            if diffItem not in userRatings and \
               userItem in self.deviations[diffItem]:
               freq = self.frequencies[diffItem][userItem]
               recommendations.setdefault(diffItem, 0.0)
               frequencies.setdefault(diffItem, 0)
               # add to the running sum representing the numerator
               # of the formula
               recommendations[diffItem] += (diffRatings[userItem] + 
                                             int(userRating)) * freq
               # keep a running sum of the frequency of diffitem
               frequencies[diffItem] += freq
      recommendations = [(self.convertProductID2name(k),
                           v / frequencies[k])
                          for (k, v) in recommendations.items()]
      # finally sort and return
      recommendations.sort(key=lambda artistTuple: artistTuple[1],
                           reverse=True)
      # I am only going to return the first 50 recommendations     
      # return recommendations[:5]
# 仅推荐分数超过5分的
      better ={};
      for (k, v) in recommendations:       
           if(v > 5):
               better[k] = v
      return better
    
        
   def pearson(self, rating1, rating2):
      sum_xy = 0
      sum_x = 0
      sum_y = 0
      sum_x2 = 0
      sum_y2 = 0
      n = 0
      for key in rating1:
         if key in rating2:
            n += 1
            x = rating1[key]
            y = rating2[key]
            sum_xy += x * y
            sum_x += x
            sum_y += y
            sum_x2 += pow(x, 2)
            sum_y2 += pow(y, 2)
      if n == 0:
         return 0
      # now compute denominator
      denominator = sqrt(sum_x2 - pow(sum_x, 2) / n) * \
                    sqrt(sum_y2 - pow(sum_y, 2) / n)
      if denominator == 0:
         return 0
      else:
         return (sum_xy - (sum_x * sum_y) / n) / denominator


   def computeNearestNeighbor(self, username):
      """creates a sorted list of users based on their distance
      to username"""
      distances = []
      for instance in self.data:
         if instance != username:
            distance = self.fn(self.data[username],
                               self.data[instance])
            distances.append((instance, distance))
      # sort based on distance -- closest first
      distances.sort(key=lambda artistTuple: artistTuple[1],
                     reverse=True)
      return distances

   def recommend(self, user):
      """Give list of recommendations"""
      recommendations = {}
      # first get list of users  ordered by nearness
      nearest = self.computeNearestNeighbor(user)
      #
      # now get the ratings for the user
      #
      userRatings = self.data[user]
      #
      # determine the total distance
      totalDistance = 0.0
      for i in range(self.k):
         totalDistance += nearest[i][1]
      # now iterate through the k nearest neighbors
      # accumulating their ratings
      for i in range(self.k):
         # compute slice of pie 
         weight = nearest[i][1] / totalDistance
         # get the name of the person
         name = nearest[i][0]
         # get the ratings for this person
         neighborRatings = self.data[name]
         # get the name of the person
         # now find bands neighbor rated that user didn't
         for artist in neighborRatings:
            if not artist in userRatings:
               if artist not in recommendations:
                  recommendations[artist] = neighborRatings[artist] * \
                                            weight
               else:
                  recommendations[artist] = recommendations[artist] + \
                                            neighborRatings[artist] * \
                                            weight
      # now make list from dictionary and only get the first n items
      recommendations = list(recommendations.items())[:self.n]
      recommendations = [(self.convertProductID2name(k), v)
                         for (k, v) in recommendations]
      # finally sort and return
      recommendations.sort(key=lambda artistTuple: artistTuple[1],
                           reverse=True)
      return recommendations




####################
r = recommender(0)
r.loadMovieLens('C:\DEV\WorkSpaces\Ali-Data-Mining\python\data\\')
#print("####################")
#r.showUserTopItems('19500', 10)
#print("####################")
r.computeDeviations() 
print("####################")

#print(r.slopeOneRecommendations(r.data['10000250']))
#print(r.slopeOneRecommendations(r.data['19500']))
file_object = open('C:\DEV\WorkSpaces\Ali-Data-Mining\python\data\\result.txt', 'w')
for id in r.user:
    recommend = r.slopeOneRecommendations(r.data[id])
    all_the_text = ""
    if len(recommend) != 0:
        all_the_text = id + "\t"+ str(recommend.keys())+"\n"  
        file_object.write(all_the_text)
        
file_object.close( )
                                