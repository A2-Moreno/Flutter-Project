import 'package:app/features/auth/domain/models/authentication_user.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

import '../../domain/repositories/i_auth_repository.dart';

class AuthenticationController extends GetxController {
  final IAuthRepository authentication;
  final logged = false.obs;
  final _loggedUser = Rxn<AuthenticationUser>();
  final RxBool isLoading = false.obs;

  AuthenticationController(this.authentication);

  AuthenticationUser? get loggedUser => _loggedUser.value;

  set loggedUser(AuthenticationUser? user) {
    _loggedUser.value = user;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    logInfo('AuthenticationController initialized');
    logged.value = await validateToken();
  }

  bool get isLogged => logged.value;

  Future<bool> login(email, password) async {
    logInfo('AuthenticationController: Login $email $password');
    await authentication.login(email, password);
    await getLoggedUser();
    logged.value = true;

    return true;
  }

  Future<bool> signUp(name, email, password, bool direct) async {
    logInfo('AuthenticationController: Sign Up $email $password');
    await authentication.signUp(email, password, name, direct);
    return true;
  }

  Future<bool> validate(String email, String validationCode) async {
    logInfo('Controller Validate $email $validationCode');
    var rta = await authentication.validate(email, validationCode);
    return rta;
  }

  Future<void> logOut() async {
    logInfo('AuthenticationController: Log Out');
    logged.value = false;
    await authentication.logOut();
    logged.value = false;
  }

  Future<bool> validateToken() async {
    logInfo('validateToken: validateToken');

    var isValid = await authentication.validateToken();

    if (isValid) {
      logInfo("Token válido, usuario autenticado");

      final user = await getLoggedUser();

      if (user == null) {
        logWarning("Usuario no existe en DB, pero SÍ está logueado");
      }
    }

    return isValid;
  }

  Future<void> forgotPassword(String email) async {
    logInfo('AuthenticationController: Forgot Password $email');
    await authentication.forgotPassword(email);
  }

  Future<AuthenticationUser?> getLoggedUser() async {
    logInfo('AuthenticationController: Get Logged User');
    isLoading.value = true;
    var rta = await authentication.getLoggedUser();
    return rta;
  }

  Future<List<AuthenticationUser>> getUsers() async {
    logInfo('AuthenticationController: Get Users');
    var rta = await authentication.getUsers();
    return rta;
  }

  Future<void> verifyAccount(
    String email,
    String code,
    String password,
    String name,
  ) async {
    try {
      isLoading.value = true;

      // 1. verificar email
      await authentication.validate(email, code);

      // 2. login (ahora sí válido)
      await authentication.login(email, password);

      // 3. actualizar estado
      logged.value = true;
      loggedUser = await getLoggedUser();

      Get.snackbar("Success", "Cuenta verificada correctamente");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
