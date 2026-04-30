

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class TodoPage extends StatefulWidget {
//   const TodoPage({super.key});

//   @override
//   State<TodoPage> createState() => _TodoPageState();
// }

// class _TodoPageState extends State<TodoPage> {
//   final user = FirebaseAuth.instance.currentUser;
//   final TextEditingController controller = TextEditingController();

//   /// 🔥 Reference to user-specific collection
//   CollectionReference get todoRef => FirebaseFirestore.instance
//       .collection('users')
//       .doc(user!.uid)
//       .collection('todos');

//   /// ➕ Add Task
//   void addTask() async {
//     if (controller.text.trim().isEmpty) return;

//     await todoRef.add({
//       'task': controller.text.trim(),
//       'createdAt': Timestamp.now(),
//     });

//     controller.clear();
//   }

//   /// ❌ Delete Task
//   void deleteTask(String id) async {
//     await todoRef.doc(id).delete();
//   }

//   /// 🚪 Logout
//   void logout() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Todo"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: logout,
//           )
//         ],
//       ),

//       body: Column(
//         children: [

//           /// ✍️ Input Field
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       hintText: "Enter task...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: addTask,
//                   child: const Text("Add"),
//                 )
//               ],
//             ),
//           ),

//           /// 📋 Todo List
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: todoRef
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const Center(child: Text("Something went wrong"));
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final docs = snapshot.data!.docs;

//                 if (docs.isEmpty) {
//                   return const Center(child: Text("No tasks yet"));
//                 }

//                 return ListView.builder(
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     final data = docs[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       child: ListTile(
//                         title: Text(data['task']),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => deleteTask(data.id),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController controller = TextEditingController();

  /// 🔥 Firestore reference (no login needed)
  CollectionReference get todoRef =>
      FirebaseFirestore.instance.collection('todos');

  /// ➕ Add Task
  void addTask() async {
    if (controller.text.trim().isEmpty) return;

    await todoRef.add({
      'task': controller.text.trim(),
      'createdAt': Timestamp.now(),
    });

    controller.clear();
  }

  /// ❌ Delete Task
  void deleteTask(String id) async {
    await todoRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todo"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// ✍️ Input Field
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTask,
                  child: const Text("Add"),
                )
              ],
            ),
          ),

          /// 📋 Todo List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: todoRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("No tasks yet"));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(data['task'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(data.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}