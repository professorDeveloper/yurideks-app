import 'dart:io';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/theme/app_colors.dart';
import 'package:yurideks_app/core/theme/app_theme.dart';
import 'package:yurideks_app/core/widgets/app_bottom_nav.dart';
import 'package:yurideks_app/features/auth/data/models/auth_user_model.dart';
import 'package:yurideks_app/features/auth/domain/entities/auth_user.dart';
import 'package:yurideks_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:yurideks_app/features/auth/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:yurideks_app/features/auth/presentation/pages/login_page.dart';
import 'package:yurideks_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:yurideks_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:yurideks_app/features/daily_law/domain/entities/daily_box.dart';
import 'package:yurideks_app/features/daily_law/domain/entities/daily_law.dart';
import 'package:yurideks_app/features/daily_law/presentation/bloc/daily_law_bloc.dart';
import 'package:yurideks_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:yurideks_app/features/home/presentation/pages/home_page.dart';
import 'package:yurideks_app/features/intro/domain/entities/intro_catalogue.dart';
import 'package:yurideks_app/features/intro/presentation/bloc/intro_bloc.dart';
import 'package:yurideks_app/features/intro/presentation/pages/intro_page.dart';
import 'package:yurideks_app/features/profile/domain/entities/app_settings.dart';
import 'package:yurideks_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:yurideks_app/features/profile/presentation/pages/profile_page.dart';

const String _out = String.fromEnvironment('RENDER_OUT');

class _FakeDailyLawBloc extends MockBloc<DailyLawEvent, DailyLawState>
    implements DailyLawBloc {}

class _FakeHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

class _FakeProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class _FakeIntroBloc extends MockBloc<IntroEvent, IntroState>
    implements IntroBloc {}

class _FakeLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class _FakeSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

const AuthUserModel _user = AuthUserModel(
  id: 'u-1',
  role: UserRole.citizen,
  phone: '+998 90 123 45 67',
  name: 'Dilnoza Karimova',
);

DailyBox _box({required bool opened}) {
  return DailyBox(
    law: const DailyLaw(
      id: 'labour-vacation',
      topic: 'Mehnat huquqi',
      title: 'Yillik ta’til eng kami 15 ish kuni',
      summary: 'Har bir xodim yiliga kamida 15 ish kuni ta’tilga chiqadi.',
      steps: <String>['Ta’til grafigini imzolang.'],
      source: 'Mehnat kodeksi',
      article: '134-modda',
    ),
    isOpened: opened,
    collectedCount: 6,
    catalogueSize: 14,
    streak: 4,
    opensAt: DateTime.now().add(const Duration(hours: 12)),
  );
}

Future<void> _loadFonts() async {
  for (final String weight in <String>[
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
  ]) {
    final ByteData data = await rootBundle.load(
      'assets/fonts/PlusJakartaSans-$weight.ttf',
    );
    await (FontLoader('PlusJakartaSans')..addFont(Future<ByteData>.value(data)))
        .load();
  }
}

Future<void> _shoot(
  WidgetTester tester,
  Widget body,
  String path, {
  Size size = const Size(393, 1400),
  bool dark = false,
}) async {
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final GlobalKey key = GlobalKey();
  await tester.pumpWidget(
    MaterialApp(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: RepaintBoundary(key: key, child: body),
    ),
  );
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 400)),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));

  await tester.runAsync(() async {
    final RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final ByteData? data = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    File(path).writeAsBytesSync(data!.buffer.asUint8List());
  });
}

Widget _home({required bool opened}) {
  final _FakeDailyLawBloc daily = _FakeDailyLawBloc();
  final _FakeHomeBloc home = _FakeHomeBloc();
  final DailyLawState dailyState = DailyLawLoaded(box: _box(opened: opened));
  const HomeState homeState = HomeLoaded(
    user: _user,
    trendingQuestion: 'Ishdan bo‘shatilganda ish beruvchi nima to‘laydi?',
  );

  whenListen(
    daily,
    Stream<DailyLawState>.value(dailyState),
    initialState: dailyState,
  );
  whenListen(
    home,
    Stream<HomeState>.value(homeState),
    initialState: homeState,
  );

  return MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<DailyLawBloc>.value(value: daily),
      BlocProvider<HomeBloc>.value(value: home),
    ],
    child: HomePage(
      onAsk: (_) {},
      onOpenBox: () {},
      onOpenCollection: () {},
      onOpenProfile: () {},
    ),
  );
}

