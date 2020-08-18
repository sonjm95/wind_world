package com.wind_world.back.Controller;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.wind_world.back.dao.MemberDao;
import com.wind_world.back.dto.MemberDTO;

@CrossOrigin(origins = { "*" }, maxAge = 6000)
@RestController
@RequestMapping("/apiRest")




public class ApiController {
	
	@Autowired
	private MemberDao dao;
	
	@RequestMapping("/add")
	   public String add(HttpServletRequest request) {
	      MemberDTO dto= new MemberDTO();
	      //dto.setId(request.getParameter("id"));
	      dto.setId("sonrg53");
	      dto.setPwd("rudehf35!");
	      dto.setName("손경호");
	      
	      
	      int result = dao.add(dto);
	      
	      
	      if(result ==1)
	         System.out.println("성공");
	      else
	         System.out.println("실패");
	      
	      return null;
	   }
	
	
	@RequestMapping("/test")  //http://localhost:8090/kamco/apiRest/test
	public String te(HttpServletRequest request) throws IOException, ParserConfigurationException, SAXException {
		
		StringBuilder urlBuilder = new StringBuilder("http://openapi.onbid.co.kr/openapi/services/KamcoPblsalThingInquireSvc/getKamcoPbctCltrList"); /*URL*/
		urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=Dvcgx3pgVWjTPf88ltePPibU4gTyuEmmX07p6uSqnjxn5K1pUBjdtesjv041WYuVxgxl1%2Bdeh8l9kEHbl8N4QQ%3D%3D"); /*공공데이터포털에서 발급받은 인증키*/
		urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode("1", "UTF-8")); /*페이지 번호*/
	    urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode("10", "UTF-8")); /*페이지당 데이터 개수*/
	    urlBuilder.append("&" + URLEncoder.encode("PRPT_DVSN_CD","UTF-8") + "=" + URLEncoder.encode("0001", "UTF-8")); /*0001 매각 0002 임대*/
	       
	    System.out.println(urlBuilder);
	       String url = new String(urlBuilder.toString());
	       
	       DocumentBuilderFactory dbFactoty=DocumentBuilderFactory.newInstance();
	       DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
	       Document doc=dBuilder.parse(url);
	       
	       doc.getDocumentElement().normalize();
	       System.out.println("Root element: "+ doc.getDocumentElement().getNodeName());
	       
	       NodeList nList = doc.getElementsByTagName("item");
	       System.out.println("파싱할 리스투 수: "+ nList.getLength());
	       
	       for(int temp=0;temp<nList.getLength();temp++) {
	    	   Node nNode=nList.item(temp);
	    	   if(nNode.getNodeType()==Node.ELEMENT_NODE) {
	    		   Element eElement = (Element) nNode;
	    		   System.out.println("############");
	    		   System.out.println("PNUM ="+getTagValue("RNUM",eElement));
	    		   System.out.println("PLNM_NO ="+getTagValue("PLNM_NO",eElement));
	    	   }
	       } 
		
		
		
		return null;
	}
	
	
	private static String getTagValue(String tag,Element eElement) {
		   NodeList nlList=eElement.getElementsByTagName(tag).item(0).getChildNodes();
		   Node nValue = (Node)nlList.item(0);
		   if(nValue==null)
			   return null;
		   return nValue.getNodeValue();
	   }

}
