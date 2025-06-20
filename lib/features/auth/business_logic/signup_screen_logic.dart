// import 'package:checkmate/features/auth/controllers/pharma_controller.dart';
// import 'package:checkmate/features/auth/controllers/signup_controller.dart';
// import 'package:checkmate/features/auth/controllers/text_controllers.dart';
// import 'package:checkmate/features/auth/model/signup_modal.dart';

// class SignupScreenLogic {
//   bool isSignUpDisabled = true;
//   bool isOptedForSocialSignUp = false;
//   final PharmaController _pharmaController = PharmaController();
//   final SignupController _signupController = SignupController();

//   List<String> items = [];
//   List<String> items2 = [];
//   // Used for Signup Button Enabling or Disabling
//   Map<String, bool> isvalid = {
//     "email": false,
//     "newPassword": false,
//     "confirmPassword": false,
//     "firstName": false,
//     "lastname": false,
//     "city": false,
//     "selectYourCompany": false,
//   };
//   getPharmaList() {
//     _pharmaController.fetchPharmaCompanies().then(
//       (v) => {
//         setState(() {
//           items2 = v.pharmaCompanies;
//         }),
//       },
//     );
//   }

//   userSignUp() {
//     SignUpModel data = SignUpModel(
//       email: TextControllers.email.text,
//       password: TextControllers.password.text,
//       firstName: TextControllers.firstName.text,
//       lastName: TextControllers.lastName.text,
//       city: TextControllers.city.text,
//       pharmaCompany: TextControllers.pharma.text,
//     );
//     _signupController
//         .signupUser(data)
//         .then(
//           (v) => {
//             setState(() {
//               TextControllers.email.clear();
//               TextControllers.password.clear();
//               TextControllers.confirmPassword.clear();
//               TextControllers.firstName.clear();
//               TextControllers.lastName.clear();
//               TextControllers.city.clear();
//               TextControllers.pharma.clear();
//             }),
//           },
//         );
//   }
// }
