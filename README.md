# Cat Partners Feeding Website
## About Cat Partners
Cat Partners of Southwestern University (CPSU) is an official SU student organization advised by Kelly Lessard.  CPSU is charged with taking care of the feral cat colonies on campus and has the following responsibilities:
- Feeding all the cats year-round.
- Trapping cats.
- Providing veterinary care (vaccinations, spay/neuter).
- Finding homes for kittens and returning strays to their owners.
For additional information, please visit the Cat Partners page on the SU website [here](https://www.southwestern.edu/life-at-southwestern/student-organizations/special-interest/cat-partners/)
## Previous Feeding Sign-up Solution
CPSU was previously using a Google Sheet that was accessible to anyone with the link.  Users would select a cell in the spreadsheet corresponding to a date and a feeding station.  Each row for a given date had an extra column where users could leave notes or observations after they fed the cats.  The spreadsheet posed several limitations including:
- Users could alter other users' entries (since everyone with the link had edit permissions).
- The spreadsheet only had one notes section per date, rather than per date _and_ feeding station.  This resulted in difficulty in understanding which notes corresponded to which station/person that fed the cats.
- End-of-year student hour calculations must be done manually.  These calculations are needed by Kelly Lessard to report to administration and are required by student organizations.
- Contact information was not readily available to Kelly Lessard and CPSU officers.
# Spring 2024 Computer Science Capstone Project
Our team (Jayden Beauchea, Marlon Mata, Yunhyeong "Daniel" Na, and Anna Wicker) worked to create a solution that builds on the previous Google Spreadsheet and diffuses the limitations listed above.  We started building this project in January of 2024 from scratch with guidance from our professor, Dr. Barabara Anthony.
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
A demo video of the home page can be found [here](https://drive.google.com/file/d/1Vrchu2FBnlDcOtnVIyn3liiXb1Lvodsm/view?usp=drive_link)
### About Page
The about page provides an overview of the website and a user's manual at the bottom of the page.  At the top, users can see a brief overview explaining what CPSU is, the creators and contributers to the website, and a small photo gallery of the cats.
### Admin Page
### Sign Up to Feed Page
### Account Page




