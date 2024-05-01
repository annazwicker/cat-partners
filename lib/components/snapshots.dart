import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_application_1/components/user_google.dart';
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

  /// Retrieves the UserDoc of the user that's currently signed in.
  /// If an Exception occurs during retrieval (perhaps due to the userDoc not existing,
  /// or there being no user signed in), returns null.
  static Future<(bool, DocumentSnapshot<Map<String, dynamic>>?)> getCurrentUserDoc() async {
    try {
      var userDocRef = await UserGoogle.getUserDoc();
      return (true, userDocRef);
    } on Exception catch (e) {
      print(e);
      return (false, null);
    }
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
    var entryQuery = entriesFromToQuery(startDate, endDate );
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

  /// Ensure entries exist, as appropriate, for all stations at least [numDays] days after the current date.
  static Future<void> ensureEntriesPast({int numDays = 14}) async {
    DateTime dateNow = equalizeDate(DateTime.now());
    DateTime dateThen = dateNow.add(Duration(days: numDays));
    var stations = await getStationQuery();
    for(var station in stations){
      await ensureStationEntries(station, dateThen);
    }
  }

  /// Ensures entries are generated for [station] up to and including the date [until] or the date of
  /// the station's deletion, if applicable; whichever is sooner.
  /// 
  static Future<void> ensureStationEntries(DocumentSnapshot<Station> station, DateTime until) async {
    Station stationModel = station.data()!;
    // Query DB for all entries for given station
    var entriesForStationQuery = fh.entriesRef.where(Entry.stationRefString, isEqualTo: station.reference);
    // Get results
    var allEntries = (await entriesForStationQuery.get()).docs;
    
    // Figure out date to start generating entries
    DateTime from;
    if(allEntries.isNotEmpty){
      // If entries already exist, start at latest entry
      allEntries.sort(
        (a, b) {
          return a.data().date.compareTo(b.data().date);
        });
      // Gets time of latest entry and goes one day after
      from = equalizeTime(allEntries.last.data().date).toDate().add(const Duration(days: 1));
    } else {
      // If no entries exist, start at station creation date
      from = stationModel.dateCreated.toDate();
    }

    // Find date to stop generating entries
    // Cut off at station deletion date, if station was ever deleted
    if(stationModel.dateDeleted != null){
      DateTime deletedEqualize = equalizeTime(stationModel.dateDeleted!).toDate();
      until = until.isAfter(deletedEqualize) ? deletedEqualize : until;
    } 

    // Iterate through times
    int i = 0;
    DateTime nextDate = from;
    while(!nextDate.isAfter(until)){
      // Transaction initializes single entry
      // MUST await; otherwise 'i' won't update as it should.
      await runTransaction((transaction) async {
        Entry newEntry = Entry(
          assignedUser: null,
          date: Timestamp.fromDate(nextDate),
          note: '',
          stationID: station.reference,
        );
        DocumentReference<Entry> newDocRef = fh.entriesRef.doc();
        transaction.set(newDocRef, newEntry);
      });
      i++;
      nextDate = from.add(Duration(days: i));
    }

  }

  /// Returns the results of querying the database for all entries on [date].
  static Future<List<QueryDocumentSnapshot<Entry>>> getEntriesOnDate(DateTime date) async {
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

  /// Retrieves a query that obtains all entries from [startDate] to [endDate] exclusive.
  static Query<Entry> entriesFromToQuery(DateTime startDate, DateTime endDate){
    return fh.entriesRef
      .where(Entry.dateString, isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where(Entry.dateString, isLessThan: Timestamp.fromDate(endDate));
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

