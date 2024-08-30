import 'package:flutter/material.dart';
import 'package:vccinputtablet/models/recipe_list_model.dart';
import 'package:vccinputtablet/utility/sqlite_helper.dart';
import 'package:vccinputtablet/widgets/show_progress.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<RecipeList_Model> recipe_list_model = [];
  bool load = true;
  bool f_no_data = true;

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Null> GET_RecipeName() async {
    await SQLiteHeltper().readsqliteVccCastLog_RecipeName().then((value) {
      print('Read Recipe Name SQLite : ${value}');
      setState(() {
        load = false;
        if (value.isEmpty) {
          f_no_data = true;
        } else {
          f_no_data = false;
          recipe_list_model = value;
        }
      });
    });
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GET_RecipeName();
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'RECIPE LIST',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(10.0, 10.0),
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                Shadow(
                  offset: Offset(10.0, 10.0),
                  blurRadius: 8.0,
                  color: Color.fromARGB(125, 0, 0, 255),
                ),
              ],
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          elevation: 25,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: load
            ? ShowProgress()
            : f_no_data
                ? Center(
                    child: Text(
                    'No Data was Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))
                : Column(
                    children: [
                      _listViewDismissible(recipe_list_model),
                    ],
                  ));
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Widget _listViewDismissible(List<RecipeList_Model> x) {
  return Expanded(
    child: ListView.builder(
        itemCount: x.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            background: slideLeftBackground(),
            //secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                showAlertDelete(context, x[index].recipe_name);
              } else {}
            },
            child: Card(
              child: ListTile(
                // selected: _selectedItems.contains(index) ? true : false,
                leading: Container(
                  height: 30,
                  width: 30,
                  child: buildNumline(index),
                ),
                title: Text(x[index].recipe_name),
                subtitle: Text(x[index].timestamp),
                onTap: () async{
                  print('You choose : ${x[index].recipe_name}');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text('You choose : ☑️  ${x[index].timestamp}     ${x[index].recipe_name}')), backgroundColor: Colors.blue,));
                  //await Future.delayed(const Duration(seconds: 2));
                   Navigator.pop(context, x[index].recipe_name);
                   
                },
              ),
            ),
          );
        }),
  );
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CircleAvatar buildNumline(int index) {
  return CircleAvatar(
    child: Text(
      (index + 1).toString(),
      style: TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.blue,
  );
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void showAlertDelete(BuildContext context, String recipe_name) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: (){
      //Delete
      SQLiteHeltper().deleteSQLiteWhereRecipeName(recipe_name).then((value) async {
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text('Delete Success : ❌ $recipe_name')), backgroundColor: Colors.red,));
        Navigator.of(context).pop();
       
        // Read again
         GET_RecipeName();
    
      });
      
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Row(children: [
      Icon(
        Icons.delete_forever,
        color: Colors.red,
        size: 50,
      ),
      Text(' Delete Recipe. ')
    ]),
    content: Text("Would you like to Delete $recipe_name?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

}