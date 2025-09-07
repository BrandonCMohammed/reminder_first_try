import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class Reminder {
  final String reminderTitle;
  final DateTime date;
  final TimeOfDay time;

  const Reminder(this.reminderTitle, this.date, this.time);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Reminder> testReminders = [
    Reminder("1", DateTime.now(), TimeOfDay.now()),
    Reminder("2", DateTime.now(), TimeOfDay.now()),
    Reminder("3", DateTime.now(), TimeOfDay.now()),
  ];
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Reminders"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          itemCount: testReminders.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Center(child: Text(testReminders[index].reminderTitle)),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ReminderInfoPage(
                        testInt: testReminders[index].reminderTitle,
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Reminder results = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ReminderAdderPage();
              },
            ),
          );
          setState(() {
            testReminders.add(results);
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ReminderInfoPage extends StatelessWidget {
  const ReminderInfoPage({super.key, required this.testInt});

  final String testInt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Second Page")),
      body: Center(child: Text(testInt)),
    );
  }
}

class ReminderAdderPage extends StatefulWidget {
  const ReminderAdderPage({super.key});

  @override
  State<ReminderAdderPage> createState() => _ReminderAdderPageState();
}

class _ReminderAdderPageState extends State<ReminderAdderPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2099),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      selectedTime = pickedTime;
    });
  }

  TextEditingController _reminderController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adder page")),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _reminderController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your reminder',
                  ),
                ),

                TextFormField(
                  controller: _dateController,

                  decoration: InputDecoration(
                    hintText: selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Please select a date',
                  ),
                  onTap: () {
                    _selectDate();
                  },
                  readOnly: true,
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    hintText: selectedTime != null
                        ? selectedTime?.format(context).toString()
                        : 'Please select a time',
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectTime();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        // Process data.
                        Reminder r = Reminder(
                          _reminderController.text,
                          selectedDate!,
                          selectedTime!,
                        );

                        Navigator.pop(context, r);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*
Ok so I have created three pages, Home page, view reminders page and add reminders page
On the home page, i just have 3 reminders with current date and time
On the view page, its just the reminder, not the date nor time. I have to add this and the ability to edit this
I need to fill out the edit page
I need to add the alarm
I need to add it to local storage
I need to make it look pretty
**/
