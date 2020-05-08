import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _edittedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0.0);
  bool _isLoading = false;

  @override
  void dispose() {
    _descNode.dispose();
    _priceFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.removeListener(_updateImage);
    _imageURLFocusNode.dispose();
    super.dispose();
  }

  var _isInit = false;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _edittedProduct =
            Provider.of<Products>(context, listen: false).getByID(productId);
        _imageURLController.text = _edittedProduct.imageUrl;
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _imageURLFocusNode.addListener(_updateImage);
  }

  void _updateImage() {
    if (!_imageURLFocusNode.hasFocus) {
      if (_imageURLController.text.isEmpty ||
          !_imageURLController.text.startsWith('http') ||
          (!(_imageURLController.text.endsWith('jpeg') ||
              _imageURLController.text.endsWith('jpg') ||
              _imageURLController.text.endsWith('svg') ||
              _imageURLController.text.endsWith('png')))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() async {
    final bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_edittedProduct.id == '') {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_edittedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error ocurred'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        setState(
          () {
            _isLoading = false;
          },
        );
        Navigator.of(context).pop();
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      initialValue: (_edittedProduct.title),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Text cant be empty';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: value,
                          price: _edittedProduct.price,
                          description: _edittedProduct.description,
                          id: _edittedProduct.id,
                          imageUrl: _edittedProduct.imageUrl,
                          isFavourite: _edittedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Price Cant be Empty';
                        } else if (double.tryParse(value) == null) {
                          return 'Price must be a valid number';
                        } else if (double.parse(value) <= 0) {
                          return 'Price must e greater than 0';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_descNode);
                      },
                      initialValue: _edittedProduct.price.toString(),
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: _edittedProduct.title,
                          price: double.parse(value),
                          description: _edittedProduct.description,
                          id: _edittedProduct.id,
                          imageUrl: _edittedProduct.imageUrl,
                          isFavourite: _edittedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Description cant be empty';
                        } else if (value.length <= 10) {
                          return 'Description is too short';
                        }
                        return null;
                      },
                      initialValue: _edittedProduct.description,
                      onSaved: (value) {
                        _edittedProduct = Product(
                          title: _edittedProduct.title,
                          price: _edittedProduct.price,
                          description: value,
                          id: _edittedProduct.id,
                          imageUrl: _edittedProduct.imageUrl,
                          isFavourite: _edittedProduct.isFavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.green)),
                          child: _imageURLController.text.isEmpty
                              ? Text('Enter URL')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(
                                    _imageURLController.text,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLController,
                            focusNode: _imageURLFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL';
                              } else if (!value.startsWith('http')) {
                                return 'Not a valid URL';
                              } else if (!(value.endsWith('jpeg') ||
                                  value.endsWith('jpg') ||
                                  value.endsWith('svg') ||
                                  value.endsWith('png'))) {
                                return 'Not an image URL';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (value) {
                              _edittedProduct = Product(
                                title: _edittedProduct.title,
                                price: _edittedProduct.price,
                                description: _edittedProduct.description,
                                id: _edittedProduct.id,
                                imageUrl: value,
                                isFavourite: _edittedProduct.isFavourite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
