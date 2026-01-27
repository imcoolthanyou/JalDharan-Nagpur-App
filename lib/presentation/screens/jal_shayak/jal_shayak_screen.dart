import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/rag_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class JalShayakScreen extends StatefulWidget {
  const JalShayakScreen({Key? key}) : super(key: key);

  @override
  State<JalShayakScreen> createState() => _JalShayakScreenState();
}

class _JalShayakScreenState extends State<JalShayakScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I\'m Jal Shayak, your water conservation assistant. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: _messageController.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Call RAG API
    _fetchAIResponse(userMessage.text);
  }

  Future<void> _fetchAIResponse(String userMessage) async {
    try {
      final response = await RAGService.sendMessage(userMessage);

      if (mounted) {
        final aiResponse = ChatMessage(
          text: response.reply,
          isUser: false,
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(aiResponse);
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        final errorResponse = ChatMessage(
          text: '⚠️ Error: ${e.toString()}\n\nTroubleshooting:\n• Check internet connection\n• Ensure backend server is running\n• Try rephrasing your question',
          isUser: false,
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(errorResponse);
          _isLoading = false;
        });
        _scrollToBottom();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get response: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.deepAquiferBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Jal Shayak',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return _buildMessageBubble(_messages[index]);
                } else {
                  return _buildLoadingBubble();
                }
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: 'Ask about water conservation...',
                        hintStyle: TextStyle(
                          color: AppColors.mediumGrey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.mediumGrey,
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.mediumGrey,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.deepAquiferBlue,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _isLoading ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isLoading
                            ? AppColors.mediumGrey
                            : AppColors.deepAquiferBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser
                ? AppColors.deepAquiferBlue
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: message.isUser ? Colors.white : AppColors.darkGrey,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.deepAquiferBlue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Jal Shayak is thinking...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
