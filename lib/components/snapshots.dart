import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../models/entry.dart';
import '../models/cat.dart';
import '../models/model.dart';
import '../models/userdoc.dart';
import '../models/station.dart';

/// Contains common data used by various pages of the database.
/// Facilitates access to such data.
class Snapshots {
  static FirebaseHelper fh = FirebaseHelper();


  // Late instance variables 
  
  static final Stream<QuerySnapshot<Entry>> _entryStream = fh.getEntryStream();
  static final Stream<QuerySnapshot<Cat>> _catStream = fh.getCatStream();
  static final Stream<QuerySnapshot<Station>> _stationStream = fh.getStationStream();
  static final Stream<QuerySnapshot<UserDoc>> _userStream = fh.getUserStream();

  
  static final Future<List<QueryDocumentSnapshot<Station>>> _stationQuery = getStationQuery();
  static final Future<List<QueryDocumentSnapshot<Entry>>> _entryQuery = getEntryQuery();
  static final Future<List<QueryDocumentSnapshot<Cat>>> _catQuery = getCatQuery();
  static final Future<List<QueryDocumentSnapshot<UserDoc>>> _userQuery = getUserQuery();

  /// A Stream returning all entries. Dynamically updates.
  static Stream<QuerySnapshot<Entry>> get entryStream => _entryStream;
  /// A Stream returning all cats. Dynamically updates.
  static Stream<QuerySnapshot<Cat>> get catStream => _catStream;
  /// A Stream returning all stations. Dynamically updates.
  static Stream<QuerySnapshot<Station>> get stationStream => _stationStream;
  /// A Stream returning all users. Dynamically updates.
  static Stream<QuerySnapshot<UserDoc>> get userStream => _userStream;


  /// Returns a list of stations. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<Station>>>  get stationQuery => _stationQuery;
  /// Returns a list of entries. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<Entry>>>    get entryQuery => _entryQuery;
  /// Returns a list of cats. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<Cat>>>      get catQuery => _catQuery;
  /// Returns a list of users. Does not dynamically update.
  static Future<List<QueryDocumentSnapshot<UserDoc>>>  get userQuery => _userQuery;

  /// Returns all documents in the collection referenced by [ref].
  static Future<List<QueryDocumentSnapshot<T>>> _getQuery<T>(CollectionReference<T> ref) async {
    // bool isError = false;
    List<QueryDocumentSnapshot<T>> results = [];
    await ref.get().then(
      (snapshot) {
        results = snapshot.docs;
      },
      onError: (e) {
        print(e);
        // isError = true;
      }
    );
    return results;
  }
  
  /// Returns DocumentSnapshots for all Stations in the collection.
  static Future<List<QueryDocumentSnapshot<Station>>> getStationQuery() async {
    List<QueryDocumentSnapshot<Station>> listStations = [];
    await _getQuery(fh.stationsRef).then((value) => listStations = value);
    listStations.sort((a, b) {
      return a.id.compareTo(b.id);
    });
    return listStations;
  }

  /// Returns DocumentSnapshots for all Users in the collection.
  static Future<List<QueryDocumentSnapshot<UserDoc>>> getUserQuery() async {
    List<QueryDocumentSnapshot<UserDoc>> listUsers = [];
    await _getQuery(fh.usersRef).then((value) => listUsers = value);
    return listUsers;
  }

  /// Returns DocumentSnapshots for all Cats in the collection.
  static Future<List<QueryDocumentSnapshot<Cat>>> getCatQuery() async {
    List<QueryDocumentSnapshot<Cat>> listUsers = [];
    await _getQuery(fh.catsRef).then((value) => listUsers = value);
    return listUsers;
  }

  /// Returns DocumentSnapshots for all Entries in the collection.
  static Future<List<QueryDocumentSnapshot<Entry>>> getEntryQuery() async {
    List<QueryDocumentSnapshot<Entry>> listUsers = [];
    await _getQuery(fh.entriesRef).then((value) => listUsers = value);
    return listUsers;
  }

  // Methods

  /// Returns a QueryDocumentSnapshot with type [T], given a DocumentReference referring
  /// to a document in the collection modelled by [T]. Throws an exception if T is not
  /// Station, UserDoc, Entry or Cat.
  static Future<QueryDocumentSnapshot<T>> getDocument<T extends Model>(DocumentReference docRef) async {
    Future<List<QueryDocumentSnapshot<T>>> query;
    switch(T){
      case Station:
        query = _stationQuery as Future<List<QueryDocumentSnapshot<T>>>;
      case Cat:
        query = _catQuery as Future<List<QueryDocumentSnapshot<T>>>;
      case Entry:
        query = _entryQuery as Future<List<QueryDocumentSnapshot<T>>>;
      case UserDoc:
        query = _userQuery as Future<List<QueryDocumentSnapshot<T>>>;
      default:
        throw FormatException('DocumentReference is not in the right collection: ${docRef.parent.runtimeType}.'
        ' Please provide a DocumentReference in the Station, Cat, Users or Entry collections.');
    }
    List<QueryDocumentSnapshot<T>> docsList = await query;

    // TODO add checks for when docRef's document doesn't exist
    var desired = docsList.where((element) => element.reference.id == docRef.id).toList();
    assert (desired.length == 1);
    return desired[0];
  }

