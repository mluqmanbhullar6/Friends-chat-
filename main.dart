
import 'package:flutter/material.dart';

void main() {
  runApp(const FriendsChatApp());
}

const Color blue = Color(0xFF38BDF8);
const Color purple = Color(0xFF8B5CF6);
const Color bg = Color(0xFF0B0B14);
const Color panel = Color(0xFF191927);

class FriendsChatApp extends StatelessWidget {
  const FriendsChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friends Chat',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class Post {
  final String name;
  final String caption;
  final String emoji;
  final Color color;

  Post(this.name, this.caption, this.emoji, this.color);
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedTab = 0;
  String displayName = 'Friends User';
  bool privateAccount = false;
  bool notifications = true;
  bool allowMessages = true;
  bool followingOnly = false;
  final Set<int> likedPosts = {};
  final Set<int> followedUsers = {};
  final List<String> comments = [];

  final TextEditingController nameController =
      TextEditingController(text: 'Friends User');

  final List<Post> posts = [
    Post('Ali Khan', 'Welcome to Friends Chat! 💙',
        '🌃', const Color(0xFF302060)),
    Post('Sara Malik', 'Friends make life beautiful ✨',
        '🌅', const Color(0xFF743B68)),
    Post('Ahmed', 'Enjoy your day! 🔥',
        '🏞️', const Color(0xFF165B65)),
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void openChat(String name, {bool group = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatView(
          userName: name,
          isGroup: group,
        ),
      ),
    );
  }

