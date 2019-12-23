import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'id': '',
  };

  Product _editedProduct =
      Product(description: '', id: null, title: '', price: 0.0, imgUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      var id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(id);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'id': _editedProduct.id,
          'imageUrl': '',
          'description': _editedProduct.description,
        };

        _imageUrlController.text = _editedProduct.imgUrl;
      }
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.startsWith('.jpeg') &&
              !_imageUrlController.text.startsWith('.png'))) return;

      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    print(isValid);
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please provide a value.';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              title: val,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imgUrl: _editedProduct.imgUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter a price';
                          if (double.tryParse(val) == null)
                            return 'Please enter a valid number.';
                          if (double.parse(val) <= 0)
                            return 'Please enter a number greater than zero.';

                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(val),
                              description: _editedProduct.description,
                              imgUrl: _editedProduct.imgUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (val) {
                          if (val.isEmpty) return 'Please enter a description';
                          if (val.length < 10)
                            return 'Should be at least 10 characters long';

                          return null;
                        },
                        onSaved: (val) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: val,
                              imgUrl: _editedProduct.imgUrl,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        onFieldSubmitted: (val) {},
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please enter an image URL';

                                if (!val.startsWith('http') &&
                                    !val.startsWith('https'))
                                  return 'Please enter a valid URL';

                                if (!val.endsWith('.jpg') &&
                                    !val.startsWith('.jpeg') &&
                                    !val.startsWith('.png'))
                                  return 'Please enter a valid image URL';

                                return null;
                              },
                              onSaved: (val) {
                                _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    imgUrl: val,
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite);
                              },
                              onFieldSubmitted: (val) {
                                _saveForm();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
