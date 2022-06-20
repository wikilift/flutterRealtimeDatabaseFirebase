import 'package:app_firebase_example/providers/products/product_form_provider.dart';
import 'package:app_firebase_example/services/services.dart';
import 'package:app_firebase_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../ui/auth/input_decoration.dart';

class ProductEditScreen extends StatelessWidget {
  const ProductEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductDataSource>(context);
    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(productService.selectedProduct),
      child: _Products_Screen_body(productService: productService),
    );
  }
}

class _Products_Screen_body extends StatelessWidget {
  const _Products_Screen_body({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductDataSource productService;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            _HeaderStack(path: productService.selectedProduct.picture),
            const _ProductForm(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productService.isSaving
            ? null
            : () async {
                if (!productFormProvider.isValidForm()) return;
                final String? imageUrl = await productService.uploadImage();
                if (imageUrl != null) productFormProvider.product.picture = imageUrl;

                await productService.saveOrCreateProduct(productFormProvider.product);
              },
        child: productService.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _HeaderStack extends StatelessWidget {
  const _HeaderStack({
    Key? key,
    this.path,
  }) : super(key: key);
  final String? path;

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductDataSource>(context);
    return Stack(
      children: [
        ProductImage(
          path: path,
        ),
        Positioned(
          top: 60,
          left: 8,
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 40)),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: IconButton(
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
                if (pickedFile == null) {
                  print("not image");
                  return;
                }
                productService.updateSelectedProductImage(pickedFile.path);
              },
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 40)),
        )
      ],
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productFormService = Provider.of<ProductFormProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: _BoxDecoration(),
        width: double.infinity,
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: productFormService.formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  onChanged: (value) => productFormService.product.name = value,
                  validator: (value) {
                    if (value == null || value.length < 1) return 'name is required';
                  },
                  initialValue: productFormService.product.name.toString(),
                  decoration: InputDecorations.authDecoration(hint: 'Product Name', label: 'Name'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      productFormService.product.price = 0;
                    } else {
                      productFormService.product.price = double.parse(value);
                    }
                  },
                  initialValue: '${productFormService.product.price}€',
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authDecoration(
                    hint: '0€',
                    label: 'Price',
                  ),
                ),
                const SizedBox(height: 30),
                SwitchListTile.adaptive(
                  value: productFormService.product.available,
                  title: const Text('Available'),
                  activeColor: Colors.amberAccent,
                  onChanged: productFormService.updateAvailability,
                )
              ],
            )),
      ),
    );
  }

//FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
  BoxDecoration _BoxDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black26, offset: Offset(0, 6), blurRadius: 10),
          ]);
}
