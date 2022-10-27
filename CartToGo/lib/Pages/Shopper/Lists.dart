import 'package:carttogo/main.dart';
import 'package:flutter/material.dart';
import 'package:carttogo/Pages/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carttogo/widgets/shoppingListItem.dart';
import 'package:carttogo/Componentss/item.dart';

class Lists extends StatefulWidget {
  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> with SingleTickerProviderStateMixin {
  @override
  final ShoppingList = ShoppingItem.shoppingList();
  final _newProductController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Text(
          "القوائم",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'CartToGo',
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(3),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 14,
                        fontFamily: 'CartToGo',
                        fontWeight: FontWeight.bold)),
                    fixedSize: MaterialStateProperty.all(const Size(70, 10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () async {
                  _showMyDialog();
                },
                child: const Text('خروج')),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    15.0,
                  ),
                  color: appColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    icon: Icon(Icons.list_outlined),
                    text: 'قائمة التسوق',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite_border_outlined),
                    text: 'قائمة الأمنيات',
                  ),
                ],
              ),
            ),

            // Tab views inside the TabBar
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 5,
                                      bottom: 20,
                                    ),
                                  ),
                                  for (ShoppingItem myItem in ShoppingList)
                                    shoppingListItem(
                                      item: myItem,
                                      onItemChanged: _handleItemChange,
                                      onDeleteItem: _deleteItem,
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // const SizedBox(height: 100),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 80,
                                right: 20,
                                left: 20,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _newProductController,
                                decoration: InputDecoration(
                                    hintText: 'اضف منتج جديد',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 80,
                              right: 20,
                            ),
                            child: ElevatedButton(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 40,
                                ),
                              ),
                              onPressed: () {
                                _addItem(_newProductController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: appColor,
                                minimumSize: Size(60, 60),
                                elevation: 10,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  // Shopping list tab view
                  Center(
                    child: Text(
                      'تجربة قائمة الأمنيات',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleItemChange(ShoppingItem item) {
    setState(() {
      item.isBuyed = !item.isBuyed;
    });
  }

  void _deleteItem(String id) {
    setState(() {
      ShoppingList.removeWhere((item) => item.id == id);
    });
  }

  void _addItem(String shoppingItem) {
    setState(() {
      ShoppingList.add(ShoppingItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productName: shoppingItem,
      ));
    });
    _newProductController.clear();
  }

  //logout dialog, to ensure that the shopper want to log out or not
  void _showMyDialog() async {
    return showDialog<void>(
        context: context,
        // user must tap button!
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                  elevation: 0,
                  backgroundColor: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(height: 15),
                    Text(
                      "هل تريد تسجيل الخروج؟",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            highlightColor: Colors.grey[200],
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              print(
                                  "UID: ${FirebaseAuth.instance.currentUser?.uid}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomePage()));
                            },
                            child: Center(
                                child: Text("خروج",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color(0xFFFE4A49),
                                      fontWeight: FontWeight.bold,
                                    ))))),
                    Divider(
                      height: 1,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: InkWell(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                                child: Text("إلغاء",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    )))))
                  ])));
        });
  }
}
