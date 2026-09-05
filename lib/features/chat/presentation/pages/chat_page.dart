import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/bird_mark.dart';
import '../../../../core/widgets/inline_notice.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_empty.dart';
import '../widgets/chat_typing.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({this.initialQuestion, super.key});

  final String? initialQuestion;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const ChatOpened());
    final String? question = widget.initialQuestion;
    if (question != null && question.isNotEmpty) {
      context.read<ChatBloc>().add(ChatQuestionSubmitted(question));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _submit(String value) {
    context.read<ChatBloc>().add(ChatQuestionSubmitted(value));
    _controller.clear();
  }

  void _scrollToEnd() {
    if (!_scrollController.hasClients) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: AppDuration.base,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const _ChatHeader(),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (BuildContext context, ChatState state) =>
                    _scrollToEnd(),
                builder: (BuildContext context, ChatState state) {
                  if (state is! ChatLoaded) {
                    return const SizedBox.shrink();
                  }
                  if (state.messages.isEmpty && !state.isThinking) {
                    return ChatEmpty(onPick: _submit);
                  }
                  return ListView.separated(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      AppSpacing.lg,
                      AppSpacing.screen,
                      AppSpacing.xl,
                    ),
                    itemCount: state.messages.length +
                        (state.isThinking ? 1 : 0) +
                        (state.errorMessage == null ? 0 : 1),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (BuildContext context, int index) {
                      if (index < state.messages.length) {
                        final ChatMessage message = state.messages[index];
                        return ChatBubble(message: message);
                      }
                      if (state.isThinking) {
                        return const ChatTyping();
                      }
                      return InlineNotice(message: state.errorMessage!);
                    },
                  );
                },
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              builder: (BuildContext context, ChatState state) {
                return ChatComposer(
                  controller: _controller,
                  onSubmit: _submit,
                  isEnabled: state is ChatLoaded && !state.isThinking,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: const BirdMark(height: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.chatTitle,
                style: AppTypography.titleSmall.copyWith(color: colors.ink),
              ),
              Text(
                AppStrings.chatSubtitle,
                style: AppTypography.caption.copyWith(color: colors.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
