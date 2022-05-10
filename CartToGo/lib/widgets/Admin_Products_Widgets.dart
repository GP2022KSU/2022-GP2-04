import 'package:carttogo/Componentss/Componets.dart';
import 'package:carttogo/Users/Products.dart';
import 'package:flutter/material.dart';

class Admin_Products_Widgets extends StatelessWidget {
  Product product;
  var quantityController = TextEditingController();
  var priceController = TextEditingController();

  Admin_Products_Widgets(this.product);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    child: Text("حذف"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {},
                    color: Color.fromARGB(215, 215, 59, 48),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  IconButton(
                      padding: EdgeInsets.all(11.0),
                      onPressed: () {},
                      icon: Icon(Icons.edit))
                ]),
          ),
          Container(
            margin: EdgeInsets.only(left: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text(
                  product.size,
                  style: TextStyle(fontSize: 12.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(
                      child: Text("ريال"),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Container(
                      height: 30,
                      width: 60,
                      padding:EdgeInsets.all(2.0) ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                      color: Color.fromARGB(255, 218, 216, 216),      
                ),
                      
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                         decoration: const InputDecoration(
                            
                             border: InputBorder.none,

                              ),
                          ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(' : السعر'),
                    SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(
                     height: 30,
                      width: 60,
                      padding:EdgeInsets.all(2.0) ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color.fromARGB(255, 218, 216, 216)
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                         decoration: const InputDecoration(
                            
                             border: InputBorder.none,

                              ),
                          ),
                    ),
                    Text(' : الكمية'),
                    SizedBox(
                      width: 5.0,
                    ),
                  
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Container(
//        padding: EdgeInsets.all(10),
//       margin: EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//           MaterialButton(
//              child: Text("حذف"),
//              shape:  RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(18.0),
//                                 ),
//              onPressed: (){},
//              color: Color.fromARGB(215, 215, 59, 48),

//              )
//         ]),
//     ),
