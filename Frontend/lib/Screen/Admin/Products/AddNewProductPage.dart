import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dogslivery/Bloc/Products/products_bloc.dart';
import 'package:dogslivery/Screen/Admin/AdminHomePage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';


class AddNewProductPage extends StatefulWidget {
  @override
  _AddNewProductPageState createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.clear();
    _nameController.dispose();
    _descriptionController.clear();
    _descriptionController.dispose();
    _priceController.clear();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final productBloc = BlocProvider.of<ProductsBloc>(context);

    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        
        if( state is LoadingProductsState ){

          modalLoading(context);

        } else if ( state is SuccessProductsState ){

          Navigator.pop(context);
          modalSuccess(context, 'Produto Adicionado com Sucesso', () => Navigator.pushReplacement(context, routeDogsLivery(page: AdminHomePage())));
        
        } else if ( state is FailureProductsState ){

          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: TextDogsLivery(text: state.error, color: Colors.white), backgroundColor: Colors.red));

        }

      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: TextDogsLivery(text: 'Adicionar Novo Produto'),
            centerTitle: true,
            leadingWidth: 80,
            leading: TextButton(
              child: TextDogsLivery(text: 'Cancelar', color: ColorsDogsLivery.primaryColor, fontSize: 17),
              onPressed: (){
                Navigator.pop(context);
                productBloc.add(OnUnSelectCategoryEvent());
                productBloc.add(OnUnSelectMultipleImagesEvent());
              },
            ),
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  productBloc.add(OnAddNewProductEvent(
                    _nameController.text, 
                    _descriptionController.text, 
                    _priceController.text, 
                    productBloc.state.images!, 
                    productBloc.state.idCategory.toString()
                  ));
                }, 
                child: TextDogsLivery(text: ' Salvar ', color: ColorsDogsLivery.primaryColor )
              )
            ],
          ),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              SizedBox(height: 10.0),
              TextDogsLivery(text: 'Nome do Produto'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _nameController,
                hintText: 'Produto',
                validator: RequiredValidator(errorText: 'O Nome do Produto é Obrigatório'),
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Descrição do Produto'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _descriptionController,
                maxLine: 5,
                validator: RequiredValidator(errorText: 'A Descrição do Produto é Obrigatória'),
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Preço'),
              SizedBox(height: 5.0),
              FormFieldDogsLivery(
                controller: _priceController,
                hintText: '\$ 0.00',
                keyboardType: TextInputType.number,
                validator: RequiredValidator(errorText: 'o Preço é Obrigatório'),
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Foto'),
              SizedBox(height: 10.0),
              InkWell(
                onTap: () async {
    
                  final ImagePicker _picker = ImagePicker();
    
                  final List<XFile>? images = await _picker.pickMultiImage();
    
                  if(images != null)  productBloc.add(OnSelectMultipleImagesEvent(images));
    
                },
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) 
                      => state.images != null
                        ? ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.images?.length,
                            itemBuilder: (_, i) 
                              => Container(
                                height: 100,
                                width: 120,
                                margin: EdgeInsets.only(right: 10.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(state.images![i].path)),
                                    fit: BoxFit.cover
                                  )
                                ),
                              )
                          )
                        : Icon(Icons.wallpaper_rounded, size: 80, color: Colors.grey)
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextDogsLivery(text: 'Categoriia'),
              SizedBox(height: 5.0),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(color: Colors.grey, blurRadius: 7, spreadRadius: -5.0)
                    ]
                  ),
                  child: InkWell(
                    onTap: () => modalSelectionCategory(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 3.5),
                                borderRadius: BorderRadius.circular(6.0)
                              ),
                            ),
                            SizedBox(width: 8.0),
                            BlocBuilder<ProductsBloc, ProductsState>(
                              builder: (context, state) 
                                => state.category == null || state.category == '' ? TextDogsLivery(text: 'Selecione a Categoria') : TextDogsLivery(text: state.category!),
                            )
                          ],
                        ),
                        Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}