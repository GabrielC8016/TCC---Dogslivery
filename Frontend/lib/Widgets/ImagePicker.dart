import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dogslivery/Bloc/User/user_bloc.dart';
import 'package:dogslivery/Helpers/Helpers.dart';
import 'package:dogslivery/Services/url.dart';

class ImagePickerDogsLivery extends StatelessWidget {

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: Colors.grey[200]!),
        shape: BoxShape.circle
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => modalPictureRegister(
          ctx: context, 
          onPressedChange: () async {
            
            Navigator.pop(context);
            final XFile? imagePath = await _picker.pickImage(source: ImageSource.gallery);
            if( imagePath != null ){
              userBloc.add( OnChangeImageProfileEvent(imagePath.path));
            }

          },
          onPressedTake: () async {

            Navigator.pop(context);
            final XFile? photoPath = await _picker.pickImage(source: ImageSource.camera);
            if( photoPath != null ){
              userBloc.add( OnChangeImageProfileEvent(photoPath.path));
            }

          }
        ),
        child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) 
                => state.user?.image != null 
                  ? Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage( URLS.BASE_URL + state.user!.image.toString()),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                    )
                  : CircularProgressIndicator()
            ),
           
      ),
    );
  }
}