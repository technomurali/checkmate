import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/features/auth/business_logic/signin_screen_logic.dart';
import 'package:checkmate/features/auth/controllers/signin_controller.dart';
import 'package:checkmate/features/auth/controllers/text_controllers.dart';
import 'package:checkmate/features/auth/model/user_modal.dart';

import 'mocks/signin_screen_logic_test.mocks.dart';

class ModalKeys {
  String get signinSuccess => 'signinSuccess';
  String get signinUser => 'signinUser';
  String get message => 'message';
}

@GenerateMocks([SigninController])
void main() {
  late SigninScreenLogic logic;
  late MockSigninController mockController;

  setUp(() {
    mockController = MockSigninController();
    logic = SigninScreenLogicTestable(mockController);
    TextControllers.email.text = '';
    TextControllers.password.text = '';
  });

  testWidgets('TC001: Valid email and valid password', (tester) async {
    TextControllers.email.text = 'sreekar.k@navasoftware.com';
    TextControllers.password.text = '996302';

    final user = UserModal(
      id: 1,
      email: 'sreekar.k@navasoftware.com',
      password: 'P@ssw0rd123',
      firstName: 'John',
      lastName: 'Doe',
      city: 'Mumbai',
      pharmaCompany: 'Pharma Inc',
    );

    when(
      mockController.signin(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer(
      (_) async => {
        ModalKeys().signinSuccess: true,
        ModalKeys().signinUser: user,
      },
    );

    final result = await logic.signinUser(MockBuildContext());
    debugPrint(" Result $result");
    expect(result?.email, 'sreekar.k@navasoftware.com');
  });

  testWidgets('SigninUser shows SnackBar and returns null on failure', (
    tester,
  ) async {
    TextControllers.email.text = 'wrong@example.com';
    TextControllers.password.text = 'wrongpass';

    when(
      mockController.signin(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer(
      (_) async => {
        ModalKeys().signinSuccess: false,
        ModalKeys().message: 'Invalid credentials',
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              Future<void> runSignin() async {
                final result = await logic.signinUser(context);
                expect(result, isNull);
              }

              tester.runAsync(runSignin);
              return Container();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle(); // Allow snack bar to show
    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  test('TC002: Empty email', () async {
    TextControllers.email.text = '';
    TextControllers.password.text = 'P@ssw0rd123';

    logic.updateButtonState();
    expect(logic.isButtonEnabled, false);
  });

  test('TC003: Empty password', () async {
    TextControllers.email.text = 'user@example.com';
    TextControllers.password.text = '';

    logic.updateButtonState();
    expect(logic.isButtonEnabled, false);
  });

  test('TC004: Invalid email format (no @)', () async {
    TextControllers.email.text = 'userexample.com';
    TextControllers.password.text = 'P@ssw0rd123';

    logic.updateButtonState();
    expect(logic.isButtonEnabled, true);
  });
}

class SigninScreenLogicTestable extends SigninScreenLogic {
  final SigninController mockController;
  SigninScreenLogicTestable(this.mockController) {
    super.isButtonEnabled = false;
  }
  @override
  SigninController get _signinController => mockController;
}

class MockBuildContext extends Mock implements BuildContext {}
