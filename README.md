## Instructions

This is the code I used to complete the CKM Data Science Exercise. In these folders are two small apps: a Rails API containing the database with SQL queries and the frontend which is a small React app with Chart.js and Semantic UI to display the data.

To run this code:
1. Download
2. Navigate to directory with your terminal
3. Navigate into the api folder
4. Run ```bundle``` and ```rake db:migrate```
5. Return to main directory
6. Navigate into the frontend folder
7. Run ```yarn install```

Great, now you are ready to query the database and generate the chart and tables I used to complete the exercise

To query the database:
1. Make sure you're in the api folder
2. Run ```rails c``` to enter the console.
3. All relevant queries can be ran with the Log class.

Queries can be found in the ```api/app/models``` folder

To generate the chart and tables:
1. Navigate to the api folder and run ```rails s``` to start the server
2. Navigate to the frontend folder
3. Run ```yarn start```

The graphics will take a moment to load due to the numerous queries against the database.

The graph is built with Chart.js and the tables with Semantic UI

Please don't hesitate to reach out if anything is unclear: alexanderf.gutterman@gmail.com
