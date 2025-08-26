💽 CS377 – Database Systems (Spring 2025)
Instructor: Prof. Johanna Montoya
University: Emory University
Language: PostgreSQL & Java (JDBC)
Topics: Relational Databases, SQL, ER Modeling, Data Normalization, Embedded SQL

🧩 Assignment 2 – DIME Political Finance SQL Queries (Parts 1 & 2)
Summary:

Analyzed a real-world political finance database ("DIME") using PostgreSQL. Wrote complex SQL queries on campaign contributions, donor/recipient networks, and political behavior. Tasks were split into Part 1 (basic queries) and Part 2 (advanced logic, data deletion, view creation, and data transformation).

Key Highlights:

Worked with 5 interrelated tables (Contributor, Recipient, Contribution, Vote, Bill)

Queried top donors and recipients over multiple election cycles

Used joins, filtering, grouping, aggregation, nested queries, and views

Applied real-world data privacy constraints (e.g., removing independents)

Designed dynamic queries that avoid hardcoding and adapt to different datasets

Created a custom Influence table to prepare political data for machine learning tasks

Skills: Advanced SQL, DDL/DML, database schema reasoning, query optimization, views, data preparation for ML

🎸 Assignment 3 – Artist DB Browser (Java + Embedded SQL)
Summary:

Implemented a Java application called ArtistBrowser using JDBC to interact with a music industry database. Supported artist searches, collaborations, songwriting relationships, and genre filters through dynamic SQL.

Key Functionalities Implemented:

findArtistsInBands: Artists active in bands during specified periods

findArtistsInGenre: Artists who released albums in a given genre

findCollaborators: Find all collaborators (main or guest) on a song

findSongwriters: Retrieve all external songwriters for an artist

findCommonAcquaintances: Determine shared collaborators/songwriters

artistConnectivity: Test if a collaboration chain exists between any two artists

Technical Details:

Used PostgreSQL and Java JDBC

Ensured SQL injection protection with prepared statements

Wrote SQL queries dynamically from Java using PreparedStatement

Handled ResultSets, schema constraints, and database connection pooling

Skills: Java, JDBC, prepared statements, foreign key handling, SQL schema exploration, recursion/graph logic in code
