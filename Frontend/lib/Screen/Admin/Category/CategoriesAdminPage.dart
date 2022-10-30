import 'package:flutter/material.dart';
import 'package:dogslivery/Controller/CategoryController.dart';
import 'package:dogslivery/Models/Response/CategoryAllResponse.dart';
import 'package:dogslivery/Screen/Admin/Category/AddCategoryAdminPage.dart';
import 'package:dogslivery/Themes/ColorsDogsLivery.dart';
import 'package:dogslivery/Widgets/AnimationRoute.dart';
import 'package:dogslivery/Widgets/Widgets.dart';

class CategoriesAdminPage extends StatelessWidget {


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextDogsLivery(text: 'Categorias'),
        centerTitle: true,
        leadingWidth: 80,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new_rounded, color: ColorsDogsLivery.primaryColor, size: 17),
              TextDogsLivery(text: 'Voltar', fontSize: 17, color: ColorsDogsLivery.primaryColor,)
            ],
          ),
        ),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.push(context, routeDogsLivery(page: AddCategoryAdminPage())),
            child: TextDogsLivery(text: 'Adicionar', color: ColorsDogsLivery.primaryColor, fontSize: 17)
          )
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: categoryController.getAllCategories(),
        builder: (context, snapshot) 
          => !snapshot.hasData 
            ? Center(
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  TextDogsLivery(text: 'Carregando categorias...')
                ],
              ),
            )
            : _ListCategories(listCategory: snapshot.data! )
      ),
    );
  }
}

class _ListCategories extends StatelessWidget {
  
  final List<Category> listCategory;

  const _ListCategories({ required this.listCategory});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      physics: BouncingScrollPhysics(),
      itemCount: listCategory.length,
      itemBuilder: (_, i) 
        => Padding(
          padding: EdgeInsets.only(bottom: 15.0),
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    border: Border.all(color: ColorsDogsLivery.primaryColor, width: 4.5)
                  ),
                ),
                SizedBox(width: 20.0),
                TextDogsLivery(text: listCategory[i].category),
              ],
            ),
          ),
        ),
    );
  }
}