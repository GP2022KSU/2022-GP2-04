import pandas as pd
import numpy as np
import s3fs
import json
from sklearn.metrics.pairwise import cosine_similarity
import datetime
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
from pandas import json_normalize
from unicodedata import category
from sklearn.metrics.pairwise import sigmoid_kernel
import matplotlib.pyplot as plt


JsonFileHistoryCarts = open('Carts.json',encoding="utf8")
JsonFileProducts = open('Products.json',encoding="utf8")


dictHistory= json.load(JsonFileHistoryCarts)
dictProducts=json.load(JsonFileProducts)


DataFrameHistory = pd.DataFrame.from_dict(dictHistory, orient='index')
DataFrameProducts = pd.DataFrame.from_dict(dictProducts, orient='index')

DataFrameHistory.reset_index(level=0, inplace=True)
DataFrameProducts.reset_index(level=0, inplace=True)

DataFrameHistory.rename(columns = {'Price':'Count'}, inplace = True)
DataFrameProducts.rename(columns = {'index':'Barcode'}, inplace = True)

Products = DataFrameProducts[['Barcode','SubCategory']].dropna()
Products=Products.reset_index(drop=True)

HistoryCart = DataFrameHistory.dropna()

popular_products = pd.DataFrame(HistoryCart.groupby('SubCategory')['Count'].count())
popular_products.reset_index(level=0, inplace=True)

#plt.figure(figsize=(9, 3))

#plt.bar(popular_products['SubCategory'], popular_products['Count'])
#plt.show()

tfidf = TfidfVectorizer(stop_words='english')

overview_matrix = tfidf.fit_transform(Products['SubCategory'])


similarity_matrix = linear_kernel(overview_matrix,overview_matrix) #Finds all category that matches each other 


MostPurchased = popular_products.loc[popular_products['Count']. idxmax()]

mapping = pd.Series(Products.index,index = Products['SubCategory'])

def recommend_Products(Products_SubCategory):
    seen = set()
    ProductIndex = []
    for x in mapping[Products_SubCategory]:
        if x not in seen:
            ProductIndex.append(x)
            seen.add(x)

    similarity_score = []
    for x in ProductIndex:
        similarity_score=list(enumerate(similarity_matrix[x]))


    sorted_similarity_score=[]
    sorted_similarity_score = sorted(similarity_score, key=lambda x: x[1], reverse=True)


    exact_score=sorted_similarity_score[0:len(ProductIndex)]



    #return prodcut barcode using the mapping series

    matchedProducts = [i[0] for i in exact_score]

    return Products['Barcode'].iloc[matchedProducts]

RecommendedItems=[]
RecommendedItems=recommend_Products(MostPurchased['SubCategory'])
#print(RecommendedItems)