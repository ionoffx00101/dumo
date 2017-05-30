package com.tobo.dumo.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Service;

import com.tobo.dumo.dao.DumoDAO;

@Service(value="dumoService")
public class DumoServiceImple implements DumoService
{
	//@Resource(name="dumoDAO")
	@Inject
	@Named("dumoDAO")
	private DumoDAO dumoDAO;
	
	@Override
	public List<Map<String, Object>> selectWordList(Map<String, Object> map) throws Exception
	{
		return dumoDAO.selectWordList(map);
	}

}
