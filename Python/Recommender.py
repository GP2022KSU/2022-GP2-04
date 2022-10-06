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
        request_data = request.data #getting the response data
        request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
        name = request_data['name'] #assigning it to name
        response = f'Hi {name}! this is Python' #re-assigning response with the name we got from the user
        return " " #to avoid a type error 
    else:
        return jsonify({'name' : response}) #sending data back to your frontend app

if __name__ == "__main__":
    app.run(debug=True)


