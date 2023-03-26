# Requirements

## User Stories

As a student or a professor, I want to easily find a professors' profile, so I can see their ratings. (Mockups 3, 4 and 5)

As a student, I want to rate my professors so that I can help others choose their classes in the future. (Mockup 6)

As a professor I want to check my ratings and comments so I can improve my teaching method. (Mockup 7)

As a student, I want to check the rating of a professor in order to know whether I should choose them. (Mockups 3 and 7)


### Acceptance tests

#### User story 1 (student checks ratings and comments about a professor)

Feature: A student checks the ratings and comments about a professor

    Scenario: User checks a professor's rating and comments left by students
    Given that he has successfully logged in with his SIGARRA credentials
    When the student opens a professor's page in the app
    Then an average general score is presented (based on previous ratings), as well as averages in specific parameters.
    

#### User story 2 (professor checks ratings and comments about them)

Feature: A professor checks the ratings and the comments about them

    Scenario: User checks a professor's rating and comments left by students
    Given that they are not logged in but signed in as guests
    When the professor opens a professor's page in the app
    Then an average general score is presented (based on previous ratings), as well as averages in specific parameters.

#### User story 3 (rate a professor)

Feature: Rate a professor

    Scenario: User rates a professor
    Given that the professor he’s trying to rate has been his professor
    When the user rates a professor by filling the rating form
    Then the professor's page on the app is updated and includes the new rating and the professor's points can change.
    
    Scenario: User can't rate the professors
    Given that he hasn't logged in
    When he inputs the wrong credentials
    Then the app will ask for the login information again and will not allow me to write a review until I login successfully

#### User story 4 (find professor's profile)

Feature: Search for professor

    Scenario: User writes the professor's name on the search bar
    Given he has accessed the search menu after logging in
    When the user writes the professor's name on the search bar and presses 'Search'
    Then a list of professors with a compatible name is shown

## Domain Model

The TeachMeWell application allows Students to rate and view Professors' ratings. Each rating is described by a value between 1-5 and a comment,
describing the professors. Each student belongs to one or more faculties and is enrolled in one or more courses which can be taught by one or more 
faculties and has its own subjects that are taught by one or more professors. A professor is described by their acronym, name and Department. 
A student is described by their student number and name. Each faculty, course and subject has their own acronym/code and name.

![Domain Model](../images/Domain%20Model.jpg)

## UI Mockups

![UI Mockup 1](../images/Mockup%201.png)
![UI Mockup 2](../images/Mockup%202.png)
![UI Mockup 3](../images/Mockup%203.png)
![UI Mockup 4](../images/Mockup%204.png)
![UI Mockup 5](../images/Mockup%205.png)
![UI Mockup 6](../images/Mockup%206.png)
![UI Mockup 7](../images/Mockup%207.png)