  void showComments() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: panel,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, refresh) => Padding(
          padding: EdgeInsets.fromLTRB(
            16, 20, 16,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Comments',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (comments.isEmpty)
                const Text('Be the first to comment!'),
              ...comments.map(
                (item) => ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(item),
                ),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: blue),
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;
                      setState(() {
                        comments.add(controller.text.trim());
                      });
                      Navigator.pop(sheetContext);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget story(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == 'Go Live') {
          message('Live streaming service needs to be connected.');
        } else if (label == 'Your story') {
          message('Gallery upload integration is needed.');
        } else {
          message('$label story');
        }
      },
      child: SizedBox(
        width: 75,
        child: Column(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [blue, purple],
                ),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget postCard(int index) {
    final post = posts[index];
    final liked = likedPosts.contains(index);
    final following = followedUsers.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: purple.withOpacity(0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: purple,
              child: Text(post.name[0]),
            ),
            title: Text(post.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Friends Chat'),
            trailing: TextButton(
              onPressed: () {
                setState(() {
                  if (following) {
                    followedUsers.remove(index);
                  } else {
                    followedUsers.add(index);
                  }
                });
              },
              child: Text(following ? 'Following' : 'Follow',
                  style: const TextStyle(color: blue)),
            ),
          ),
          Container(
            height: 310,
            width: double.infinity,
            color: post.color,
            child: Stack(
              children: [
                Center(
                  child: Text(post.emoji,
                      style: const TextStyle(fontSize: 95)),
                ),
                const Positioned(
                  left: 12,
                  bottom: 12,
                  child: Text('Video preview'),
                ),
                Positioned(
                  right: 10,
                  bottom: 8,
                  child: IconButton(
                    onPressed: () => message(
                      'Connect a video player for real video playback.',
                    ),
                    icon: const Icon(Icons.play_circle_fill,
                        size: 42, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(post.caption),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    if (liked) {
                      likedPosts.remove(index);
                    } else {
                      likedPosts.add(index);
                    }
                  });
                },
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: liked ? Colors.pinkAccent : Colors.white,
                ),
                label: Text(liked ? 'Liked' : 'Like'),
              ),
              TextButton.icon(
                onPressed: showComments,
                icon: const Icon(Icons.comment_outlined),
                label: const Text('Comment'),
              ),
              TextButton.icon(
                onPressed: () => message(
                  'Connect a sharing feature to share real posts.',
                ),
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text(
          'Connect • Share • Chat',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 85,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              story('Your story', Icons.add),
              story('Ali', Icons.person),
              story('Sara', Icons.face),
              story('Ahmed', Icons.favorite),
              story('Go Live', Icons.live_tv),
            ],
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => message(
            'Video upload requires gallery and storage integration.',
          ),
          icon: const Icon(Icons.video_call, color: blue),
          label: const Text('Upload a short video'),
        ),
        const SizedBox(height: 14),
        ...List.generate(posts.length, postCard),
      ],
    );
  }

  Widget inboxPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Inbox',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: const Text('Ali Khan'),
          subtitle: const Text('Personal chat'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openChat('Ali Khan'),
        ),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.groups)),
          title: const Text('Friends Group'),
          subtitle: const Text('Group chat'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openChat('Friends Group', group: true),
        ),
        const Divider(),
        const Text(
          'Real-time messaging requires Firebase Firestore.',
          style: TextStyle(color: Colors.white60),
        ),
      ],
    );
  }

  Widget searchPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Search',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search people...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(posts.length, (index) {
          final post = posts[index];
          final following = followedUsers.contains(index);
          return ListTile(
            leading: CircleAvatar(child: Text(post.name[0])),
            title: Text(post.name),
            trailing: TextButton(
              onPressed: () {
                setState(() {
                  if (following) {
                    followedUsers.remove(index);
                  } else {
                    followedUsers.add(index);
                  }
                });
              },
              child: Text(following ? 'Following' : 'Follow'),
            ),
            onTap: () => openChat(post.name),
          );
        }),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('My Profile',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        const Center(
          child: CircleAvatar(
            radius: 48,
            backgroundColor: purple,
            child: Icon(Icons.person, size: 55),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () => message(
              'Camera and gallery selection need image_picker integration.',
            ),
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Choose profile picture'),
          ),
        ),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        const SizedBox(height: 12),
        Text('Following: ${followedUsers.length}'),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            setState(() => displayName = nameController.text.trim());
            message('Name updated in this demo.');
          },
          child: const Text('Save profile'),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings & Privacy'),
          onTap: () => setState(() => selectedTab = 4),
        ),
      ],
    );
  }

  Widget settingsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Settings & Privacy',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        SwitchListTile(
          value: privateAccount,
          onChanged: (value) => setState(() => privateAccount = value),
          title: const Text('Private account'),
          secondary: const Icon(Icons.lock_outline),
        ),
        SwitchListTile(
          value: notifications,
          onChanged: (value) => setState(() => notifications = value),
          title: const Text('Notifications'),
          secondary: const Icon(Icons.notifications_outlined),
        ),
        SwitchListTile(
          value: allowMessages,
          onChanged: (value) => setState(() => allowMessages = value),
          title: const Text('Allow messages'),
          secondary: const Icon(Icons.message_outlined),
        ),
        SwitchListTile(
          value: followingOnly,
          onChanged: (value) => setState(() => followingOnly = value),
          title: const Text('Following feed only'),
          secondary: const Icon(Icons.people_outline),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English'),
          onTap: () => message('Language selection will be added next.'),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help and support'),
          onTap: () => message('Friends Chat Help'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About Friends Chat'),
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'Friends Chat',
            applicationVersion: '1.0',
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            setState(() => selectedTab = 5);
          },
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
        ),
      ],
    );
  }

  Widget loginPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.forum, size: 65, color: blue),
            const Text('Friends Chat',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(labelText: 'Email or phone'),
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => message(
                'Firebase Authentication is needed for real login.',
              ),
              child: const Text('Log in'),
            ),
            TextButton(
              onPressed: () => message(
                'Firebase Authentication is needed for sign up.',
              ),
              child: const Text('Create account'),
            ),
            TextButton(
              onPressed: () => setState(() => selectedTab = 0),
              child: const Text('Return to demo'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      homePage(),
      inboxPage(),
      searchPage(),
      profilePage(),
      settingsPage(),
      loginPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Friends Chat',
          style: TextStyle(
            color: blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => selectedTab = 4),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedTab,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab < 4 ? selectedTab : 3,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ChatView extends StatefulWidget {
  final String userName;
  final bool isGroup;

  const ChatView({
    super.key,
    required this.userName,
    this.isGroup = false,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages = [];

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'text': text,
        'time': TimeOfDay.now().format(context),
      });
    });

    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: panel,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: purple,
              child: Icon(
                widget.isGroup ? Icons.groups : Icons.person,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName,
                      style: const TextStyle(fontSize: 16)),
                  const Text(
                    'Friends Chat',
                    style: TextStyle(fontSize: 11, color: blue),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Calling service is not connected yet.'),
              ),
            ),
            icon: const Icon(Icons.call_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.forum_outlined, size: 65, color: purple),
                        SizedBox(height: 12),
                        Text('Start your conversation!'),
                        SizedBox(height: 5),
                        Text(
                          'Send your first message below.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final item = messages[index];
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.78,
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5B4BDB), purple],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item['text'] ?? ''),
                              const SizedBox(height: 4),
                              Text(
                                item['time'] ?? '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: panel,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Emoji picker can be added later.'),
                      ),
                    ),
                    icon: const Icon(Icons.emoji_emotions_outlined, color: blue),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Write a message...',
                        filled: true,
                        fillColor: const Color(0xFF252538),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: purple,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, size: 20),
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
}
