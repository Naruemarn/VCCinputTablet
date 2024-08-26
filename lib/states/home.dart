import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vccinputtablet/states/input.dart';
import 'package:vccinputtablet/states/setting_db.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:vccinputtablet/utility/my_constant.dart';
import 'package:vccinputtablet/widgets/show_image.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final formkey = GlobalKey<FormState>();

  var isSelected1 = [true, false, false];

  TextEditingController recipe_name = TextEditingController();
  TextEditingController job_id = TextEditingController();
  TextEditingController design_code = TextEditingController();
  TextEditingController alloy = TextEditingController();
  TextEditingController flask_temp = TextEditingController();
  TextEditingController weight_ = TextEditingController();

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
        backgroundColor: Colors.blueAccent,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    build_selectMachine(context),
                    build_serialnumber(),
                    build_recipelistbutton(),
                    build_recipe_name(recipe_name),
                    build_uploadtbutton(),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      build_jobid(job_id),
                      build_design_code(design_code),
                      build_alloy(alloy),
                      build_flask_temp(flask_temp),
                      build_weight(weight_),
                      buildTitle('* Use or No'),
                      build_wax_wax3d_resin(),
                    ],
                  ),
                  Column(
                    children: [
                      build_image(),
                      build_recommend_to_fill(),
                    ],
                  ),
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
  Widget build_image() {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, top: 8),
      color: MyConstant.dark,
      height: 220,
      width: 345,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Card(
          child: Image.asset(
            MyConstant.image1,
            width: 345.0,
          ),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_wax_wax3d_resin() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 0),
      height: 30,
      width: 170,
      //color: Colors.pink,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ToggleButtons(
          //constraints: BoxConstraints.expand(height: 30, width: 54),
          fillColor: Colors.lightGreen,
          selectedColor: Colors.purple,
          borderColor: Colors.blueGrey,
          borderWidth: 2,
          selectedBorderColor: Colors.blue,
          splashColor: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          children: [
            Text('Wax',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Wax (3D)',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('Resin',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
          onPressed: (int index) {
            setState(() {
              isSelected1[index] = !isSelected1[index];
              print("Wax Wax3D Resin : ${isSelected1}");
            });
          },
          isSelected: isSelected1,
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_recommend_to_fill() {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 2),
      child: Text('[*] = Recommend to fill in blank to upload data to SV',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.black)),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget buildTitle(String msg) {
    return Container(
      margin: EdgeInsets.only(left: 6, top: 8),
      //color: Colors.amberAccent,
      child: Text(
        msg,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_weight(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill WEIGHT';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 3,
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: '* WEIGHT : max 3 digits',
          labelStyle: TextStyle(fontSize: 10),
          hintStyle: TextStyle(fontSize: 10),
          counterText: "",
          suffix: Text('g'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_flask_temp(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill FLASK TEMP';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 4,
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: '* FLASK TEMP : max 4 digits',
          labelStyle: TextStyle(fontSize: 10),
          hintStyle: TextStyle(fontSize: 10),
          counterText: "",
          suffix: Text('℃'),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_alloy(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill ALLOY';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 15,
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: '* ALLOY : max 15 digits',
          labelStyle: TextStyle(fontSize: 10),
          hintStyle: TextStyle(fontSize: 10),
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
        ),
      ),
    );
  }

  //------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_design_code(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill DESIGN CODE';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 15,
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: '* DESIGN CODE : max 15 digits',
          labelStyle: TextStyle(fontSize: 10),
          hintStyle: TextStyle(fontSize: 10),
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Widget build_jobid(TextEditingController inputbox) {
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: 6, top: 8),
      height: 30,
      width: 170,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill JOB ID';
          } else {
            return null;
          }
        },
        //keyboardType: TextInputType.number,
        controller: inputbox,
        maxLength: 15,
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          labelText: '* JOB ID : max 15 digits',
          labelStyle: TextStyle(fontSize: 10),
          hintStyle: TextStyle(fontSize: 10),
          counterText: "",
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
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
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: MyConstant.dark),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.dark)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: MyConstant.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.red)),
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
            colors: [
              Colors.white,
              Colors.lightBlueAccent.shade100,
              Colors.blueAccent
            ],
            center: Alignment.center,
            tileMode: TileMode.clamp),
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          print("Upload");
        },
        icon: Icon(Icons.cloud_upload_rounded,
            color: Colors.white), //icon data for elevated button
        label: Text(
          "UPLOAD",
          style: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ), //label text
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
