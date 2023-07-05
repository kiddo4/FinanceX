import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceX',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.amber,
          ).copyWith(
            secondary: Colors.blue,
            error: Colors.red,
          ),
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: AppBarTheme(
              titleTextStyle:
              TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              // Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
              //   fontFamily: 'OpenSans',
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              // )
          )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
  //   Transaction(
  //       't1',
  //       'New Shoes',
  //       69.99,
  //       DateTime.now()
  //   ),
  //   Transaction(
  //       't2',
  //       'Weekly Groceries',
  //       16.99,
  //       DateTime.now()
  //   ),
   ];
  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate){
    final newTx = Transaction(
        DateTime.now().toString(),
        title,
        amount,
        chosenDate
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
      return GestureDetector(
        onTap: () {},
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    },);
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }
 List  <Widget> _buildLanscapeContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget
      ) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            'Show chart',
            style: Theme.of(context).textTheme.titleMedium
        ),
        Switch.adaptive(
          activeColor: Theme.of(context).primaryColor,
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },),
      ],),
      _showChart
          ? Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.7,
        child: Chart(_recentTransactions),
      )
          : txListWidget
    ];
  }

  List <Widget> _buildPotraitContent(
      MediaQueryData mediaQuery,
      AppBar appBar,
      Widget txListWidget
      ) {
    return [
      Container(
        height: (mediaQuery.size.height -
            appBar.preferredSize.height -
            mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ), txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
      middle: Text(
        'FinanceX'
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],
      ),
    )
        : AppBar(
      title: Text('FinanceX'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isLandscape) ..._buildLanscapeContent(
              mediaQuery,
              appBar,
              txListWidget
          ),
          if (!isLandscape)
            ..._buildPotraitContent(
                mediaQuery,
                appBar,
                txListWidget
            ),
        ],
      ),
    ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
    )
        : Scaffold(
        appBar: appBar,
        body: pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS
            ? Container(
          
        )
            : FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      );
  }
}
