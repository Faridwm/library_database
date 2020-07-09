### 1. Motives & background.

This Script is created because I want to learn the database from the start table creation, then continue using triggers, store procedure, functions and events.
    
### 2. Project Duration

The time required to complete until this stage takes about 2-3 weeks

### 3. Entity Relational Diagram


### 4. Metadata
  #### a. Tables
  1) member_jobs
  
      Table that contains information about the list of various jobs from members.
  
      ##### Columns
      | Columns | Data Type | Length | Not Null | Default | Description |
      | --- | --- | --- | --- | --- | --- |
      | id | int | 10 | yes | - | primary key for member jobs record |
      | job_name | varchar | 100 | yes | - | job name, for example: Student, Teacher, etc |
      | job_dec | varchar | 255 | yes | - | description for job_name |

      ##### Constraint
      | Contraint Type | Contraint Name | Contraint Keys | Description |
      | --- | --- | --- | --- |
      | Primary Key | Primary | id | Primary key with value from mbr_jobs_id() |
      | Unique Key | member_jobs_un_name | job_name | to make sure there are no job_name that have the same name |
      
      ##### Indexes
      | Name | Index Type | Unique | Description |
      | --- | --- | --- | --- |
      | PRIMARY | BTree | yes | index created by a primary key constraint |
      | member_jobs_un_name | BTree | yes | index there are no job_name that have the same name |
      
      ##### Triggers
      Table does not have triggers
         
  2) members
  
      Table containing information about the list of library members
  
      ##### Columns
      | Columns        | Data Type    | Length | Not Null | Default                                 | Description                                                               |
      |----------------|--------------|--------|----------|-----------------------------------------|---------------------------------------------------------------------------|
      | id             | int unsigned | 10     | yes      | -                                       | primary key for members record                                            |
      | email          | varchar      | 50     | yes      | -                                       | member's email                                                            |
      | first_name     | varchar      | 20     | yes      | -                                       | member's first name or nickname                                           |
      | last_name      | varchar      | 30     | yes      | -                                       | member's surname                                                          |
      | gender         | enum(M, F)   | 1      | yes      | -                                       | member's gender, M = Male, F = Female                                     |
      | phone          | varchar      | 20     | no       | -                                       | member's phone number or home number                                      |
      | birthday_date  | date         | -      | yes      | -                                       | member's birthday date                                                    |
      | address        | varchar      | 255    | yes      | -                                       | member's address                                                          |
      | job            | int unsigned | 10     | yes      | -                                       | member's job based on id of the table member_jobs                         |
      | created_member | date         | -      | yes      | current_timestamp()                     | date member record created                                                |
      | expired_member | date         | -      | yes      | (current_timestamp() + interval 5 year) | date member expires, 5 years after the record created and can be extended |
      | status         | tinyint      | 3      | yes      | 1                                       | member status, 1 = active, 0 = expired                                    |

      ##### Constraint
      | Constraint Type | Constraint Name  | Constraint Keys | Description                                                    |
      |-----------------|------------------|-----------------|----------------------------------------------------------------|
      | Primary Key     | PRIMARY          | id              | primary key with value from mbr_id()                           |
      | Unique Key      | members_un_email | email           | unique index. to identify member emails already used only once |
      | Unique Key      | members_un_phone | phone           | unique phone number for every member                           |
      
      ##### Indexes
      | Name             | Index Type | Unique | Description                                                                                   |
      |------------------|------------|--------|-----------------------------------------------------------------------------------------------|
      | PRIMARY          | BTree      | yes    | index cretated by a primary constraint                                                        |
      | member_fk_job    | BTree      | no     | index has referencing job field on the members table to the field id on the table member_jobs |
      | members_un_email | BTree      | yes    | index for the unique value of an email, and the email can only be used once.                  |
      | members_un_phone | BTree      | yes    | index for the unique member's phone number                                                    |
      
      ##### Triggers
      Table does not have triggers
  
  3) employees_positions
 
      ##### Columns
      | Columns       | Data Type    | Length | Not Null | Default | Description                                      |
      |---------------|--------------|--------|----------|---------|--------------------------------------------------|
      | id            | int unsigned | 10     | yes      | -       | primary key for employees_positions record       |
      | position_name | varchar      | 200    | yes      | -       | position name                                    |
      | position_desc | varchar      | 20     | yes      | -       | job description based on the field position_name |
      
      ##### Constraints
      | Constraint Type | Constraint Name             | Constraint Keys | Description                                                 |
      |-----------------|-----------------------------|-----------------|-------------------------------------------------------------|
      | Primary Key     | PRIMARY                     | id              | primary key with value from emp_position_id()               |
      | Unique Key      | employees_positions_un_name | position_name   | to make sure there are no positions that have the same name 
      
      ##### Indexes
      | Name                        | Index Type | Unique | Description                                                       |
      |-----------------------------|------------|--------|-------------------------------------------------------------------|
      | PRIMARY                     | BTree      | yes    | index cretated by a primary constraint                            |
      | employees_positions_un_name | BTree      | yes    | index there are no positions that have the same name |
      
      ##### Triggers
      Table does not have triggers
      
  4) employees
  
      Table containing information about the employee in the library
      
      ##### Columns
      | Columns       | Data Type    | Length | Not Null | Default             | Description                                                    |
      |---------------|--------------|--------|----------|---------------------|----------------------------------------------------------------|
      | id            | int unsigned | 10     | yes      | -                   | primary key for employees record                               |
      | first_name    | varchar      | 20     | yes      | -                   | employee's first name or nickname                              |
      | last_name     | varchar      | 30     | yes      | -                   | employee's surname                                             |
      | gender        | enum(M, F)   | 1      | yes      | -                   | employee's gender, M = Male, F = Female                        |
      | birthday_date | date         | -      | yes      | -                   | employee's birthday date                                       |
      | position      | int unsigned | 10     | yes      | -                   | employee position based on id of the table employees_positions |
      | phone         | varchar      | 20     | yes      | -                   | employee's phone number                                        |
      | address       | varchar      | 255    | yes      | -                   | employee's address                                             |
      | hire_date     | date         | -      | yes      | -                   | date employee hired                                            |
      | created_at    | date         | -      | yes      | current_timestamp() | date employee record created                                   |
      | status        | tinyint      | 3      | yes      | 1                   | employee status, 1 = active, 0 = not active                    |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys | Description                          |
      |-----------------|-----------------|-----------------|--------------------------------------|
      | Primary Key     | PRIMARY         | id              | primary key with value from emp_id() |
      
      ##### Indexes
      | Name                  | Index Type | Unique | Description                                                                                                   |
      |-----------------------|------------|--------|---------------------------------------------------------------------------------------------------------------|
      | PRIMARY               | BTree      | yes    | index cretated by a primary constraint                                                                        |
      | employees_fk_position | BTree      | no     | index has referencing position field on the employees table to the field id on the table employeees_positions |
      
      ##### Triggers
      Table does not have triggers
    
  5) publishers
  
      ##### Columns
      | Columns     | Data Type    | Length | Not Null | Default | Description                              |
      |-------------|--------------|--------|----------|---------|------------------------------------------|
      | id          | int unsigned | 10     | yes      | -       | primary key for publishers record        |
      | pub_name    | varchar      | 200    | yes      | -       | publisher name or publisher company name |
      | pub_phone   | varchar      | 20     | yes      | -       | publisher phone number or fax number     |
      | pub_city    | varchar      | 100    | yes      | -       | publisher's hometown                     |
      | pub_address | varchar      | 255    | yes      | -       | publisher address                        |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys | Description                                |
      |-----------------|-----------------|-----------------|--------------------------------------------|
      | Primary Key     | PRIMARY         | id              | primary key with value from publisher_id() |
      
      ##### Indexes
      | Name    | Index Type | Unique | Description                            |
      |---------|------------|--------|----------------------------------------|
      | PRIMARY | BTree      | yes    | index cretated by a primary constraint |
      
      ##### Triggers
      Table does not have triggers
  
  6) authors
  
 
      ##### Columns
      | Columns       | Data Type    | Length | Not Null | Default | Description                         |
      |---------------|--------------|--------|----------|---------|-------------------------------------|
      | id            | int unsigned | 10     | yes      | -       | primary key for authors record      |
      | first_name    | varchar      | 20     | yes      | -       | author first name or nickname       |
      | last_name     | varchar      | 30     | yes      | -       | author surname                      |
      | gender        | enum(M, F)   | 1      | yes      | -       | author gender, M = Male, F = Female |
      | birthday_date | date         | -      | yes      | -       | author birthday date                |
      | phone         | varchar      | 20     | yes      | -       | author phone number                 |
      | address       | varchar      | 255    | yes      | -       | author address                      |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys | Description                             |
      |-----------------|-----------------|-----------------|-----------------------------------------|
      | Primary Key     | PRIMARY         | id              | primary key with value from author_id() |
      
      ##### Indexes
      | Name    | Index Type | Unique | Description                            |
      |---------|------------|--------|----------------------------------------|
      | PRIMARY | BTree      | yes    | index cretated by a primary constraint |
      
      ##### Triggers
      Table does not have triggers
      
  7) categories_books
  8) books
  9) books_authors
  10) loans
  11) books_loan
  
  #### b. Store Procedures
  #### c. Functions
  #### d. Events

### 5. Statistics
