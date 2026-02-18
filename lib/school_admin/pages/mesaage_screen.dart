import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  final String? name;
  final String? message;
  final String? time;
  final String? avatarUrl;

  MessageScreen({
    Key? key,
    this.name,
    this.message,
    this.time,
    this.avatarUrl,
  }) : super(key: key);

  static const List<Map<String, dynamic>> dummyMessages = [
    {
      'text': 'Hello, how can I help you today?',
      'sent': false,
      'time': '09:30',
    },
    {
      'text': 'I want to know more about the exam schedule.',
      'sent': true,
      'time': '09:31',
    },
    {
      'text': "Sure! The schedule will be available in your portal this week.",
      'sent': false,
      'time': '09:32',
    },
    {
      'text': "Thank you so much!",
      'sent': true,
      'time': '09:33',
    },
    // ... Add more as needed
  ];

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late List<Map<String, dynamic>> _messages;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If message is passed from user/page, show only that as the single message
    final bool hasSingleMessage = widget.message != null && widget.time != null;
    _messages = hasSingleMessage
        ? [
            {
              'text': widget.message ?? '',
              'sent': false, // from the "other" person
              'time': widget.time ?? '',
            }
          ]
        : List<Map<String, dynamic>>.from(MessageScreen.dummyMessages);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final String text = _controller.text.trim();
    if (text.isNotEmpty) {
      final String nowTime = TimeOfDay.now().format(context);
      setState(() {
        _messages.add({
          'text': text,
          'sent': true,
          'time': nowTime,
        });
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color orange = Color(0xFF5AB04B);
    const Color darkBlue = Color(0xFF023471);
    const Color lightGrey = Color(0xFFF5F6FA);

    final bool hasSingleMessage = widget.message != null && widget.time != null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
          onPressed: () => Navigator.of(context).maybePop(),
          splashRadius: 25,
        ),
        // If a sender name is provided, show it. Otherwise, show 'Messages'
        title: Text(
          widget.name ?? 'Messages',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.avatarUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.avatarUrl!),
                radius: 20,
                backgroundColor: Colors.white24,
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white, size: 26),
              onPressed: () {},
              splashRadius: 25,
            ),
        ],
      ),
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            if (hasSingleMessage)
              SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                reverse: false,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                itemBuilder: (context, idx) {
                  final msg = _messages[idx];
                  final isSent = msg['sent'] as bool;
                  return Align(
                    alignment: isSent
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.74,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 2,
                          bottom: 2,
                          left: isSent ? 38 : 0,
                          right: isSent ? 0 : 38,
                        ),
                        decoration: BoxDecoration(
                          color: isSent ? orange : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(22),
                            topRight: const Radius.circular(22),
                            bottomLeft: Radius.circular(isSent ? 18 : 0),
                            bottomRight: Radius.circular(isSent ? 0 : 18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSent
                                  ? orange.withOpacity(0.13)
                                  : Colors.grey.withOpacity(0.09),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['text'],
                                style: TextStyle(
                                  color: isSent ? Colors.white : darkBlue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.2,
                                  height: 1.36,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    msg['time'],
                                    style: TextStyle(
                                      color: isSent ? Colors.white : Colors.grey.shade500,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.1,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  if (isSent)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Icon(
                                        Icons.done_all,
                                        color: Colors.white.withOpacity(0.88),
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, idx) => const SizedBox(height: 12),
                itemCount: _messages.length,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFDFE2E7), width: 1.1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.attach_file,
                          color: orange,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message ...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        isDense: true,
                        filled: true,
                        fillColor: lightGrey,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                              color: orange, width: 2.2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(
                              color: Colors.grey.shade300, width: 1.6),
                        ),
                      ),
                      cursorColor: orange,
                      minLines: 1,
                      maxLines: 5,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Material(
                    color: orange,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _sendMessage,
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
