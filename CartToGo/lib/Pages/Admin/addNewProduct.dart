import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carttogo/main.dart';
import 'package:flutter/services.dart';
import 'package:carttogo/Pages/Admin/adminProductsList.dart';
import 'package:carttogo/scanner_icons.dart'; // import custom icon
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:qr_code_scanner/qr_code_scanner.dart'; // A Flutter plugin by Julius Canute https://pub.dev/packages/qr_code_scanner
import 'dart:developer';
import 'package:carttogo/widgets/productImage.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddNewProduct extends StatefulWidget {
  String scanData;
  AddNewProduct(this.scanData);
  @override
  State<AddNewProduct> createState() => AddNewProductState(scanData);
}

class AddNewProductState extends State<AddNewProduct> {
  File? pickedImage;
  bool imgEmpty = false;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imagePath = File(image.path);
      print(imagePath.toString());
      setState(() => pickedImage = File(image.path));

      final imageController = await saveImagePermanently(image.path);
    } on PlatformException catch (e) {
      print('filled pick iamge $e');
    }
  }

  Future<String> uploadImage() async {
    final productImage = File(pickedImage!.path);
    final path = "ProductsImages/" + pbarcodeController.text + '.png';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(productImage);
    final imageUrl = ref.getDownloadURL();

    return imageUrl;
  }

  // try {
  //   final image = await ImagePicker().pickImage(source: source);
  //   if (image == null) return;
  //   final ref = FirebaseStorage.instance.ref().child(path);
  //   ref.putFile(imagePath);
  //   setState(() => this.productImage = imagePath);
  //   final imageController = await saveImagePermanently(image.path);
  // } on PlatformException catch (e) {
  //   print('filled pick iamge $e');
  // }

  Future saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(imagePath);
    final image = File('${directory.path}/$name');
    //print(image.path);
    return File(imagePath).copy(image.path);
  }

  // Locations list for the dropdown menue
  List<String> Locations = [
    'ممر 1',
    'ممر 2',
    'ممر 3',
    'ممر 4',
    'ممر 5',
    'ممر 6',
    'ممر 7',
    'ممر 8',
    'ممر 9',
    'ممر 10',
    'ممر 11',
    'ممر 12'
  ];
  String? selectedLocation; // to save the value of chosen location

  // Brands list for the dropdown menue
  List<String> Brands = [
    'أبو كأس',
    'السعودية',
    'الوها',
    'المراعي',
    'الصافي',
    'البطل',
    'الطائي',
    'اوريو',
    'اوكيفس',
    'بيرين',
    'بيبسي',
    'تويكس',
    'تريفا',
    'جود',
    'جيوفاني',
    'ديتول',
    'دايجستف',
    'سانيتا',
    'سفن اب',
    'سيزر',
    'سولين',
    'غارنييه',
    'فاين',
    'فانتا',
    'قودي',
    'كوكاكولا',
    'كادينا',
    'كيندر',
    'لفانا',
    'لوزين',
    'لون',
    'لايون',
    'نيفيا',
    'نوفا',
    'نادك',
    'هاينز',
    'ووتر وايبس',
  ];
  String? selectedBrand; // to save the value of chosen brand

  // Categories list for the dropdown menue
  List<String> Categories = [
    'العناية بالبشرة',
    'العناية بالشعر',
    'العناية بالأقدام',
    'أطعمة معلبة',
    'حلويات و بسكويتات',
    'سيزر',
    'شاي وقهوة',
    'عسل',
    'لوازم الصحة والعناية الشخصية',
    'صلصات طعام',
    'منظفات ومطهرات',
    'مناديل',
    'مشروبات',
    'مياه',
    'مخبوزات',
    'منتجات الألبان',
    'وجبات خفيفة',
  ];
  String? selectedCategory; // to save the value of chosen category

  // Sub ategories list for the dropdown menue, to use with the offers recommendations
  List<String> SubCategories = [
    'أسماك معلبة',
    'بقوليات معلبة',
    'بسكويت',
    'جبن',
    'حليب',
    'خبز',
    'زبادي',
    'شوكولاته',
    'شاي',
    'شامبو',
    'عصائر',
    'فشار',
    'كريم قدمين',
    'كريم يدين',
    'مناديل مبللة',
    'مناديل جيب',
    'مناديل مطبخ',
    'مشروب غازي',
    'مياه شرب',
    'معقم',
    'مايونيز',
  ];
  String? selectedSubCategory; // to save the value of chosen sub category

  // Sizes list for the dropdown menue
  List<String> Sizes = [
    'غرام',
    'مليلتر',
    'لتر',
    'منديل',
    'كيس',
    'رول',
    'كيلو',
    'قطعة',
  ];
  String? selectedSize; // to save the value of chosen size

  late String scanData;
  AddNewProductState(this.scanData);
  @override

  //create add new product form
  final _formKey = GlobalKey<FormState>();
  var pbarcodeController = new TextEditingController();
  var pNameController = new TextEditingController();
  var pQuantityController = new TextEditingController();
  var pSizeController = new TextEditingController();
  var pPriceController = new TextEditingController();

  final databaseRef = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    setState(() => pbarcodeController.text = scanData);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: appColor,
          ),
          backgroundColor: Colors.white,
          title: const Text("اضافة منتج جديد",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          pickedImage != null
                              ? ImageWidget(
                                  image: pickedImage!,
                                  onClicked: (source) => pickImage(source),
                                )
                              : ImageWidget(
                                  image: File(
                                      'CartToGo/assets/images/addImage.png'),
                                  onClicked: (source) => pickImage(source),
                                ),
                          const SizedBox(height: 5),
                          Visibility(
                              visible: imgEmpty,
                              child: const Text(
                                "الرجاء إضافة صورة",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 225, 48, 48)),
                              )),
                          // imageButton(
                          //     icon: Icons.image_outlined,
                          //     title: "الكاميرا",
                          //     onClicked: () => pickImage(ImageSource.gallery)),
                          // imageButton(
                          //     icon: Icons.camera_alt_outlined,
                          //     title: "آلبوم الصور",
                          //     onClicked: () => pickImage(ImageSource.camera)),

                          // Product's barcode number
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                // #1 the barcode number can be added by typing
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // numbers keyboard to ensure only numbers can be entered
                                controller: pbarcodeController,
                                decoration: InputDecoration(
                                  labelText: "الرمز الشريطي",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل الرمز الشريطي للمنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),

                                  // #2 the barcode number can be added by scanning
                                  // click on the scan icon to open the scanner to scan the product's barcode
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const scanProductBarcode(),
                                      ));
                                    },
                                    icon: const Icon(Scanner.scanner),
                                    color: appColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة الرمز الشريطي للمنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'الرمز الشريطي للمنتج يجب ان لا يحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 5),

                          // Product's name
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: pNameController,
                                decoration: const InputDecoration(
                                  labelText: "الإسم",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل إسم المنتج",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة إسم المنتج';
                                  }
                                  if (value.contains(RegExp(r'[0-9]'))) {
                                    return 'اسم المنتج يجب ان لا يحتوي على ارقام';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 5),

                          // Product's brand
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                  labelText: 'العلامة التجارية',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: appColor,
                              ),
                              // Array list of brands names
                              items: Brands.map((String items) {
                                return DropdownMenuItem(
                                  alignment: Alignment.topRight,
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              validator: (value) => value == null
                                  ? 'الرجاء اختيار العلامة التجارية'
                                  : null,
                              // After selecting the brand name ,it will
                              // change button value to selected brand name
                              onChanged: (String? newBrand) {
                                setState(() {
                                  selectedBrand = newBrand!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Product's location
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                  labelText: 'الموقع',
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: appColor,
                              ),
                              // Array list of locations
                              items: Locations.map((String items) {
                                return DropdownMenuItem(
                                  alignment: Alignment.topRight,
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              validator: (value) =>
                                  value == null ? 'الرجاء اختيار الموقع' : null,
                              // After selecting the location ,it will
                              // change button value to selected location
                              onChanged: (String? newLocation) {
                                setState(() {
                                  selectedLocation = newLocation!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Product's sub category
                          Row(
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Flexible(
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
                                        ),
                                        labelText: 'الفئة الفرعية',
                                        labelStyle: TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: appColor,
                                    ),
                                    // Array list of sub categories
                                    items: SubCategories.map((String items) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    validator: (value) => value == null
                                        ? 'الرجاء اختيار الفئة الفرعية'
                                        : null,
                                    // After selecting the sub category ,it will
                                    // change button value to selected sub category
                                    onChanged: (String? newSubCategory) {
                                      setState(() {
                                        selectedSubCategory = newSubCategory!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Product's category
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Flexible(
                                  child: DropdownButtonFormField(
                                    alignment: AlignmentDirectional.center,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
                                        ),
                                        labelText: 'الفئه',
                                        labelStyle: TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: appColor,
                                    ),
                                    // Array list of categories
                                    items: Categories.map((String items) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    validator: (value) => value == null
                                        ? 'الرجاء اختيار الفئة'
                                        : null,
                                    // After selecting the category ,it will
                                    // change button value to selected category
                                    onChanged: (String? newCategory) {
                                      setState(() {
                                        selectedCategory = newCategory!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Product's measuring unit
                          Row(
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Flexible(
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
                                        ),
                                        labelText: 'وحدة القياس',
                                        labelStyle: TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: appColor,
                                    ),
                                    // Array list of units
                                    items: Sizes.map((String items) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    validator: (value) => value == null
                                        ? 'الرجاء اختيار وحدة قياس الحجم'
                                        : null,
                                    // After selecting the unit ,it will
                                    // change button value to selected unit
                                    onChanged: (String? newSize) {
                                      setState(() {
                                        selectedSize = newSize!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Product's size text field
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Flexible(
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'(^\d*\.?\d*)'))
                                      ], // Only numbers can be entered
                                      controller: pSizeController,
                                      decoration: const InputDecoration(
                                        labelText: "الحجم",
                                        labelStyle: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        hintText: "أدخل حجم/وزن المنتج ",
                                        hintStyle: TextStyle(fontSize: 13),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              width: 2, color: appColor),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء كتابة حجم/وزن المنتج';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Product's quantity
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                controller: pQuantityController,
                                decoration: const InputDecoration(
                                  labelText: "الكمية",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل كمية المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة كمية المنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'كمية المنتج يجب ان لا تحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 5),

                          //Product's price
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^\d*\.?\d*)'))
                                ], // Only numbers can be entered
                                controller: pPriceController,
                                decoration: const InputDecoration(
                                  labelText: "السعر",
                                  labelStyle: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  hintText: "أدخل سعر المنتج ",
                                  hintStyle: TextStyle(fontSize: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide:
                                        BorderSide(width: 2, color: appColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء كتابة سعر المنتج';
                                  }
                                  if (value.contains(RegExp(r'[A-Z]')) &&
                                      value.contains(RegExp(r'[a-z]'))) {
                                    return 'سعر المنتج يجب ان لا يحتوي على احرف';
                                  }
                                  return null;
                                },
                                onChanged: (value) {}),
                          ),
                          const SizedBox(height: 5),

                          // start of "add new product" button
                          ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(8.0),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'CartToGo')),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(270, 50)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(90.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all(appColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              onPressed: () {
                                if (pickedImage?.path == null) {
                                  setState(() {
                                    imgEmpty = true;
                                  });
                                } else {
                                  setState(() {
                                    imgEmpty = false;
                                  });
                                }
                                if (_formKey.currentState!.validate()) {
                                  if (pbarcodeController.text.isNotEmpty &&
                                      pNameController.text.isNotEmpty &&
                                      selectedBrand!.isNotEmpty &&
                                      selectedLocation!.isNotEmpty &&
                                      selectedSubCategory!.isNotEmpty &&
                                      selectedCategory!.isNotEmpty &&
                                      selectedSize!.isNotEmpty &&
                                      pSizeController.text.isNotEmpty &&
                                      pQuantityController.text.isNotEmpty &&
                                      pPriceController.text.isNotEmpty &&
                                      pickedImage!.path.isNotEmpty) {
                                    addProduct(
                                      pbarcodeController.text,
                                      pbarcodeController.text,
                                      pNameController.text,
                                      selectedBrand.toString(),
                                      selectedLocation.toString(),
                                      selectedSubCategory.toString(),
                                      selectedCategory.toString(),
                                      selectedSize.toString(),
                                      pSizeController.text,
                                      pQuantityController.text,
                                      pPriceController.text,
                                    );
                                  }
                                  uploadImage();
                                  // if the form is filled correctly،
                                  //navigate to "ProductsListAdmin" to show the product in the products' list
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ProductsListAdmin();
                                  }));
                                }
                              },
                              child: const Text('إضافة المنتج')),
                          // end of "add new product" button
                        ]))
                // end of add new product form
                )));
  }

// add new product to the database/stock
  Future<void> addProduct(
      String barcode,
      String searchBarcode,
      String name,
      String selectedBrand,
      String selectedLocation,
      String selectedSubCategory,
      String selectedCategory,
      String selectedSize,
      String size,
      String quantity,
      String price) async {
    var intBarcode = int.tryParse(barcode);
    String imgurl = await uploadImage();
// insert into database
    databaseRef.child("Products").child("${intBarcode}").set({
      'SearchBarcode': searchBarcode,
      'Name': name,
      'Brand': selectedBrand,
      'Location': selectedLocation,
      'Category': selectedCategory,
      'SubCategory': selectedSubCategory,
      'Size': size + " " + selectedSize,
      'Quantity': int.tryParse(quantity),
      'Price': double.tryParse(price),
      "Offer": false,
      "PriceAfterOffer": 0,
      "ImgUrl": imgurl
    });
    pbarcodeController.clear();
    pNameController.clear();
    pQuantityController.clear();
    pSizeController.clear();
    pPriceController.clear();
  }
}

Widget imageButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked,
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(56),
        primary: Colors.white,
        onPrimary: Colors.black,
        textStyle: TextStyle(fontSize: 20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
      onPressed: onClicked,
    );

// This is a Flutter plugin by Julius Canute https://pub.dev/packages/qr_code_scanner
class scanProductBarcode extends StatefulWidget {
  const scanProductBarcode({Key? key}) : super(key: key);
  @override
  State<scanProductBarcode> createState() => _scanProductBarcodeState();
}

class _scanProductBarcodeState extends State<scanProductBarcode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // scanner page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, actions: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  iconSize: 44,
                  alignment: Alignment.topRight,
                  color: appColor,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductsListAdmin();
                    }));
                  },
                  icon: Icon(Icons.keyboard_arrow_right)))
        ]),
        backgroundColor: Colors.white24,
        body: Column(children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                        child: Text(
                            'قم بمسح الرمز الشريطي للمنتج لإضافته إلى المخزون',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17)))
                  ]))
        ]));
  }

  // the barcode scan area
  Widget _buildQrView(BuildContext context) {
    // check device's size and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation,
    // listen for Flutter SizeChanged notification and update controller
    return QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: appColor,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p));
  }

  void _onQRViewCreated(QRViewController controller) {
    int check = 0;
    setState(() {
      this.controller = controller;
    });

//if the scanner has read the product's barcode number return to "add new prduct page" to complete the "add new product form"
    controller.scannedDataStream.listen((scanData) {
      check++;
      if (check == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNewProduct(scanData.code.toString())));
      }
    });
  }

  // Admin must allow the camera to scan by clicking on the scanner icon, then allow permission
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يوجد سماح من الكاميرا')));
    }
  }
}