Widget _shellHome({required bool opened}) {
  return _Shell(child: _home(opened: opened));
}

Widget _shellHomeLoading() {
  final _FakeDailyLawBloc daily = _FakeDailyLawBloc();
  final _FakeHomeBloc home = _FakeHomeBloc();
  const DailyLawState dailyState = DailyLawLoading();
  const HomeState homeState = HomeInitial();

  whenListen(
    daily,
    Stream<DailyLawState>.value(dailyState),
    initialState: dailyState,
  );
  whenListen(
    home,
    Stream<HomeState>.value(homeState),
    initialState: homeState,
  );

  return _Shell(
    child: MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<DailyLawBloc>.value(value: daily),
        BlocProvider<HomeBloc>.value(value: home),
      ],
      child: HomePage(
        onAsk: (_) {},
        onOpenBox: () {},
        onOpenCollection: () {},
        onOpenProfile: () {},
      ),
    ),
  );
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: child,
      bottomNavigationBar: AppBottomNav(currentIndex: 0, onSelected: (_) {}),
    );
  }
}

Widget _profile() {
  final _FakeProfileBloc bloc = _FakeProfileBloc();
  const ProfileState state = ProfileLoaded(
    settings: AppSettings(),
    collectedCount: 6,
    catalogueSize: 14,
    streak: 4,
    user: _user,
  );
  whenListen(bloc, Stream<ProfileState>.value(state), initialState: state);

  return BlocProvider<ProfileBloc>.value(
    value: bloc,
    child: ProfilePage(onSignedOut: () {}),
  );
}

Widget _intro() {
  final _FakeIntroBloc bloc = _FakeIntroBloc();
  const IntroState state = IntroLoaded(
    slides: IntroCatalogue.slides,
    page: 0,
  );
  whenListen(bloc, Stream<IntroState>.value(state), initialState: state);
  return BlocProvider<IntroBloc>.value(
    value: bloc,
    child: IntroPage(onFinished: () {}),
  );
}

Widget _login() {
  final _FakeLoginBloc bloc = _FakeLoginBloc();
  const LoginState state = LoginState();
  whenListen(bloc, Stream<LoginState>.value(state), initialState: state);
  return BlocProvider<LoginBloc>.value(
    value: bloc,
    child: LoginPage(onSignedIn: (_) {}, onSignUpRequested: () {}),
  );
}

Widget _signUp() {
  final _FakeSignUpBloc bloc = _FakeSignUpBloc();
  const SignUpState state = SignUpState();
  whenListen(bloc, Stream<SignUpState>.value(state), initialState: state);
  return BlocProvider<SignUpBloc>.value(
    value: bloc,
    child: SignUpPage(onSignedUp: (_) {}, onLoginRequested: () {}),
  );
}

Widget _welcome() {
  return WelcomePage(user: _user, onContinue: () {});
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadFonts();
  });

  testWidgets('renders the main screens', (WidgetTester tester) async {
    await _shoot(tester, _home(opened: false), '$_out/home_closed.png');
    await _shoot(tester, _home(opened: true), '$_out/home_open.png');
    await _shoot(
      tester,
      _shellHome(opened: false),
      '$_out/shell_home_closed.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _shellHome(opened: true),
      '$_out/shell_home_open.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _shellHomeLoading(),
      '$_out/shell_home_loading.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _shellHome(opened: false),
      '$_out/shell_home_dark.png',
      size: const Size(393, 852),
      dark: true,
    );
    await _shoot(tester, _profile(), '$_out/profile.png');
    await _shoot(
      tester,
      _intro(),
      '$_out/intro.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _login(),
      '$_out/login.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _signUp(),
      '$_out/signup.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _welcome(),
      '$_out/welcome.png',
      size: const Size(393, 852),
    );
    await _shoot(
      tester,
      _intro(),
      '$_out/intro_dark.png',
      size: const Size(393, 852),
      dark: true,
    );
  }, skip: _out.isEmpty);
}
