// lib/features/settings/presentation/view/settings_view.dart

import 'package:adora_mobile_app/app/service_locator.dart';
import 'package:adora_mobile_app/features/auth/presentation/view/login_view.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/change_password_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/delete_account_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_settings_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  void _navigateToProfileSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<ProfileViewModel>(),
          child: const ProfileSettingsView(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => sl<ChangePasswordViewModel>(),
          child: AlertDialog(
            title: const Text('Change Password'),
            content: BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
              listener: (context, state) {
                if (state is ChangePasswordSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password changed successfully')),
                  );
                } else if (state is ChangePasswordFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is ChangePasswordLoading;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Current Password'),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Enter current password' : null,
                      ),
                      TextFormField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'New Password'),
                        validator: (val) =>
                            val == null || val.length < 6 ? 'At least 6 characters' : null,
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Confirm New Password'),
                        validator: (val) =>
                            val != newPasswordController.text ? 'Passwords do not match' : null,
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ChangePasswordViewModel>().add(
                                        ChangePasswordRequested(
                                          currentPasswordController.text.trim(),
                                          newPasswordController.text.trim(),
                                        ),
                                      );
                                }
                              },
                              child: const Text('Change'),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear everything and go to login
              Navigator.of(ctx).pushNamedAndRemoveUntil(
                LoginView.routeName,
                (_) => false,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => sl<DeleteAccountViewModel>(),
          child: AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              BlocConsumer<DeleteAccountViewModel, DeleteAccountState>(
                listener: (context, state) {
                  if (state is DeleteAccountSuccess) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  } else if (state is DeleteAccountFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete failed: ${state.error}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is DeleteAccountLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CircularProgressIndicator(),
                    );
                  }
                  return TextButton(
                    onPressed: () {
                      context.read<DeleteAccountViewModel>().add(DeleteAccountRequested());
                    },
                    child: const Text('Delete'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: const Color(0xFFF9FAFB),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingsCard(
              context,
              icon: Icons.person_outline,
              title: 'Profile Settings',
              onTap: () => _navigateToProfileSettings(context),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () => _showChangePasswordDialog(context),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () => _showLogoutDialog(context),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              context,
              icon: Icons.delete_forever,
              title: 'Delete Account',
              iconColor: Colors.redAccent,
              onTap: () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color iconColor = Colors.black54,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: const Color(0xFFab1d79).withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
