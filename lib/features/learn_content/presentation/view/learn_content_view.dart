import 'package:adora_mobile_app/features/learn_content/domain/usecases/get_news_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/learn_content_bloc.dart';
import '../../../../app/service_locator.dart';

class LearnContentView extends StatelessWidget {
  const LearnContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LearnContentBloc(sl<GetNewsUseCase>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Learn Trends')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SearchBar(),
              const SizedBox(height: 12),
              Expanded(child: _ResultList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
              hintText: 'Type your niche…',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: _submit, child: const Text('Go')),
      ],
    );
  }

  void _submit() {
    context.read<LearnContentBloc>().add(FetchNewsRequested(_ctrl.text));
  }
}

class _ResultList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearnContentBloc, LearnContentState>(
      builder: (context, state) {
        if (state is LearnContentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is LearnContentError) {
          return Center(child: Text(state.message));
        }
        if (state is LearnContentLoaded) {
          return ListView.builder(
            itemCount: state.articles.length,
            itemBuilder: (_, i) {
              final a = state.articles[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: a.imageUrl.isNotEmpty
                      ? Image.network(a.imageUrl, width: 56, fit: BoxFit.cover)
                      : null,
                  title: Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(a.description,
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    // TODO: launch a.url
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text('Enter a term to see trends'));
      },
    );
  }
}
