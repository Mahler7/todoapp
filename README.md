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


User