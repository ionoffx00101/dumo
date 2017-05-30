package com.tobo.dumo.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

// @Repository(value="dumoDAO")
@Component(value="dumoDAO")
public class DumoDAO extends AbstractDAO
{

	public List<Map<String, Object>> selectWordList(Map<String, Object> map)
	{
		// TODO Auto-generated method stub
		 return (List<Map<String, Object>>)selectList("dumo.selectWordList", map);
	}

}
