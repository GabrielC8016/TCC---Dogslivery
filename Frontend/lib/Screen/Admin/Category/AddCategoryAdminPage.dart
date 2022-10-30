// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:dogslivery/Bloc/Products/products_bloc.dart';
import 'package:dogslivery/Screen/Admin/Category/CategoriesAdminPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';
import 'package:dogslivery/Helpers/Helpers.dart';

class AddCategoryAdminPage extends StatefulWidget {
  @override
  _AddCategoryAdminPageState createState() => _AddCategoryAdminPageState();
}

class _AddCategoryAdminPageState extends State<AddCategoryAdminPage> {
  late TextEditingController _nameCategoryController;
  late TextEditingController _categoryDescriptionController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameCategoryController = TextEditingController();
    _categoryDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameCategoryController.clear();
    _categoryDescriptionController.clear();
    _nameCategoryController.dispose();
    _categoryDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductsBloc>(context);

    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is LoadingProductsState) {
          modalLoading(context);
        } else if (state is SuccessProductsState) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context, routeDogsLivery(page: CategoriesAdminPage()));
        } else if (state is FailureProductsState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: TextDogsLivery(text: state.error, color: Colors.white),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextDogsLivery(text: 'Adicionar Categoria'),
          centerTitle: true,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new_rounded,
                    color: ColorsDogsLivery.primaryColor, size: 17),
                TextDogsLivery(
                    text: 'Voltar',
                    fontSize: 17,
                    color: ColorsDogsLivery.primaryColor)
              ],
            ),
          ),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  if (_keyForm.currentState!.validate()) {
                    productBloc.add(OnAddNewCategoryEvent(
                        _nameCategoryController.text,
                        _categoryDescriptionController.text));
                  }
                },
                child: TextDogsLivery(
                    text: 'Salvar', color: ColorsDogsLivery.primaryColor))
          ],
        ),
        body: Form(
          key: _keyForm,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.0),
                TextDogsLivery(text: 'Nome da Empresa'),
                SizedBox(height: 5.0),
                FormFieldDogsLivery(
                  controller: _nameCategoryController,
                  hintText: 'Produtos',
                  validator: RequiredValidator(
                      errorText: 'Nome da Empresa é Obrigatório'),
                ),
                SizedBox(height: 25.0),
                TextDogsLivery(text: 'Descrição da Empresa'),
                SizedBox(height: 5.0),
                FormFieldDogsLivery(
                  controller: _categoryDescriptionController,
                  maxLine: 8,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
