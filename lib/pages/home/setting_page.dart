import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:member_manage_web/apis/user_api.dart';
import 'package:member_manage_web/extensions/context_extension.dart';
import 'package:member_manage_web/utils/http_util.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Future<void> onLogoutTap(BuildContext context) async {
    UserAPI.logout().then(
      (_) {
        HttpUtil.onLogout();
        context.replace('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '折扣',
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 16,
                  children: [
                    Chip(label: Text('九折')),
                    Chip(label: Text('八折')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '消费类型',
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 16,
                  children: [
                    Chip(label: Text('剪发')),
                    Chip(label: Text('烫染')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: () => onLogoutTap(context),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('退出登录'),
            ),
          ),
        ),
      ],
    );
  }
}
