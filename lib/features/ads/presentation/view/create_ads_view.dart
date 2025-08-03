// lib/features/ads/presentation/view/create_ads_view.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/service_locator.dart';
import '../../../auth/domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/generate_ad_usecase.dart';
import '../bloc/generate_ad_bloc.dart';
import '../view/full_screen_image_view.dart';

class CreateAdsView extends StatelessWidget {
  const CreateAdsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GenerateAdBloc(sl<GenerateAdUseCase>()),
      child: const _CreateAdsBody(),
    );
  }
}

class _CreateAdsBody extends StatefulWidget {
  const _CreateAdsBody();

  @override
  State<_CreateAdsBody> createState() => _CreateAdsBodyState();
}

class _CreateAdsBodyState extends State<_CreateAdsBody> {
  final _promptController = TextEditingController();
  int _credits = 0;
  bool _loadingCredits = true;

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    try {
      final user = await sl<GetProfileUseCase>()();
      setState(() => _credits = user.credits);
    } catch (_) {
      // ignore errors
    } finally {
      setState(() => _loadingCredits = false);
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _submit() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;
    if (_credits < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough credits')),
      );
      return;
    }
    context.read<GenerateAdBloc>().add(GenerateAdRequested(prompt));
  }

  void _onBuyCredits() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buy credits flow not yet implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    if (_loadingCredits) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ad'),
        centerTitle: true,
      ),
      body: BlocListener<GenerateAdBloc, GenerateAdState>(
        listener: (context, state) {
          if (state is GenerateAdSuccess) {
            setState(() => _credits = state.remainingCredits);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 Your ad is ready!')),
            );
          }
          if (state is GenerateAdFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_rounded),
                      const SizedBox(width: 8),
                      Text(
                        'Credits: $_credits',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _onBuyCredits,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Buy'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: 'Describe your ad idea…',
                      border: InputBorder.none,
                    ),
                    maxLines: 2,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Generate (5 credits)',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<GenerateAdBloc, GenerateAdState>(
                builder: (context, state) {
                  if (state is GenerateAdLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is GenerateAdSuccess) {
                    final raw = state.imageUrl;
                    Widget imageWidget;
                    if (raw.startsWith('data:image')) {
                      final b64 = raw.split(',').last;
                      imageWidget = Image.memory(
                        base64Decode(b64),
                        fit: BoxFit.cover,
                      );
                    } else {
                      final url = 'http://10.0.2.2:5050$raw';
                      imageWidget = Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, prog) =>
                            prog == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator()),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Preview',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          clipBehavior: Clip.hardEdge,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FullScreenImageView(
                                      imageUri: raw.startsWith('data:')
                                          ? raw
                                          : 'http://10.0.2.2:5050$raw',
                                    ),
                                  ),
                                );
                              },
                              child: imageWidget,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is GenerateAdFailure) {
                    return Center(
                      child: Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
