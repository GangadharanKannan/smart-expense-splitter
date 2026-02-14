# 💰 Smart Expense Splitter -- Backend

This repository contains the **PHP + MySQL backend** for the Smart
Expense Splitter application.\
The backend provides REST APIs for user authentication, group
management, expense tracking, and balance calculation.

------------------------------------------------------------------------

# 📌 Tech Stack

-   **Language:** PHP
-   **Database:** MySQL
-   **API Testing:** Postman
-   **Server:** Apache / XAMPP / WAMP

------------------------------------------------------------------------

# 🚀 Database Schema

Run the following SQL queries to create the database structure.

``` sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE groups (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(150) NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE group_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    user_id INT NOT NULL,
    UNIQUE(group_id, user_id),
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    paid_by INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
    FOREIGN KEY (paid_by) REFERENCES users(id)
);

CREATE TABLE expense_splits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    expense_id INT NOT NULL,
    user_id INT NOT NULL,
    amount_owed DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (expense_id) REFERENCES expenses(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

------------------------------------------------------------------------

# 🔑 Authentication APIs

## ✅ Register User

**Endpoint**

    POST /controllers/register.php

**Request**

``` json
{
  "name": "Akash",
  "email": "hello2@gmail.com",
  "password": "12345678"
}
```

**Response**

``` json
{
  "status": true,
  "message": "User registered successfully"
}
```

📷 Add screenshot here:

    assets/images/register.png

------------------------------------------------------------------------

## ✅ Login User

**Endpoint**

    POST /controllers/login.php

**Request**

``` json
{
  "email": "hello2@gmail.com",
  "password": "12345678"
}
```

**Response**

``` json
{
  "status": true,
  "message": "Login successful",
  "user": {
    "id": 6,
    "name": "Akash",
    "email": "hello2@gmail.com"
  }
}
```

📷 Screenshot:

    assets/images/login.png

------------------------------------------------------------------------

# 👥 Group Management APIs

## ✅ Create Group

    POST /controllers/create_group.php

**Request**

``` json
{
  "group_name": "Goa Trip",
  "created_by": 1
}
```

**Response**

``` json
{
  "status": true,
  "message": "Group created successfully"
}
```

------------------------------------------------------------------------

## ✅ Add Member

    POST /controllers/add_member.php

**Request**

``` json
{
  "group_id": 9,
  "email": "hello2@gmail.com"
}
```

**Response**

``` json
{
  "status": true,
  "message": "Member added successfully"
}
```

------------------------------------------------------------------------

## ✅ Get All Groups

    GET /controllers/get_groups.php?user_id=6

**Response**

``` json
{
  "status": true,
  "groups": [
    {
      "id": 9,
      "group_name": "Goa Trip"
    }
  ]
}
```

------------------------------------------------------------------------

## ✅ Get Group Members

    GET /controllers/get_members.php?group_id=12

------------------------------------------------------------------------

# 💸 Expense APIs

## ✅ Add Expense

    POST /controllers/add_expense.php

**Request**

``` json
{
  "group_id": 9,
  "paid_by": 1,
  "title": "Dinner",
  "amount": 100,
  "members": [1,2,3]
}
```

**Response**

``` json
{
  "status": true,
  "message": "Expense added successfully"
}
```

------------------------------------------------------------------------

## ✅ Get Group Expenses

    GET /controllers/get_expense.php?group_id=9

------------------------------------------------------------------------

## ✅ Split Expense / Balance Summary

    GET /controllers/split_expense.php?group_id=9

Returns each member's total paid, owed amount, and balance.

------------------------------------------------------------------------

# ▶️ How To Run Backend Locally

### 1️⃣ Clone Repository

    git clone <repo-url>

### 2️⃣ Move Project

Place inside:

    htdocs/ (XAMPP)

### 3️⃣ Import Database

-   Open **phpMyAdmin**
-   Create database
-   Run the SQL schema

### 4️⃣ Start Server

Start Apache & MySQL from XAMPP.

### 5️⃣ Test APIs

Use Postman with:

    http://localhost/expense_splitter_app/

------------------------------------------------------------------------

# 📂 Recommended Project Structure

    backend/
     ├── config/
     ├── controllers/
     ├── models/
     ├── utils/
     └── index.php

------------------------------------------------------------------------

# 🔥 Future Improvements

-   JWT Authentication\
-   Password Hashing (bcrypt)\
-   API Rate Limiting\
-   Docker Deployment\
-   Cloud Database

------------------------------------------------------------------------

# 👨‍💻 Author

**Gangadharan Kannan**\
Backend Developer
