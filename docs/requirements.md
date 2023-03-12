# Requirements

## User Stories

As a student, I want to check the rating of a teacher in order to know whether I should choose them.

As a professor I want to check my ratings and comments so I can improve my teaching method.

As a student, I want to rate my professors so that I can help others choose their classes in the future.

As a student or a teacher, I want to easily find a teacher's profile, so can easily rate and see the ratings.

### Acceptance tests

#### User story 1 (student checks ratings and comments about a teacher)

Feature: A teacher checks the ratings and the comments about them

    Scenario: User checks a teacher's rating and comments left by students
        When the teacher opens a teacher's page in the app
        Then an average general score is presented (based on previous ratings), as well as averages in specific parameters.

#### User story 2 (teacher checks ratings and comments about them)

Feature: A teacher checks the ratings and the comments about them

    Scenario: User checks a teacher's rating and comments left by students
        When the teacher opens a teacher's page in the app
        Then an average general score is presented (based on previous ratings), as well as averages in specific parameters.

#### User story 3 (rate a teacher)

Feature: Rate a teacher

    Scenario: User rates a teacher
        When the user rates a teacher by filling the rating form
        Then the teacher's page on the app is updated and includes the new rating and the teacher's points can change.


#### User story 4 (find teacher's profile)

Feature: Search for teacher

    Scenario: User writes the teacher's name on the search bar
        When the user writes the teacher's name on the search bar and presses 'Search'
        Then a list of teachers with a compatible name is shown

## Domain Model

The TeachMeWell application allows Students to rate and view Professors' ratings. Each rating is described by a value between 1-5 and a comment,
describing the professors. Each student belongs to one or more faculties and is enrolled in one or more courses which can be taught by one or more 
faculties and has its own subjects that are taught by one or more professors. A professor is described by their acronym, name and Department. 
A student is described by their student number and name. Each faculty, course and subject has their own acronym/code and name.

![Domain Model](../images/Domain%20Model.png)

## UI Mockups

![UI Mockup 1](../images/Mockup%201.png)
![UI Mockup 2](../images/Mockup%202.png)
![UI Mockup 3](../images/Mockup%203.png)
![UI Mockup 4](../images/Mockup%204.png)
![UI Mockup 5](../images/Mockup%205.png)
![UI Mockup 6](../images/Mockup%206.png)
![UI Mockup 7]()
