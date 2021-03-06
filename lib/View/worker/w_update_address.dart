import 'package:flutter/material.dart';
import 'package:home_well/Model/WorkerModel/WorkerProfileModel.dart';

import 'w_profile.dart';


WorkerDataFromFireStore  updateDataFromFireStore = new WorkerDataFromFireStore ();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _address = new TextEditingController();

class WorkerUpdateAddress extends StatefulWidget {
  final String uid;

  const WorkerUpdateAddress({Key key, this.uid}) : super(key: key);

  @override
  _WorkerUpdateAddressState createState() => _WorkerUpdateAddressState(uid);
}

class _WorkerUpdateAddressState extends State<WorkerUpdateAddress> {
  String uid;

  _WorkerUpdateAddressState(this.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Your Address',
            style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WProfile()));
              }),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Update your Address',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Text(
                  'Your name makes it easy for Company to Approach you',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(
                    hintText: 'Enter your full Address',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Address';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Container(
                    width: 330,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.lightGreen)),
                      color: Colors.lightGreen,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          updateDataFromFireStore.updateData(
                              uid, 'Area', _address.text);
                          updateDataFromFireStore.removeValueFromSP('area');
                          updateDataFromFireStore.save('area', _address.text);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => WProfile()));
                        }
                      }, //  padding: EdgeInsets.only(top: 20),
                    )),
              ],
            ),
          ),
        ));
  }
}
