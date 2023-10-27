import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test2/list_view_model.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListPage(),
    );
  }
}

class ListPage extends StatelessWidget {
  ListPage({super.key});
  // 키테스트
  GlobalKey<ChildWidgetState> childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              childKey.currentState!.hello();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailPage()));
            },
            child: Text("상세 이동하기"),
          ),
          ChildWidget(key: childKey),
        ],
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({
    super.key,
  });

  @override
  State<ChildWidget> createState() => ChildWidgetState();
}

class ChildWidgetState extends State<ChildWidget> {
  void hello() {
    print("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          ListModel? model = ref.watch(listProvider);

          if (model == null) {
            return CircularProgressIndicator();
          } else {
            return Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      ref.read(listProvider.notifier).add();
                    },
                    child: Text("댓글추가")),
                Text("${model.title}"),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) =>
                        ListTile(title: Text("${model.comments[index]}")),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("뒤로 가기")),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                ListModel? model = ref.watch(listProvider);

                if (model == null) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ref.read(listProvider.notifier).add();
                          },
                          child: Text("댓글추가")),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.comments.length,
                          itemBuilder: (context, index) =>
                              ListTile(title: Text("${model.comments[index]}")),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
