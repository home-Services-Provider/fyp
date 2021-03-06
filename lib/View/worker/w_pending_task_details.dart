import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_well/Controller/CustomerController/rigesterCustomerCtrl.dart';
import 'package:home_well/Controller/WorkerController/historyDataModel.dart';
import 'package:home_well/Model/CustomerModel/AddJobRequest.dart';
import 'package:home_well/Model/WorkerModel/WorkerProfileModel.dart';
import 'package:home_well/View/worker/w_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'w_pending_task.dart';

AddJobRequest _jobRequest = new AddJobRequest();
WorkerHistoryData _workerData = new WorkerHistoryData();
CustomerData _customerData = new CustomerData();
WorkerDataFromFireStore _dataFromFireStore = WorkerDataFromFireStore();
SharedPreferences sp;

class PendingTaskDetails extends StatelessWidget {
  final Task task;

  const PendingTaskDetails({Key key, this.task}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    currentUser();
    Color color;
    if (task.jobStatus == 'Accepted')
      color = Colors.lightGreen;
    else
      color = Colors.red;

    return new AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Center(
        child: const Text(
          'Work Detail',
          style: TextStyle(
              color: Colors.lightGreen,
              fontSize: 24.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(task.customerImage)))),
              Text(
                task.customerName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                task.customerContact,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                task.jobStatus,
                style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: color),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Type :  " + task.job,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Field : " + task.subJob,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Sub Fields :  " + task.subJobFields.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Address :  " +
                          task.address +
                          ", " +
                          task.area +
                          ", " +
                          task.city,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ]),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Container(
                  child: RaisedButton(
                    color: Colors.lightGreen,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WorkerHome()));

                      await addToWorkerHistory(task);
                      await addToCustomerHistory(task);

                    },
                    child: Text(
                      "Completed",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
              )),

              Container(
                  child: RaisedButton(
                    color: Colors.lightGreen,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: () async {
                      await _jobRequest.removeFromPendingWorker(task.docId, user.uid);
                      await _jobRequest.removeFromPendingCustomer(task.docId, task.customerId);
                      Navigator.pop(context);

                    },
                    child: Text(
                      "Cancel Request",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )),
            ],
      )),
    );
  }
}
final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

currentUser()async{
  user = await _auth.currentUser();
}

addToWorkerHistory(Task task) async{

  currentUser();
  _workerData.workerId=user.uid;
  _workerData.customerId = task.customerId;
  _workerData.customerName = task.customerName;
  _workerData.ph = task.customerContact;
  _workerData.customerImg = task.customerImage;
  _workerData.job = task.job;
  _workerData.subJob = task.subJob;
  _workerData.subJobFields = task.subJobFields;
  _workerData.date = task.date;
  _workerData.time = task.time;
  _workerData.city = task.city;
  _workerData.area = task.area;
  _workerData.address = task.address;


  await _jobRequest.removeFromPendingWorker(task.docId, user.uid);
  await _jobRequest.updateWorkerHistory(task.docId, _workerData);

}

addToCustomerHistory(Task task) async {
  _dataFromFireStore.getSharedPreferences().then((value) {
    sp = value;
  });
  _customerData.userId = task.customerId;
  _customerData.workerName = sp.getString('wName');
  _customerData.workerContact = sp.getString('ph');
  _customerData.workerImg = task.customerImage;
  _customerData.job = task.job;
  _customerData.subJob = task.subJob;
  _customerData.subJobFields = task.subJobFields;
  _customerData.date = task.date;
  _customerData.time = task.time;
  _customerData.city = task.city;
  _customerData.area = task.area;
  _customerData.address = task.address;

  await _jobRequest.removeFromPendingCustomer(task.docId, task.customerId);
  await _jobRequest.updateCustomerHistory(task.docId, _customerData);

}