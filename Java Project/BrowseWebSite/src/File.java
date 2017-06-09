import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

public class File {

	FileOutputStream file = null;
	PrintStream Output = null;
	
	public File(String path) 
	{

		try {
			file = new FileOutputStream(path);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Output = new PrintStream(file);
	}

	public void write(String inputString)
	{
		
		Output.println(inputString);
	}
	public void close() 
	{
		Output.close();
		
		try {
			file.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
}