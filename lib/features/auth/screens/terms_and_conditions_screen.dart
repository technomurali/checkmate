import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final String termsAndConditions = """
  <div>
    <h2>CHECKMATE END USER LICENSE AGREEMENT</h2>
    <p><strong>Effective Date: July , 2024</strong></p>
    <p>Dynamic Consultants Group d/b/a Checkmate (hereinafter referred to as "Checkmate", "we", "our", or "us") owns the Checkmate software and services made available to you through this kiosk, tablet or other hardware ("Kiosk"), which is operated and maintained by the operator of the facility (our "Partner"). This End User License Agreement (this "Agreement") applies to your access to and use of the Checkmate software and/or the Kiosk running the Checkmate software (collectively, the "Services").</p>
    <p>This agreement is not intended to approve, condition, or otherwise endorse, modify, or supplement the relationship between you, our Partner and our Partner's employees. If you experience issues with the Services, including the Kiosk, please direct all inquiries to our Partner.</p>
    <p>We reserve the right to change or modify this Agreement at any time. If we make changes to this Agreement, we will post a notice on the Services or update the "Effective Date" above and obtain your consent to be bound by the updated Agreement. If you do not agree to the amended Agreement, you must not agree to the updated Terms and you must stop using the Services.</p>
    <p><strong>BY ACCESSING OR USING THE SERVICES, INCLUDING THE KIOSK, YOU AGREE TO BE BOUND BY THIS AGREEMENT OF USE AND ALL TERMS INCORPORATED BY REFERENCE. IF YOU DO NOT AGREE TO ALL OF THIS AGREEMENT, DO NOT USE THE SERVICES OR KIOSK.</strong></p>

    <h3>1. ELIGIBILITY, REGISTRATION AND ACCOUNT.</h3>
    <p><strong>1.1 Eligibility.</strong> By using the Services, you represent and warrant that you (a) have not been previously suspended or removed from the Services; (b) have full power and authority to enter into this Agreement and that, in doing so, you will not violate any other agreement to which you are a party; and (c) are at least eighteen (18) years of age or older. The Services are not targeted towards, nor intended for use by, anyone under the age of 18.</p>

    <p><strong>1.2 Account Registration.</strong> Some features of the Services may require you to register for an account and/or create a profile. You may only maintain one account at a time. In addition, when registering for an account or creating a profile, you agree to: (a) provide accurate, current and complete information; (b) maintain and promptly update your information; (c) maintain the security of your account, including the privacy of your account credentials; (d) not share your account credentials with others; and (e) promptly notify our Partner if you discover or suspect any security breaches related to your account or the Services.</p>

    <p><strong>1.3 User Data.</strong> In order to use the Services, you may be required to provide certain information about yourself, including, without limitation, your name, phone number, email, and business address (collectively, "User Data"). You agree to provide accurate, current and complete User Data. You further agree that we and/or our Partner has a legitimate interest in storing and sharing User Data, and we may use your contact information to contact you directly. Please refer to our Partner's Privacy Policy for information about how our Partner collects, uses and discloses your information as a user of these Services.</p>

    <p><strong>1.4 No Obligation for Checkmate.</strong> Your use of the Services is at your own risk. Although we have no obligation to screen, edit or monitor any of the User Data submitted, we reserve the right and have absolute discretion to remove, screen or edit any User Data submitted or stored on the Services at any time and for any reason without notice. You are solely responsible for creating backup copies of and replacing any User Data you submit or store on the Service. Any use of the Services in violation of the foregoing violates this Agreement and may result in, among other things, termination or suspension of your rights to use the Services.</p>

    <h3>2. LIMITED LICENSE.</h3>
    <p><strong>2.1 Ownership of Materials.</strong> All content and other materials on the Services, including, without limitation, our logos, and all designs, text, graphics, images, information, data, software and links, audio and video clips, and any intellectual property contained therein, and the selection and arrangement thereof (collectively, the "Materials") are the proprietary property of Checkmate, our Partner, or our licensors and suppliers and are protected by U.S. and international copyright, trademark and other laws. You acknowledge that you do not acquire any ownership rights by accessing or using the Services or the Materials.</p>

    <p><strong>2.2 License Grant.</strong> Subject to your compliance with this Agreement, you are granted a limited, revocable, non-transferable, non-sublicensable license to access and use the Services for the purposes allowed by our Partner. You may not: (a) resell the Services or the Materials; (b) distribute, publicly perform or publicly display any Materials (except as contemplated herein through the Services); (c) modify or otherwise make any derivative work or uses of the Services or the Materials, or any portion thereof; (d) use any data mining, robots or similar data gathering or extraction methods; (e) download any portion of the Services, the Materials or any information contained therein, except as expressly permitted on the Services; or (f) use of the Services or the Materials other than for their intended purposes. Any use of the Services or the Materials in violation of the foregoing violates this Agreement and may result in termination or suspension of your rights to use the Services.</p>

    <p><strong>2.3 Modification.</strong> We reserve the right to change the Services and to modify, suspend or discontinue the Services or any features or functionality of the Services at any time without notice, obligation or liability to you.</p>

    <p><strong>2.4 Termination.</strong> We reserve the right, without notice and in our sole discretion, to terminate your license to use the Services, and to prevent future access to and use of the Services.</p>

    <h3>3. THIRD-PARTY CONTENT.</h3>
    <p>We or our Partner may provide third party content on the Services and may provide links to web pages and content of third parties (collectively, "Third-Party Content"). We do not control or endorse any Third-Party Content and make no representation or warranties of any kind regarding the Third-Party Content, including without limitation regarding its accuracy or completeness. Use of such Third-Party Content at your own risk.</p>

    <h3>4. FEEDBACK.</h3>
    <p>Checkmate shall own all feedback, comments, suggestions, ideas, concepts and changes that you provide to Checkmate or our Partner relating to the Services and all associated intellectual property rights (collectively the "Feedback"), and you hereby assign all of your right, title and interest in the Feedback to Checkmate.</p>

    <h3>5. NO GUARANTEE OF ACCURACY.</h3>
    <p>The Services are designed and maintained with the goal of achieving storage and transmission of your User Data. However, we do not guarantee that your User Data or other information submitted will be processed with any degree of accuracy, nor do we guarantee that User Data will be saved, stored, or transmitted successfully. Checkmate does not guarantee any intended results or outcomes from use of the Services. You further understand that variances in the operation of the Services may arise due to, among other things, mechanical damage to the Kiosk, a software malfunction, or power interruption. Checkmate disclaims all responsibility, liability, or obligation arising from or related to the foregoing.</p>

    <h3>6. INDEMNIFICATION.</h3>
    <p>You shall defend, indemnify and hold harmless Checkmate and its affiliates, subsidiaries, independent contractors, service providers, and consultants, and their respective directors, officers, employees and agents (the "Checkmate Parties") from and against any and all actual or threatened suits, actions, proceedings, claims, damages, costs, liabilities and expenses (collectively, "Claims") arising out of or related to (a) your use or misuse of the Services; (b) any User Data, information, or Feedback you provide; (c) your violation of this Agreement; or (d) your violation of any third party rights. You shall cooperate with the Checkmate Parties in defending such Claims and pay all fees, costs and expenses associated with defending such Claims (including, but not limited to attorneys' fees). You further agree the Checkmate Parties may determine, at their sole option, to have control of the defense or settlement of any Claims.</p>

    <h3>7. DISCLAIMERS.</h3>
    <p>THE SERVICES AND THE MATERIALS ARE PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. WE DO NOT REPRESENT OR WARRANT THAT CONTENT, MATERIALS OR FUNCTIONS OF THE SERVICES ARE ACCURATE, COMPLETE, RELIABLE, OR CURRENT OR THAT THE SERVICES WILL NOT CONTAIN TYPOGRAPHICAL ERRORS OR OMISSIONS. WE DO NOT REPRESENT OR WARRANT THAT THE SERVICES, INCLUDING THE KIOSKS, ARE IN WORKING CONDITION OR VIRUS-FREE.</p>

    <h3>8. LIMITATION OF LIABILITY.</h3>
    <p>IN NO EVENT SHALL THE CHECKMATE PARTIES BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES OF ANY KIND, INCLUDING BUT NOT LIMITED TO LOSS OF USE, LOSS OF PROFITS OR LOSS OF DATA, WHETHER IN AN ACTION IN CONTRACT, TORT (INCLUDING NEGLIGENCE) OR OTHERWISE, ARISING OUT OF OR IN ANY WAY CONNECTED TO THE ACCESS TO OR USE OF THE SERVICES (INCLUDING THE KIOSK) OR OTHERWISE RELATED TO THIS AGREEMENT, EVEN IF WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. IN NO EVENT SHALL THE AGGREGATE LIABILITY OF THE CHECKMATE PARTIES TO YOU EXCEED THE AMOUNTS YOU PAY, IF ANY, TO CHECKMATE OR OUR PARTNER FOR ACCESS TO OR USE OF THE SERVICES.</p>

    <h3>9. MISCELLANEOUS.</h3>
    <p><strong>9.1 Governing Law and Venue.</strong> This Agreement is governed by and construed in accordance with the laws of the State of Missouri without giving effect to any conflict of laws principles. You agree that any action at law or in equity arising out of or relating to this Agreement shall be filed only in the state and federal courts located in Jackson County, Missouri, and you hereby irrevocably and unconditionally consent and submit to the exclusive jurisdiction of such courts over any suit, action, or proceeding arising out of this Agreement.</p>

    <p><strong>9.2 Independent Contractors.</strong> You and Checkmate are independent contractors and not agents or employees of the other party. Neither you nor Checkmate has any right, power, or authority to act or create any obligation, express or implied, on behalf of the other party.</p>

    <p><strong>9.3 Consent to Do Business Electronically.</strong> We use and rely upon electronic records and electronic signatures for the execution and delivery of this Agreement and any other agreements, undertakings, notices, disclosures or other documents, communications or information of any type sent or received in accordance with this Agreement and in performing our obligations and exercising our rights under this Agreement. Neither you nor Checkmate or our Partner will prevent or inhibit in any way the printing, saving, or otherwise storing electronic records sent or otherwise made available through the Services. You agree not to contest the authorization for, or validity or enforceability of, electronic records and electronic signatures, or the admissibility of copies thereof, under any applicable law relating to whether certain agreements, files, or electronic records are to be in writing or signed by you to be bound thereby. You will bear your own costs and expenses in conducting business electronically, and will undertake all steps necessary, including software, hardware, and other equipment upgrades and purchases, in order to be able to conduct business electronically.</p>

    <p><strong>9.4 Entire Agreement.</strong> This Agreement constitutes the entire agreement between you and Checkmate with respect to the subject matter hereof and supersede all prior agreements, both oral and written, with respect to the subject matter hereof. Our failure to enforce any provision of this Agreement will not be deemed to be a waiver of our right to enforce them. If any term or provision of this Agreement will be held to be invalid, illegal, or unenforceable, the remaining terms and provisions of this Agreement will remain in full force and effect, and such invalid, illegal, or unenforceable term or provision will be deemed not to be part of this Agreement.</p>

    <p><strong>9.5 Assignment.</strong> You may not assign or transfer your rights or obligations under this Agreement, nor delegate your duties hereunder to any other person, without our prior written consent. Any purported assignment without our consent will be void and will constitute a breach of this Agreement.</p>

    <p><strong>9.6 Survival.</strong> The provisions of this Agreement that by their content are intended to survive the expiration or termination of this Agreement, including, without limitation, provisions governing ownership and use of intellectual property, representations, disclaimers, warranties, liability, indemnification, governing law, jurisdiction, venue, remedies, rights after termination, and interpretation of this Agreement, will survive the expiration or termination of this Agreement.</p>
  </div>
  """;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Html(
                  data: termsAndConditions,
                  style: {"body": Style(backgroundColor: Colors.white)},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentSuccess,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    AppStrings.accept,
                    style: TextStyle(color: AppColors.background),
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentError,
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(color: AppColors.background),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
