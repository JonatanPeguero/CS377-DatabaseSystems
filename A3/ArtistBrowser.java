// Necessary imports:
/*
THIS CODE WAS MY OWN WORK, IT WAS WRITTEN WITHOUT CONSULTING
CODE WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
Jonatan Peguero 
*/
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.ArrayDeque;



// Class ArtistBrowser represents a JDBC application that enables navigating
// data about artists, stored in a PostgreSQL database
public class ArtistBrowser {

	/* An instance variable representing a connection to the database */
	private Connection connection;

	/**
	 * The constructor loads the JDBC driver. No need to modify this.
	 */
	public ArtistBrowser() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			System.err.println("Failed to locate the JDBC driver.");
		}
	}

	/**
	* Establishes a connection to be used for this session, assigning it to
	* the private instance variable 'connection'.
	*
	* @param  url       the url to the database
	* @param  username  the username to connect to the database
	* @param  password  the password to connect to the database
	* @return           true if the connection is successful, false otherwise
	*/
	public boolean connectDB(String url, String username, String password) {
		try {
			this.connection = DriverManager.getConnection(url, username, password);
			try (Statement stmt = this.connection.createStatement()) {
				stmt.execute("SET search_path TO artistdb");
				System.err.println("Search path set to artistdb");

			}
			return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception: " + se.getMessage());
			return false;
		}
	}

	/**
	* Closes the database connection.
	*
	* @return true if the closing was successful, false otherwise.
	*/
	public boolean disconnectDB() {
		try {
			this.connection.close();
		return true;
		} catch (SQLException se) {
			System.err.println("SQL Exception: " + se.getMessage());
			return false;
		}
	}


	/**
	 * Returns a sorted list of the names of all musicians who were part of a band
	 * at some point between a given start year and an end year (inclusive).
 	 *
	 * Returns an empty list if no musicians match, or if the given timeframe is invalid.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *		Use prepared statements.
	 *
	 * @param startYear
	 * @param endYear
	 * @return  a sorted list of artist names
	 */
	public ArrayList<String> findArtistsInBands(int startYear, int endYear) {
		ArrayList<String> artistList = new ArrayList<>();

    	if (startYear > endYear) {
        	return artistList;
    	}

    	String sql = "SELECT DISTINCT A.name " +
                 	"FROM \"artist\" A " +
                 	"JOIN \"role\" R ON A.artist_id = R.artist_id " +
                 	"JOIN \"wasinband\" W ON A.artist_id = W.artist_id " +
                 	"WHERE R.role = 'Musician' " +
                 	"AND NOT (W.end_year < ? OR W.start_year > ?);";

    	try (PreparedStatement ps = connection.prepareStatement(sql)) {
        	ps.setInt(1, startYear);
        	ps.setInt(2, endYear);

        	try (ResultSet rs = ps.executeQuery()) {
            	while (rs.next()) {
                	artistList.add(rs.getString("name"));
            	}
        	}		

        Collections.sort(artistList);
    } catch (SQLException e) {
        System.err.println("Error in findArtistsInBands: " + e.getMessage());
    }

    	return artistList;
	}


	/**
	 * Returns a sorted list of the names of all musicians and bands
	 * who released at least one album in a given genre.
	 *
	 * Returns an empty list if no such genre exists or no artist matches.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *		Use prepared statements.
	 *
	 * @param genre  the genre to find artists for
	 * @return       a sorted list of artist names
	 */
	public ArrayList<String> findArtistsInGenre(String genre) {
		ArrayList<String> artistList = new ArrayList<>();

    	if (genre == null || genre.trim().isEmpty()) {
        	return artistList;
    	}

    	String sql = "SELECT DISTINCT A.name " +
                 	"FROM \"artist\" A " +
                 	"JOIN \"album\" AL ON A.artist_id = AL.artist_id " +
                 	"JOIN \"genre\" G ON AL.genre_id = G.genre_id " +
                 	"WHERE G.genre = ?;";

    	try (PreparedStatement ps = connection.prepareStatement(sql)) {
        	ps.setString(1, genre);

        	try (ResultSet rs = ps.executeQuery()) {
            	while (rs.next()) {
                	artistList.add(rs.getString("name"));
            	}
        	}

        Collections.sort(artistList);
    } catch (SQLException e) {
        System.err.println("Error in findArtistsInGenre: " + e.getMessage());
    }

    return artistList;
	}


	/**
	 * Returns a sorted list of the names of all collaborators
	 * (either as a main artist or guest) for a given artist.
	 *
	 * Returns an empty list if no such artist exists or the artist
	 * has no collaborators.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *		Use prepared statements.
	 *
	 * @param artist  the name of the artist to find collaborators for
	 * @return        a sorted list of artist names
	 */
	public ArrayList<String> findCollaborators(String artist) {
		ArrayList<String> collaborators = new ArrayList<>();

    	if (artist == null || artist.trim().isEmpty()) {
        	return collaborators;
    	}

    	String sql = "SELECT DISTINCT A.name " +
                 	"FROM \"artist\" A " +
                 	"WHERE A.artist_id IN ( " +
                 	"    SELECT C.artist2 " +
                 	"    FROM \"collaboration\" C " +
                 	"    JOIN \"artist\" AR ON C.artist1 = AR.artist_id " +
                 	"    WHERE AR.name = ? " +
                 	"    UNION " +
                 	"    SELECT C.artist1 " +
                 	"    FROM \"collaboration\" C " +
                 	"    JOIN \"artist\" AR ON C.artist2 = AR.artist_id " +
                 	"    WHERE AR.name = ? " +
                 	");";
    	try (PreparedStatement ps = connection.prepareStatement(sql)) {
        	ps.setString(1, artist);
        	ps.setString(2, artist);

        	try (ResultSet rs = ps.executeQuery()) {
            	while (rs.next()) {
                	collaborators.add(rs.getString("name"));
            	}
        	}

        	Collections.sort(collaborators);
    	} catch (SQLException e) {
        	System.err.println("Error in findCollaborators: " + e.getMessage());
    	}

    	return collaborators;
		}


	/**
	 * Returns a sorted list of the names of all songwriters
	 * who wrote songs for a given artist (the given artist is excluded).
	 *
	 * Returns an empty list if no such artist exists or the artist
	 * has no other songwriters other than themself.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist  the name of the artist to find the songwriters for
	 * @return        a sorted list of songwriter names
	 */
	public ArrayList<String> findSongwriters(String artist) {
		ArrayList<String> songwriters = new ArrayList<>();

    	if (artist == null || artist.trim().isEmpty()) {
        	return songwriters;
    	}

    	String sql = "SELECT DISTINCT A.name " +
                 	"FROM \"song\" S " +
                 	"JOIN \"belongstoalbum\" BTA ON S.song_id = BTA.song_id " +
                 	"JOIN \"album\" AL ON BTA.album_id = AL.album_id " +
                 	"JOIN \"artist\" MainArtist ON AL.artist_id = MainArtist.artist_id " +
                 	"JOIN \"artist\" A ON S.songwriter_id = A.artist_id " +
                 	"WHERE MainArtist.name = ? " +
                 	"AND S.songwriter_id <> MainArtist.artist_id;";

    	try (PreparedStatement ps = connection.prepareStatement(sql)) {
        	ps.setString(1, artist);

        	try (ResultSet rs = ps.executeQuery()) {
            	while (rs.next()) {
                	songwriters.add(rs.getString("name"));
            	}
        	}

        	Collections.sort(songwriters);
    	} catch (SQLException e) {
        	System.err.println("Error in findSongwriters: " + e.getMessage());
    	}

    	return songwriters;
	}

	/**
	 * Returns a sorted list of the names of all common acquaintances
	 * for a given pair of artists.
	 *
	 * Returns an empty list if either of the artists does not exist,
	 * or they have no acquaintances.
	 *
	 * NOTE:
	 *    Use Collections.sort() to sort the names in ascending
	 *    alphabetical order.
	 *
	 * @param artist1  the name of the first artist to find acquaintances for
	 * @param artist2  the name of the second artist to find acquaintances for
	 * @return         a sorted list of artist names
	 */
	public ArrayList<String> findCommonAcquaintances(String artist1, String artist2) {
		ArrayList<String> result = new ArrayList<>();
		
		if (artist1 == null || artist2 == null || artist1.equals(artist2)) {
			return result;
		}
		
		HashSet<String> set1 = new HashSet<>();
		HashSet<String> set2 = new HashSet<>();
		
		set1.addAll(findCollaborators(artist1));
		set1.addAll(findSongwriters(artist1));
		
		set2.addAll(findCollaborators(artist2));
		set2.addAll(findSongwriters(artist2));
		
		set1.retainAll(set2);
		
		result.addAll(set1);
		Collections.sort(result);
		
			return result;
	}

	/**
	 * Returns true if two artists have a collaboration path connecting
	 * them in the database (see A3 handout for our definition of a path).
	 * For example, artists `Z' and `Usher' are considered connected even though
	 * they have not collaborated directly on any song, because 'Z' collaborated
	 * with `Alicia Keys' who in turn had collaborated with `Usher', therefore there
	 * is a collaboration path connecting `Z' and `Usher'.
	 *
	 * Returns false if there is no collaboration path at all between artist1 and artist2
	 * or if either of them do not exist in the database.
	 *
	 * @return    true iff artist1 and artist2 have a collaboration path connecting them
	 */
	public boolean artistConnectivity(String artist1, String artist2) {
		if (artist1 == null || artist2 == null || artist1.equals(artist2)) {
			return false;
		}
	
		String getIdSQL = "SELECT artist_id FROM \"artist\" WHERE name = ?";
		Integer id1 = null, id2 = null;
	
		try (
			PreparedStatement ps = connection.prepareStatement(getIdSQL)
		) {
			ps.setString(1, artist1);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) id1 = rs.getInt("artist_id");
			}
	
			ps.setString(1, artist2);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) id2 = rs.getInt("artist_id");
			}
		} catch (SQLException e) {
			System.err.println("Error fetching artist IDs: " + e.getMessage());
			return false;
		}
	
		if (id1 == null || id2 == null) return false;
	
		// BFS setup
		ArrayDeque<Integer> queue = new ArrayDeque<>();
		HashSet<Integer> visited = new HashSet<>();
	
		queue.add(id1);
		visited.add(id1);
	
		while (!queue.isEmpty()) {
			int current = queue.poll();
			if (current == id2) return true;
	
			// Get neighbors (collaborators)
			String collabSQL =
				"SELECT artist2 AS neighbor FROM \"collaboration\" WHERE artist1 = ? " +
				"UNION " +
				"SELECT artist1 AS neighbor FROM \"collaboration\" WHERE artist2 = ?";
	
			try (PreparedStatement ps = connection.prepareStatement(collabSQL)) {
				ps.setInt(1, current);
				ps.setInt(2, current);
	
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						int neighbor = rs.getInt("neighbor");
						if (!visited.contains(neighbor)) {
							visited.add(neighbor);
							queue.add(neighbor);
						}
					}
				}
			} catch (SQLException e) {
				System.err.println("Error during BFS: " + e.getMessage());
				return false;
			}
		}
		return false; // temporarily
	}


	public static void main(String[] args) {

		if( args.length < 2 ){
			System.out.println("Usage: java ArtistBrowser <userName> <password>");
			return;
		}

		String user = args[0];
		String pass = args[1];

		ArtistBrowser a3 = new ArtistBrowser();

		String url = "jdbc:postgresql://localhost:5432/postgres?currentSchema=artistdb";
		a3.connectDB(url, user, pass);

		System.err.println("\n----- ArtistsInBands -----");
    ArrayList<String> res = a3.findArtistsInBands(1990,1999);
    for (String s : res) {
    System.err.println(s);
    }

		System.err.println("\n----- ArtistsInGenre -----");
    res = a3.findArtistsInGenre("Rock");
    for (String s : res) {
    System.err.println(s);
    }

		System.err.println("\n----- Collaborators -----");
		res = a3.findCollaborators("Usher");
		for (String s : res) {
		System.err.println(s);
		}

		System.err.println("\n----- Songwriters -----");
	res = a3.findSongwriters("Justin Bieber");
		for (String s : res) {
		System.err.println(s);
		}

		System.err.println("\n----- Common Acquaintances -----");
		res = a3.findCommonAcquaintances("Jaden Smith", "Miley Cyrus");
		for (String s : res) {
		System.err.println(s);
		}

		System.err.println("\n----- artistConnectivity -----");
		String a1 = "Z", a2 = "Usher";
		boolean areConnected = a3.artistConnectivity(a1, a2);
		System.err.println("Do artists " + a1 + " and " + a2 + " have a collaboration path connecting them? Answer: " + areConnected);

		a3.disconnectDB();
	}
}
