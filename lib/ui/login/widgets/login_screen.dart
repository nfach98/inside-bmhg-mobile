import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:inside_bmhg/config/injection.dart';
import 'package:inside_bmhg/ui/login/bloc/login_bloc.dart';
import 'package:inside_bmhg/ui/login/bloc/login_event.dart';
import 'package:inside_bmhg/ui/login/bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ── Controllers and Focus Nodes ───────────────────────────────────────────
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;
  double _buttonScale = 1.0;

  // ── Staggered Entry Animation Controllers ──────────────────────────────────
  late AnimationController _entryController;

  late Animation<double> _logoScale;
  late Animation<Offset> _logoSlide;
  late Animation<double> _logoFade;

  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  late Animation<double> _emailLabelFade;
  late Animation<Offset> _emailLabelSlide;
  late Animation<double> _emailFieldFade;
  late Animation<Offset> _emailFieldSlide;

  late Animation<double> _passwordLabelFade;
  late Animation<Offset> _passwordLabelSlide;
  late Animation<double> _passwordFieldFade;
  late Animation<Offset> _passwordFieldSlide;

  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;

  late Animation<double> _forgotFade;

  // ── Brand Design System Tokens (Figma Exacts) ─────────────────────────────
  static const Color _brandNavy = Color(0xFF1A2185);
  static const Color _pureBlack = Color(0xFF000000);
  static const double _fieldHeight = 40.0;
  static const double _pageHorizontalPadding = 47.33;

  @override
  void initState() {
    super.initState();

    // Dark status bar elements on crisp white background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    _initAnimations();
    _entryController.forward();
  }

  void _initAnimations() {
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // 1. School Crest Logo (elastic scale + slide down)
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 2. Heading "Selamat Datang di InsideBMHG!"
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.18, 0.58, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.18, 0.63, curve: Curves.easeOutCubic),
      ),
    );

    // 3. Email Label
    _emailLabelFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.65, curve: Curves.easeOut),
      ),
    );
    _emailLabelSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // 4. Email Field
    _emailFieldFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
      ),
    );
    _emailFieldSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    // 5. Password Label
    _passwordLabelFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.42, 0.77, curve: Curves.easeOut),
      ),
    );
    _passwordLabelSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.42, 0.82, curve: Curves.easeOutCubic),
      ),
    );

    // 6. Password Field
    _passwordFieldFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.47, 0.82, curve: Curves.easeOut),
      ),
    );
    _passwordFieldSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.47, 0.87, curve: Curves.easeOutCubic),
      ),
    );

    // 7. Login Button (elastic bouncy slide up)
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.55, 0.95, curve: Curves.easeOutBack),
      ),
    );

    // 8. Forgot Password Link
    _forgotFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.68, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext blocContext) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan password tidak boleh kosong');
      return;
    }

    FocusScope.of(context).unfocus();

    blocContext.read<LoginBloc>().add(
          LoginSubmitEvent(email: email, password: password),
        );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state.status == LoginStatus.loading;
          });

          if (state.status == LoginStatus.success) {
            context.go('/'); // Home screen route
          } else if (state.status == LoginStatus.failure) {
            _showSnackBar(state.errorMessage ?? 'Email atau password salah');
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: _pageHorizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Proportional Margin
                      const SizedBox(height: 80.0),

                      Center(
                        child: SlideTransition(
                          position: _logoSlide,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: FadeTransition(
                              opacity: _logoFade,
                              child: SizedBox(
                                width: 120.0,
                                height: 48.0,
                                child: Image.asset(
                                  'assets/images/logo-bmhg.png',
                                  color: _brandNavy,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.school_rounded,
                                    color: _brandNavy,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Exact Logo to Title Gap: 16px
                      const SizedBox(height: 16.0),

                      // 2. Title "Selamat Datang di InsideBMHG!"
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: const Text(
                            'Selamat Datang\ndi InsideBMHG!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Archivo',
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: _brandNavy,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),

                      // Exact Title to Username Gap: 113.5px
                      const SizedBox(height: 113.5),

                      // 3. Email Label (Inter regular 14px, #000000)
                      SlideTransition(
                        position: _emailLabelSlide,
                        child: FadeTransition(
                          opacity: _emailLabelFade,
                          child: const Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Archivo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _pureBlack,
                            ),
                          ),
                        ),
                      ),

                      // Exact Label to Field Gap: 4.5px
                      const SizedBox(height: 4.5),

                      // 4. Email Field (Exact height 40px, border radius 8px, #1A2185)
                      SlideTransition(
                        position: _emailFieldSlide,
                        child: FadeTransition(
                          opacity: _emailFieldFade,
                          child: _buildTextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            hint: 'Masukkan email',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => _passwordFocus.requestFocus(),
                          ),
                        ),
                      ),

                      // Exact Field to Label Gap: 16.1px
                      const SizedBox(height: 16.1),

                      // 5. Password Label (Inter regular 14px, #000000)
                      SlideTransition(
                        position: _passwordLabelSlide,
                        child: FadeTransition(
                          opacity: _passwordLabelFade,
                          child: const Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: 'Archivo',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: _pureBlack,
                            ),
                          ),
                        ),
                      ),

                      // Exact Label to Field Gap: 4.5px
                      const SizedBox(height: 4.5),

                      // 6. Password Field (Exact height 40px, border radius 8px, #1A2185)
                      SlideTransition(
                        position: _passwordFieldSlide,
                        child: FadeTransition(
                          opacity: _passwordFieldFade,
                          child: _buildPasswordField(),
                        ),
                      ),

                      // Exact Password to Button Gap: 35.5px
                      const SizedBox(height: 35.5),

                      // 7. Login Button (Exact height 40px, rounded 8px, color #1A2185)
                      SlideTransition(
                        position: _buttonSlide,
                        child: FadeTransition(
                          opacity: _buttonFade,
                          child: Center(
                            child: Listener(
                              onPointerDown: (_) {
                                if (!_isLoading) {
                                  setState(() => _buttonScale = 0.97);
                                }
                              },
                              onPointerUp: (_) {
                                if (!_isLoading) {
                                  setState(() => _buttonScale = 1.0);
                                }
                              },
                              onPointerCancel: (_) {
                                if (!_isLoading) {
                                  setState(() => _buttonScale = 1.0);
                                }
                              },
                              child: AnimatedScale(
                                scale: _buttonScale,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeOut,
                                child: _buildLoginButton(context),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Exact Button to Link Gap: 7.5px
                      const SizedBox(height: 7.5),

                      // 8. Forgot Password Link (Right-aligned, underlined, size 11px, #1A2185)
                      FadeTransition(
                        opacity: _forgotFade,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Forgot password action
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Lupa password?',
                              style: TextStyle(
                                fontFamily: 'Archivo',
                                fontSize: 11,
                                color: _brandNavy,
                                decoration: TextDecoration.underline,
                                decorationColor: _brandNavy,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helpers & Inner Widgets ────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    ValueChanged<String>? onSubmitted,
  }) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, child) {
        final hasFocus = focusNode.hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _fieldHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: hasFocus
                ? [
                    BoxShadow(
                      color: _brandNavy.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 14,
              color: _brandNavy,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _brandNavy, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _brandNavy, width: 1.5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return AnimatedBuilder(
      animation: _passwordFocus,
      builder: (context, child) {
        final hasFocus = _passwordFocus.hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _fieldHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: hasFocus
                ? [
                    BoxShadow(
                      color: _brandNavy.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: _obscurePassword,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 14,
              color: _brandNavy,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Masukkan password',
              hintStyle: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _brandNavy, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _brandNavy, width: 1.5),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButton(BuildContext blocContext) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: _isLoading ? _fieldHeight : double.infinity,
      height: _fieldHeight,
      decoration: BoxDecoration(
        color: _brandNavy,
        borderRadius: BorderRadius.circular(_isLoading ? (_fieldHeight / 2) : 8),
        boxShadow: [
          BoxShadow(
            color: _brandNavy.withOpacity(0.24),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_isLoading ? (_fieldHeight / 2) : 8),
          onTap: _isLoading ? null : () => _handleLogin(blocContext),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Text(
                      'Log In',
                      style: TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}