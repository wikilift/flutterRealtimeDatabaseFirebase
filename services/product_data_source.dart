import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ProductDataSource extends ChangeNotifier {
  final String _baseUrl = 'testingflutterapp-5b65e-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Products> products = [];
  final _storage = const FlutterSecureStorage();
  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;
  late Products selectedProduct;

  ProductDataSource() {
    loadProducts();
  }

  Future<List<Products>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
      _baseUrl,
      'products.json',
      {'auth': await _storage.read(key: 'idToken') ?? ''},
    );
    final resp = await http.get(url);
    // await products.map((e) => Products.fromJson(resp.body));
    // print(products);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach(
      (key, value) {
        final tempProdcut = Products.fromMap(value);
        tempProdcut.id = key;
        products.add(tempProdcut);
      },
    );
    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Products product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Products p) async {
    final url = Uri.https(_baseUrl, 'products/${p.id}.json', {'auth': await _storage.read(key: 'idToken') ?? ''});
    final resp = await http.put(url, body: p.toJson());
    final decodecData = resp.statusCode;
    final index = products.indexWhere((element) => p.id == element.id);
    print(decodecData);
    products[index] = p;

    //notifyListeners();

    return '';
  }

  Future<String> createProduct(Products p) async {
    final url = Uri.https(_baseUrl, 'products.json', {'auth': await _storage.read(key: 'idToken') ?? ''});
    final resp = await http.post(url, body: p.toJson());
    final decodecData = json.decode(resp.body);
    p.id = decodecData['name'];
    products.add(p);

    //notifyListeners();

    return p.id!;
  }

  void updateSelectedProductImage(path) {
    newPictureFile = File.fromUri(Uri(path: path));
    selectedProduct.picture = path;
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/df8wsfkin/auto/upload?upload_preset=ybja4dlp');
    final requestImageUpload = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);
    //bind
    requestImageUpload.files.add(file);
    //shoot request
    final streamResponse = await requestImageUpload.send();

    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      return null;
    }
    newPictureFile = null;
    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}
