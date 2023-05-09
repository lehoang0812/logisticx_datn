import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logisticx_datn/home/index.dart';
import 'package:logisticx_datn/login/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required HomeBloc homeBloc,
    Key? key,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  //CreateOrderTab(),    ListOrderTab(),    ManageBankTab(),
  HomeScreenState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: widget._homeBloc,
      builder: (
        BuildContext context,
        HomeState currentState,
      ) {
        if (currentState is UnHomeState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (currentState is ErrorHomeState) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(currentState.errorMessage),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: ElevatedButton(
                  child: Text('reload'),
                  onPressed: _load,
                ),
              ),
            ],
          ));
        }
        if (currentState is InHomeState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(Icons.add), Text("Đặt lịch")],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(Icons.add), Text("Lịch sử")],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(Icons.add), Text("Bảng giá")],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: CircleBorder(),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [Icon(Icons.add), Text("Ưu đãi")],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green[100],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _load() {
    widget._homeBloc.add(LoadHomeEvent());
  }
}
