// Stations + cats
final List<int> testStationIDs = [0, 1, 2];
final Map<int, Map<String, dynamic>> testStationData = {
  0: {
    'name': 'Caskey Lords',
    'cats': ['Patches', 'Super Cal', 'Ziggy']
  },
  1: {
    'name': 'Mabee',
    'cats': ['Pumpkin', 'Princess']
  },
  2: {
    'name': 'Admissions',
    'cats': ['Gray Mama', 'Itty Bitty', 'Gaia', 'Teddy']
  },
};

// TODO REPLACE with call to DB
final List<String> listOfStations = ['Caskey', 'Mabee', 'Admin'];

// Placeholder variables
const String feedIDString = 'feederID';
const String noteIDString = 'notes';
const String sightingsIDString = 'sightings';
final List<Map<String, dynamic>> testData = [
      {
        'date': DateTime.utc(2024, 1, 1), 
        'data': [
          {feedIDString: 'Joe Schmoe',
           noteIDString: 'Saw Super Cal yelling at me',
           sightingsIDString: [true, true, false],
          },
          
          {feedIDString: 'Joe Schmoe',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Argus',
           noteIDString: '',
           sightingsIDString: [false, false, false, false],
          },
        ]
      },
      {
        'date': DateTime.utc(2024, 1, 2), 
        'data': [
          {feedIDString: 'Mary Sue',
           noteIDString: 'No one around :(',
           sightingsIDString: [false, false, false],
          },
          
          {feedIDString: 'Just Joe',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Tori Vanderbucks',
           noteIDString: 'Saw a silly little guy',
           sightingsIDString: [false, true, false, false],
          },
        ]
      },
      {
        'date': DateTime.utc(2024, 1, 3), 
        'data': [
          {feedIDString: 'Smorgus Borde',
           noteIDString: 'woah!!!1!!',
           sightingsIDString: [true, false, false],
          },
          
          {feedIDString: 'Smorgus Borde',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Smorgus Borde',
           noteIDString: '',
           sightingsIDString: [false, true, false, true],
          },
        ]
      },
      {
        'date': DateTime.utc(2024, 1, 4), 
        'data': [
          {feedIDString: null,
           noteIDString: '',
           sightingsIDString: [false, false, false],
          },
          
          {feedIDString: 'Felid Day',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Felid Day',
           noteIDString: '',
           sightingsIDString: [false, false, false, false],
          },
        ]
      },
    ];