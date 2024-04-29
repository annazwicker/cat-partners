# Cat Partners Feeding Website
## About Cat Partners
Cat Partners of Southwestern University (CPSU) is an official SU student organization advised by Kelly Lessard.  CPSU is charged with taking care of the feral cat colonies on campus and has the following responsibilities:
- Feeding all the cats year-round.
- Trapping cats.
- Providing veterinary care (vaccinations, spay/neuter).
- Finding homes for kittens and returning strays to their owners.
For additional information, please visit the Cat Partners page on the SU website [here](https://www.southwestern.edu/life-at-southwestern/student-organizations/special-interest/cat-partners/).

## Previous Feeding Sign-up Solution
CPSU was previously using a Google Sheet that was accessible to anyone with the link.  Users would select a cell in the spreadsheet corresponding to a date and a feeding station.  Each row for a given date had an extra column where users could leave notes or observations after they fed the cats.  The spreadsheet posed several limitations including:
- Users could alter other users' entries (since everyone with the link had edit permissions).
- The spreadsheet only had one notes section per date, rather than per date _and_ feeding station.  This resulted in difficulty in understanding which notes corresponded to which station/person that fed the cats.
- End-of-year student hour calculations must be done manually.  These calculations are needed by Kelly Lessard to report to administration and are required by student organizations.
- Contact information was not readily available to Kelly Lessard and CPSU officers.

# Spring 2024 Computer Science Capstone Project
We started building this project in January of 2024 from scratch with guidance from our professor, Dr. Barabara Anthony.  Our team (Jayden Beauchea, Marlon Mata, Yunhyeong "Daniel" Na, and Anna Wicker) worked to create a solution that builds on the previous Google Spreadsheet and diffuses the limitations listed above.  The main required features were to create a feeding schedule that allows users to sign up to feed, accounts to prevent users from altering entries other than their own, and adding additional privileges for Kelly and the CPSU officers.

## Tech Stack 
Our project made use of the following software:
- Flutter (Google's UI toolkit) to develop a website custom to Cat Partners.  
- Firebase in order to allow for Google Sign In through the Google API.
- Firestore for storing information in a NoSQL document-based database.
- GitHub for version control.
- Figma to create initial designs for our website.

## Features and Pages on the Website
### Signing Into the Website
Users must sign in with a Google Account, though this does not have to be an SU gmail account.  Clicking on the sign-in button initiates Firebase Authorization and awaits for Google sign-in.  After the sign-in information is authorized, the user will be redirected to the home page.

### Home Page
The home page is the default page users will be directed to upon logging in.  As of May 2024, this page contains three main features:
- A notification box displaying the stations for the current day and following day that don't have anyone signed up to feed.
- A box displaying the total number of times the user has signed up to feed the cats.  We hope that this box will give users a sense of accomplishment and will encourage them to continue to volunteer.
- A calendar that displays the next two weeks of entries the user has signed up for.

A demo video of the home page can be found [here](https://drive.google.com/file/d/1Vrchu2FBnlDcOtnVIyn3liiXb1Lvodsm/view?usp=sharing).

### About Page
The about page provides an overview of the website and a user's manual at the bottom of the page.  At the top, users can see a brief overview explaining what CPSU is, a link to the CPSU page on the official SU website, the creators and contributers to the website, and a small photo gallery of the cats.  The user's manual at the bottom of the page contains a set of nested tabs, with a tab for each page in the website.  Each tab contains information for that page, specifically defining the features available and how to make use of those features.  

A demo video of the about page can be found [here](https://drive.google.com/file/d/1NEbtWCFAfSJkU7IY6m7DZAmby0SNmmLn/view?usp=sharing).

### Admin Page
The admin page is specifically for users who have admin permissions.  It allows for the website to be flexible to any changes that the campus cats/feeding stations may undergo, as well as other capabilities admin users might need.  Below is a list of all of those features:

- Edit a user's SU affiliation (with the options being student, staff, faculty, alumni, and parent of student) by entering the desired user's email and selecting the new status from a dropdown box.
- Delete a user's account by entering their email.
- Grant admin permissions to a user by entering their email.
- Revoke admin permissions by selecting an existing user from a dropdown box.
- Add a new cat by entering the cat's name, details about the cat, and selecting the feeding station it's located at.
- Deleting a cat by selecting from an existing cat from a dropdown box.
- Add a feeding station by entering the name.
- Delete a feeding station by selecting an existing station from a dropdown box.
- Search for a user by entering their email.
- Export data as a CSV file by selecting a yearlong range from a dropdown box.

A demo video of the admin page can be found [here](https://drive.google.com/file/d/1z5ZmxNhxAfLXjHhymFgovI_GY0cn0Trd/view?usp=sharing).

### Sign Up to Feed Page
The sign up to feed page contains the feeding schedule where users can sign up to feed the cats.  The table displays entries in the past and present by date and station, as well as the name of the user signed up for a given entry, if there is one.  Users can view and interact with entries by clicking them on the table, which displays the entry's information on a sidebar to the right.  The information displayed includes the entry's date, station, notes and assigned user.  

Users can add entries by selecting multiple at a time.  The entries they select will be displayed on the sidebar with the date and station.  Clicking the confirm button will lock in the user's selection.  Users can edit the notes of their own entries, but not those of other users.  A user may also only unassign themselves from entries, and cannot unassign others unless they're an admin.

A demo video of the sign up to feed page can be found [here](https://drive.google.com/file/d/1vHcPDvv1DWjwpt9RHrnMLyubZWwqWtqb/view?usp=sharing).

### Account Page
The account page stores basic information about every user including first and last name, email, phone number, affiliation with SU, and rescue group affiliation.  This information is collected in case admin users need to reach a user regarding CPSU.  All information on this page is able to be changed by the user, but if the user changes their email, their login will also change since user accounts are tied to gmail accounts.  When the user clicks the save button at the bottom of the list of information, a pop up box will provide a warning that changing the email field will change will result in their login changing.  User's are also able to sign out of the website by clicking the sign out button at the bottom of the page.

A screenshot of the account page can be found [here](https://drive.google.com/file/d/1H_mTCkjJ2S8qaDd7g_gTVacoel3pGrGq/view?usp=sharing).


***The most up-to-date code is on the 'restored-commit' branch.***
