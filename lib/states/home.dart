import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vccinputtablet/states/input.dart';
import 'package:vccinputtablet/states/setting_db.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vccinputtablet/utility/my_constant.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController recipe_name = TextEditingController();

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'VCC Input Data',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InputForm()),
                );
              },
              icon: const Icon(
                Icons.keyboard_outlined,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingDB()),
                );
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 25,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Row(
                children: [
                  build_selectMachine(context),
                  build_serialnumber(),
                  build_recipelistbutton(),
                  build_recipe_name(recipe_name),
                  build_uploadtbutton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_recipe_name(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 130,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Recipe name';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 17,
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: 'Recipe name : max 17 digits',
          labelStyle: TextStyle(fontSize: 10),
          hintStyle: TextStyle(fontSize: 10),
          counterText: "",
          border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: MyConstant.dark),),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: MyConstant.dark)),
          
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: MyConstant.light)),

          errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.red)),
            
        ),
      ),
    );
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Container build_uploadtbutton() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 125,
      //color: Colors.red,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          gradient: RadialGradient(
            //stops: [0.0, 1],
            radius: 1.5,
            colors: [Colors.white,Colors.lightBlueAccent.shade100,Colors.blueAccent],
            center: Alignment.center,
            tileMode: TileMode.clamp
          ),
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        
        ),
      child:  ElevatedButton.icon(
                      onPressed: (){
                        print("Upload");
                      }, 
                      icon: Icon(Icons.cloud_upload_rounded,color: Colors.white),  //icon data for elevated button
                      label: Text("UPLOAD",style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),), //label text 
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                      
                  ),
    );
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Container build_recipelistbutton() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 80,
      //color: Colors.red,
      child: ElevatedButton(
          onPressed: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => InputForm()),
          },
          style: ElevatedButton.styleFrom(
              elevation: 10,
              backgroundColor: Colors.amberAccent,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
                side: BorderSide(color: MyConstant.dark),
              )),
          child: Text(
            'RecipeList',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          )),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Container build_serialnumber() {
    return Container(
      margin: EdgeInsets.only(top: 6),
      height: 30,
      width: 70,
      color: Colors.lightBlueAccent,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          'S/N:W3491',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_selectMachine(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 6),
      height: 30,
      width: 100,
      //color: Colors.red,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Row(
            children: [
              Icon(
                Icons.list,
                size: 14,
                color: Colors.black,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  'M/C name',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 100,
            padding: const EdgeInsets.only(left: 6, right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: MyConstant.dark,
              ),
              color: Colors.blueAccent,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 12,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Colors.blueAccent,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(30),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 30,
            padding: EdgeInsets.only(left: 6, right: 6),
          ),
        ),
      ),
    );
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
}
