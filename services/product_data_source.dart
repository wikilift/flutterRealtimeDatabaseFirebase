import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class ProductDataSource extends ChangeNotifier {
  final String _baseUrl = 'testingflutterapp-5b65e-default-rtdb.europe-west1.firebasedatabase.app';

  final List<Products> products = [];
  late Products selectedProduct;

  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductDataSource() {
    this.loadProducts();
  }

  Future<List<Products>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Products.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Products product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // Es necesario crear
      await createProduct(product);
    } else {
      // Actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Products product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.put(url, body: product.toJson());
    final decodedData = resp.body;

    //TODO: Actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Products product) async {
    final url = Uri.https(_baseUrl, 'products.json', {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];

    products.add(product);

    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dx0pryfzn/image/upload?upload_preset=autwc6pa');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
