import 'package:example/environments.dart';
import 'package:example/feature/yuno_payment/data_source/api/yuno_api.dart';
import 'package:example/feature/yuno_payment/domain/reposiotry/yuno_payment_repository.dart';
import 'package:example/feature/yuno_payment/presenter/bloc/yuno_payment_notifier.dart';
import 'package:example/widgets/show_payment_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yuno/yuno.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Yuno.init(
      apiKey: Environments.apiKey, countryCode: 'YOUR_COUNTRY_CODE');
  runApp(
    MultiProvider(
      providers: [
        Provider<YunoPaymentRepository>(
          create: (_) => YunoApi(),
        ),
        ChangeNotifierProvider(
            create: (context) => YunoPaymentExampleNotifier(
                paymentRepository: context.read<YunoPaymentRepository>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<YunoPaymentExampleNotifier>().addListener(_listener);
  }

  void _listener() async {
    final status = context.read<YunoPaymentExampleNotifier>().status;
    if (status == ResultStatus.success) {
      //After the payment is created and proccessed, you can continue with the payment
      Yuno.continuePayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YunoPaymentListener(
      listener: (contest, yunoStatus) async {
        YunoSnackBar.showSnackBar(context, YunoSnackbarOptions.payment,
            yunoStatus.paymentStatus, null);
        if (yunoStatus.token.isNotEmpty) {
          await context
              .read<YunoPaymentExampleNotifier>()
              .createPayment(oneTimeToken: yunoStatus.token);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // FULL SDK VERSION
              YunoPaymentMethods(
                config: const PaymentMethodConf(
                  checkoutSession: 'YOUR_CHECKOUT_SESSION',
                ),
                listener: (context, isSelected) {},
              ),
              TextButton(
                onPressed: _startPaymentLite,
                child: const Text('Start Payment Lite'),
              ),
              TextButton(
                onPressed: _startPayment,
                child: const Text('Start Payment'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _startPaymentLite() {
    Yuno.startPaymentLite(
      arguments: const StartPayment(
        checkoutSession: 'YOUR_CHECKOUT_SESSION',
        methodSelected: MethodSelected(paymentMethodType: 'CARD'),
      ),
    );
  }

  void _startPayment() {
    Yuno.startPayment();
  }
}
