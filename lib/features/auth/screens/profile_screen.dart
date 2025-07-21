import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_paths.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:checkmate/features/auth/screens/top_nav.dart';
import 'package:flutter/material.dart';

/// A fully-featured profile editing page with Save and Cancel buttons.
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    UserProfileTextControllers.companyController.text =
        userModal.pharmaCompany ?? '';
    UserProfileTextControllers.roleController.text = userModal.role ?? '';
    UserProfileTextControllers.cityController.text = userModal.city ?? '';
    UserProfileTextControllers.emailController.text = userModal.email ?? '';
    UserProfileTextControllers.profileUrlController.text =
        userModal.profileUrl ?? '';
    UserProfileTextControllers.firstNameController.text =
        userModal.firstName ?? '';
    UserProfileTextControllers.lastNameController.text =
        userModal.lastName ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: unused_element
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = userModal.copyWith(
        email: UserProfileTextControllers.emailController.text.trim(),
        firstName: UserProfileTextControllers.firstNameController.text.trim(),
        lastName: UserProfileTextControllers.lastNameController.text.trim(),
        profileUrl: UserProfileTextControllers.profileUrlController.text.trim(),
        modeOfAuthentication: userModal.modeOfAuthentication,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(SuccessStrings.profileSaved)),
      );
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      ///Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userModal.profileUrl != null
                            ? NetworkImage(userModal.profileUrl!)
                                  as ImageProvider
                            : const AssetImage(AppPaths.logoPath),
                      ),

                      ///Edit icon on the profile picture
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: !isEnabled ? () {} : null,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isEnabled
                                  ? AppColors.profileIconbgColor
                                  : AppColors.border,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.profileEditIconColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                ///Email TextField
                _buildTextField(
                  enabled: isEnabled,
                  controller: UserProfileTextControllers.emailController,
                  label: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return ErrorText.emailReq;
                    }
                    final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$');
                    if (!emailReg.hasMatch(v)) return ErrorText.emailError;
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                ///First Name TextField
                _buildTextField(
                  enabled: isEnabled,
                  controller: UserProfileTextControllers.firstNameController,
                  label: AppStrings.firstName,
                ),
                const SizedBox(height: 12),

                ///Last Name TextField
                _buildTextField(
                  enabled: isEnabled,
                  controller: UserProfileTextControllers.lastNameController,
                  label: AppStrings.lastName,
                ),
                const SizedBox(height: 12),

                ///City TextField
                _buildTextField(
                  enabled: isEnabled,
                  controller: UserProfileTextControllers.cityController,
                  label: AppStrings.city,
                ),
                const SizedBox(height: 12),

                ///Pharma Company TextField
                if (userModal.role == UserType.pharmaRep)
                  _buildTextField(
                    enabled: isEnabled,
                    controller: UserProfileTextControllers.companyController,
                    label: AppStrings.pharmaCompany,
                  ),
                const SizedBox(height: 12),
                Button(
                  text: isEnabled ? AppStrings.save : AppStrings.edit,
                  onPressed: () {
                    setState(() {
                      isEnabled = !isEnabled;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }

  /// Builds a standard editable text field with validation.
  Widget _buildTextField({
    required bool enabled,
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
