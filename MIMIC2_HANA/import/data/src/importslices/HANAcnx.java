package importslices;
import java.io.File;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringEscapeUtils;

import au.com.bytecode.opencsv.CSVReader;

public class HANAcnx {
	
	private static Connection connection = null;
	private static String userName = "";
	private static String password = "";
	
	public static void main(String[] argv) throws IOException, SQLException {

		long start = System.currentTimeMillis();
		if (argv.length != 3) {
			System.out.println("Need to pass the path of the slices, username and password");
			System.exit(1);
		}
		
		String filePath = argv[0];
		userName = argv[1];
		password = argv[2];
		
		File[] files = getSlicesFileNames(filePath);

//		Runtime rt = Runtime.getRuntime();
//		String command = "tar xfz " + files[0];
//		Process pr = rt.exec(command);

		File untarDirectory = files[0];
		
		for(File subDirectory: untarDirectory.listFiles()) {
			long intermediate_start = System.currentTimeMillis();
			System.out.println("Processing " + subDirectory);
			for(File file: subDirectory.listFiles()) {
				
				String fileName = file.getAbsolutePath();
				String tableName = file.getName().split("-[0-9]{5,5}.txt")[0];
				if(tableName.equals("CHARTEVENTS")){
					List<String[]> lines = readCSV(fileName);

					for(String[] line: lines) {
						PreparedStatement query = buildInsertQuery(tableName, line);
						executeQuery(query);
					}
				}
			}
			System.out.println((System.currentTimeMillis() - intermediate_start) + "ms to complete " + subDirectory.listFiles().length + " files");
			intermediate_start = System.currentTimeMillis();
		}
		
		System.out.println((System.currentTimeMillis() - start) + "ms to complete everything");
	}
	
	
	private static PreparedStatement buildInsertQuery(String tableName, String[] fields) throws SQLException {
		if(connection == null) {
			getConnection();
		}
		
		String query = "INSERT INTO \"MIMIC2\".\"mimic.data::" + tableName.toLowerCase() + "\" VALUES (";
		
		for(int i = 0; i < fields.length; i++) {
			query += '?';
			if (i != fields.length - 1) {
				query += ", ";
			}
		}
		query += ")";
		
		PreparedStatement ps = connection.prepareStatement(query);
		for(int i = 0; i < fields.length; i++) {
			if(fields[i].equals("")) {
				ps.setNull(i + 1,  java.sql.Types.NVARCHAR);
			} else {
				String field = fields[i].split(" EST")[0];
				ps.setString(i + 1, field);
			}
		} 
	
		return ps;
	}
	
	
	private static File[] getSlicesFileNames(String path) {
		File f = new File(path);
		SliceFilter sliceFilter = new SliceFilter();
		File[] files = null;
		
		if(f.exists() && f.isDirectory()) { 
			files = f.listFiles(sliceFilter);
		} else {
			throw new RuntimeException("The path provided does not correspond to a directory\n" + path);
		}
		
		return files;
	}
	
	public static void getConnection() {
		try {
			connection = DriverManager.getConnection("jdbc:sap://bostonresearch.bos.sap.corp:30115/?autocommit=false",userName,password); 
			if (connection != null) { 
				System.out.println("Connection to HANA successful!");
			}
			
		} catch (SQLException e) {
			 System.err.println("Connection Failed. User/Passwd Error?");
		     return;
		}
	}

	
public static void executeQuery(PreparedStatement query) {
	if(connection == null) {
		getConnection();
	}
	
	if (connection != null) {
		try {
			query.executeUpdate();

			connection.commit();

		} catch (SQLException e) {
			System.err.println("Query failed!\n" + query);
			e.printStackTrace();
		}
	} else {
		throw new RuntimeException("No connection to the database");
	}
	
}
	
	private static List<String[]> readCSV(String file) throws IOException {
		CSVReader reader;
		reader = new CSVReader(new FileReader(file), ',','"', 1);
		List<String[]> myEntries = reader.readAll();
		reader.close();
		return myEntries;
	}
	
	
	
}

class SliceFilter implements FilenameFilter {

	@Override
	public boolean accept(File dir, String name) {
		boolean match = Pattern.matches("mimic2cdb-2.6-[0-9]{2,2}.tar.gz", name);
		File newfile = new File(dir + File.separator + name);
		match = newfile.isDirectory();
		return match;
	}
	
}

class DirectoryFilter implements FilenameFilter {

	@Override
	public boolean accept(File dir, String name) {
		boolean match = Pattern.matches("[0-9]{5,5}", name);
		
		return match;
	}
	
}