  /// Returns the DocumentSnapshot<UserDoc> of the user document referenced by the
  /// entry in [entrySnapshot]. The bool in the first part of the tuple
  /// is true if and only if such a user exists; i.e., if [entrySnapshot] both has
  /// a non-null assignedUser field and that user exists in the database.
  static Future<(bool, DocumentSnapshot<UserDoc>?)> getAssignedUser(QueryDocumentSnapshot<Entry> entrySnapshot) async {
    /// A tuple with a bool is used to allow this Future to return a non-null value
    /// even when the given Entry has no assignedUser. Otherwise, FutureBuilders using
    /// this function won't be able to differentiate waiting on this function from the
    /// function returning a null value.
    DocumentReference? userID = entrySnapshot.data().assignedUser;
    DocumentSnapshot<UserDoc>? toReturn;
    bool userExists = false;
    if(userID != null){
      var snap = await fh.usersRef.doc(userID.id).get();
      toReturn = snap;
      userExists = true;
    }
    assert (userExists == (toReturn != null));
    return (userExists, toReturn);
  }

  /// TEMPORARY FUNCTION.
  /// Returns whether there is a user logged in.
  static bool isUserLoggedIn() { return fh.isUserLoggedIn; }

  /// TEMPORARY FUNCTION.
  /// Returns the DocumentReference of the current HARD-CODED user.
  static Future<DocumentReference> getCurrentUserTEST() async {
    assert (isUserLoggedIn());
    String currentUserID = fh.currentUserIDTest!;
    return await fh.usersRef.doc(currentUserID);
  }

  /// Returns a timestamp with the same date as [stamp], with hours, minutes, seconds and
  /// milliseconds set to 0.
  static Timestamp equalizeTime(Timestamp stamp) {
    DateTime date = stamp.toDate();
    date = DateTime(date.year, date.month, date.day);
    return Timestamp.fromDate(date);
  }

  /// Returns a timestamp with the same date as [datetime], with hours, minutes, seconds and
  /// milliseconds set to 0.
  static DateTime equalizeDate(DateTime datetime) {
    return DateTime(datetime.year, datetime.month, datetime.day);
  }

  static Future<T> runTransaction<T>(
    Future<T> Function(Transaction) transactionHandler, 
    {Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5}
    ) async {
    return await fh.db.runTransaction(transactionHandler, timeout: timeout, maxAttempts: maxAttempts);
  }

