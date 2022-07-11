// The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
const functions = require('firebase-functions');

const admin = require('firebase-admin');
const { onRequest } = require('firebase-functions/v1/https');
const { user } = require('firebase-functions/v1/auth');
const { firestore } = require('firebase-admin');
const { document } = require('firebase-functions/v1/firestore');
admin.initializeApp();

exports.create = functions.https.onCall((data, context) => {
   return admin.firestore().collection('games').add({
      points: 0,
      user: context.auth.uid,
      isComplete: 'true',
      location: 'Obesekarapura Rajagiriya',
      date: firestore.FieldValue.serverTimestamp(),
      garbage: 'G1',
   }).then((docRef) => console.log(docRef.id));
});

exports.update = functions.https.onCall((data, context) => {
   return admin.firestore().collection('games').where('isComplete', '==', 'true').where('user', '==', context.auth.uid).get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) => {
         admin.firestore().collection('games').doc(element.id).update({
            isComplete: 'false',
         })
      })
   })
});


// exports.update = functions.https.onCall((data, context) => {
//    const final = admin.firestore().collection('games').where('isComplete', '==', 'true').where('user', '==', context.auth.uid).get().then(snapshot => {
//       snapshot.forEach(doc => {
//          return admin.firestore().collection('games').doc(doc.id).update({
//             isComplete : 'false',
//          })
//       })
//    })
// });


exports.points = functions.https.onRequest((res, req) => {
   return admin.firestore().collection('games').where('isComplete', '==', 'true').get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) => {
         admin.firestore().collection('games').doc(element.id).update({
            points : firestore.FieldValue.increment(10),
         })
         admin.firestore().collection('users').get().then((querySnapshot) => {
            querySnapshot.docs.forEach((element) => {
               admin.firestore().collection('users').doc(element.id).update({
                  points : firestore.FieldValue.increment(10),
               })
            })
         })
      })   
   }) 
});


exports.voucher = functions.https.onCall((data, context) => {
   return admin.firestore().collection('users').where('uid', '==', context.auth.uid).get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) => {
         admin.firestore().collection('users').doc(element.id).update({
            points : firestore.FieldValue.increment(-200),
         })
      })
   })
});

exports.vouchersecond = functions.https.onCall((data, context) => {
   return admin.firestore().collection('users').where('uid', '==', context.auth.uid).get().then((querySnapshot) => {
      querySnapshot.docs.forEach((element) => {
         admin.firestore().collection('users').doc(element.id).update({
            points : firestore.FieldValue.increment(-50),
         })
      })
   })
});

// exports.points = functions.https.onRequest((req, res) => {
//    const final = admin.firestore().collection('games').get().then(snapshot => {
//       snapshot.forEach(doc => {
//          return admin.firestore().collection('games').doc(doc.id).update({
//             points : firestore.FieldValue.increment(10),
//          })
//       })
//    })
// });


// exports.update = functions.https.onCall((data, context) => {
//    const final = admin.firestore().collection('games').where('isComplete', '==', 'true').where('user', '==', context.auth.uid).get().then(snapshot => {
//       snapshot.forEach(doc => {
//          return admin.firestore().collection('games').doc(doc.id.toString()).update({
//             isComplete : 'false',
//          })
//       })
//    })
// });



// exports.addAdminRole = functions.https.onCall(async (data, context) => {
//     return admin.auth().getUserByProviderUid(data.uid);
// });

// exports.update = functions.https.onCall((data, context) => {
//   return admin.firestore().collection().doc().where('isComplete', "==", 'true').update({
//     isComplete: 'false',
//   })
// });

// exports.closeGame = functions.https.onCall((data, context) => {
//   return admin.firestore().collection('games').where("isComplete", "==", "true").doc().update({
//      isComplete: 'false',
//   })
//  });
