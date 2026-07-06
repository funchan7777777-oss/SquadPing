import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementWebViewStage extends StatefulWidget {
  const AgreementWebViewStage({
    super.key,
    required this.pageTitle,
    required this.pageUrl,
  });

  final String pageTitle;
  final String pageUrl;

  @override
  State<AgreementWebViewStage> createState() => _AgreementWebViewStageState();
}

class _AgreementWebViewStageState extends State<AgreementWebViewStage> {
  late final WebViewController _webController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
          onPageStarted: (_) => setState(() => _isLoading = true),
        ),
      )
      ..loadRequest(Uri.parse(widget.pageUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          WebViewWidget(controller: _webController),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 92,
              padding: const EdgeInsets.fromLTRB(12, 34, 18, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4C2CEB).withValues(alpha: 0.96),
                    const Color(0xFF7D45FF).withValues(alpha: 0.86),
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.pageTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned(
              top: 92,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: const Color(
                  0xFF7D45FF,
                ).withValues(alpha: 0.18),
                minHeight: 3,
              ),
            ),
        ],
      ),
    );
  }
}
