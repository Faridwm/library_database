### 1. Motives & background.

This Script is created because I want to learn the database from the start table creation, then continue using triggers, store procedure, functions and events.
    
### 2. Project Duration

The time required to complete until this stage takes about 2-3 weeks

### 3. Entity Relational Diagram


### 4. Metadata, Store Procedures, Functions, and Events
  #### a. Tables
  1) member_jobs
  
      Table that contains information about the list of various jobs from members.
  
      ##### Columns
      | Columns  | Data Type    | Length | Not Null | Default | Description                                  |
      |----------|--------------|--------|----------|---------|----------------------------------------------|
      | id       | int unsigned | 10     | yes      | -       | primary key for member jobs record           |
      | job_name | varchar      | 100    | yes      | -       | job name, for example: Student, Teacher, etc |
      | job_dec  | varchar      | 255    | yes      | -       | description for job_name                     |

      ##### Constraint
      | Contraint Type | Contraint Name      | Contraint Keys | Description                                                |
      |----------------|---------------------|----------------|------------------------------------------------------------|
      | Primary Key    | Primary             | id             | Primary key with value from mbr_jobs_id()                  |
      | Unique Key     | member_jobs_un_name | job_name       | to make sure there are no job_name that have the same name |
      
      ##### Indexes
      | Name                | Index Type | Unique | Description                                         |
      |---------------------|------------|--------|-----------------------------------------------------|
      | PRIMARY             | BTree      | yes    | index created by a primary key constraint           |
      | member_jobs_un_name | BTree      | yes    | index there are no job_name that have the same name |
      
      ##### Triggers
      Table does not have triggers
         
  2) members
  
      Table containing information about the list of library members
  
      ##### Columns
      | Columns        | Data Type    | Length | Not Null | Default                                 | Description                                                               |
      |----------------|--------------|--------|----------|-----------------------------------------|---------------------------------------------------------------------------|
      | id             | int unsigned | 10     | yes      | -                                       | primary key for members record                                            |
      | email          | varchar      | 50     | yes      | -                                       | member email                                                            |
      | first_name     | varchar      | 20     | yes      | -                                       | member first name or nickname                                           |
      | last_name      | varchar      | 30     | yes      | -                                       | member surname                                                          |
      | gender         | enum(M, F)   | 1      | yes      | -                                       | member gender, M = Male, F = Female                                     |
      | phone          | varchar      | 20     | no       | -                                       | member phone number or home number                                      |
      | birthday_date  | date         | -      | yes      | -                                       | member birthday date                                                    |
      | address        | varchar      | 255    | yes      | -                                       | member address                                                          |
      | job            | int unsigned | 10     | yes      | -                                       | member job based on id of the table member_jobs                         |
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
      
      This table contains information about the position of employees in libraries, such as library heads, librarians, administrative officers, etc.
      
      ##### Columns
      | Columns       | Data Type    | Length | Not Null | Default | Description                                      |
      |---------------|--------------|--------|----------|---------|--------------------------------------------------|
      | id            | int unsigned | 10     | yes      | -       | primary key for employees_positions record       |
      | position_name | varchar      | 100    | yes      | -       | position name                                    |
      | position_desc | varchar      | 255    | yes      | -       | job description based on the field position_name |
      
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
  
      Table containing information about the employee in the library.
      
      ##### Columns
      | Columns       | Data Type    | Length | Not Null | Default             | Description                                                    |
      |---------------|--------------|--------|----------|---------------------|----------------------------------------------------------------|
      | id            | int unsigned | 10     | yes      | -                   | primary key for employees record                               |
      | first_name    | varchar      | 20     | yes      | -                   | employee first name or nickname                                |
      | last_name     | varchar      | 30     | yes      | -                   | employee surname                                               |
      | gender        | enum(M, F)   | 1      | yes      | -                   | employee gender, M = Male, F = Female                          |
      | birthday_date | date         | -      | yes      | -                   | employee birthday date                                         |
      | position      | int unsigned | 10     | yes      | -                   | employee position based on id of the table employees_positions |
      | phone         | varchar      | 20     | yes      | -                   | employee phone number                                          |
      | address       | varchar      | 255    | yes      | -                   | employee address                                               |
      | hire_date     | date         | -      | yes      | -                   | date employee hired                                            |
      | created_at    | date         | -      | yes      | current_timestamp() | date employee record created                                   |
      | status        | tinyint      | 3      | yes      | 1                   | employee status, 1 = active, 0 = not active                    |
      
      ##### Constraints
      | Constraint Type | Constraint Name    | Constraint Keys | Description                            |
      |-----------------|--------------------|-----------------|----------------------------------------|
      | Primary Key     | PRIMARY            | id              | primary key with value from emp_id()   |
      | Unique Key      | employees_un_phone | phone           | unique phone number for every employee | 
      
      ##### Indexes
      | Name                  | Index Type | Unique | Description                                                                                                   |
      |-----------------------|------------|--------|---------------------------------------------------------------------------------------------------------------|
      | PRIMARY               | BTree      | yes    | index cretated by a primary constraint                                                                        |
      | employees_fk_position | BTree      | no     | index has referencing position field on the employees table to the field id on the table employeees_positions |
      | employees_un_phone    | BTree      | yes    | index for the unique employee's phone number                                                                  |
      
      ##### Triggers
      Table does not have triggers
    
  5) publishers
      
      Table contains information about all the publisher's books in the library.
      
      ##### Columns
      | Columns     | Data Type    | Length | Not Null | Default | Description                              |
      |-------------|--------------|--------|----------|---------|------------------------------------------|
      | id          | int unsigned | 10     | yes      | -       | primary key for publishers record        |
      | pub_name    | varchar      | 200    | yes      | -       | publisher name or publisher company name |
      | pub_phone   | varchar      | 20     | yes      | -       | publisher phone number or fax number     |
      | pub_city    | varchar      | 100    | yes      | -       | publisher's hometown                     |
      | pub_address | varchar      | 255    | yes      | -       | publisher address                        |
      
      ##### Constraints
      | Constraint Type | Constraint Name     | Constraint Keys | Description                                |
      |-----------------|---------------------|-----------------|--------------------------------------------|
      | Primary Key     | PRIMARY             | id              | primary key with value from publisher_id() |
      | Unique Key      | publishers_un_phone | pub_phone       | unique phone number for every publisher    | 
      
      ##### Indexes
      | Name                | Index Type | Unique | Description                                   |
      |---------------------|------------|--------|-----------------------------------------------|
      | PRIMARY             | BTree      | yes    | index cretated by a primary constraint        |
      | publishers_un_phone | BTree      | yes    | index for the unique publisher's phone number |
      
      ##### Triggers
      Table does not have triggers
  
  6) authors
  
      Table contains information about all the authors of books that are in the library.
 
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
      | Constraint Type | Constraint Name  | Constraint Keys | Description                             |
      |-----------------|------------------|-----------------|-----------------------------------------|
      | Primary Key     | PRIMARY          | id              | primary key with value from author_id() |
      | Unique Key      | authors_un_phone | phone           | unique phone number for every author    |
      
      ##### Indexes
      | Name             | Index Type | Unique | Description                                |
      |------------------|------------|--------|--------------------------------------------|
      | PRIMARY          | BTree      | yes    | index cretated by a primary constraint     |
      | authors_un_phone | BTree      | yes    | index for the unique author's phone number |
      
      ##### Triggers
      Table does not have triggers
      
  7) categories_books
      
      Table contains a list of book categories in the library by following the Dewey Decimal Classification system rules.
      
      ##### Columns
      | Columns       | Data Type | Length | Not Null | Default | Description                             |
      |---------------|-----------|--------|----------|---------|-----------------------------------------|
      | id            | char      | 3      | yes      | -       | primary key for categories_books record |
      | category_name | varchar   | 100    | yes      | -       | name of the book category               |
      | category_desc | varchar   | 255    | yes      | -       | book category description               |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys | Description                                           |
      |-----------------|-----------------|-----------------|-------------------------------------------------------|
      | Primary Key     | PRIMARY         | id              | primary key follows the dewey decimal classification  |
      
      ##### Indexes
      | Name    | Index Type | Unique | Description                            |
      |---------|------------|--------|----------------------------------------|
      | Primary | BTree      | yes    | index cretated by a primary constraint |
      
      ##### Triggers
      Table does not have triggers
  
  8) books
  
      Table that contains information on all books in the library.
  
      ##### Columns
      | Columns      | Data Type         | Length | Not Null | Default | Description                                                  |
      |--------------|-------------------|--------|----------|---------|--------------------------------------------------------------|
      | id           | char              | 10     | yes      | -       | primary key for booksrecord                                  |
      | isbn         | char              | 13     | yes      | -       | 13 digit isbn book number                                    |
      | name         | varchar           | 100    | yes      | -       | book title                                                   |
      | category     | char              | 3      | yes      | -       | book category based on id of the table categories_books      |
      | stock        | smallint unsigned | 5      | yes      | -       | the number of the book in library                            |
      | avaibility   | smallint unsigned | 5      | yes      | -       | the number of the book that can be borrowed from the library |
      | publisher    | int unsigned      | 10     | yes      | -       | book publisher based on id of the table publishers           |
      | release_date | date              | -      | yes      | -       | the date the book was first published                        |
      | release_city | varchar           | 100    | yes      | -       | the place where the book was first published                 |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys | Description                           |
      |-----------------|-----------------|-----------------|---------------------------------------|
      | Primary Key     | PRIMARY         | id              | primary key with value from book_id() |
      | Unique Key      | books_un_isbn   | isbn            | unique isbn number for each book      |
      
      ##### Indexes
      | Name               | Index Type | Unique | Description                                                                                           |
      |--------------------|------------|--------|-------------------------------------------------------------------------------------------------------|
      | Primary            | BTree      | yes    | index created by a primary constraint                                                                 |
      | books_fk_category  | BTree      | no     | index has referencing category field on the books table to the field id on the table categories_books |
      | books_fk_publisher | BTree      | no     | index has referencing publisher field on the book table to the field id on the table publishers       |
      | books_un_isbn      | BTree      | yes    | index for the unique 13 digit isbn number                                                             |
      
      ##### Triggers
      Table does not have triggers
      
  9) books_authors
      
      Reference table of relationships many to many between table books and authors.
      
      ##### Columns
      | Columns   | Data Type    | Length | Not Null | Default | Description                  |
      |-----------|--------------|--------|----------|---------|------------------------------|
      | id_book   | char         | 10     | yes      | -       | book id from table books     |
      | id_author | int unsigned | 10     | yes      | -       | author id from table authors |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys    | Description                                                              |
      |-----------------|-----------------|--------------------|--------------------------------------------------------------------------|
      | Primary Key     | PRIMARY         | id_book, id_author | primary key for every many-to-many relationship in table book and author |
      
      ##### Indexes
      | Name    | Index Type | Unique | Description                           |
      |---------|------------|--------|---------------------------------------|
      | Primary | BTree      | yes    | index created by a primary constraint |
      
      ##### Triggers
      Table does not have triggers
  10) loans
      
      Table that contains information on all borrowing and returning books in the library
  
      ##### Columns
      | Columns             | Data Type    | Length | Not Null | Default                             | Description                                                                                                                                   |
      |---------------------|--------------|--------|----------|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
      | id                  | int unsigned | 10     | yes      | -                                   | primary key for loans record                                                                                                                  |
      | id_member           | int unsigned | 10     | yes      | -                                   | id members who borrow books                                                                                                                   |
      | emp_id_borrow       | int unsigned | 10     | yes      | -                                   | employee id at the time borrowing books                                                                                                       |
      | date_borrow         | date         | -      | yes      | current_timestamp()                 | books borrowing date                                                                                                                          |
      | emp_id_return       | int unsigned | 10     | no       | -                                   | employee id at the time returning books                                                                                                       |
      | date_return         | date         | -      | no       | -                                   | books returning date                                                                                                                          |
      | expired_date_return | date         | -      | yes      | current_timestamp() + inteval 7 day | deadline for borrowing books, default 7 days after borrowing                                                                                  |
      | loan_note           | varchar      | 255    | no       | -                                   | additional notes                                                                                                                              |
      | status              | tinyint      | 3      | yes      | 1                                   | book loan status 0 = books returned 1 = books borrowed 2 = books returned but past the return date 3 = books borrowe and past the return date |
      
      ##### Constrains
      | Constraint Type | Constraint Name | Constraint Keys | Description                                |
      |-----------------|-----------------|-----------------|--------------------------------------------|
      | Primary Key     | PRIMARY         | id              | primary key with value from loan_book_id() |
      
      ##### Indexes
      | Name                     | Index Type | Unique | Description                                                                                         |
      |--------------------------|------------|--------|-----------------------------------------------------------------------------------------------------|
      | Primary                  | BTree      | yes    | index created by a primary constraint                                                               |
      | loans_fk_employee_borrow | BTree      | no     | index has referencing emp_id_borrow field on the loans table to the field id on the table employees |
      | loans_fk_employee_return | BTree      | no     | index has referencing emp_id_return field on the loans table to the field id on the table employees |
      | loans_fk_member          | BTree      | no     | index has referencing member_id field on the loans table to the field id on the table members       |
      
      ##### Triggers
      | Trigger Name | Timing | Type   | Description                                                    |
      |--------------|--------|--------|----------------------------------------------------------------|
      | return_book  | BEFORE | UPDATE | update status in table books_loan when member returning books  |
      
  11) books_loan
  
      Reference table of relationships many to many between table books and loans.
      
      ##### Columns
      | Columns | Data Type      | Length | Not Null | Default | Description                                              |
      |---------|----------------|--------|----------|---------|----------------------------------------------------------|
      | id_book | char           | 10     | yes      | -       | book id from table books                                 |
      | id_loan | int unsigned   | 10     | yes      | -       | loan id from table loans                                 |
      | status  | enum('0', '1') | 1      | yes      | 1       | book loan status, 0 = book returning, 1 = book borrowing |
      
      ##### Constraints
      | Constraint Type | Constraint Name | Constraint Keys  | Description                                                              |
      |-----------------|-----------------|------------------|--------------------------------------------------------------------------|
      | Primary Key     | PRIMARY         | id_book, id_loan | primary key for every many-to-many relationship in table books and loans |
      
      ##### Indexes 
      | Name    | Index Type | Unique | Description                           |
      |---------|------------|--------|---------------------------------------|
      | Primary | BTree      | yes    | index created by a primary constraint |
      
      ##### Triggers
      | Trigger Name             | Timing | Type   | Description                                       |
      |--------------------------|--------|--------|---------------------------------------------------|
      | avaibility_after_loan    | AFTER  | INSERT | updating book avaibility when books are borrowed  |
      | availbility_after_return | BEFORE | UPDATE | updating book avaibility when books are returned  |
      
      
  #### b. Store Procedures
  
  1. add_member
       The procedure used to add new book authors
       ###### Parameters
       | Direction | Name          | Data Type      | Length | Description                                   |
       |-----------|---------------|----------------|--------|-----------------------------------------------|
       | IN        | first_name    | varchar        | 20     | author first name                             |
       | IN        | last_name     | varchar        | 30     | author surname                                |
       | IN        | gender        | enum('M', 'F') | 1      | author gender Male(M)/Female(F)               |
       | IN        | birthday_date | date           | 10     | author birthday date with format 'yyyy-mm-dd' |
       | IN        | phone         | varchar        | 20     | author phone number                           |
       | IN        | address       | varchar        | 255    | author address                                |
       
  2. add_book
  3. add_emp
       The procedure used to add new employees
       ##### Parameters
       | Direction | Name          | Data Type      | Length | Description                                                                     |
       |-----------|---------------|----------------|--------|---------------------------------------------------------------------------------|
       | IN        | first_name    | varchar        | 20     | employee first name                                                             |
       | IN        | last_name     | varchar        | 30     | employee surname                                                                |
       | IN        | gender        | enum('M', 'F') | 1      | employee gender Male(M)/Female(F)                                               |
       | IN        | birthday_date | date           | 10     | employee birthday date                                                          |
       | IN        | position      | int            | 10     | employee position in library, filled with id based on employees_positions table |
       | IN        | phone         | varchar        | 20     | employee phone number                                                           |
       | IN        | address       | varchar        | 255    | employee address                                                                |
       | IN        | hire_date     | date           | 10     | date employee hired                                                             |

  4. add_member
       The procedure used to add new members
       ##### Parameters
       | Direction | Name          | Data Type      | Length | Description                                           |
       |-----------|---------------|----------------|--------|-------------------------------------------------------|
       | IN        | first_name    | varchar        | 20     | member first name                                     |
       | IN        | last_name     | varchar        | 30     | member surname                                        |
       | IN        | email         | varchar        | 50     | member email                                          |
       | IN        | gender        | enum('M', 'F') | 1      | member gender Male(M)/Female(F)                       |
       | IN        | phone         | varchar        | 20     | member phone number                                   |
       | IN        | birthday_date | date           | 10     | member birthday date                                  |
       | IN        | address       | varchar        | 255    | member address                                        |
       | IN        | job           | int            | 10     | member job, filled with id base on members_jobs table |
       
  5. extended_member_expired
  6. loan_book
  7. return_book

  #### c. Functions
  | Function Name   | Parameter | Return           | Description                                  |
  |-----------------|-----------|------------------|----------------------------------------------|
  | author_id       | -         | int(10) unsigned | to generate id on table authors              |
  | book_id         | -         | char(10)         | to generate id on table books                |
  | emp_id          | -         | int(10) unsigned | to generate id on table employees            |
  | emp_position_id | -         | int(10) unsigned | to generate id on table empployees_positions |
  | loan_book_id    | -         | int(10) unsigned | to generate id on table loans                |
  | mbr_id          | -         | int(10) unsigned | to generate id on table members              |
  | mbr_jobs_id     | -         | int(10) unsigned | to generate id on table members_jobs         |
  | publisher_id    | -         | int(10) unsigned | to generate id on table publishers           |
      
  #### d. Events
  | Event Name              | Type      | Interval Value | Interval Field | Description                                                              |
  |-------------------------|-----------|----------------|----------------|--------------------------------------------------------------------------|
  | check_sts_member        | RECURRING | 1              | DAY            | event that will run every day to check membership status                 |
  | check_loan_book_expired | RECURRING | 1              | DAY            | event taht will run every day to check the book loan has expired or not  |
  

### 5. Statistics
  The number of lines needed to write the sql script is 659 lines
