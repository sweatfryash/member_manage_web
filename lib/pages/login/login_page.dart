import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:member_manage_web/apis/user_api.dart';
import 'package:member_manage_web/extensions/context_extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVisible = ValueNotifier<bool>(true);

  Future<void> onLoginTap(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;
    final res = await UserAPI.login(username, password);
    if (mounted && res != null) {
      context.replace('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(
                '会员管理',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(99))),
                  labelText: '用户名',
                ),
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<bool>(
                valueListenable: passwordVisible,
                builder: (context, bool value, _) {
                  return TextField(
                    obscureText: value,
                    controller: passwordController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(99))),
                      labelText: '密码',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          passwordVisible.value = !value;
                        },
                        child: AnimatedSwitcher(
                          duration: kThemeChangeDuration,
                          child: Icon(
                            value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: value
                                ? context.colorScheme.onSurface
                                : context.colorScheme.primary,
                            key: ValueKey<bool>(value),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              ListenableBuilder(
                listenable: Listenable.merge([
                  usernameController,
                  passwordController,
                ]),
                builder: (BuildContext context, Widget? child) {
                  final enabled = usernameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty;
                  return FilledButton(
                    onPressed: enabled ? () => onLoginTap(context) : null,
                    child: child!,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 64),
                  child: Text('登录'),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
