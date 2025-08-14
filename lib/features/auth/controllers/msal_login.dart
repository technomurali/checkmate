import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/constants/msal_config_constants.dart';
import 'package:checkmate/features/auth/controllers/signin_controller.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:msal_auth/msal_auth.dart';

class MsalLogin {
  Future<SingleAccountPca> initializeMsal() async {
    SingleAccountPca pca = await SingleAccountPca.create(
      clientId: MsalConfigConstants.clientId,
      androidConfig: AndroidConfig(
        configFilePath: MsalConfigConstants.configFilePath,
        redirectUri: MsalConfigConstants.redirectUri,
      ),
      appleConfig: AppleConfig(
        authorityType: AuthorityType.b2c,
        broker: Broker.webView,
      ),
    );
    return pca;
  }

  Future<bool> signIn(SingleAccountPca pca) async {
    try {
      await pca.acquireToken(scopes: [MsalConfigConstants.scopesUrl]);
      //:ToDO Remove this Part and Initilize with the api integration Needed to verify the token
      final response = await SigninController().signin(
        email: 'rep@abc.com',
        password: 'abcabc',
      );
      if (response[SigninModalKeys.signinSuccess] == true) {
        final user = response[SigninModalKeys.signinUser] as UserModal;
        userModal = user;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
