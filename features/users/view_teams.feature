Feature: view teams
  As a student,
  I want to see a list of teams that can be joined (not full).
  So that I know which teams I am allowed to join.

  Background:
    Given the following users exist
     | name  |       email                    |team_passcode | major           | sid  | skill      |
     | Sahai | eecs666@hotmail.com            | penguindrool | EECS            | 000  | JavaScript |
     | Jorge | legueoflegends667@hotmail.com  | penguindrool | Football Player | 999  | Backend    |
     | Kandi | justanotheremail@aol.com       | anotherteam  | EECS            | 567  | CSS        |

  Scenario: A user is looking for a team
    Given I am on the home page
    Given I log in as a user with email "justanotheremail@aol.com"
    And I am on the team list page
    And I should see "2"
    And I should see "JavaScript, Backend"
