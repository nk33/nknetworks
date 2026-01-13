
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NKNetworksApp());
}

class NKNetworksApp extends StatelessWidget {
  const NKNetworksApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seedBlue = const Color(0xFF0D47A1);
    return MaterialApp(
      title: 'NK Networks Ltd',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedBlue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeWebViewPage(),
      const SupportWizardPage(),
      const ContactPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NK Networks Ltd'),
        centerTitle: true,
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.support_agent_outlined), selectedIcon: Icon(Icons.support_agent), label: 'Support'),
          NavigationDestination(icon: Icon(Icons.chat_outlined), selectedIcon: Icon(Icons.chat), label: 'Contact'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Image.asset('assets/images/Canva logo 4.png', height: 48, fit: BoxFit.contain)),
          const SizedBox(width: 12),
          Expanded(child: Image.asset('assets/images/comp doc final e card.jpg', height: 48, fit: BoxFit.contain)),
          const SizedBox(width: 12),
          Expanded(child: Image.asset('assets/images/mcp logo.png', height: 48, fit: BoxFit.contain)),
        ],
      ),
    );
  }
}

class HomeWebViewPage extends StatefulWidget {
  const HomeWebViewPage({super.key});

  @override
  State<HomeWebViewPage> createState() => _HomeWebViewPageState();
}

class _HomeWebViewPageState extends State<HomeWebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          setState(() => _progress = progress);
        },
        onPageFinished: (_) => setState(() => _progress = 100),
      ))
      ..loadRequest(Uri.parse('https://www.nknetworks.co.uk'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandHeader(),
        if (_progress < 100)
          LinearProgressIndicator(value: _progress / 100),
        Expanded(child: WebViewWidget(controller: _controller)),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchWhatsApp('Hello Nick, I'd like to chat with NK Networks.'),
                  icon: const Icon(Icons.whatsapp),
                  label: const Text('Message us on WhatsApp'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchEmail(
                    to: 'nick@nknetworks.co.uk',
                    subject: 'General enquiry from NK Networks App',
                    body: 'Hello Nick, I'd like to ask about...'
                  ),
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Email us'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BrandHeader(),
          const SizedBox(height: 12),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Contact NK Networks Ltd', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _launchWhatsApp('Hello Nick, I'd like to book support.'),
                    icon: const Icon(Icons.whatsapp),
                    label: const Text('WhatsApp'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _launchEmail(
                      to: 'nick@nknetworks.co.uk',
                      subject: 'Contact from NK Networks App',
                      body: 'Hello Nick, can you help with...'
                    ),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Email'),
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

class SupportWizardPage extends StatefulWidget {
  const SupportWizardPage({super.key});

  @override
  State<SupportWizardPage> createState() => _SupportWizardPageState();
}

class _SupportWizardPageState extends State<SupportWizardPage> {
  final Map<String, List<String>> categories = {
    'Networking Issues': ['Wi-Fi not connecting', 'Router setup', 'Slow internet', 'Cabling'],
    'Computer Repair': ['Won't start', 'Blue screen', 'Overheating', 'Battery/Power'],
    'Software Problems': ['Windows Update', 'Microsoft 365/Outlook', 'Antivirus/Malware', 'Drivers'],
    'Data Recovery': ['Deleted files', 'Drive failure', 'Backup restore', 'Cloud restore'],
    'Other': ['Other']
  };

  final List<String> devices = ['Windows PC', 'Mac', 'Linux', 'Android', 'iOS', 'Other'];

  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedDevice;
  final TextEditingController detailsController = TextEditingController();

  int step = 0;

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  String buildMessage() {
    final lines = [
      'Support Request - NK Networks Ltd (Computer Doctor)',
      'Category: ${selectedCategory ?? ''}',
      'Issue: ${selectedSubCategory ?? ''}',
      'Device: ${selectedDevice ?? ''}',
      'Details: ${detailsController.text.trim()}',
    ];
    return lines.join('
');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BrandHeader(),
            const SizedBox(height: 8),
            const Text('Get Instant Support', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Stepper(
              currentStep: step,
              onStepContinue: () {
                if (step < 3) setState(() => step += 1);
              },
              onStepCancel: () {
                if (step > 0) setState(() => step -= 1);
              },
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    ElevatedButton(onPressed: details.onStepContinue, child: const Text('Next')),
                    const SizedBox(width: 12),
                    TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
                  ],
                );
              },
              steps: [
                Step(
                  title: const Text('Choose a category'),
                  content: Wrap(
                    spacing: 8,
                    children: categories.keys.map((k) => ChoiceChip(
                      label: Text(k),
                      selected: selectedCategory == k,
                      onSelected: (_) => setState(() {
                        selectedCategory = k;
                        selectedSubCategory = null;
                      }),
                    )).toList(),
                  ),
                ),
                Step(
                  title: const Text('Choose a sub-issue'),
                  content: Wrap(
                    spacing: 8,
                    children: (selectedCategory == null)
                        ? [const Text('Please choose a category first')]
                        : categories[selectedCategory]!.map((s) => ChoiceChip(
                            label: Text(s),
                            selected: selectedSubCategory == s,
                            onSelected: (_) => setState(() => selectedSubCategory = s),
                          )).toList(),
                  ),
                ),
                Step(
                  title: const Text('Select your device'),
                  content: Wrap(
                    spacing: 8,
                    children: devices.map((d) => ChoiceChip(
                      label: Text(d),
                      selected: selectedDevice == d,
                      onSelected: (_) => setState(() => selectedDevice = d),
                    )).toList(),
                  ),
                ),
                Step(
                  title: const Text('Add specifics'),
                  content: TextField(
                    controller: detailsController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: 'Describe the issue, error messages, when it started, etc.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final msg = buildMessage();
                      _launchWhatsApp(msg);
                    },
                    icon: const Icon(Icons.whatsapp),
                    label: const Text('Send via WhatsApp'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final msg = buildMessage();
                      _launchEmail(
                        to: 'nick@nknetworks.co.uk',
                        subject: 'Support Request - NK Networks Ltd',
                        body: msg,
                      );
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Send via Email'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchWhatsApp(String message) async {
  const phone = '447801866445'; // UK number without leading zeros or +
  final encoded = Uri.encodeComponent(message);
  final url = Uri.parse('https://wa.me/$phone?text=$encoded');
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch WhatsApp');
  }
}

Future<void> _launchEmail({required String to, String subject = '', String body = ''}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: to,
    queryParameters: {
      if (subject.isNotEmpty) 'subject': subject,
      if (body.isNotEmpty) 'body': body,
    },
  );
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch email client');
  }
}
