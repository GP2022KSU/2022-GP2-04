import 'package:carttogo/main.dart';
import 'package:carttogo/Componentss/item.dart';
import 'package:flutter/material.dart';

class shoppingListItem extends StatelessWidget {
  final ShoppingItem item;
  final onItemChanged;
  final onDeleteItem;
  final myShoppingList = ShoppingItem.shoppingList();

  shoppingListItem({
    Key? key,
    required this.item,
    required this.onItemChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () {
          onItemChanged(item);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          item.isBuyed ? Icons.check_box : Icons.check_box_outline_blank,
          color: appColor,
        ),
        title: Text(
          item.productName!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: item.isBuyed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          child: IconButton(
            color: Colors.red,
            iconSize: 20,
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeleteItem(item.id);
            },
          ),
        ),
      ),
    );
  }
}
