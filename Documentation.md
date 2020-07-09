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
      
      ##### Indexes
      | Name | Index Type | Unique | Description |
      | --- | --- | --- | --- |
      | PRIMARY | BTree | Yes | index created by a primary key constraint |
      
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
      
      ##### Indexes
      | Name            | Index Type | Unique | Description                                                                                   |
      |-----------------|------------|--------|-----------------------------------------------------------------------------------------------|
      | PRIMARY         | BTree      | yes    | index cretated by a primary constraint                                                        |
      | member_fk_job   | BTree      | no     | index has referencing job field on the members table to the field id on the table member_jobs |
      | member_un_email | BTree      | yes    | index for the unique value of an email, and the email can only be used once.                  |
      
      ##### Triggers
      Table does not have triggers
  
  #### b. Store Procedures
  #### c. Functions
  #### d. Events

### 5. Statistics
