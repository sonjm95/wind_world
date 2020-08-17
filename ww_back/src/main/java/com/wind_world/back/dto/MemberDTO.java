package com.wind_world.back.dto;

public class MemberDTO {
	   String id;
	   String pwd;
	   String name;
	   public MemberDTO() {
	      super();
	      // TODO Auto-generated constructor stub
	   }
	   
	   public MemberDTO(String id, String pwd, String name) {
	      super();
	      this.id = id;
	      this.pwd = pwd;
	      this.name = name;
	   }
	   
	   public String getId() {
	      return id;
	   }
	   public void setId(String id) {
	      this.id = id;
	   }
	   public String getPwd() {
	      return pwd;
	   }
	   public void setPwd(String pwd) {
	      this.pwd = pwd;
	   }
	   public String getName() {
	      return name;
	   }
	   public void setName(String name) {
	      this.name = name;
	   }
	   
	}