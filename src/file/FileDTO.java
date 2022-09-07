/*
서동학: 전체적인 코딩
*/


package file;

public class FileDTO {
	
	String fileName;
	String fileRealName;
	String userID;
	String itemID;
	
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getFileRealName() {
		return fileRealName;
	}
	public void setFileRealName(String fileRealName) {
		this.fileRealName = fileRealName;
	}
	
	public String getuserID() {
		return userID;
	}
	public void setuserID(String userID) {
		this.userID = userID;
	}
	
	public String getitemID() {
		return itemID;
	}
	public void setitemID(String itemID) {
		this.itemID = itemID;
	}
	
	public FileDTO(String fileName, String fileRealName) {
		super();
		this.fileName = fileName;
		this.fileRealName = fileRealName;
	}
}