  /// Converts [listOfLists] into a CSV file, which is then saved to the user's computer.
  static Future<void> saveCSV(List<List<dynamic>> listOfLists) async {
    String csv = const ListToCsvConverter().convert(listOfLists);
    String fileName = 'FeederScheduleSiteCSV';

    // From https://stackoverflow.com/questions/77030227/how-to-download-generated-csv-file-in-flutter-web
    Uint8List bytes = Uint8List.fromList(utf8.encode(csv));
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  /// Saves all entries in the database from [startDate] inclusive to [endDate] exclusive
  /// as a CSV, which is then saved to the user's computer.
  static Future<void> saveEntryCSVTimeframe(DateTime startDate, DateTime endDate) async {    
    List<List<dynamic>> listOfLists = [];
    listOfLists.add(
      [ "Date",         // Date of entry
        "Station",      // Station of entry
        "User",         // User assigned to entry. NULL for no user.
        "Affiliation",  // Affiliation of user. NULL for no user.
        ]
    );
    var entryQuery = fh.entriesRef
      .where(Entry.dateString, isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where(Entry.dateString, isLessThan: Timestamp.fromDate(endDate));
    await entryQuery.get().then( (querySnapshot) async {
      List<QueryDocumentSnapshot<Entry>> entrySnapshots = querySnapshot.docs;
      for (QueryDocumentSnapshot<Entry> entrySnapshot in entrySnapshots){
        
        Entry entry = entrySnapshot.data();

        // Check existence of user
        var assignedUser = await getAssignedUser(entrySnapshot);
        String userName;
        String userAffiliation;
        if(assignedUser.$1 && assignedUser.$2!.exists){ // assigned user exists
          var user = assignedUser.$2!.data()!;
          userName = user.getName();
          userAffiliation = user.affiliation == '' ? 'Not given' : user.affiliation ;
        } else { // no user assigned
          userName = "NULLUSER";
          userAffiliation = "N/A";
        }

        // entry
        // TODO what format should the date be in?
        List<dynamic> entryRow = [
          formatDashes.format(entry.date.toDate()),
          (await getDocument<Station>(entry.stationID)).data().name,
          userName,
          userAffiliation
        ];
        listOfLists.add(entryRow);
      }
    } );
    await saveCSV(listOfLists);
  }

  /// Returns the starting and ending dates of the academic year starting at [yearOne].
  /// startDate will be the first day of the academic year (inclusive), with 0 time, and endDate
  /// will be the first day of the following academic year (exclusive), with 0 time.
  static (DateTime startDate, DateTime endDate) academicYear(int yearOne) {
    DateTime startDate = DateTime(yearOne, DateTime.july, 1);
    DateTime endDate = DateTime(yearOne + 1, DateTime.july, 1);
    return (startDate, endDate);
  }

  /// Adds [entry] to the database.
  static void addEntry(Entry entry) async {
    // TODO perform uniqueness checks (date + stationID)
    fh.entriesRef.add(entry);
  }

  /// Ensure entries exist for at least [numDays] days after the current date.
  static Future<void> ensureEntriesPast({int numDays = 14}) async {
    // TODO account for added/deleted stations
    DateTime dateNow = equalizeDate(DateTime.now());
    DateTime dateThen = dateNow.add(const Duration(days: 14));

    // Obtain the date of the latest set of entries
    var allEntries = await getEntryQuery();
    allEntries.sort(
      (a, b) {
        return a.data().date.compareTo(b.data().date);
      });
    DateTime latestDate = equalizeTime(allEntries.last.data().date).toDate();

    // Ensure entries exist starting from that date up until dateNow + numDays
    int i = 1;
    DateTime nextDate = latestDate.add(Duration(days: i));
    var stations = await getStationQuery();
    while(!nextDate.isAfter(dateThen)){
      addEntriesForAll(stations, Timestamp.fromDate(nextDate));
      i++;
      nextDate = latestDate.add(Duration(days: i));
    }
  }

  /// Ensures that entries exist for [date] for each station by adding them if they don't exist.
  static void ensureEntries(DateTime date) async {
    // Remove milliseconds
    date = DateTime(date.year, date.month, date.day);
    Timestamp stamp = Timestamp.fromDate(date);
    runTransaction((transaction) async {
      // Get all stations
      bool isError = false;
      List<QueryDocumentSnapshot<Station>> stations = await getStationQuery();

      // Get entries with given date
      List<QueryDocumentSnapshot<Entry>> entries = [];
      entriesOnDateQuery(date).get().then(
        (querySnapshot) {
          entries = querySnapshot.docs;
        },
        onError: (e) {
          print(e);
          isError = true;
        },
      );

      // Check if there isn't an error
      if (!isError) {
        for (QueryDocumentSnapshot<Station> station in stations) {
          // Query returns entry with station and date
          List<QueryDocumentSnapshot<Entry>> statEntry = entries
              .where((element) => element.data().stationID.id == station.id)
              .toList();
          // Add entry if it doesn't exist
          if (statEntry.isEmpty) {
            Entry newEntry = Entry(
              assignedUser: null,
              date: stamp,
              note: '',
              stationID: station.reference,
            );
            DocumentReference<Entry> newDocRef = fh.entriesRef.doc();
            transaction.set(newDocRef, newEntry);
          }
        }
      }
    });
  }

  /// Adds a new entry for each station in [stations], all with Timestamp [stamp].
  static Future<void> addEntriesForAll(List<QueryDocumentSnapshot<Station>> stations, Timestamp stamp) async {
    await runTransaction(
      (transaction) async {
        for(var station in stations){
          Entry newEntry = Entry(
          assignedUser: null,
            date: stamp,
            note: '',
            stationID: station.reference,
          );
          DocumentReference<Entry> newDocRef = fh.entriesRef.doc();
          transaction.set(newDocRef, newEntry);
        }
      }
    );
  }



  /// Returns the results of querying the database for all entries on [date].
  static Future<List<QueryDocumentSnapshot<Entry>>> getEntries(DateTime date) async {
    ensureEntries(date);
    List<QueryDocumentSnapshot<Entry>> entries = [];
    await entriesOnDateQuery(date).get().then((querySnapshot) {
      entries = querySnapshot.docs.toList();
    });
    return entries;
  }

  /// Returns a query that queries the database for all entries on the given [date].
  static Query<Entry> entriesOnDateQuery(DateTime date) {
    DateTime nextDate = date.add(const Duration(days: 1));

    Timestamp stamp = Timestamp.fromDate(date);
    Timestamp nextStamp = Timestamp.fromDate(nextDate);
    return fh.entriesRef.where('date',
        isGreaterThanOrEqualTo: stamp, isLessThan: nextStamp);
  }

  // Modifying stations

  /// adds station to Station collection given a map of the station's characteristics
  static Future addStation(Station station) async {
    // Add station document
    DocumentReference<Station> newStationRef = await fh.stationsRef.add(station);
    // Add entries for the new station for the next two weeks
    DateTime now = equalizeDate(DateTime.now());
    for(int i = 0; i <= 14; i++){
      addEntry(Entry(
        assignedUser: null, 
        date: Timestamp.fromDate(now.add(Duration(days: i))), 
        note: '', 
        stationID: newStationRef));
    }
  }

  
  /// deletes station from Station collection given a doc reference to that station
  static Future deleteStation(String stationToDelete) async {
    // TODO remove future entries for new station
    return runTransaction(
      (transaction) async {
        DocumentReference stationRef = fh.stationsRef.doc(stationToDelete);
        // Deletion is done by setting the 'date deleted' param
        transaction.update(stationRef, {Station.dateDeletedString: Timestamp.now()});
      });
  }

}

