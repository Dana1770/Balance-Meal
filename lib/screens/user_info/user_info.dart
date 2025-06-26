import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/components/components.dart';
import 'package:meal_app/screens/order_screen/order_screen.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = 'Male';
  double weight = 0, height = 0, age = 0;
  double dailyCalories = 0;

  void calculateCalories() {
    if (gender == 'Male') {
      dailyCalories = 666.47 + (13.75 * weight) + (5 * height) - (6.75 * age);
    } else {
      dailyCalories = 655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderScreen(dailyCalories: dailyCalories),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter your details"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0, right: 20, left: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Gender'),
              SizedBox(height: 15),

              DropdownButtonFormField2<String>(
                value: gender,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange.shade900),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                  hintText: 'Enter your gender',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 14,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(color: Colors.white),
                ),
                menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.zero),
                
                items: ['Male', 'Female'].map((item) {
                  final isSelected = item == gender;
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange.shade100 : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.orange.shade200,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: Colors.deepOrange,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                selectedItemBuilder: (context) {
                  return ['Male', 'Female'].map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList();
                },
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
              ),

              SizedBox(height: 25),
              Text('Height'),
              SizedBox(height: 15),
              buildNumberField(
                label: 'Weight',
                onChanged: (value) => weight = double.tryParse(value) ?? 0,
                hint: 'Enter your weight',
                suffix: 'Kg',
              ),
              SizedBox(height: 25),
              Text('Width'),
              SizedBox(height: 15),
              buildNumberField(
                label: 'Height',
                onChanged: (value) => height = double.tryParse(value) ?? 0,
                hint: 'Enter your height',
                suffix: 'cm',
              ),
              SizedBox(height: 25),
              Text('Age'),
              SizedBox(height: 15),
              buildNumberField(
                label: 'Age',
                onChanged: (value) => age = double.tryParse(value) ?? 0,
                hint: 'Enter your age',
              ),
              SizedBox(height: 100),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[350],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: calculateCalories,
                child: Text("Next", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
