import java.util.List;
import java.util.Vector;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;


public class UseChrome {

	//static String chromeDriverPath="C:\\Users\\marco.miccoli\\Desktop\\New folder\\Programs\\chromedriver_win32\\chromedriver.exe";
	static String chromeDriverPath="chromedriver.exe";
	static String remoteUrl="https://www.privacyshield.gov/list";
	static String separator="|#|";
	static Vector<String> companyVector= new Vector<String>();
	
	//open the browser with the extensions disabled for allowing Remote Management
	public static WebDriver initializeBrowser()
	{
		System.setProperty("webdriver.chrome.driver", chromeDriverPath);
		ChromeOptions options = new ChromeOptions();
		options.addArguments("chrome.switches","--disable-extensions");
		WebDriver driver = new ChromeDriver(options);
		System.out.println("web driver instanciated");

		return driver;
	}
	
	public static void main(String[] args)
	{
		File out = new File("Links.txt");
		WebDriver driver=initializeBrowser();
		
		driver.get(remoteUrl); //Get the web Page
		
		String labelXpath="//label";
		String companyNameXpath="//div[@class='col-md-5']/h4/a";
		List<WebElement>  labels = driver.findElements(By.xpath(labelXpath));
		String labelText="";
		String findTextLabel="Total Organizations";
		String findTextButton="Next Results";
		int companyNumber=0;
		int firstDisplayedCompanyNumber=0;
		int lastDisplayedCompanyNumber=0;
		int gap=0;
		int spares=0;
		int numberofCycles=0;

		for(int i=0; labels!=null && i<labels.size();i++)
		{
			WebElement we=labels.get(i);
			System.out.println("Label Value: " + we.getText());
			if(we.getText().indexOf(findTextLabel)!=-1)
				labelText=we.getText();	//Get the field with the total number of companies
		}
		if(labelText.equalsIgnoreCase(""))
		{
			System.out.println("Error: Maximum number of companies not found...code will exit");
			return;
		}else
		{
			//Calculate total number of cycles
			String[] tmpLabel=labelText.split(" ");
			companyNumber=Integer.parseInt(tmpLabel[tmpLabel.length-3]);
			firstDisplayedCompanyNumber=Integer.parseInt(tmpLabel[0]);
			lastDisplayedCompanyNumber=Integer.parseInt(tmpLabel[2]);
			gap=lastDisplayedCompanyNumber-firstDisplayedCompanyNumber+1;
			numberofCycles=companyNumber/gap;
			spares=companyNumber%gap;
			if(spares>0)
				numberofCycles=numberofCycles+1;
			else
				spares=gap;
		}


		//for(int i=0; i<numberofCycles;i++)
		for(int i=0; i<3;i++)
		{
			boolean exit=false;
			int countTry=0;
			int threshold=10;
			System.out.println("Cycle: "+(i+1));
			if(i<(numberofCycles-1))
			{
				//the while is used in case the browser has not loaded all the page yet
					//if the number of returned element is lower than the number of expected element --> try again to process the page
						//max number of times a page can be processed: countTry  
				while(getCompanies(driver,companyNameXpath).size()<gap && exit==false)
				{
					try {
						Thread.sleep(2000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					countTry++;
					if(countTry==threshold)
					{
						exit=true;
						System.out.println("Reached the maximum number of attempt ("+countTry+") to get Companies");
					}
				}
				if(exit==false)
				{
					WebElement button=null;
					List<WebElement>  buttons = driver.findElements(By.xpath("//a[@class='btn-navigate']"));
					for(int j=0; buttons!=null && j<buttons.size();j++)
					{
						WebElement we=buttons.get(j);
						System.out.println("Button Value: " + we.getText());
						if(we.getText().indexOf(findTextButton)!=-1)
							button=we;
					}
					//System.out.println("element "+element.toString() );
					System.out.println("Chosen button: "+button.getText() );
					button.click();
					try {
						Thread.sleep(4000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}									
				}

			}else
			{
				while(getCompanies(driver,companyNameXpath).size()<spares && exit==false)
				{
					try {
						Thread.sleep(2000);
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					countTry++;
					if(countTry==threshold)
					{
						exit=true;
						System.out.println("Reached the maximum number of attempt ("+countTry+") to get Companies");
					}
				}

			}
			//for each page write the vector
			for(int index=0;index<companyVector.size();index++)
				out.write(companyVector.get(index));
		}
		out.close();
		driver.quit();
		System.out.println("Browser Closed");
	}
	
	/*for each company in the current page
 	* Get the href (link) field 
 	* Add an entry to the global Vector companyVector
 		* Each entry is composed of CompanyName+separator+Link 
 */
public static Vector<String> getCompanies(WebDriver driver, String companyNameXpath) {

	companyVector= new Vector<String>();
	System.out.println("get performed");

	By b=By.xpath(companyNameXpath);

	List<WebElement> names=driver.findElements(b);
	for(int i=0; i<names.size();i++)
	{
		WebElement we=names.get(i);
		System.out.println("\t"+(i+1)+". Name: " + we.getText());
		System.out.println("\tLink: " + we.getAttribute("href"));
		companyVector.add(we.getText()+separator+we.getAttribute("href"));
		//System.out.println("Link: " + we.getAttribute("style"));
	}
	return companyVector;
}

}




