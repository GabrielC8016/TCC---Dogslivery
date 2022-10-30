import 'package:form_field_validator/form_field_validator.dart';


final validatedPhoneForm = MultiValidator([
  RequiredValidator(errorText: 'O telefone é obrigatório'),
  MinLengthValidator(9, errorText: 'Mínimo de 9 números')
]);

final validatedEmail = MultiValidator([
  RequiredValidator(errorText: 'O ID de e-mail é obrigatório'),
  EmailValidator(errorText: 'Insira um ID de e-mail válido')
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Senha requerida'),
  MinLengthValidator(8, errorText: 'Mínimo 8 caracteres')
]);
