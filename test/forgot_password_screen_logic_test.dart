import 'package:checkmate/features/auth/business_logic/forgot_password_screen_logic.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/controllers/verify_controller.dart';
import 'package:checkmate/core/constants/modal_keys.dart';
import 'package:checkmate/core/constants/app_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'mocks/mock_verify_controller.mocks.dart' show MockVerifyController;

@GenerateMocks([VerifyController])
void main() {
  late ForgotPasswordScreenLogic logic;
  late MockVerifyController mockVerifyController;

  setUp(() {
    mockVerifyController = MockVerifyController();
    logic = ForgotPasswordScreenLogic();

    logic
      ..disposeControllers()
      ..resetForm();

    logic = ForgotPasswordScreenLogic()..resetForm();
    logic.sentCode = false;
    logic.wrongCodeEntered = false;
  });

  tearDown(() {
    logic.disposeControllers();
  });

  test('Initial state is correct', () {
    expect(logic.sentCode, false);
    expect(logic.emailEnteredAndValid, false);
    expect(logic.isVerificationCodeEntered, false);
    expect(logic.wrongCodeEntered, false);
  });

  test('sendVerificationCode sets sentCode to true', () {
    logic.sendVerificationCode();
    expect(logic.sentCode, true);
  });

  test('resetForm resets all fields and clears text controllers', () {
    TextControllers.email.text = 'test@example.com';
    TextControllers.verificationCode.text = '123456';
    logic
      ..sentCode = true
      ..wrongCodeEntered = true
      ..isVerificationCodeEntered = true
      ..emailEnteredAndValid = true;

    logic.resetForm();

    expect(logic.sentCode, false);
    expect(logic.wrongCodeEntered, false);
    expect(logic.isVerificationCodeEntered, false);
    expect(logic.emailEnteredAndValid, false);
    expect(TextControllers.email.text, '');
    expect(TextControllers.verificationCode.text, '');
  });

  test('Listeners respond to valid email', () {
    TextControllers.email.text = 'valid@example.com';
    TextControllers.email.notifyListeners();
    expect(logic.emailEnteredAndValid, true);
  });

  test('Listeners respond to empty verification code', () {
    TextControllers.verificationCode.text = '';
    TextControllers.verificationCode.notifyListeners();
    expect(logic.isVerificationCodeEntered, false);
  });

  testWidgets('verifyCode updates wrongCodeEntered on failure', (tester) async {
    TextControllers.verificationCode.text = 'wrongcode';

    final logicWithMock = ForgotPasswordScreenLogic();
    logicWithMock.resetForm();

    final mock = MockVerifyController();
    when(mock.verifyEmailCode(any)).thenAnswer(
      (_) async => {
        ModalKeys().statusCode: AppApiStatusCodes.error,
        ModalKeys().message: 'Invalid code',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            logicWithMock.verifyCode(context);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(logicWithMock.wrongCodeEntered, true);
  });
}
