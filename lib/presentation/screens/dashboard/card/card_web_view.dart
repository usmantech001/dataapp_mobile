import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardWebView extends StatefulWidget {
  const CardWebView({
    super.key,
    required this.cardToken,
    required this.cardId,
  });

  final String cardToken;
  final String cardId;

  @override
  State<CardWebView> createState() => _CardWebViewState();
}

class _CardWebViewState extends State<CardWebView> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    log("CARD ID: ${widget.cardId}\n CARD TOKEN: ${widget.cardToken}");

    final html = _buildHtml(widget.cardToken, widget.cardId);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
       ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          // 🟢 Handle click event here
          if (message.message == "copyCardNumber") {
            print("User clicked to copy card number");
            // You can show a snackbar or trigger an action here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Card number clicked in WebView")),
            );
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
       onPageFinished: (_) async {
  await Future.delayed(Duration(seconds: 1)); // allow iframe to settle
  if (mounted) {
    setState(() => isLoading = false);
  }
}
      ))
      ..loadHtmlString(html);
  }

String _buildHtml(String token, String id) {
  return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      background-color: #f0f0f0;
      padding: 0px;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
     background: linear-gradient(135deg, #000000, #fffffF);
  border-radius: 20px;
  padding: 30px 24px;
  color: white;
  width: 600px;
  max-width: 600px; /* ⬅️ Increased from 480px to 600px */
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .info-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
       flex-wrap: nowrap;
  overflow: hidden;
    }

    .label {
      font-size: 18px;
      font-weight: 500;
    }

    .value-container {
      display: flex;
      align-items: center;
      gap: 12px;
      max-width: 60%;
      justify-content: flex-end;
      flex: 1;
    }

.value {
  font-size: 20px;
  font-weight: 600;
  display: flex;
  align-items: center;
  min-height: 30px;
  max-width: 100%;
    color: white;
  overflow: hidden;
}

.value iframe {
  border: none;
  display: block;
  height: 30px;
  width: 180px; /* Set a fixed or max width */
  max-width: 100%;
  color: white;
}

    .copy-icon {
      background-color: rgba(255, 255, 255, 0.1);
      padding: 8px;
      border-radius: 6px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background-color 0.2s;
    }

    .copy-icon:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }

    .copy-icon img {
      width: 20px;
      height: 20px;
      filter: brightness(0) invert(1);
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="info-row">
      <div class="label">Card Number</div>
      <div class="value-container">
        <div class="value" id="cardNumber"></div>
        <div class="copy-icon" onclick="copyText('cardNumber')">
          <img src="https://www.svgrepo.com/show/353337/copy.svg" alt="copy icon" />
        </div>
      </div>
    </div>

    <div class="info-row">
      <div class="label">CVV</div>
      <div class="value-container">
        <div class="value" id="cvv2"></div>
        <div class="copy-icon" onclick="copyText('cvv2')">
          <img src="https://www.svgrepo.com/show/353337/copy.svg" alt="copy icon" />
        </div>
      </div>
    </div>
  </div>

  <script src="https://js.securepro.xyz/sudo-show/1.1/ACiWvWF9tYAez4M498DHs.min.js"></script>
  <script>
    const vaultId = "vdl2xefo5";
    const cardId = "$id";
    const cardToken = "$token";

    const numberSecret = SecureProxy.create(vaultId);
    const cvv2Secret = SecureProxy.create(vaultId);

    const cardNumberIframe = numberSecret.request({
      name: 'pan-text',
      method: 'GET',
      path: '/cards/' + cardId + '/secure-data/number',
      headers: {
        "Authorization": "Bearer " + cardToken
      },
      htmlWrapper: 'text',
      jsonPathSelector: 'data.number',
      serializers: [
        numberSecret.SERIALIZERS.replace(
          '(\\d{4})(\\d{4})(\\d{4})(\\d{4})',
          '\$1 \$2 \$3 \$4'
        ),
      ]
    });
    cardNumberIframe.render('#cardNumber');

    const cvv2iframe = cvv2Secret.request({
      name: 'cvv-text',
      method: 'GET',
      path: '/cards/' + cardId + '/secure-data/cvv2',
      headers: {
        "Authorization": "Bearer " + cardToken
      },
      htmlWrapper: 'text',
      jsonPathSelector: 'data.cvv2',
      serializers: []
    });
    cvv2iframe.render('#cvv2');

    function copyText(id) {
      const el = document.getElementById(id);
      if (el && navigator.clipboard) {
        navigator.clipboard.writeText(el.textContent.trim())
          .then(() => alert("Copied"))
          .catch((err) => console.error("Copy failed", err));
      }
    }
  </script>
</body>
</html>
''';
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Card Details"), backgroundColor:Colors.white,),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}