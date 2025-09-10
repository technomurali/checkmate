import 'dart:convert';

import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:checkmate/core/widgets/custom_button.dart';
import 'package:checkmate/core/widgets/custom_text_field.dart';
import 'package:checkmate/features/auth/controllers/pharma_controller.dart';
import 'package:checkmate/features/auth/controllers/profile_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEnabled = false;
  bool isLoading = false;
  List<Map> filteredCompanies = [];
  List<Map> allCompanies = [];
  final ProfileController _profileController = ProfileController();
  PharmaController pharmaController = PharmaController();
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
    fetchHcoName();
  }

  void selectCompany(dynamic company) {
    setState(() {
      UserProfileTextControllers.companyController.text =
          company['accountName'];
      UserProfileTextControllers.companyIdController.text = company['id'];
      filteredCompanies.clear();
    });
  }

  void filterCompanies(String input) {
    setState(() {
      debugPrint(
        "filterCompanies : $input , $allCompanies ,$filteredCompanies",
      );
      if (input.isEmpty) {
        filteredCompanies.clear();
      } else {
        filteredCompanies = allCompanies
            .where(
              (company) => company['accountName'].toLowerCase().contains(
                input.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  void getPharmaList() async {
    final result = await pharmaController.fetchPharmaCompanies();
    debugPrint("fetchPharmaCompanies : $result");

    setState(() {
      allCompanies = result.pharmaCompanies;
      isLoading = false;
    });
  }

  fetchHcoName() {
    setState(() {
      isLoading = true;
    });
    _profileController.getCompanyName(userModal.pharmaCompany ?? '').then((
      value,
    ) {
      setState(() {
        UserProfileTextControllers.companyController.text = value;
      });
      getPharmaList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleSave() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      final updated = userModal.copyWith(
        email: UserProfileTextControllers.emailController.text.trim(),
        firstName: UserProfileTextControllers.firstNameController.text.trim(),
        lastName: UserProfileTextControllers.lastNameController.text.trim(),
        profileUrl: UserProfileTextControllers.profileUrlController.text.trim(),
        modeOfAuthentication: userModal.modeOfAuthentication,
      );
      var updateProfileData = {
        "Id": userModal.id ?? "",
        "Kiosk": userModal.kiosk ?? "",
        "FirstName": UserProfileTextControllers.firstNameController.text.trim(),
        "LastName": UserProfileTextControllers.lastNameController.text.trim(),
        "Email": UserProfileTextControllers.emailController.text.trim(),
        "City": UserProfileTextControllers.cityController.text.trim(),
        "CompanyId": UserProfileTextControllers.companyIdController.text,
        "UserRoleId": userModal.role ?? "",
        "ModeOfAuthentication": userModal.modeOfAuthentication ?? "Password",
      };
      debugPrint("Update Profile Data ${jsonEncode(updateProfileData)}");

      _profileController.updateProfile(updateProfileData).then((value) {
        debugPrint("Update Profile Response $value");
        if (value['status'] == true) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value['message'] ?? 'Profile updated successfully'),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(value['message'] ?? 'Failed to update profile'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: CircularProgressIndicator()),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Center(
                  //   child: Stack(
                  //     children: [
                  //       CircleAvatar(
                  //         radius: 50,
                  //         backgroundImage:
                  //             (userModal.profileUrl != null &&
                  //                 userModal.profileUrl!.isNotEmpty)
                  //             ? NetworkImage(userModal.profileUrl!)
                  //             : null,
                  //         child:
                  //             (userModal.profileUrl == null ||
                  //                 userModal.profileUrl!.isEmpty)
                  //             ? ClipOval(
                  //                 child: Icon(
                  //                   Icons.person,
                  //                   size: 50,
                  //                   color: AppColors.pastStatusBadgeTextColor,
                  //                 ),
                  //               )
                  //             : null,
                  //       ),

                  //       Positioned(
                  //         bottom: 0,
                  //         right: 0,
                  //         child: InkWell(
                  //           onTap: !isEnabled ? () {} : null,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: isEnabled
                  //                   ? AppColors.profileIconbgColor
                  //                   : AppColors.border,
                  //             ),
                  //             padding: const EdgeInsets.all(6),
                  //             child: Icon(
                  //               Icons.edit,
                  //               size: 18,
                  //               color: AppColors.profileEditIconColor,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 24),
                  _buildTextField(
                    enabled: false,
                    controller: UserProfileTextControllers.emailController,
                    label: AppStrings.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return ErrorText.emailReq;
                      }
                      final emailReg = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailReg.hasMatch(v)) return ErrorText.emailError;
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    enabled: isEnabled,
                    controller: UserProfileTextControllers.firstNameController,
                    label: AppStrings.firstName,
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    enabled: isEnabled,
                    controller: UserProfileTextControllers.lastNameController,
                    label: AppStrings.lastName,
                  ),
                  const SizedBox(height: 12),

                  _buildTextField(
                    enabled: isEnabled,
                    controller: UserProfileTextControllers.cityController,
                    label: AppStrings.city,
                  ),
                  const SizedBox(height: 12),

                  if (userModal.role == UserType.pharmaRep) ...{
                    CustomTextField(
                      readOnly: !isEnabled,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      controller: isLoading
                          ? TextEditingController()
                          : UserProfileTextControllers.companyController,
                      label: AppStrings.selectThePharma,
                      onChanged: filterCompanies,
                    ),
                    if (filteredCompanies.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          border: Border.all(color: AppColors.border),
                        ),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: filteredCompanies
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Column(
                                    children: [
                                      InkWell(
                                        onTap: () => selectCompany(entry.value),
                                        child: Text(entry.value['accountName']),
                                      ),
                                      if (entry.key !=
                                          filteredCompanies.length - 1)
                                        const Divider(),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  },
                  if (userModal.role == UserType.hcp)
                    _buildTextField(
                      enabled: false,
                      controller: UserProfileTextControllers.companyController,
                      label: AppStrings.company,
                    ),
                  const SizedBox(height: 12),
                  Button(
                    text: isEnabled ? AppStrings.save : AppStrings.edit,
                    onPressed: () {
                      if (isEnabled) {
                        _handleSave();
                      }
                      setState(() {
                        isEnabled = !isEnabled;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
  }

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
