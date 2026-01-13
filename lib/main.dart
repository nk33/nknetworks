
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
    return MaterialApp(
      title: 'NK Networks Ltd',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
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
      appBar: AppBar(title: const Text('NK Networks Ltd')),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.support_agent), label: 'Support'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Contact'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
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

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.nknetworks.co.uk'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: WebViewWidget(controller: _controller)),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchWhatsApp('Hello Nick, I need support.'),
                icon: const Icon(Icons.whatsapp),
                label: const Text('WhatsApp'),
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _launchEmail(
                  to: 'nick@nknetworks.co.uk',
                  subject: 'Enquiry',
                  body: 'Hello Nick, I need help.'
                ),
                icon: const Icon(Icons.email),
                label: const Text('Email'),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Contact NK Networks Ltd'));
  }
}

class SupportWizardPage extends StatelessWidget {
  const SupportWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Support Wizard Coming Soon'));
  }
}

Future<void> _launchWhatsApp(String message) async {
  const phone = '447801866445';
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
