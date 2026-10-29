
import 'package:flutter/material.dart';

void main() {
  runApp(const ChatlyApp());
}

const purple = Color(0xFF7545D6);
const purpleDark = Color(0xFF5830B0);
const background = Color(0xFFF8F7FC);
const muted = Color(0xFF9993A6);

class ChatlyApp extends StatelessWidget {
  const ChatlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'شاتلي',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: purpleDark,
          elevation: 0,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int tab = 0;
  String search = '';

  final names = ['أحمد محمد', 'علي حسن', 'محمد كريم', 'حسين', 'مصطفى'];
  final messages = [
    'شلونك حبيبي؟',
    'وصلت الرسالة',
    'نشوفك باچر إن شاء الله',
    'تمام حبيبي',
    'صورة جميلة',
  ];
  final times = ['الآن', '10:25', 'أمس', 'أمس', 'الاثنين'];
  final avatars = ['أ', 'ع', 'م', 'ح', 'م'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          title: const Row(
            children: [
              Icon(Icons.chat_bubble_rounded,
                  color: purple, size: 27),
              SizedBox(width: 9),
              Text(
                'شاتلي',
                style: TextStyle(
                  color: purpleDark,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: IndexedStack(
          index: tab,
          children: [
            chatsPage(),
            storiesPage(),
            postsPage(),
            profilePage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.white,
          selectedIndex: tab,
          indicatorColor: purple.withOpacity(.12),
          onDestinationSelected: (i) => setState(() => tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.chat_outlined),
              selectedIcon: Icon(Icons.chat),
              label: 'الدردشات',
            ),
            NavigationDestination(
              icon: Icon(Icons.circle_outlined),
              selectedIcon: Icon(Icons.circle),
              label: 'القصص',
            ),
            NavigationDestination(
              icon: Icon(Icons.dynamic_feed_outlined),
              selectedIcon: Icon(Icons.dynamic_feed),
              label: 'المنشورات',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'حسابي',
            ),
          ],
        ),
        floatingActionButton: tab == 0
            ? FloatingActionButton(
                backgroundColor: purple,
                foregroundColor: Colors.white,
                onPressed: () {},
                child: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }

  Widget chatsPage() {
    final filtered = List.generate(names.length, (i) => i)
        .where((i) => names[i].contains(search))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (v) => setState(() => search = v),
            decoration: InputDecoration(
              hintText: 'ابحث عن محادثة...',
              prefixIcon: const Icon(Icons.search, color: purple),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'القصص الجديدة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 105,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              storyAvatar('أنت', 'أ', own: true),
              storyAvatar('أحمد', 'أ'),
              storyAvatar('علي', 'ع'),
              storyAvatar('محمد', 'م'),
              storyAvatar('حسين', 'ح'),
              storyAvatar('مصطفى', 'ص'),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: Text(
            'المحادثات',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final i = filtered[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 5),
                leading: CircleAvatar(
                  radius: 27,
                  backgroundColor: purple.withOpacity(.12),
                  child: Text(
                    avatars[i],
                    style: const TextStyle(
                      color: purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ),
                title: Text(
                  names[i],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(messages[i]),
                ),
                trailing: Text(
                  times[i],
                  style: const TextStyle(fontSize: 11, color: muted),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(name: names[i]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget storyAvatar(String name, String letter, {bool own = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: own ? Colors.grey.shade300 : purple,
                width: 2.5,
              ),
            ),
            child: CircleAvatar(
              radius: 27,
              backgroundColor: purple.withOpacity(.12),
              child: own
                  ? const Icon(Icons.add, color: purple, size: 27)
                  : Text(letter,
                      style: const TextStyle(
                          color: purple, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget storiesPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('القصص',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: purple,
            child: Icon(Icons.add, color: Colors.white),
          ),
          title: const Text('أضف قصتك'),
          subtitle: const Text('شارك صورة أو فيديو مع أصدقائك'),
          onTap: () {},
        ),
        const Divider(),
        const Text('آخر القصص', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        ...['أحمد محمد', 'علي حسن', 'محمد كريم'].map(
          (name) => ListTile(
            leading: const CircleAvatar(
              backgroundColor: purple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(name),
            subtitle: const Text('قصة جديدة'),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget postsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('المنشورات',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Card(
          color: Colors.white,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: purple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('شنو ببالك اليوم؟'),
            subtitle: const Text('اكتب منشوراً جديداً'),
            trailing: const Icon(Icons.add_circle, color: purple),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 25),
        const Center(
          child: Column(
            children: [
              Icon(Icons.dynamic_feed, size: 55, color: purple),
              SizedBox(height: 12),
              Text('منشورات الأصدقاء ستظهر هنا'),
              SizedBox(height: 5),
              Text('قريباً في شاتلي', style: TextStyle(color: muted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget profilePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: purple,
            child: Icon(Icons.person, size: 55, color: Colors.white),
          ),
          const SizedBox(height: 15),
          const Text(
            'حسابي في شاتلي',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          const Text('أنشئ حسابك وابدأ التواصل',
              style: TextStyle(color: muted)),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: purple),
            onPressed: () {},
            icon: const Icon(Icons.login),
            label: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name;

  const ChatPage({super.key, required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {'text': 'هلا بيك، شلونك؟', 'mine': false},
    {'text': 'الحمد لله بخير، إنت شلونك؟', 'mine': true},
  ];

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'text': text, 'mine': true});
      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: const [
            Icon(Icons.call_outlined),
            SizedBox(width: 18),
            Icon(Icons.more_vert),
            SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final mine = message['mine'] as bool;
                  return Align(
                    alignment: mine
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: mine ? purple : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color: mine ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(
                children: [
                  const Icon(Icons.add_circle_outline, color: purple),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك...',
                        filled: true,
                        fillColor: background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: purple,
                    child: IconButton(
                      onPressed: send,
                      icon: const Icon(Icons.send,
                          color: Colors.white, size: 19),
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
