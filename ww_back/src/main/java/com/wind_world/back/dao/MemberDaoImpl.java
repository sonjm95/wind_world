package com.wind_world.back.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.wind_world.back.dto.MemberDTO;

@Repository("MemberDaoImpl")
public class MemberDaoImpl implements MemberDao {
	@Autowired
	SqlSession session;

	@Override
	public int add(MemberDTO memberDTO) {
		// TODO Auto-generated method stub
		return session.insert("back.member.add",memberDTO);
	}

	
	
}
