import pandas as pd
import numpy as np
import s3fs
import datetime
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from flask import Flask, jsonify, request
import json


#declared an empty variable for reassignment
response = ''

#creating the instance of our flask application
app = Flask(__name__)

#route to entertain our post and get request from flutter app
@app.route('/name', methods = ['GET', 'POST'])
def nameRoute():

    #fetching the global response variable to manipulate inside the function
    global response

    #checking the request type we get from the app 
    if(request.method == 'POST'):
        ProductsHistory = request.data #getting the response data
        
        ProductsHistory_data = json.loads(ProductsHistory.decode('utf-8')) #converting it from json to key value pair


        DataFrameHistory = pd.DataFrame.from_dict(ProductsHistory_data['PurchaseHistory'], orient='index')
        DataFrameProducts = pd.DataFrame.from_dict(ProductsHistory_data['Products'], orient='index')

        DataFrameHistory.reset_index(level=0, inplace=True)
        DataFrameProducts.reset_index(level=0, inplace=True)

        DataFrameHistory.rename(columns = {'Price':'Count'}, inplace = True)
        DataFrameProducts.rename(columns = {'index':'Barcode'}, inplace = True)
        global Products
        Products = DataFrameProducts[['Barcode','SubCategory']].dropna()
        Products=Products.reset_index(drop=True)

        HistoryCart = DataFrameHistory.dropna()

        popular_products = pd.DataFrame(HistoryCart.groupby('SubCategory')['Count'].count())
        popular_products.reset_index(level=0, inplace=True)

        tfidf = TfidfVectorizer(stop_words='english')

        overview_matrix = tfidf.fit_transform(Products['SubCategory'])

        print(popular_products)
        global similarity_matrix
        similarity_matrix = cosine_similarity(overview_matrix,overview_matrix) #Finds all category that matches each other 

        global MostPurchased

        MostPurchased = popular_products.loc[popular_products['Count']. idxmax()]
        print(MostPurchased)
        global mapping
        mapping = pd.Series(Products.index,index = Products['SubCategory'])
        return "History received"
    else:
        return MostPurchased['SubCategory']
        def recommend_Products(Products_SubCategory):
                product_index = mapping[Products_SubCategory]
                if (product_index.size > 1): #check if there is only one product of that product subcategory
                    seen = set()
                    ProductIndex = []
                    for x in mapping[Products_SubCategory]:
                        if x not in seen:
                            ProductIndex.append(x)
                            seen.add(x)
                else:
                    Barcodes = Products['Barcode'].iloc[product_index.size] #return the only one product
                    return Barcodes

                similarity_score = []
                for x in ProductIndex:
                    similarity_score=list(enumerate(similarity_matrix[x])) #gets the similar subcategory based on the number of purchase

                sorted_similarity_score=[]
                sorted_similarity_score = sorted(similarity_score, key=lambda x: x[1], reverse=True) #sort them

                exact_score=sorted_similarity_score[0:len(ProductIndex)]


                matchedProducts = [i[0] for i in exact_score] 
                print(list(Products['Barcode'].iloc[matchedProducts])[1])

                return list(Products['Barcode'].iloc[matchedProducts]) #return prodcut barcode using the mapping series

        RecommendedItems=[]
        RecommendedItems=recommend_Products(MostPurchased['SubCategory'])
        return jsonify({'Barcodes' : RecommendedItems}) 


if __name__ == "__main__":
    app.run(host="0.0.0.0")

