import 'package:flutter/material.dart';
import 'package:lekhk/models/blogItemModel.dart';
import 'package:provider/provider.dart';

class BlogItemProvider extends ChangeNotifier {
  List<blogItemModel> blogItemsProviderList = [];

  void addBlogItem(blogItemModel item) {
    blogItemsProviderList.add(item);
    notifyListeners();
  }
  void deleteItem(int index){
    blogItemsProviderList.removeAt(index);
    notifyListeners();
  }
}
