
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_well/Controller/CustomerController/rigesterCustomerCtrl.dart';

final CollectionReference customerCollection = Firestore.instance.collection('Customer');

class AddJobRequest{

  Future <void> updateCustomerData(CustomerData bundle) async {

    return await customerCollection.document(bundle.userId).collection('JobRequest').document('job'+bundle.jobCount.toString()).setData({
      'WorkerId' : bundle.workerId,
      'WorkerName' : bundle.workerName,
      'WorkerContact' : bundle.workerContact,
      'WorkerImg' : bundle.workerImg,
      'Job': bundle.job,
      'SubJob': bundle.subJob,
      'SubJobField': FieldValue.arrayUnion(bundle.subJobFields),
      'Date': bundle.date.toString(),
      'Time': bundle.time.toString(),
      'City': bundle.city,
      'Area': bundle.area,
      'Address': bundle.address,
    });
  }
}