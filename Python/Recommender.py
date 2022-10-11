import pandas as pd
import numpy as np
import s3fs
import datetime
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
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
        print(request.data)
        ProductsHistory_data = json.loads(ProductsHistory.decode('utf-8')) #converting it from json to key value pair
        JsonFileProducts = open('/Users/haya/Documents/2022-GP1-04/Python/Products.json',encoding="utf8")

    #/Users/haya/Documents/2022-GP1-04/Python/Products.json Haya's path
    
    #dictHistory= json.load(JsonFileHistoryCarts)
        dictProducts=json.load(JsonFileProducts)


        DataFrameHistory = pd.DataFrame.from_dict(ProductsHistory_data, orient='index')
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

        global MostPurchased

        MostPurchased = popular_products.loc[popular_products['Count']. idxmax()]
        print(MostPurchased)
        global mapping
        mapping = pd.Series(Products.index,index = Products['SubCategory'])
        return "History received"
    else:
        return MostPurchased['SubCategory']
        def recommend_Products(Products_SubCategory):
                seen = set()
                ProductIndex = []
                for x in mapping["بقوليات معلبة"]:
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
        print(RecommendedItems)
        return jsonify({'Barcodes' : RecommendedItems}) #sending data back to your frontend app


if __name__ == "__main__":
    app.run(host="0.0.0.0")

