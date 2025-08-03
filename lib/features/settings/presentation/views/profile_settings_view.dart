
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:adora_mobile_app/app/service_locator.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/profile_view_model.dart';
import 'package:adora_mobile_app/features/settings/presentation/view_model/change_password_view_model.dart';

class ProfileSettingsView extends StatefulWidget {
  final bool changePasswordOnly;
  const ProfileSettingsView({this.changePasswordOnly = false, super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _currCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch profile as soon as this screen loads
    context.read<ProfileViewModel>().add(FetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.changePasswordOnly ? 'Change Password' : 'Profile Settings',
        ),
      ),
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (ctx, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(ctx)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (ctx, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoaded) {
            // Populate controllers
            _nameCtrl.text = state.user.name;
            _emailCtrl.text = state.user.email;

            // Use non-null fallback for profilePic
            final picUrl = state.user.profilePic ?? '';

            return Padding(
              padding: const EdgeInsets.all(16),
              child: widget.changePasswordOnly
                  ? _buildChangePasswordSection()
                  : _buildProfileForm(picUrl),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileForm(String picUrl) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          // Profile picture + upload button
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: picUrl.isNotEmpty
                      ? NetworkImage(picUrl)
                      : const AssetImage('assets/avatar.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: PopupMenuButton<ImageSource>(
                    icon: const Icon(Icons.camera_alt),
                    onSelected: (src) {
                      context
                          .read<ProfileViewModel>()
                          .add(PickProfileImage(src));
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: ImageSource.camera,
                        child: Text('Camera'),
                      ),
                      PopupMenuItem(
                        value: ImageSource.gallery,
                        child: Text('Gallery'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Name field
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
          ),
          const SizedBox(height: 12),

          // Email field
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) =>
                v != null && v.contains('@') ? null : 'Invalid email',
          ),
          const SizedBox(height: 20),

          // Save button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ProfileViewModel>().add(
                      UpdateProfile(
                        name: _nameCtrl.text.trim(),
                        email: _emailCtrl.text.trim(),
                      ),
                    );
              }
            },
            child: const Text('Save Changes'),
          ),

          const SizedBox(height: 20),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return BlocProvider.value(
      value: sl<ChangePasswordViewModel>(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _currCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            BlocConsumer<ChangePasswordViewModel, ChangePasswordState>(
              listener: (ctx, st) {
                if (st is ChangePasswordSuccess) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('Password changed')));
                  Navigator.pop(ctx);
                } else if (st is ChangePasswordFailure) {
                  ScaffoldMessenger.of(ctx)
                      .showSnackBar(SnackBar(content: Text(st.error)));
                }
              },
              builder: (ctx, st) {
                if (st is ChangePasswordLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    if (_newCtrl.text == _confCtrl.text) {
                      ctx.read<ChangePasswordViewModel>().add(
                            ChangePasswordRequested(
                              _currCtrl.text.trim(),
                              _newCtrl.text.trim(),
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(
                            content: Text('Passwords don’t match')),
                      );
                    }
                  },
                  child: const Text('Change Password'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
