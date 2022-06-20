import 'package:app_firebase_example/models/models.dart';
import 'package:flutter/material.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Products product;

  ProductFormProvider(this.product);

  updateAvailability(bool change) {
    product.available = change;
    notifyListeners();
  }
}
