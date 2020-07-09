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
      | Columns | Data Type | Length | Nullable | Description |
      | --- | --- | --- | --- | --- |
      | id | int | 10 | No | primary key for member jobs record |
      | job_name | varchar | 100 | No | job name, for example: Student, Teacher, etc |
      | job_dec | varchar | 255 | No | description for job_name |

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
  
  #### b. Store Procedures
  #### c. Functions
  #### d. Events

### 5. Statistics
