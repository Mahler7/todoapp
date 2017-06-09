Models

Todo
-valid
-name should be present
-description should be present
-todo without user should be invalid

User
-valid
-name should be present
-name should be less than 30 characters
-email should be present
-email should be less than 255 characters
-email should be unique
-email should have correct format
-email without correct format are rejected
-email should be lowercase before hitting db
*-password should be present
*-password should have 8 characters
*-associated todos should be destroyed

Controllers

Todo
-index
  -get todos index
  -hits controller
  -todo names should be links
-show
  -get show page
  -hits controller
  -match todo names, description, and user
  -edit, delete, and back links
-new
  -get new page
  -hits controller
  -add new name, description, 
  -check count is greater by 1
  -check redirect is to show
  -check flash is not empty
  -check new name, description match response.body
-new errors
  -get new page
  -hits controller
  -add invalid data
  -check count is the same
  -check redirect is to new
  -check for error message html classes
-edit
  -get edit page
  -hits controller
  -update name, description
  -check redirect is to show
  -check flash is not empty
  -check updated name, description match instance
-edit errors
  -get edit page
  -hits controller
  -add invalid data
  -check count is the same
  -check redirect is to edit
  -check for error message html classes
-delete
  -get show route
  -hits controller show
  -show has delete link, route,  with text
  -check db count is -1
  -redirect to todos
  -make sure flash is there


User
-index
  -should get index page
  -hit index controller
  -match route for link to user show page
-signup
  -get signup path
  -hit new controller
  -assert count in db is +1
  -redirect to show
  -hit show controller
  -check flash
-signup errors
  -get signup path
  -hit new controller
  -assert in db stays the same
  -hit new controller
  -assert matches for error partial
-show
  -get show route
  -hit show controller
  -assert todo names are links with matching text
  -assert todo descriptions match descriptions
-edit
  -get edit route
  -hit edit controller
  -patch request
  -redirect to show
  -check flash
  -reload user
  -match user name and email
-edit errors
  -get edit route
  -hit edit controller
  -patch request
  -redirect to edit
  -assert matches for error partial
-admin edit
  -get edit route
  -hit edit controller
  -patch request
  -redirect to show
  -check flash
  -reload user
  -match user name and email
-admin edit errors
  -get edit route
  -hit edit controller
  -patch request
  -redirect to index
  -check flash
  -reload user
  -check for patch matches original
-delete
  -get user path
  -hit index controller
  -check for difference in db -1
  -redirect to index
  -check flash