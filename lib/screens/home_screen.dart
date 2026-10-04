import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:taskly/data/task_box.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/utils/string_extensions.dart';
import 'package:taskly/widgets/glass_container.dart';
import 'package:taskly/widgets/new_task.dart';
import 'package:taskly/widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
  with SingleTickerProviderStateMixin {
  final _fullname = 'kenny odukoya';

  int _activeTabId = 1;
  final _tabs = [
    {'identifier': 'all', 'id': 1, 'label': 'All'},
    {'identifier': 'personal', 'id': 2, 'label': 'Personal'},
    {'identifier': 'work', 'id': 3, 'label': 'Work'},
  ];

  late final AnimationController _buttonController;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _sheet;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 1), // starts fully below its final position
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutCubic),
    );

    _buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    );

    // Wait a bit after the screen appears, then play the entrance.
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _buttonController.forward();
    });
  }

  void _openAddTaskSheet() {
  if (_sheet != null) return; // a sheet is already open, ignore extra taps

  _sheet = _scaffoldKey.currentState!.showBottomSheet(
    backgroundColor: Colors.transparent,
    (sheetContext) {
      final isDark =
          MediaQuery.platformBrightnessOf(sheetContext) == Brightness.dark;

      return Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        decoration: BoxDecoration(
          color: isDark ? const Color.fromARGB(235, 20, 28, 56) : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 15,
              children: [
                IconButton(
                  icon: Icon(Icons.close,
                   size: 30,
                   color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () => _sheet?.close(),
                ),
                Text('Add New Task',
                  style: TextStyle(
                    fontSize: 26,
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight(500)
                  ),
                )
              ]
            ),
            NewTask(isDark: isDark,)
          ],
        ),
      );
    },
  );

  // This future completes when the sheet closes, whether from the X
  // button or from the user dragging it down.
  _sheet!.closed.then((_) => _sheet = null);
}

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final titleColor = isDarkMode ? Colors.white : const Color(0xFF0D1224);
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final accentColor = !isDarkMode ? Colors.white : const Color.fromARGB(255, 138, 139, 180);

    final name = _fullname.split(' ')[0].capitalize();

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ValueListenableBuilder(
                valueListenable: taskBox.listenable(),
                builder: (context, Box<Task> box, _) {
                  final allTasks = box.values.toList();
                  final tasksRemaining = allTasks.where((task) => !task.isDone).length;
                  final tasksCompleted = allTasks.where((task) => task.isDone).length;
          
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 140),
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good morning, $name',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                    color: titleColor,
                                    height: 1.8,
                                  ),
                                ),
                                Text(
                                  'You have $tasksRemaining tasks remaining today',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          GlassContainer(
                            borderRadius: 100,
                            paddingHorizontal: 0,
                            paddingVertical: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                'assets/images/noprofile.png',
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.41,
                            child: GlassContainer(
                              paddingHorizontal: 20,
                              paddingVertical: 25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$tasksRemaining',
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: accentColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  const Text(
                                    'Remaining',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.41,
                            child: GlassContainer(
                              paddingHorizontal: 20,
                              paddingVertical: 25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$tasksCompleted',
                                    style: const TextStyle(
                                      fontSize: 35,
                                      color: Color(0xFF09F334),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  const Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      Row(
                        spacing: 15,
                        children: _tabs.map((tab) {
                          final isActive = tab['id'] == _activeTabId;
          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeTabId = tab['id'] as int;
                              });
                            },
                            child: isActive
                                ? GlassContainer(
                                    paddingHorizontal: 16,
                                    paddingVertical: 8,
                                    child: Text(
                                      tab['label'] as String,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      tab['label'] as String,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TaskList(
                        activeTabId: _activeTabId,
                        tasks: allTasks,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 100,
            child: SlideTransition(
              position: _buttonSlide,
              child: FadeTransition(
                opacity: _buttonFade,
                child: ElevatedButton(
                  onPressed: _openAddTaskSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3134DE),
                    minimumSize: const Size(56, 56), 
                    fixedSize: const Size(56, 56),
                    padding: EdgeInsets.zero, 
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  )
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}