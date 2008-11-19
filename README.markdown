Annotrack
=======
Annotrack generates a report for all of the accepted Pivotal Tracker stories that a user worked on for a given day.

Usage
-----
    $ annotrack --username sandro --project 123
    ACCEPTED: Users can view other user's profiles (263028). 
    ACCEPTED: Guests cannot view user's profiles (263029). 

Use --help for more information:

    $ annotrack --help

TODO
------------
 - support for more story statuses such as 'started' and 'delivered' (dependent on a tracker API update)
 - optionally integrate with the git commits for the project

