
-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- Jonatan Peguero 
set search_path to dimeDB;

select 
    v."bonica.rid", 
    party,
    count(*) as numbills
from
    vote v
where 
    v.sponsor = 1 and not exists(
		select 1 from vote v2 where "vote.choice" = 6 and sponsor = 1 and v."bonica.rid" = v2."bonica.rid")
group by
    v."bonica.rid", 
    party
order by 
    numbills desc;


// A simple JDBC example.
// ------------------------------------------------------------ //
// To run this example:
// ====================
// 1. Download the JDBC driver "PostgreSQL JDBC 4.2 Driver, 42.5.0"
// (You can also find it in the JDBC/ folder on Canvas under SQLScripts/)
// Source: https://jdbc.postgresql.org/download/
//
// 2. Modify line 59 (connection URL) to make it match your database host IP,
// your user name, and password. Keep "localhost" if youre running PostgreSQLlocally.
// 3. Create a directory where youd like this example to run and "cd" to it.
//
// 4. Compile
// javac Example.java
//
// 5. Run
// Normally, you would run a Java program as follows: java Example
// But we need to also give the class path to where JDBC is, so we type:
// java -cp /path/to/postgresql-42.5.0.jar: Example
// Alternatively, you can set your CLASSPATH variable to include the JDBC driver
location.
// See: https://jdbc.postgresql.org/documentation/head/classpath.html
//
// Note: Remember to replace /path/to/ above with the actual location of
// your JDBC jar file. Also, dont forget the colon ":" after the jar file name!!!
11!1 Unless youre working on a Windows machine, use a semicolon ";" instead
// And if you put the driver in the same folder as the Java file, then you can
type:
// java -cp postgresql-42.5.0.jar: Example
// ------------------------------------------------------------ //
import java.sql.*;
import java.io.*;
class Example {
public static void main(String args[]) throws IOException
{
String url;
Connection conn;
PreparedStatement pStatement;
Statement statement;
ResultSet rs;
String queryString;
try {
Class.forName("org.postgresql.Driver");
}
catch (ClassNotFoundException e) {
System.out.println("Failed to find the JDBC driver");
}
try
{
// This program connects to the database "postgres",
// with user name "postgres" and password "postgres" (very creative,eh?)
// Establish our own connection to the database.
// Replace "localhost" with the IP of your SQL instance (if you'reusing a remote instance).
// Replace the first "postgres" string with your user name and the
second "postgres" with your password.
url = "jdbc:postgresql://localhost:5432/postgres"; // DB = postgres
conn = DriverManager.getConnection(url, "postgres", "postgres");
// 1. Let's create a simple table in the public schema
queryString = "create table if not exists jdbctable(a int, b
varchar(30))";
pStatement = conn.prepareStatement(queryString);
int result = pStatement.executeUpdate();
System.out.println("Executed Update: " + queryString);
System.out.println("Result: " + result); // Expected: 0
// 2. Delete all tuples
queryString = "delete from jdbctable";
pStatement = conn.prepareStatement(queryString);
result = pStatement.executeUpdate();
System.out.println("\nExecuted Update: " + queryString);
System.out.println("Result: " + result); // #tuples affected
// 3. Insert new tuples
queryString = "insert into jdbctable values(1,'apples'), " +
"(2, 'oranges'), (3, 'peaches'), (4, 'avocado')";
statement = conn.createStatement();
result = statement.executeUpdate(queryString);
System.out.println("\nExecuted Update: " + queryString);
System.out.println("Result: " + result); // #tuples affected: 4
// 4. Read all tuples (using a PreparedStatement)
queryString = "select * from jdbctable";
pStatement = conn.prepareStatement(queryString);
rs = pStatement.executeQuery();
System.out.println("\nExecuted Query: " + queryString);
// Iterate through the result set and report the content of each tuple
while (rs.next()) {
String word = rs.getString("b");
int id = rs.getInt("a");
System.out.println("(" + id + "," + word + ")");
}
// 5. Read specific tuples that match a criteria
// (using a PreparedStatement object)
queryString = "select * from jdbctable where a = ?";
PreparedStatement ps = conn.prepareStatement(queryString);
int who = 4;
ps.setInt(1, who); // set first "?" in the prepared statement to value
of "who"
rs = ps.executeQuery();
System.out.println("\nExecuted Query: " + queryString);
while (rs.next()) {
System.out.println("(" + rs.getObject(1) + "," + rs.getObject(2) +
")");
}
// 6. Read specific tuples that match a criteria
// (using a Statement object)
String food = "p";
queryString = "select * from jdbctable where b like '%" + food + "%'";
rs = statement.executeQuery(queryString);
System.out.println("\nExecuted Query: " + queryString);
// Iterate through the result set and report the content of each tuple
while (rs.next()) {
System.out.println("(" + rs.getObject(1) + "," + rs.getObject(2) +
")");
}
// 7. What's going on here? :-O
food = "2; drop table jdbctable";
queryString = "select * from jdbctable where a = " + food;
rs = statement.executeQuery(queryString);
System.out.println("\nExecuted Query: " + queryString);
while (rs.next()) {
System.out.println("(" + rs.getObject(1) + "," + rs.getObject(2) +
")");
}
// Check your jdbctable table now. What happened? ;-)
}
catch (SQLException se)
{
System.err.println("SQL Exception." +
"<Message>: " + se.getMessage());
}
}
}